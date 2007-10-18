Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbXJRP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbXJRP5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764807AbXJRP4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:56:22 -0400
Received: from services.sin.cvut.cz ([147.32.110.2]:60459 "EHLO
	services.sin.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763423AbXJRP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:56:17 -0400
From: Jaroslav Sykora <jara@sin.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/5] Shadow directories: headers
Date: Thu, 18 Oct 2007 17:22:37 +0200
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
Message-Id: <200710181722.37629.jara@sin.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Header file changes for shadow directories.
Adds pointers to shadows dirs to the struct file and struct fs_struct.
Defines internal lookup flags and syscall flags.

Signed-off-by: Jaroslav Sykora <jaroslav.sykora@gmail.com>

 include/linux/file.h      |    2 ++
 include/linux/fs.h        |   18 ++++++++++++++++++
 include/linux/fs_struct.h |   25 +++++++++++++++++++++++++
 include/linux/namei.h     |   16 ++++++++++++++++
 4 files changed, 61 insertions(+)

--- orig/include/linux/fs.h	2007-10-07 19:00:24.000000000 +0200
+++ new/include/linux/fs.h	2007-10-07 13:39:08.000000000 +0200
@@ -266,6 +266,14 @@ extern int dir_notify_enable;
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+/* sys_setshdwinfo(), sys_getshdwinfo(): */
+#define FSI_SHDW_ENABLE		1	/* enable shadow directories */
+#define FSI_SHDW_ESC_EN		2	/* enable use of escape character */
+#define FSI_SHDW_ESC_CHAR	3	/* specify escape character */
+/* sys_setshdwpath */
+#define SHDW_FD_ROOT		-1	/* pseudo FD for root shadow dir */
+#define SHDW_FD_PWD		-2	/* pseudo FD for pwd shadow dir */
+
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
@@ -752,6 +760,16 @@ struct file {
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+
+	/* the following fields are protected by f_owner.lock */
+	/* | f_shdw   | f_shdwmnt   | result
+	   +----------+-------------+------------
+	   | NULL     | NULL        | delayed
+	   | NULL     | !NULL       | invalid
+	   | !NULL    | NULL        | BUG
+	   | !NULL    | !NULL       | valid */
+	struct dentry		*f_shdw;
+	struct vfsmount		*f_shdwmnt;
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
--- orig/include/linux/fs_struct.h	2007-07-09 01:32:17.000000000 +0200
+++ new/include/linux/fs_struct.h	2007-10-07 13:39:08.000000000 +0200
@@ -10,8 +10,31 @@ struct fs_struct {
 	int umask;
 	struct dentry * root, * pwd, * altroot;
 	struct vfsmount * rootmnt, * pwdmnt, * altrootmnt;
+
+	int flags;
+	/* shadow dirs: root and pwd */
+	/* | shdwroot | shdwrootmnt | result
+	   +----------+-------------+------------
+	   | NULL     | NULL        | BUG_ON(flags&SHDW_ENABLED)
+	   | !NULL    | !NULL       | ok
+	   +==========+=============+============
+	   | shdwpwd  | shdwpwdmnt  | result
+	   +----------+-------------+------------
+	   | NULL     | NULL        | delayed
+	   | NULL     | !NULL       | invalid
+	   | !NULL    | NULL        | BUG
+	   | !NULL    | !NULL       | valid */
+	struct dentry *shdwroot, *shdwpwd;
+	struct vfsmount *shdwrootmnt, *shdwpwdmnt;
+	/* shadow dirs: escape character */
+	unsigned char shdw_escch;
 };
 
+/* bitflags for fs_struct.flags */
+#define SHDW_ENABLED		1	/* are shadow dirs enabled? */
+#define SHDW_USE_ESC		2	/* use escape char in shadow dirs? */
+
+
 #define INIT_FS {				\
 	.count		= ATOMIC_INIT(1),	\
 	.lock		= RW_LOCK_UNLOCKED,	\
@@ -24,6 +47,8 @@ extern void exit_fs(struct task_struct *
 extern void set_fs_altroot(void);
 extern void set_fs_root(struct fs_struct *, struct vfsmount *, struct dentry *);
 extern void set_fs_pwd(struct fs_struct *, struct vfsmount *, struct dentry *);
+extern void set_fs_shdwpwd(struct fs_struct *fs,
+			   struct vfsmount *mnt, struct dentry *dentry);
 extern struct fs_struct *copy_fs_struct(struct fs_struct *);
 extern void put_fs_struct(struct fs_struct *);
 
--- orig/include/linux/namei.h	2007-10-07 19:00:25.000000000 +0200
+++ new/include/linux/namei.h	2007-10-07 20:03:11.000000000 +0200
@@ -22,6 +22,7 @@ struct nameidata {
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
+	unsigned char	find_char;
 
 	/* Intent data */
 	union {
@@ -54,6 +55,16 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_PARENT		16
 #define LOOKUP_NOALT		32
 #define LOOKUP_REVAL		64
+
+/* don't fallback to lookup in shadow directory */
+#define LOOKUP_NOSHDW		128
+/* try to find nameidata.find_char in pathname,
+ * set LOOKUP_CHARFOUND in nameidata.flags if found */
+#define LOOKUP_FINDCHAR		(1<<16)
+#define LOOKUP_CHARFOUND	(1<<17)
+/* (dentry,mnt) was found in shadow dir */
+#define LOOKUP_INSHDW		(1<<18)
+
 /*
  * Intent data
  */
@@ -68,6 +79,8 @@ extern int FASTCALL(__user_walk_fd(int d
 	__user_walk_fd(AT_FDCWD, name, LOOKUP_FOLLOW, nd)
 #define user_path_walk_link(name,nd) \
 	__user_walk_fd(AT_FDCWD, name, 0, nd)
+extern int FASTCALL(path_lookup_shdw(int dfd, const char *name,
+			unsigned int flags, struct nameidata *nd));
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
@@ -90,6 +103,9 @@ extern int follow_up(struct vfsmount **,
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 
+extern int get_file_shdwdir(struct file *file, struct dentry **dentry,
+			    struct vfsmount **mnt);
+
 static inline void nd_set_link(struct nameidata *nd, char *path)
 {
 	nd->saved_names[nd->depth] = path;
--- orig/include/linux/file.h	2007-10-07 19:00:24.000000000 +0200
+++ new/include/linux/file.h	2007-10-16 21:06:51.000000000 +0200
@@ -68,6 +68,8 @@ static inline void fput_light(struct fil
 		fput(file);
 }
 
+extern struct file *FASTCALL(__fget(struct files_struct *files,
+				unsigned int fd));
 extern struct file * FASTCALL(fget(unsigned int fd));
 extern struct file * FASTCALL(fget_light(unsigned int fd, int *fput_needed));
 extern void FASTCALL(set_close_on_exec(unsigned int fd, int flag));


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.
