Return-Path: <linux-kernel-owner+w=401wt.eu-S1765121AbXJRP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765121AbXJRP1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXJRP03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:26:29 -0400
Received: from services.sin.cvut.cz ([147.32.110.2]:60160 "EHLO
	services.sin.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765638AbXJRP00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:26:26 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 11:26:25 EDT
From: Jaroslav Sykora <jara@sin.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/5] Shadow directories: procfs
Date: Thu, 18 Oct 2007 17:26:23 +0200
User-Agent: KMail/1.9.7
References: <200710181721.09201.jara@sin.cvut.cz>
In-Reply-To: <200710181721.09201.jara@sin.cvut.cz>
X-Face: >I|[{8s3:Ic!^A\YY'ktAfvq]K.-@B=!>(:.VX7_KNlZ@`l)vxL}2g~)k(#@=?utf-8?q?BN=24U+3MgB2=0A=097yR=5D=26tZ8PTc=3D=60?=<A%=5!.VCQ~(<-2#;/xmM4t6'MB7zDSm7i$nn/x^TC*adoyqd"{b0,=?utf-8?q?Hr=5F=0A=09?=<.yl<O}[Z[s.oX/:P917[b9QB%3f]{m=`7azOx[(.XW)"nW?N]jA5=%!<=?utf-8?q?=27ayW=5E!NQg6RcZ=0A=09vG?=@\&{XT%rV)u^hXq%ecRC;$jLBaa>ZZB_o
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181726.23976.jara@sin.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Procfs interface: /proc/<pid>/status, /proc/<pid>/{root-shdw, cwd-shdw}.

Signed-off-by: Jaroslav Sykora <jaroslav.sykora@gmail.com>

 fs/proc/array.c |   23 +++++++++++++++++++
 fs/proc/base.c  |   53 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

--- orig/fs/proc/base.c	2007-10-07 19:00:20.000000000 +0200
+++ new/fs/proc/base.c	2007-10-07 13:39:08.000000000 +0200
@@ -171,6 +171,32 @@ static int proc_cwd_link(struct inode *i
 	return result;
 }
 
+static int proc_shdwcwd_link(struct inode *inode, struct dentry **dentry,
+			     struct vfsmount **mnt)
+{
+	struct task_struct *task = get_proc_task(inode);
+	struct fs_struct *fs = NULL;
+	int result = -ENOENT;
+
+	if (task) {
+		fs = get_fs_struct(task);
+		put_task_struct(task);
+	}
+	if (fs) {
+		read_lock(&fs->lock);
+		*dentry = dget(fs->shdwpwd);
+		if (fs->shdwpwd)
+			*mnt = mntget(fs->shdwpwdmnt);
+		else
+			*mnt = NULL;
+		read_unlock(&fs->lock);
+		if (*dentry)
+			result = 0;
+		put_fs_struct(fs);
+	}
+	return result;
+}
+
 static int proc_root_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
 {
 	struct task_struct *task = get_proc_task(inode);
@@ -192,6 +218,29 @@ static int proc_root_link(struct inode *
 	return result;
 }
 
+static int proc_shdwroot_link(struct inode *inode, struct dentry **dentry,
+			      struct vfsmount **mnt)
+{
+	struct task_struct *task = get_proc_task(inode);
+	struct fs_struct *fs = NULL;
+	int result = -ENOENT;
+
+	if (task) {
+		fs = get_fs_struct(task);
+		put_task_struct(task);
+	}
+	if (fs) {
+		read_lock(&fs->lock);
+		*mnt = mntget(fs->shdwrootmnt);
+		*dentry = dget(fs->shdwroot);
+		read_unlock(&fs->lock);
+		if (*dentry)
+			result = 0;
+		put_fs_struct(fs);
+	}
+	return result;
+}
+
 #define MAY_PTRACE(task) \
 	(task == current || \
 	(task->parent == current && \
@@ -2094,6 +2143,8 @@ static const struct pid_entry tgid_base_
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
 	REG("coredump_filter", S_IRUGO|S_IWUSR, coredump_filter),
 #endif
+	LNK("root-shdw",  shdwroot),
+	LNK("cwd-shdw",   shdwcwd),
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, pid_io_accounting),
 #endif
@@ -2377,6 +2428,8 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+	LNK("root-shdw", shdwroot),
+	LNK("cwd-shdw",  shdwcwd),
 };
 
 static int proc_tid_base_readdir(struct file * filp,
--- orig/fs/proc/array.c	2007-10-07 19:00:20.000000000 +0200
+++ new/fs/proc/array.c	2007-10-07 19:57:03.000000000 +0200
@@ -298,6 +298,28 @@ static inline char *task_context_switch_
 			    p->nivcsw);
 }
 
+static inline char *task_fsinfo(struct task_struct *p, char *buffer)
+{
+	int enabled = 0, use_esc = 0, esc_ch = 0;
+
+	rcu_read_lock();
+	task_lock(p);
+	if (p->fs) {
+		read_lock(&p->fs->lock);
+		enabled = (p->fs->flags & SHDW_ENABLED) ? 1 : 0;
+		use_esc = (p->fs->flags & SHDW_USE_ESC) ? 1 : 0;
+		esc_ch = p->fs->shdw_escch;
+		read_unlock(&p->fs->lock);
+	}
+	task_unlock(p);
+	rcu_read_unlock();
+
+	return buffer + sprintf(buffer, "Shdw_Enabled:\t%d\n"
+				"Shdw_UseEscChar: %d\n"
+				"Shdw_EscChar:\t%u\n",
+				enabled, use_esc, (unsigned int)esc_ch);
+}
+
 int proc_pid_status(struct task_struct *task, char *buffer)
 {
 	char *orig = buffer;
@@ -317,6 +339,7 @@ int proc_pid_status(struct task_struct *
 	buffer = task_show_regs(task, buffer);
 #endif
 	buffer = task_context_switch_counts(task, buffer);
+	buffer = task_fsinfo(task, buffer);
 	return buffer - orig;
 }
 
