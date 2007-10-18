Return-Path: <linux-kernel-owner+w=401wt.eu-S934154AbXJRP56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbXJRP56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764971AbXJRP4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:56:25 -0400
Received: from services.sin.cvut.cz ([147.32.110.2]:60460 "EHLO
	services.sin.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763476AbXJRP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:56:17 -0400
From: Jaroslav Sykora <jara@sin.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/5] Shadow directories: chdir, fchdir
Date: Thu, 18 Oct 2007 17:25:15 +0200
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
Message-Id: <200710181725.15721.jara@sin.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_chdir and sys_fchdir changes.

Signed-off-by: Jaroslav Sykora <jaroslav.sykora@gmail.com>

 fs/open.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 6 deletions(-)

--- orig/fs/open.c	2007-10-07 19:00:19.000000000 +0200
+++ new/fs/open.c	2007-10-16 21:04:56.000000000 +0200
@@ -476,13 +476,51 @@ asmlinkage long sys_access(const char __
 	return sys_faccessat(AT_FDCWD, filename, mode);
 }
 
+static inline int read_fs_flags(void)
+{
+	int res;
+	read_lock(&current->fs->lock);
+	res = current->fs->flags;
+	read_unlock(&current->fs->lock);
+	return res;
+}
+
+void set_fs_shdwpwd(struct fs_struct *fs,
+			struct vfsmount *mnt, struct dentry *dentry)
+{
+	struct dentry *old_dentry;
+	struct vfsmount *old_mnt;
+
+	BUG_ON(dentry != NULL && mnt == NULL);
+	write_lock(&fs->lock);
+	/* set shadow pwd */
+	old_dentry = fs->shdwpwd;
+	old_mnt = fs->shdwpwdmnt;
+	fs->shdwpwd = dget(dentry);
+	if (dentry)
+		fs->shdwpwdmnt = mntget(mnt);
+	else
+		/* PTR_ERR flag */
+		fs->shdwpwdmnt = mnt;
+	write_unlock(&fs->lock);
+
+	if (old_dentry) {
+		mntput(old_mnt);
+		dput(old_dentry);
+	}
+}
+
 asmlinkage long sys_chdir(const char __user * filename)
 {
 	struct nameidata nd;
-	int error;
+	char *tmp = getname(filename);
+	int error = PTR_ERR(tmp);;
+
+	if (IS_ERR(tmp))
+		goto out_badname;
 
-	error = __user_walk(filename,
-			    LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_CHDIR, &nd);
+	error = path_lookup(tmp, LOOKUP_FOLLOW | LOOKUP_DIRECTORY
+			| LOOKUP_CHDIR, &nd);
 	if (error)
 		goto out;
 
@@ -490,11 +528,23 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto dput_and_out;
 
-	set_fs_pwd(current->fs, nd.mnt, nd.dentry);
+	if (!(read_fs_flags() & SHDW_ENABLED))
+		goto set_std;
 
+	if (!(nd.flags & LOOKUP_INSHDW))
+		set_fs_shdwpwd(current->fs, NULL, NULL);
+	else
+		/* shadow == std */
+		set_fs_shdwpwd(current->fs, nd.mnt, nd.dentry);
+
+set_std:
+	/* set std cwd */
+	set_fs_pwd(current->fs, nd.mnt, nd.dentry);
 dput_and_out:
 	path_release(&nd);
 out:
+	putname(tmp);
+out_badname:
 	return error;
 }
 
@@ -520,8 +570,25 @@ asmlinkage long sys_fchdir(unsigned int 
 		goto out_putf;
 
 	error = file_permission(file, MAY_EXEC);
-	if (!error)
-		set_fs_pwd(current->fs, mnt, dentry);
+	if (error)
+		goto out_putf;
+
+	set_fs_pwd(current->fs, mnt, dentry);
+
+	if (!(read_fs_flags() & SHDW_ENABLED))
+		/* shadow dirs aren't enabled */
+		goto out_putf;
+
+	if (get_file_shdwdir(file, &dentry, &mnt))
+		/* some error ocured */
+		set_fs_shdwpwd(current->fs, NULL, NULL);
+	else {
+		/* ok */
+		set_fs_shdwpwd(current->fs, mnt, dentry);
+		mntput(mnt);
+		dput(dentry);
+	}
+
 out_putf:
 	fput(file);
 out:
