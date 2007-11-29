Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbXK2Okl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbXK2Okl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbXK2Okd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:40:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:40404 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932162AbXK2Okc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:40:32 -0500
Date: Thu, 29 Nov 2007 15:40:30 +0100
From: Jan Kara <jack@suse.cz>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, nfs@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [BUG] 2.6.24-rc3-mm2 kernel bug on nfs & cifs mounted partitions
Message-ID: <20071129144030.GE16558@duck.suse.cz>
References: <20071128034140.648383f0.akpm@linux-foundation.org> <474E7F9E.9000601@linux.vnet.ibm.com> <20071129010906.772e0c15.akpm@linux-foundation.org> <474EA914.1060502@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474EA914.1060502@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29-11-07 17:27:08, Kamalesh Babulal wrote:
> Andrew Morton wrote:
> > On Thu, 29 Nov 2007 14:30:14 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > 
> >> Hi Andrew,
> >>
> >> While running file system stress on nfs and cifs mounted partitions, the machine
> >> drops to xmon
> >>
> >> 1:mon> e
> >> cpu 0x1: Vector: 300 (Data Access) at [c000000080a9f880]
> >>     pc: c0000000001392c8: .inotify_inode_queue_event+0x50/0x158
> >>     lr: c0000000001074d0: .vfs_link+0x204/0x298
> >>     sp: c000000080a9fb00
> >>    msr: 8000000000009032
> >>    dar: 280 
> >>  dsisr: 40010000
> >>   current = 0xc0000000c8e6f670
> >>   paca    = 0xc000000000512c00
> >>     pid   = 2848, comm = fsstress
> >> 1:mon> t
> >> [c000000080a9fbd0] c0000000001074d0 .vfs_link+0x204/0x298
> >> [c000000080a9fc70] c00000000010b6e0 .sys_linkat+0x134/0x1b4
> >> [c000000080a9fe30] c00000000000872c syscall_exit+0x0/0x40
> >> --- Exception: c00 (System Call) at 000000000ff1bdfc
> >> SP (ffeaed10) is in userspace
> >> 1:mon> r
> >> R00 = c0000000001074d0   R16 = 0000000000000000
> >> R01 = c000000080a9fb00   R17 = 0000000000000000
> >> R02 = c00000000060c380   R18 = 0000000000000000
> >> R03 = 0000000000000000   R19 = 0000000000000000
> >> R04 = 0000000000000004   R20 = 0000000000000000
> >> R05 = 0000000000000000   R21 = 0000000000000000
> >> R06 = 0000000000000000   R22 = 0000000000000000
> >> R07 = 0000000000000000   R23 = 0000000000000004
> >> R08 = 0000000000000000   R24 = 0000000000000280
> >> R09 = 0000000000000000   R25 = fffffffffffff000
> >> R10 = 0000000000000001   R26 = c000000082827790
> >> R11 = c0000000003963e8   R27 = c0000000828275a0
> >> R12 = d000000000deec78   R28 = 0000000000000000
> >> R13 = c000000000512c00   R29 = c00000007b18fcf0
> >> R14 = 0000000000000000   R30 = c0000000005bc088
> >> R15 = 0000000000000000   R31 = 0000000000000000
> >> pc  = c0000000001392c8 .inotify_inode_queue_event+0x50/0x158
> >> lr  = c0000000001074d0 .vfs_link+0x204/0x298
> >> msr = 8000000000009032   cr  = 24000882
> >> ctr = c0000000003963e8   xer = 0000000000000000   trap =  300 
> >> dar = 0000000000000280   dsisr = 40010000
> >>
> >>
> >> The gdb output shows 
> >>
> >> 0xc0000000001076d4 is in vfs_symlink (include/linux/fsnotify.h:108).
> >> 103      * fsnotify_create - 'name' was linked in
> >> 104      */  
> >> 105     static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
> >> 106     {   
> >> 107             inode_dir_notify(inode, DN_CREATE);
> >> 108             inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
> >> 109                                       dentry->d_inode);
> >> 110             audit_inode_child(dentry->d_name.name, dentry, inode);
> >> 111     }   
> >> 112
> >>
> > 
> > If it is reproducible can you please try reverting
> > inotify-send-in_attrib-events-when-link-count-changes.patch?
> 
> Hi Andrew,
> 
> reverting the patch inotify-send-in_attrib-events-when-link-count-changes.patch, the 
> bug is not reproduced.
  OK, it's a problem with CIFS. Its cifs_hardlink() function doesn't call
d_instantiate() and thus returns a dentry with d_inode set to NULL. I'm not
sure if such behavior is really correct but anyway, attached is a new
version of the patch which should handle it gracefully. Kamalesh, can you
please give it a try? Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

  Currently, no notification event has been sent when inode's link count
changed. This is inconvenient for the application in some cases:
  Suppose you have the following directory structure
    foo/test
    bar/

  and you watch test. If someone does "mv foo/test bar/", you get event
IN_MOVE_SELF and you know something has happened with the file "test".
However if someone does "ln foo/test bar/test" and "rm foo/test" you get no
inotify event for the file "test" (only directories "foo" and "bar" receive
events).
  Furthermore it could be argued that link count belongs to file's metadata
and thus IN_ATTRIB should be sent when it changes.
  The following patch implements sending of IN_ATTRIB inotify events when
link count of the inode changes, i.e., when a hardlink to the inode is
created or when it is removed. This event is sent in addition to all the
events sent so far. In particular, when a last link to a file is removed,
IN_ATTRIB event is sent in addition to IN_DELETE_SELF event.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/namei.c b/fs/namei.c
index 3b993db..c1839d1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2188,6 +2188,7 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
 	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+		fsnotify_link_count(dentry->d_inode);
 		d_delete(dentry);
 	}
 
@@ -2360,7 +2361,7 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	error = dir->i_op->link(old_dentry, dir, new_dentry);
 	mutex_unlock(&old_dentry->d_inode->i_mutex);
 	if (!error)
-		fsnotify_create(dir, new_dentry);
+		fsnotify_link(dir, old_dentry->d_inode, new_dentry);
 	return error;
 }
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 2bd31fa..d4b7c4a 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -92,6 +92,14 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 }
 
 /*
+ * fsnotify_link_count - inode's link count changed
+ */
+static inline void fsnotify_link_count(struct inode *inode)
+{
+	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
+}
+
+/*
  * fsnotify_create - 'name' was linked in
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
@@ -103,6 +111,20 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 }
 
 /*
+ * fsnotify_link - new hardlink in 'inode' directory
+ * Note: We have to pass also the linked inode ptr as some filesystems leave
+ *   new_dentry->d_inode NULL and instantiate inode pointer later
+ */
+static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
+{
+	inode_dir_notify(dir, DN_CREATE);
+	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
+				  inode);
+	fsnotify_link_count(inode);
+	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
+}
+
+/*
  * fsnotify_mkdir - directory 'name' was created
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
