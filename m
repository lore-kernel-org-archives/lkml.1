Return-Path: <linux-kernel-owner+w=401wt.eu-S1763858AbZARHho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763858AbZARHho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 02:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760196AbZARHhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 02:37:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115AbZARHhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:37:08 -0500
Date: Sun, 18 Jan 2009 08:34:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com, raven@themaw.net
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] autofs4: turn ->oz_pgrp into "struct pid *"
Message-ID: <20090118073449.GA707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile tested, please review, depends on
	pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch

Nowadays task_struct-> __session/__pgrp are writeonly, except task_pgrp_nr()
is wrongly used by some filesystems, and autofs4 is the major offender.

Turn autofs_sb_info->oz_pgrp into "struct pid*" to make it namespace-friendly.

I guess autofs4_show_options()->pid_vnr() is not exactly right, but hopefully
not worse than the current code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/fs/autofs4/autofs_i.h~2_AUTOFS4	2009-01-12 23:07:46.000000000 +0100
+++ CUR/fs/autofs4/autofs_i.h	2009-01-18 06:51:07.000000000 +0100
@@ -119,7 +119,7 @@ struct autofs_sb_info {
 	u32 magic;
 	int pipefd;
 	struct file *pipe;
-	pid_t oz_pgrp;
+	struct pid *oz_pgrp;
 	int catatonic;
 	int version;
 	int sub_version;
@@ -153,7 +153,7 @@ static inline struct autofs_info *autofs
    filesystem without "magic".) */
 
 static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
-	return sbi->catatonic || task_pgrp_nr(current) == sbi->oz_pgrp;
+	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
 /* Does a dentry have some pending activity? */
--- CUR/fs/autofs4/dev-ioctl.c~2_AUTOFS4	2009-01-12 23:07:46.000000000 +0100
+++ CUR/fs/autofs4/dev-ioctl.c	2009-01-18 07:34:05.000000000 +0100
@@ -429,7 +429,8 @@ static int autofs_dev_ioctl_setpipefd(st
 			fput(pipe);
 			goto out;
 		}
-		sbi->oz_pgrp = task_pgrp_nr(current);
+		put_pid(sbi->oz_pgrp);
+		sbi->oz_pgrp = get_task_pid(current, PIDTYPE_PGID);
 		sbi->pipefd = pipefd;
 		sbi->pipe = pipe;
 		sbi->catatonic = 0;
--- CUR/fs/autofs4/inode.c~2_AUTOFS4	2009-01-12 23:07:46.000000000 +0100
+++ CUR/fs/autofs4/inode.c	2009-01-18 07:44:28.000000000 +0100
@@ -172,6 +172,7 @@ void autofs4_kill_sb(struct super_block 
 	autofs4_force_release(sbi);
 
 	sb->s_fs_info = NULL;
+	put_pid(sbi->oz_pgrp);
 	kfree(sbi);
 
 out_kill_sb:
@@ -192,7 +193,7 @@ static int autofs4_show_options(struct s
 		seq_printf(m, ",uid=%u", root_inode->i_uid);
 	if (root_inode->i_gid != 0)
 		seq_printf(m, ",gid=%u", root_inode->i_gid);
-	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
+	seq_printf(m, ",pgrp=%d", pid_vnr(sbi->oz_pgrp));
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
 	seq_printf(m, ",maxproto=%d", sbi->max_proto);
@@ -229,7 +230,8 @@ static const match_table_t tokens = {
 };
 
 static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
-		pid_t *pgrp, unsigned int *type, int *minproto, int *maxproto)
+			 struct pid **pgrp, unsigned int *type, int *minproto,
+			 int *maxproto)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -237,7 +239,6 @@ static int parse_options(char *options, 
 
 	*uid = current_uid();
 	*gid = current_gid();
-	*pgrp = task_pgrp_nr(current);
 
 	*minproto = AUTOFS_MIN_PROTO_VERSION;
 	*maxproto = AUTOFS_MAX_PROTO_VERSION;
@@ -271,7 +272,9 @@ static int parse_options(char *options, 
 		case Opt_pgrp:
 			if (match_int(args, &option))
 				return 1;
-			*pgrp = option;
+			*pgrp = find_get_pid(option);
+			if (!*pgrp)
+				return 1;
 			break;
 		case Opt_minproto:
 			if (match_int(args, &option))
@@ -296,6 +299,10 @@ static int parse_options(char *options, 
 			return 1;
 		}
 	}
+
+	if (!*pgrp)
+		*pgrp = get_task_pid(current, PIDTYPE_PGID);
+
 	return (*pipefd < 0);
 }
 
@@ -334,7 +341,6 @@ int autofs4_fill_super(struct super_bloc
 	sbi->pipe = NULL;
 	sbi->catatonic = 1;
 	sbi->exp_timeout = 0;
-	sbi->oz_pgrp = task_pgrp_nr(current);
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
@@ -401,7 +407,7 @@ int autofs4_fill_super(struct super_bloc
 		sbi->version = sbi->max_proto;
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
 
-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
+	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, pid_vnr(sbi->oz_pgrp));
 	pipe = fget(pipefd);
 	
 	if (!pipe) {
@@ -436,6 +442,7 @@ fail_iput:
 fail_ino:
 	kfree(ino);
 fail_free:
+	put_pid(sbi->oz_pgrp);
 	kfree(sbi);
 	s->s_fs_info = NULL;
 fail_unlock:
--- CUR/fs/autofs4/root.c~2_AUTOFS4	2008-10-10 00:13:53.000000000 +0200
+++ CUR/fs/autofs4/root.c	2009-01-18 08:09:35.000000000 +0100
@@ -483,7 +483,7 @@ static struct dentry *autofs4_lookup(str
 	oz_mode = autofs4_oz_mode(sbi);
 
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
-		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
+		 current->pid, task_pgrp_vnr(current), sbi->catatonic, oz_mode);
 
 	expiring = autofs4_lookup_expiring(sbi, dentry->d_parent, &dentry->d_name);
 	if (expiring) {
@@ -877,7 +877,7 @@ static int autofs4_root_ioctl(struct ino
 	void __user *p = (void __user *)arg;
 
 	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
-		cmd,arg,sbi,task_pgrp_nr(current));
+		cmd, arg, sbi, task_pgrp_vnr(current));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)

