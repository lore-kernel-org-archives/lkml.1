Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZI2HKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZI2HKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 03:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZI2HKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 03:10:36 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:43705 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZI2HKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 03:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sRDFAfQ7/Mbl/ER3Yd7iJoBTf/Q34Hr5y5wXoSg49uyZX9we/Jl+X2fMs6+5gWPbmu
         GF/yBmDbueiDiQaalaOT69rL1hgSZsjQmN/jUO9blTOSo0Z8n8lxYOj3W1DuFTTpgnmK
         zqEN3U1gmq746APne2dPtMlIXBuHgqEQAP3Dc=
Date: Tue, 29 Sep 2009 07:10:10 +0000
From: Andy Spencer <andy753421@gmail.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Permission masking security module (was dpriv)
Message-ID: <20090929071010.GA17782@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-17899-1254208234-0001-2"
Content-Disposition: inline
In-Reply-To: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-17899-1254208234-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Changes since the previous patch (dpriv-p0):

- Change the name to pmask (Permission Masking)

- Use recursive and non-recursive variants for setting masks=20
  $ echo self $perm $path > $stage # Set perms for $path only
  $ echo kids $perm $path > $stage # Set perms for children of $path
  $ echo both $perm $path > $stage # Set perms for $path and children

- Add a quota of 500 permission lines per policy

- Improve securityfs parsing.

- Change '-' to '.' in permissions string to avoid confusion with
  `chmod -rwx foo'

- Many syntax/naming/etc bug fixes

Signed-off-by: Andy Spencer <andy753421@gmail.com>
---
 Documentation/pmask.txt |  102 ++++++++++++++
 lib/vsprintf.c          |    2 +-
 security/Kconfig        |    1 +
 security/Makefile       |    2 +
 security/pmask/Kconfig  |    8 +
 security/pmask/Makefile |    1 +
 security/pmask/fs.c     |  299 +++++++++++++++++++++++++++++++++++++++++
 security/pmask/pmask.c  |  144 ++++++++++++++++++++
 security/pmask/policy.c |  337 +++++++++++++++++++++++++++++++++++++++++++=
++++
 security/pmask/policy.h |  230 ++++++++++++++++++++++++++++++++
 10 files changed, 1125 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/pmask.txt
 create mode 100644 security/pmask/Kconfig
 create mode 100644 security/pmask/Makefile
 create mode 100644 security/pmask/fs.c
 create mode 100644 security/pmask/pmask.c
 create mode 100644 security/pmask/policy.c
 create mode 100644 security/pmask/policy.h

diff --git a/Documentation/pmask.txt b/Documentation/pmask.txt
new file mode 100644
index 0000000..522cb30
--- /dev/null
+++ b/Documentation/pmask.txt
@@ -0,0 +1,102 @@
+Source code
+-----------
+  policy.[ch] - policy datatypes
+  pmask.c     - security/credentials hooks
+  fs.c        - securityfs hooks
+
+
+TODO
+----
+  - Check for race conditions
+
+
+Overview
+--------
+1. Each process keeps a list of inode -> priv mappings:
+   - i.e. the security policy
+
+2. Caching possibilities (todo?)
+   - Processes keeps a list of open fds to prevent recursing up the FS tre=
e?
+   - Store the most recent processes access in each inode?
+
+Privs:
+  - read/write/exec/sticky/setuid/setgui
+  - All permissions are recursive
+  - Permissions for dirs and file are separate
+    - This prevents recursion problems
+    - e.g. you can set noexec for files without smashing directories
+  - Notation
+     (rwx) =3D specified permission (inode in policy)
+    ~(rwx) =3D implied permission (parent(s) in policy)
+
+Things to do when:
+  1. Setting privs
+     - Add policy line(s) for given path?
+     - Update privs on open inodes that are children of policy line?
+  2. Loading inode
+     - Cache privs from parent(s)?
+  3. Namespace modification (mv,ln,bind,etc)
+     - OR
+       - Keep policy for inode the same        (policy =3D old      )
+       - Merge policy for both locations       (policy =3D old & new)
+       - Change policy to reflect new location (policy =3D       new)
+     - If mv, and including old implied policy:
+       - need to write new (combined) policy line
+
+
+Security FS
+-----------
+files:
+  -rw-rw-rw- /securityfs/pmask/stage
+  -r--r--r-- /securityfs/pmask/policy
+  --w--w--w- /securityfs/pmask/control
+
+stage:
+  read:  print staged policy
+  write: set inode in staged policy to given perms OR
+         add inode to staged policy with given perms
+         > staged[inode] =3D perms
+
+  In the stage, order does not matter, adding a line simply writes or
+  overwrites the location with no regard to the rest of the policy.
+
+policy:
+  read: print active policy
+
+control:
+  write:
+    "commit" - merge staged policy into policy
+      > for (inode in policy, staged):
+      >     new[inode] =3D
+      >         implied_privs(policy, inode) &
+      >         implied_privs(staged, inode)
+      > clear(staged)
+
+    When committing, privilages can only be revoked.
+
+
+Examples
+--------
+Example 1:
+  set /src/     (rw-)
+  set /dst/     (r-x)
+
+  $ mv /src/foo /dst
+
+  get /src/     (rw-)
+  get /dst/     (r-x)
+  OR:
+    get /dst/foo  (rw-)
+    get /dst/foo ~(r-x)
+    get /dst/foo  (rw-) & ~(r-x) =3D (r--)
+
+Example 2:
+  $ ln /src/foo /dst
+
+  set /src/     (rw-)
+  set /dst/     (rwx)
+
+  get /src/     (rw-)
+  get /dst/     (rwx)
+  get /src/foo ~(rw-) & ~(rwx) =3D ~(rw-)
+  get /dst/foo ~(rw-) & ~(rwx) =3D ~(rw-)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b91839e..33bed5e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1771,7 +1771,7 @@ int vsscanf(const char * buf, const char * fmt, va_li=
st args)
 		 * advance both strings to next white space
 		 */
 		if (*fmt =3D=3D '*') {
-			while (!isspace(*fmt) && *fmt)
+			while (!isspace(*fmt) && *fmt !=3D '%' && *fmt)
 				fmt++;
 			while (!isspace(*str) && *str)
 				str++;
diff --git a/security/Kconfig b/security/Kconfig
index fb363cd..d4521b5 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -159,6 +159,7 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
=20
+source security/pmask/Kconfig
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
diff --git a/security/Makefile b/security/Makefile
index 95ecc06..f8c5b26 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -3,6 +3,7 @@
 #
=20
 obj-$(CONFIG_KEYS)			+=3D keys/
+subdir-$(CONFIG_SECURITY_PERM_MASKING)  +=3D pmask
 subdir-$(CONFIG_SECURITY_SELINUX)	+=3D selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+=3D smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        +=3D tomoyo
@@ -14,6 +15,7 @@ obj-y		+=3D commoncap.o min_addr.o
 obj-$(CONFIG_SECURITY)			+=3D security.o capability.o
 obj-$(CONFIG_SECURITYFS)		+=3D inode.o
 # Must precede capability.o in order to stack properly.
+obj-$(CONFIG_SECURITY_PERM_MASKING)	+=3D pmask/built-in.o
 obj-$(CONFIG_SECURITY_SELINUX)		+=3D selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+=3D smack/built-in.o
 obj-$(CONFIG_AUDIT)			+=3D lsm_audit.o
diff --git a/security/pmask/Kconfig b/security/pmask/Kconfig
new file mode 100644
index 0000000..a8ca887
--- /dev/null
+++ b/security/pmask/Kconfig
@@ -0,0 +1,8 @@
+config SECURITY_PERM_MASKING
+	bool "Permission masking"
+	depends on SECURITY
+	select SECURITYFS
+	default n
+	help
+	  This enabled support for masking filesystem permissions.
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/pmask/Makefile b/security/pmask/Makefile
new file mode 100644
index 0000000..39d5b27
--- /dev/null
+++ b/security/pmask/Makefile
@@ -0,0 +1 @@
+obj-y =3D pmask.o policy.o fs.o
diff --git a/security/pmask/fs.c b/security/pmask/fs.c
new file mode 100644
index 0000000..84a6515
--- /dev/null
+++ b/security/pmask/fs.c
@@ -0,0 +1,299 @@
+/**
+ * pmask/fs.c -- Security FS interface for privilege dropping
+ *
+ * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
+ *
+ * This program is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation, either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WIT=
HOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along=
 with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/security.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/ctype.h>
+#include <linux/uaccess.h>
+
+#include "policy.h"
+
+/***************************
+ * Generic policy iterator *
+ ***************************/
+/* Use this for reading form any policy file */
+static void *pmask_seq_start(struct seq_file *sf, loff_t *pos)
+{
+	struct pmask_policy *policy =3D sf->private;
+	down_read(&policy->privs_lock);
+	return seq_list_start(&policy->privs, *pos);
+}
+
+static void *pmask_seq_next(struct seq_file *sf, void *seq, loff_t *pos)
+{
+	struct pmask_policy *policy =3D sf->private;
+	return seq_list_next(seq, &policy->privs, pos);
+}
+
+static void pmask_seq_stop(struct seq_file *sf, void *seq)
+{
+	struct pmask_policy *policy =3D sf->private;
+	up_read(&policy->privs_lock);
+}
+
+static int pmask_seq_show(struct seq_file *sf, void *seq)
+{
+	struct pmask_line *line =3D list_entry(seq, struct pmask_line, list);
+	char perm_str[PMASK_PERM_BITS+1] =3D {};
+	if (pmask_isset(line->self_perm) &&
+			line->self_perm =3D=3D line->kids_perm) {
+		pmask_perm_to_str(line->self_perm, perm_str);
+		seq_printf(sf, "both %s %s\n", perm_str, line->path);
+	} else {
+		if (pmask_isset(line->self_perm)) {
+			pmask_perm_to_str(line->self_perm, perm_str);
+			seq_printf(sf, "self %s %s\n", perm_str, line->path);
+		}
+		if (pmask_isset(line->kids_perm)) {
+			pmask_perm_to_str(line->kids_perm, perm_str);
+			seq_printf(sf, "kids %s %s\n", perm_str, line->path);
+		}
+	}
+	return 0;
+}
+
+static const struct seq_operations pmask_seq_ops =3D {
+	.start =3D pmask_seq_start,
+	.next  =3D pmask_seq_next,
+	.stop  =3D pmask_seq_stop,
+	.show  =3D pmask_seq_show,
+};
+
+static int pmask_seq_open(struct file *file, struct pmask_policy *policy)
+{
+	/* From __seq_open_private
+	 * Not sure if this is correct way to store private data */
+	struct seq_file *sf;
+	if (seq_open(file, &pmask_seq_ops) < 0) {
+		pr_warning("Out of memory opening PMask sequence\n");
+		return -ENOMEM;
+	}
+	sf =3D file->private_data;
+	sf->private =3D policy;
+	return 0;
+};
+
+
+
+/**************
+ * Stage file *
+ **************/
+static int pmask_stage_open(struct inode *inode, struct file *file)
+{
+	return pmask_seq_open(file, pmask_cur_stage);
+};
+
+/**
+ * Parse policy lines one at a time.
+ * Format: /\s*([rwxsguRWXSGU\-]*)\s*(.*)(\s*)?/
+ *   \1: See pmask_str_to_perm() for discussion
+ *   \2: A file path, \3 trailing whitespace is optional
+ */
+static ssize_t pmask_stage_write(struct file *filp, const char *ubuffer,
+		size_t length, loff_t *off)
+{
+	struct file *file;
+	int err, rval, perm, scope;
+	char *kbuffer, *cmd_str, *perm_str, *path_str;
+	int cmd_start, cmd_end, perm_start, perm_end, path_start;
+
+	if (length > (size_t)~0LL)
+		return -EINVAL;;
+	kbuffer =3D kmalloc(length+1, GFP_KERNEL);
+	if (!kbuffer)
+		return -ENOMEM;
+	kbuffer[length] =3D '\0';
+
+	if (copy_from_user(kbuffer, ubuffer, length))
+		goto fail_fault;
+
+	/* Parse input */
+	path_start =3D -1;
+	sscanf(kbuffer, " %n%*s%n %n%*s%n %n", &cmd_start, &cmd_end,
+			&perm_start, &perm_end, &path_start);
+	if (path_start =3D=3D -1)
+		goto fail_inval;
+	cmd_str  =3D kbuffer+cmd_start;  kbuffer[cmd_end]  =3D '\0';
+	perm_str =3D kbuffer+perm_start; kbuffer[perm_end] =3D '\0';
+	path_str =3D kbuffer+path_start;
+
+	/* Check and convert cmd/scope */
+	if (!strcmp(cmd_str, "self"))
+		scope =3D PMASK_SELF;
+	else if (!strcmp(cmd_str, "kids"))
+		scope =3D PMASK_KIDS;
+	else if (!strcmp(cmd_str, "both"))
+		scope =3D PMASK_BOTH;
+	else
+		goto fail_inval;
+
+	/* Check and convert perm */
+	if (perm_str[0] =3D=3D '\0')
+		goto fail_inval;
+	perm =3D pmask_str_to_perm(perm_str);
+	if (perm < 0)
+		goto fail_inval;
+
+	/* Check and open path */
+	if (path_str[0] =3D=3D '\0')
+		goto fail_inval;
+	file =3D filp_open(path_str, 0, 0);
+	if (IS_ERR(file)) {
+		/* file not found, try trimming trailing spaces */
+		strstrip(path_str);
+		if (path_str[0] =3D=3D '\0')
+			goto fail_inval;
+		file =3D filp_open(path_str, 0, 0);
+		if (IS_ERR(file))
+			goto fail_noent;
+	}
+
+	path_str =3D kstrdup(path_str, GFP_KERNEL);
+	if (!path_str)
+		goto fail_nomem;
+
+	err =3D pmask_policy_set_perm(pmask_cur_stage,
+			file->f_dentry->d_inode, path_str, perm, scope);
+	if (err) {
+		kfree(path_str);
+		rval =3D err;
+		goto out;
+	}
+
+	pr_debug("pmask_task=3D%p pid=3D%d perm=3D%o[%s] path=3D%p[%s]\n",
+		pmask_cur_task, current->pid, perm, perm_str, file, path_str);
+
+	rval =3D length;
+	goto out; /* Success */
+
+fail_inval: rval =3D -EINVAL; goto out;
+fail_nomem: rval =3D -ENOMEM; goto out;
+fail_fault: rval =3D -EFAULT; goto out;
+fail_noent: rval =3D -ENOENT; goto out;
+out:
+	kfree(kbuffer);
+	/* if (rval < 0) abort task ? */
+	return rval;
+}
+
+static const struct file_operations pmask_stage_fops =3D {
+	.open    =3D pmask_stage_open,
+	.write   =3D pmask_stage_write,
+	.read    =3D seq_read,
+	.llseek  =3D seq_lseek,
+	.release =3D seq_release,
+};
+
+
+
+/***************
+ * Policy file *
+ ***************/
+static int pmask_policy_open(struct inode *inode, struct file *file)
+{
+	return pmask_seq_open(file, pmask_cur_policy);
+};
+
+static const struct file_operations pmask_policy_fops =3D {
+	.open    =3D pmask_policy_open,
+	.read    =3D seq_read,
+	.llseek  =3D seq_lseek,
+	.release =3D seq_release,
+};
+
+
+
+/****************
+ * Control file *
+ ****************/
+/**
+ * Read various commands from the user
+ * Format: /(\w+).* /
+ * Commands:
+ *   commit: copy stage to the policy and reset stage
+ */
+static ssize_t pmask_control_write(struct file *filp, const char *buffer,
+		size_t length, loff_t *off)
+{
+	int rval, err;
+	char *command;
+
+	command =3D kzalloc(length+1, GFP_KERNEL);
+	if (!command)
+		return -ENOMEM;
+
+	if (copy_from_user(command, buffer, length)) {
+		rval =3D -EFAULT;
+		goto out;
+	}
+
+	strstrip(command);
+
+	if (!strcmp("commit", command)) {
+		pr_debug("committing stage for pid=3D%d\n", current->pid);
+		err =3D pmask_policy_commit(pmask_cur_stage, pmask_cur_policy);
+		if (err) {
+			rval =3D err;
+			goto out;
+		}
+		pmask_policy_clear(pmask_cur_stage);
+	} else {
+		pr_debug("unimplemented control coomand `%s'\n", command);
+		rval =3D -EINVAL;
+		goto out;
+	}
+
+	rval =3D length; /* success */
+	goto out;
+
+out:
+	kfree(command);
+	return rval;
+}
+
+static const struct file_operations pmask_control_fops =3D {
+	.write =3D pmask_control_write,
+};
+
+
+
+/****************
+ * Registration *
+ ****************/
+static int __init pmask_fs_init(void)
+{
+	struct dentry *pmask_dir;
+	if (!pmask_loaded)
+		return 0;
+	pmask_dir =3D securityfs_create_dir("pmask", NULL);
+	securityfs_create_file("stage",
+			0666, pmask_dir, NULL, &pmask_stage_fops);
+	securityfs_create_file("policy",
+			0444, pmask_dir, NULL, &pmask_policy_fops);
+	securityfs_create_file("control",
+			0222, pmask_dir, NULL, &pmask_control_fops);
+	pr_info("PMask FS initialized\n");
+	return 0;
+}
+
+fs_initcall(pmask_fs_init);
diff --git a/security/pmask/pmask.c b/security/pmask/pmask.c
new file mode 100644
index 0000000..c64e4bc
--- /dev/null
+++ b/security/pmask/pmask.c
@@ -0,0 +1,144 @@
+/**
+ * pmask/pmask.c -- Linux Security Module interface for privilege dropping
+ *
+ * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
+ *
+ * This program is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation, either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WIT=
HOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along=
 with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/security.h>
+#include <linux/sched.h>
+
+#include "policy.h"
+
+int pmask_loaded;
+
+/* Credentials */
+static void pmask_cred_free(struct cred *cred)
+{
+	pmask_task_free(cred->security);
+	cred->security =3D NULL;
+}
+
+static int pmask_cred_prepare(struct cred *new, const struct cred *old,
+		gfp_t gfp)
+{
+	new->security =3D pmask_task_dup(old->security, gfp);
+	if (!new->security) {
+		pr_warning("Out of memory while preparing PMask task\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int pmask_dentry_open(struct file *file, const struct cred *cred)
+{
+	u16 perm, need;
+
+	/* Set parent link */
+	if (!IS_ROOT(file->f_dentry))
+		file->f_dentry->d_inode->i_security =3D
+				file->f_dentry->d_parent->d_inode;
+	else
+		file->f_dentry->d_inode->i_security =3D NULL;
+
+
+	/* Check privs */
+	perm =3D pmask_policy_get_perm(pmask_cur_policy,
+			file->f_dentry->d_inode);
+	need =3D pmask_flags_to_mode(file->f_flags);
+	need =3D pmask_imode_to_perm(need, file->f_dentry->d_inode);
+	if (unlikely(pmask_denied(perm, need))) {
+		char *path =3D kzalloc(PATH_MAX, GFP_KERNEL);
+		if (path) {
+			path =3D d_path(&file->f_path, path, sizeof(path));
+			pr_debug("denied perm=3D%o:%o path=3D%s\n",
+					perm, need, path);
+			kfree(path);
+		} else {
+			pr_warning("Out of memory getting path\n");
+			pr_debug("denied perm=3D%o:%o path=3D%s\n",
+					perm, need, "-ENOMEM");
+		}
+		return -EACCES;
+	}
+	return 0;
+}
+
+/* Mostly for directory walking */
+static int pmask_inode_permission(struct inode *inode, int mask)
+{
+	u16 perm =3D pmask_policy_get_perm(pmask_cur_policy, inode);
+	u16 need =3D pmask_imode_to_perm(mask, inode);
+	if (unlikely(pmask_denied(perm, need))) {
+		pr_debug("denied perm=3D%o:%o:%o inode=3D%p\n",
+				perm, need, mask, inode);
+		return -EACCES;
+	}
+	return 0;
+}
+
+/* TODO: Use these to store the multiple pointers? */
+/*
+static int pmask_inode_alloc_security(struct inode *inode)
+{
+	return 0;
+}
+static int pmask_inode_init_security(struct inode *inode, struct inode *di=
r,
+		char **name, void **value, size_t *len)
+{
+	return 0;
+}
+static void pmask_inode_free_security(struct inode *inode)
+{
+}
+*/
+
+/* Registration */
+static struct security_operations pmask_security_ops =3D {
+	.name                 =3D "pmask",
+	.cred_prepare         =3D pmask_cred_prepare,
+	.cred_free            =3D pmask_cred_free,
+	.dentry_open          =3D pmask_dentry_open,
+	.inode_permission     =3D pmask_inode_permission,
+	/*
+	.inode_alloc_security =3D pmask_inode_alloc_security,
+	.inode_init_security  =3D pmask_inode_init_security,
+	.inode_free_security  =3D pmask_inode_free_security,
+	*/
+	/* TODO: add path operations and update the policies when the
+	 * filesystem layout changes */
+};
+
+static int __init pmask_init(void)
+{
+	struct cred *cred =3D (struct cred *)current_cred();
+
+	if (!security_module_enable(&pmask_security_ops))
+		return 0;
+	if (register_security(&pmask_security_ops))
+		panic("Failure registering PMask");
+	cred->security =3D pmask_task_new(GFP_KERNEL);
+	if (!cred->security)
+		panic("Out of memory while initializing pmask");
+	pr_info("PMask initialized\n");
+	pmask_loaded =3D 1;
+	return 0;
+}
+
+security_initcall(pmask_init);
diff --git a/security/pmask/policy.c b/security/pmask/policy.c
new file mode 100644
index 0000000..90d0606
--- /dev/null
+++ b/security/pmask/policy.c
@@ -0,0 +1,337 @@
+/**
+ * pmask/policy.c -- Privilege dropping core functionality
+ *
+ * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
+ *
+ * This program is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation, either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WIT=
HOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along=
 with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/security.h>
+#include <linux/sched.h>
+#include <linux/ctype.h>
+#include <linux/fs.h>
+
+#include "policy.h"
+
+/*******************
+ * Permission bits *
+ *******************/
+static char pmask_perm_bit_list[] =3D "rwxsguRWXSGU";
+static u16  pmask_perm_bit_table['z'] =3D {
+	['x'] PMASK_EXEC,
+	['w'] PMASK_WRITE,
+	['r'] PMASK_READ,
+	['s'] PMASK_KEEPSWP,
+	['g'] PMASK_SETGID,
+	['u'] PMASK_SETUID,
+	['X'] PMASK_WALK,
+	['W'] PMASK_CREATE,
+	['R'] PMASK_LIST,
+	['S'] PMASK_STICKY,
+	['G'] PMASK_PASSGID,
+	['U'] PMASK_PASSUID,
+	['.'] 0,
+}; /* plus 0.25k .. */
+
+u16 pmask_flags_to_mode(unsigned int flags)
+{
+	u16 mode =3D 0;
+	if (flags & FMODE_READ)  mode |=3D PMASK_READ;
+	if (flags & FMODE_WRITE) mode |=3D PMASK_WRITE;
+	if (flags & FMODE_EXEC)  mode |=3D PMASK_EXEC;
+	if (flags & O_CREAT)     mode |=3D PMASK_CREATE;
+	return mode;
+}
+
+int pmask_str_to_perm(const char *str)
+{
+	int perm =3D 0;
+	for (; *str; str++) {
+		if ((!isalpha(*str) || !pmask_perm_bit_table[(int)*str]) &&
+				*str !=3D '.')
+			return -1;
+		perm |=3D pmask_perm_bit_table[(int)*str];
+	}
+	return perm;
+}
+
+void pmask_perm_to_str(u16 perm, char *str)
+{
+	char *c =3D pmask_perm_bit_list;
+	for (; *c; c++, str++)
+		*str =3D (perm & pmask_perm_bit_table[(int)*c]) ?  *c : '.';
+	*str =3D '\0';
+}
+
+
+
+/**************
+ * PMask Line *
+ **************/
+/**
+ * Allocate and initalize a new pmask_line
+ * @indoe, @path, @perm: fileds to store en line
+ */
+static struct pmask_line *pmask_line_new(const struct inode *inode,
+		const char *path, gfp_t gfp)
+{
+	struct pmask_line *line;
+	line =3D kzalloc(sizeof(struct pmask_line), gfp);
+	if (!line)
+		return NULL;
+	line->inode =3D inode;
+	line->path  =3D path;
+	line->self_perm =3D PMASK_IGNORE;
+	line->kids_perm =3D PMASK_IGNORE;
+	return line;
+}
+
+
+
+/****************
+ * PMask Policy *
+ ****************/
+/* Return the line from @policy->privs that matches @inode */
+static struct pmask_line *pmask_policy_get_line(
+		const struct pmask_policy *policy, const struct inode *inode)
+{
+	struct pmask_line *line;
+	list_for_each_entry(line, &policy->privs, list)
+		if (line->inode =3D=3D inode)
+			return line;
+	return NULL;
+}
+
+/* Create and add a line to to @policy while checking for errors and updat=
ing
+ * the quota */
+static struct pmask_line *pmask_policy_add_line(struct pmask_policy *polic=
y,
+		const struct inode *inode, const char *path, gfp_t gfp)
+{
+	struct pmask_line *line;
+	if (atomic_read(&policy->privs_count) >=3D PMASK_MAX_LINES)
+		return NULL;
+	atomic_inc(&policy->privs_count);
+	line =3D pmask_line_new(inode, path, GFP_KERNEL);
+	if (!line)
+		return NULL;
+	list_add_tail(&line->list, &policy->privs);
+	return line;
+}
+
+/* Create and add a line to to @policy while checking for errors and updat=
ing
+ * the quota */
+static struct pmask_line *pmask_policy_ensure_line(struct pmask_policy *po=
licy,
+		const struct inode *inode, const char *path, gfp_t gfp)
+{
+	struct pmask_line *line =3D pmask_policy_get_line(policy, inode);
+	if (!line)
+		line =3D pmask_policy_add_line(policy, inode, path, gfp);
+	return line;
+}
+
+
+/* Delete a line form @policy and update the quota */
+static void pmask_policy_del_line(struct pmask_policy *policy,
+		struct pmask_line *line)
+{
+	list_del(&line->list);
+	kfree(line);
+	atomic_dec(&policy->privs_count);
+}
+
+/* Do a semi-deep copy, that is, copy enough that the policies are distinc=
t,
+ * but without duplicating conostant data such as paths and dentries */
+static int pmask_policy_append(struct pmask_policy *from,
+		struct pmask_policy *to, gfp_t gfp)
+{
+	struct pmask_line *old_line, *new_line;
+	list_for_each_entry(old_line, &from->privs, list) {
+		new_line =3D pmask_policy_add_line(to,
+				old_line->inode, old_line->path, gfp);
+		if (!new_line)
+			return -ENOMEM;
+		new_line->self_perm =3D old_line->self_perm;
+		new_line->kids_perm =3D old_line->kids_perm;
+	}
+	return 0;
+}
+
+/* Initialize a blank @policy */
+static void pmask_policy_init(struct pmask_policy *policy)
+{
+	INIT_LIST_HEAD(&policy->privs);
+	init_rwsem(&policy->privs_lock);
+	atomic_set(&policy->privs_count, 0);
+}
+
+void pmask_policy_clear(struct pmask_policy *policy)
+{
+	struct pmask_line *line, *n;
+	list_for_each_entry_safe(line, n, &policy->privs, list)
+		pmask_policy_del_line(policy, line);
+}
+
+
+static u16 pmask_policy_get_perm_rec(const struct pmask_policy *policy,
+		const struct inode *inode)
+{
+	struct pmask_line *line;
+
+	/* Allow everything if we've reach the root without finding perms */
+	/* TODO: recurse to parent filesystems */
+	if (inode =3D=3D NULL)
+		return USHORT_MAX;
+
+	line =3D pmask_policy_get_line(policy, inode);
+
+	if (line && pmask_isset(line->kids_perm))
+		return line->kids_perm;
+
+	/* Check parents for recursive permissions */
+	/* TODO: Check for multiple parents */
+	return pmask_policy_get_perm_rec(policy, inode->i_security);
+	/*
+	 * perm =3D USHORT_MAX;
+	 * foreach parent:
+	 * 	perm &=3D pmask_policy_get_perm(policy, inode->d_parent);
+	 * return perm;
+	 */
+}
+
+u16 pmask_policy_get_perm(const struct pmask_policy *policy,
+		const struct inode *inode)
+{
+	/* Stop if a permissions is found for current node */
+	struct pmask_line *line =3D pmask_policy_get_line(policy, inode);
+	if (line && pmask_isset(line->self_perm))
+		return line->self_perm;
+	return pmask_policy_get_perm_rec(policy, inode->i_security);
+}
+
+/* We need the inode and path so we can create the line if it doesn't exis=
t */
+int pmask_policy_set_perm(struct pmask_policy *policy,
+		const struct inode *inode, const char *path,
+		u16 perm, int scope)
+{
+	struct pmask_line *line =3D pmask_policy_ensure_line(policy,
+			inode, path, GFP_KERNEL);
+	if (!line)
+		return -ENOMEM;
+	if (scope =3D=3D PMASK_BOTH || scope =3D=3D PMASK_SELF)
+		line->self_perm =3D perm;
+	if (scope =3D=3D PMASK_BOTH || scope =3D=3D PMASK_KIDS)
+		line->kids_perm =3D perm;
+	return 0;
+}
+
+static void pmask_policy_merge_line(const struct inode *inode,
+		struct pmask_policy *pl, struct pmask_policy *pr,
+		struct pmask_line *to)
+{
+	struct pmask_line *ll =3D pmask_policy_get_line(pl, inode);
+	struct pmask_line *lr =3D pmask_policy_get_line(pr, inode);
+	if ((ll && pmask_isset(ll->self_perm)) ||
+	    (lr && pmask_isset(lr->self_perm))) {
+		to->self_perm  =3D pmask_policy_get_perm(pl, inode);
+		to->self_perm &=3D pmask_policy_get_perm(pr, inode);
+	}
+	if ((ll && pmask_isset(ll->kids_perm)) ||
+	    (lr && pmask_isset(lr->kids_perm))) {
+		to->kids_perm  =3D pmask_policy_get_perm_rec(pl, inode);
+		to->kids_perm &=3D pmask_policy_get_perm_rec(pr, inode);
+	}
+}
+
+int pmask_policy_commit(struct pmask_policy *from, struct pmask_policy *to)
+{
+	struct pmask_line *line, *merge_line, *n;
+	struct pmask_policy merge;
+	pmask_policy_init(&merge);
+
+	/* Merge paths from @to into merge */
+	list_for_each_entry(line, &to->privs, list) {
+		merge_line =3D pmask_policy_ensure_line(&merge,
+				line->inode, line->path, GFP_KERNEL);
+		if (!merge_line)
+			goto fail;
+		pmask_policy_merge_line(line->inode, from, to, merge_line);
+	}
+
+	/* Merge paths from @from into merge */
+	list_for_each_entry(line, &from->privs, list) {
+		merge_line =3D pmask_policy_ensure_line(&merge,
+				line->inode, line->path, GFP_KERNEL);
+		if (!merge_line)
+			goto fail;
+		pmask_policy_merge_line(line->inode, from, to, merge_line);
+	}
+
+	/* Free old entries, and move to ones to @to */
+	pmask_policy_clear(to);
+	list_for_each_entry_safe(line, n, &merge.privs, list)
+		list_move_tail(&line->list, &to->privs);
+
+	return 0;
+
+fail:
+	pmask_policy_clear(&merge);
+	return -ENOMEM;
+}
+
+
+
+/**************
+ * PMask Task *
+ **************/
+struct pmask_task *pmask_task_new(gfp_t gfp)
+{
+	struct pmask_task *task;
+	task =3D kzalloc(sizeof(struct pmask_task), gfp);
+	if (!task)
+		return NULL;
+
+	pmask_policy_init(&task->stage);
+	pmask_policy_init(&task->policy);
+
+	return task;
+}
+
+void pmask_task_free(struct pmask_task *task)
+{
+	pmask_policy_clear(&task->stage);
+	pmask_policy_clear(&task->policy);
+	kfree(task);
+}
+
+struct pmask_task *pmask_task_dup(struct pmask_task *task, gfp_t gfp)
+{
+	struct pmask_task *copy =3D pmask_task_new(gfp);
+	if (!copy)
+		return NULL;
+
+	/* Copy policies */
+	if (pmask_policy_append(&task->stage,  &copy->stage,  gfp))
+		goto fail;
+	if (pmask_policy_append(&task->policy, &copy->policy, gfp))
+		goto fail;
+
+	return copy;
+
+fail:
+	pmask_task_free(copy);
+	return NULL;
+}
diff --git a/security/pmask/policy.h b/security/pmask/policy.h
new file mode 100644
index 0000000..bc2d526
--- /dev/null
+++ b/security/pmask/policy.h
@@ -0,0 +1,230 @@
+/**
+ * pmask/policy.h -- Privilege dropping core functionality
+ *
+ * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
+ *
+ * This program is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation, either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WIT=
HOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along=
 with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __PMASK_POLICY_H__
+#define __PMASK_POLICY_H__
+
+/* Set to 1 when pmask is initialized */
+extern int pmask_loaded;
+
+/**
+ * Terminology
+ *   mode   =3D `Unix' mode (u16 use for filesyste mode bits)
+ *   perm   =3D PMask permission bits (see below)
+ *   privs  =3D List of files and associated perm
+ *   policy =3D Privs + whatever else
+ */
+
+#define pmask_cur_task   ((struct pmask_task *)current_security())
+#define pmask_cur_stage  ((struct pmask_policy *)&pmask_cur_task->stage)
+#define pmask_cur_policy ((struct pmask_policy *)&pmask_cur_task->policy)
+
+
+/*******************
+ * Permission bits *
+ *******************/
+/* File bits */
+#define PMASK_EXEC    (1u<<0)  /* x */
+#define PMASK_WRITE   (1u<<1)  /* w */
+#define PMASK_READ    (1u<<2)  /* r */
+#define PMASK_KEEPSWP (1u<<3)  /* s (ignored) */
+#define PMASK_SETGID  (1u<<4)  /* g */
+#define PMASK_SETUID  (1u<<5)  /* u */
+
+/* Directory bits */
+#define PMASK_WALK    (1u<<6)  /* X */
+#define PMASK_CREATE  (1u<<7)  /* W */
+#define PMASK_LIST    (1u<<8)  /* R */
+#define PMASK_STICKY  (1u<<9)  /* S */
+#define PMASK_PASSGID (1u<<10) /* G */
+#define PMASK_PASSUID (1u<<11) /* U (ignored) */
+
+/* Special bits */
+#define PMASK_IGNORE  (1u<<12) /* Permissions unset */
+
+/* Meta bits/masks */
+#define PMASK_PERM_BITS 12
+#define PMASK_MASK      0b111111111111
+#define PMASK_FILE_MASK 0b000000111111
+#define PMASK_DIR_MASK  0b111111000000
+
+/* Scope of permission */
+enum {
+	PMASK_SELF, /* Permissions only affect the inode */
+	PMASK_KIDS, /* Permissions only affect the inodes children */
+	PMASK_BOTH, /* Permissions affect inode and children */
+};
+
+/* Determine if a permission is set or ignored */
+static inline bool pmask_isset(u16 perm)
+{
+	return !(perm & PMASK_IGNORE);
+}
+
+/* Mode conversion functions */
+static inline bool pmask_denied(u16 perm, u16 request)
+{
+	return perm >=3D 0 && ~perm & request;
+}
+
+/* Convert from a unix directory mode to a perm */
+static inline u16 pmask_dmode_to_perm(u16 mode)
+{
+	return mode << 6;
+}
+
+/* Convert from a unix file mode to a perm */
+static inline u16 pmask_fmode_to_perm(u16 mode)
+{
+	return mode;
+}
+
+/* Convert from a unix perm to a mode based on inode type */
+static inline u16 pmask_imode_to_perm(u16 mode, struct inode *inode)
+{
+	return S_ISDIR(inode->i_mode) ?
+		 pmask_dmode_to_perm(mode) :
+		 pmask_fmode_to_perm(mode);
+}
+
+/**
+ * Convert struct file->f_flags to a Unix mode
+ * <x>mode_to_perm should probably be called on the resulting mode
+ */
+u16 pmask_flags_to_mode(unsigned int flags);
+
+/**
+ * Parse a permission string into a perm
+ * @str:
+ *  - Format is "rwxsguRWXSGU" (see Permission bits)
+ *  - Order does not matter
+ *  - '.' is ignored, any other character is invalid
+ *  - return -1 on invalid str
+ */
+int pmask_str_to_perm(const char *str);
+
+/**
+ * Convert a perm to a string for printing
+ */
+void pmask_perm_to_str(u16 perm, char *str);
+
+
+
+/**************
+ * PMask Line *
+ **************/
+/**
+ * An entry in the policy
+ *
+ * Example:
+ *   /var/tmp (rw-)
+ *
+ * @list:      list_head for stroing in policy
+ * @inode:     Some point in the filesystem, topically an inode
+ * @path:      Path given when the line was created, debugging only
+ * @self_perm: Permissions given to the location
+ * @kids_perm: Permissions given to the location's kids
+ */
+struct pmask_line {
+	struct list_head    list;
+	const struct inode *inode;
+	const char         *path;
+	u16                 self_perm;
+	u16                 kids_perm;
+};
+
+
+
+/****************
+ * PMask Policy *
+ ****************/
+#define PMASK_MAX_LINES 500
+
+/**
+ * Contains permisisons and operations allowed for given security policy
+ *
+ * @privs:      List of pmask_lines for filesystem privilages
+ * @privs_lock: Used for printing (maybe other?)
+ *
+ * Example:
+ *   privs:
+ *     /         (r--)
+ *     /bin/     (r-x)
+ *     /tmp/     (rw-)
+ */
+struct pmask_policy {
+	struct list_head privs;
+	struct rw_semaphore privs_lock;
+	atomic_t privs_count;
+	/* TODO: add other security things */
+};
+
+/* Clear/free data from @policy */
+void pmask_policy_clear(struct pmask_policy *policy);
+
+/* Recursivly lookup perm for @inode in @policy */
+u16 pmask_policy_get_perm(const struct pmask_policy *policy,
+		const struct inode *inode);
+
+/* Set perm for @inode in @policy to @perm, create new line if necessasiar=
y */
+int pmask_policy_set_perm(struct pmask_policy *policy,
+		const struct inode *inode, const char *path,
+		u16 perm, int scope);
+
+/* Copy lines from @from to @to making sure that no additional oeratoins a=
re
+ * allowed in @to after the commit is performed */
+int pmask_policy_commit(struct pmask_policy *from, struct pmask_policy *to=
);
+
+
+
+/**************
+ * PMask Task *
+ **************/
+/**
+ * Contains information for a given task, including the security policy, s=
tage,
+ * and cache information.
+ *
+ * @stage:
+ *   The modifialbe policy, privilages can be allowed or denied in the sta=
ge
+ * @policy:
+ *   The effective policy, used to determines whether an action is allowed
+ *
+ * @policy can only be modified by commiting @stage to @policy. When this =
is
+ * done, it is insured that no additional operations will be allowed by @p=
olicy
+ * after the commit.
+ *
+ * Example:
+ *   stage:  (see pmask_policy)
+ *   policy: (see pmask_policy)
+ */
+struct pmask_task {
+	struct pmask_policy stage;
+	struct pmask_policy policy;
+};
+
+/* Allocate a blank task */
+struct pmask_task *pmask_task_new(gfp_t gfp);
+
+/* Free a task and data associated with it */
+void pmask_task_free(struct pmask_task *task);
+
+/* Create a semi-deep copy of @task, suitable for passing to a child on ex=
ec */
+struct pmask_task *pmask_task_dup(struct pmask_task *task, gfp_t gfp);
+
+#endif

--=_c-17899-1254208234-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrBsuoACgkQz1OYJ/s1XTBfnACeNzvusm+O6maM0sNk95wwW7bU
crQAoNWuwFbpv42igdZRgSgm1VS8eKCr
=lm9K
-----END PGP SIGNATURE-----

--=_c-17899-1254208234-0001-2--
