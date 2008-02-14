Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYBNRQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYBNRQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYBNRQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:16:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:51045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYBNRQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:16:37 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Is there a "blackhole" /dev/null directory?
To: rzryyvzy <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 14 Feb 2008 18:16:22 +0100
References: <9WIJE-1Nr-11@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JPhh9-0000El-DM@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+nn3+i7SPr7nceZ594Ed406/QwSIn8cAl8O5b
 xAknJxmPFmIe9Beaq9Z89d7M/NhfXopQqiU0msLAh3HvJEZDEG
 aQ3h9R+j7rKUmfYzPv4nA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rzryyvzy <rzryyvzy@trashmail.net> wrote:

> /dev/null is often very useful, specially if programs force to save data in
> some file. But some programs like to creates different temporary file names,
> so /dev/null could no more work.
> 
> What is with a "/dev/null"-directory?
> I mean a "blackhole pseudo directory" which eats every write to null.
> 
> Here is how it could work:
> mount -t nulldir nulldir /dev/nulldir
> 
> Now if a program does a create(2),
> it creates in the memory the file with its fd.
> Then if a program does a write(2) to the fd, it eats the writes and give out
> fakely it has written the number of bytes. When the program calls does a
> close(2) of the fd, then the complete inode is deleted in the memory.
> 
> The directory should  be permanently empty except for the inodes with open
> file descriptors. So only inode information would be temporary saved in this
> "nulldir tmpfs" directory.
> 
> Is there already existing a possibility to create a null directory?

Please try the patch below. It will add an autounlink option to
tmpfs, which should automatically get rid of non-referenced files.

diff -X dontdiff -dpruN linux-2.6.24.pure/include/linux/shmem_fs.h
linux-2.6.24.autounlink/include/linux/shmem_fs.h
--- linux-2.6.24.pure/include/linux/shmem_fs.h  2006-11-29 22:57:37.000000000
+0100
+++ linux-2.6.24.autounlink/include/linux/shmem_fs.h    2008-02-14
15:35:01.000000000 +0100
@@ -30,11 +30,14 @@ struct shmem_sb_info {
        unsigned long free_blocks;  /* How many are left for allocation */
        unsigned long max_inodes;   /* How many inodes are allowed */
        unsigned long free_inodes;  /* How many are left for allocation */
-       int policy;                 /* Default NUMA memory alloc policy */
-       nodemask_t policy_nodes;    /* nodemask for preferred and bind */
+       unsigned int  flags;
+       int           policy;       /* Default NUMA memory alloc policy */
+       nodemask_t    policy_nodes; /* nodemask for preferred and bind */
        spinlock_t    stat_lock;
 };
 
+#define TMPFS_FL_AUTOREMOVE 1
+
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
 {
        return container_of(inode, struct shmem_inode_info, vfs_inode);
diff -X dontdiff -dpruN linux-2.6.24.pure/mm/shmem.c
linux-2.6.24.autounlink/mm/shmem.c
--- linux-2.6.24.pure/mm/shmem.c        2008-01-25 15:09:39.000000000 +0100
+++ linux-2.6.24.autounlink/mm/shmem.c  2008-02-14 18:00:54.000000000 +0100
@@ -1747,31 +1747,41 @@ static int
 shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
        struct inode *inode = shmem_get_inode(dir->i_sb, mode, dev);
+       struct shmem_sb_info *sbinfo = SHMEM_SB(dir->i_sb);
        int error = -ENOSPC;
 
-       if (inode) {
-               error = security_inode_init_security(inode, dir, NULL, NULL,
-                                                    NULL);
-               if (error) {
-                       if (error != -EOPNOTSUPP) {
-                               iput(inode);
-                               return error;
-                       }
-               }
-               error = shmem_acl_init(inode, dir);
-               if (error) {
+       if (!inode)
+               return error;
+
+       error = security_inode_init_security(inode, dir, NULL, NULL,
+                                            NULL);
+       if (error) {
+               if (error != -EOPNOTSUPP) {
                        iput(inode);
                        return error;
                }
-               if (dir->i_mode & S_ISGID) {
-                       inode->i_gid = dir->i_gid;
-                       if (S_ISDIR(mode))
-                               inode->i_mode |= S_ISGID;
-               }
-               dir->i_size += BOGO_DIRENT_SIZE;
-               dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-               d_instantiate(dentry, inode);
+       }
+       error = shmem_acl_init(inode, dir);
+       if (error) {
+               iput(inode);
+               return error;
+       }
+       if (dir->i_mode & S_ISGID) {
+               inode->i_gid = dir->i_gid;
+               if (S_ISDIR(mode))
+                       inode->i_mode |= S_ISGID;
+       }
+
+       dir->i_size += BOGO_DIRENT_SIZE;
+       dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+       d_instantiate(dentry, inode);
+       if ( S_ISDIR(mode)
+         || !(sbinfo->flags & TMPFS_FL_AUTOREMOVE))
+       {
                dget(dentry); /* Extra count - pin the dentry in core */
+       } else {
+               dir->i_size -= BOGO_DIRENT_SIZE;
+               drop_nlink(inode);
        }
        return error;
 }
@@ -1800,6 +1810,11 @@ static int shmem_link(struct dentry *old
        struct inode *inode = old_dentry->d_inode;
        struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 
+       /* In auto-unlink mode, the newly created link would be unlinked
+          immediately. We don't need to do anything here. */
+       if (sbinfo->flags & TMPFS_FL_AUTOREMOVE)
+               return 0;
+
        /*
         * No ordinary (disk based) filesystem counts links as inodes;
         * but each new link needs a new dentry, pinning lowmem, and
@@ -2095,6 +2110,7 @@ static const struct export_operations sh
 
 static int shmem_parse_options(char *options, int *mode, uid_t *uid,
        gid_t *gid, unsigned long *blocks, unsigned long *inodes,
+       unsigned int * flags,
        int *policy, nodemask_t *policy_nodes)
 {
        char *this_char, *value, *rest;
@@ -2120,8 +2136,18 @@ static int shmem_parse_options(char *opt
                        continue;
                if ((value = strchr(this_char,'=')) != NULL) {
                        *value++ = 0;
+
+               /* These options don't take arguments: */
+               } else if (!strcmp(this_char,"autounlink")) {
+                       *flags |= TMPFS_FL_AUTOREMOVE;
+                       continue;
+               } else if (!strcmp(this_char,"noautounlink")) {
+                       *flags &= ~TMPFS_FL_AUTOREMOVE;
+                       continue;
+
+               /* All other options need an argument */
                } else {
-                       printk(KERN_ERR
+                       printk(KERN_ERR 
                            "tmpfs: No value for mount option '%s'\n",
                            this_char);
                        return 1;
@@ -2192,10 +2218,12 @@ static int shmem_remount_fs(struct super
        nodemask_t policy_nodes = sbinfo->policy_nodes;
        unsigned long blocks;
        unsigned long inodes;
+       unsigned int sbflags;
        int error = -EINVAL;
 
+       sbflags = sbinfo->flags;
        if (shmem_parse_options(data, NULL, NULL, NULL, &max_blocks,
-                               &max_inodes, &policy, &policy_nodes))
+                               &max_inodes, &sbflags, &policy, &policy_nodes))
                return error;
 
        spin_lock(&sbinfo->stat_lock);
@@ -2221,6 +2249,7 @@ static int shmem_remount_fs(struct super
        sbinfo->free_blocks = max_blocks - blocks;
        sbinfo->max_inodes  = max_inodes;
        sbinfo->free_inodes = max_inodes - inodes;
+       sbinfo->flags = sbflags;
        sbinfo->policy = policy;
        sbinfo->policy_nodes = policy_nodes;
 out:
@@ -2247,6 +2276,7 @@ static int shmem_fill_super(struct super
        struct shmem_sb_info *sbinfo;
        unsigned long blocks = 0;
        unsigned long inodes = 0;
+       unsigned int flags = 0;
        int policy = MPOL_DEFAULT;
        nodemask_t policy_nodes = node_states[N_HIGH_MEMORY];
 
@@ -2262,7 +2292,7 @@ static int shmem_fill_super(struct super
                if (inodes > blocks)
                        inodes = blocks;
                if (shmem_parse_options(data, &mode, &uid, &gid, &blocks,
-                                       &inodes, &policy, &policy_nodes))
+                                       &inodes, &flags, &policy, &policy_nodes))
                        return -EINVAL;
        }
        sb->s_export_op = &shmem_export_ops;
@@ -2281,6 +2311,7 @@ static int shmem_fill_super(struct super
        sbinfo->free_blocks = blocks;
        sbinfo->max_inodes = inodes;
        sbinfo->free_inodes = inodes;
+       sbinfo->flags = flags;
        sbinfo->policy = policy;
        sbinfo->policy_nodes = policy_nodes;
 


