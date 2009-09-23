Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZIWVbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZIWVbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZIWVbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:31:34 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:57658 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZIWVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lHRA7kFa+BlZxI1qtckPT0WGaYuUoV6IOcEQlWYVINl9JTrKPHXy9fqOYTi6uWM9fN
         Kv6q1xBNN9JbseuHs/9Qo7ouOX1xGs0svYdLjNS6dq+O1LOL5iutGhYW8yYAlzWXR1Zq
         gENPjC+tabZ5WSW/Lnu9c9iYn4wUSAK3gai3U=
Date: Wed, 23 Sep 2009 21:31:09 +0000
From: Andy Spencer <andy753421@gmail.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Privilege dropping security module
Message-ID: <20090923213109.GA936@c.hsd1.tn.comcast.net>
Reply-To: linux-security-module@vger.kernel.org
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-1139-1253741493-0001-2"
Content-Disposition: inline
In-Reply-To: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-1139-1253741493-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

policy.h and policy.c contain the core data types use for storing and acces=
sing
permission associated with tasks.

dpriv.c contains the struct security_operations hooks for dpriv.

fs.c contains the securityfs interface that is uses to configure and access
policies.

readme.txt contains some notes and will eventually be deleted or moved to t=
he
Documentation folder.

The rest is used for configuring and building dpriv

Signed-off-by: Andy Spencer <andy753421@gmail.com>

 security/Kconfig          |    1 +
 security/Makefile         |    2 +
 security/dpriv/Kconfig    |    8 ++
 security/dpriv/Makefile   |    1 +
 security/dpriv/dpriv.c    |  124 +++++++++++++++++++++++
 security/dpriv/fs.c       |  243 +++++++++++++++++++++++++++++++++++++++++=
++++
 security/dpriv/policy.c   |  235 +++++++++++++++++++++++++++++++++++++++++=
++
 security/dpriv/policy.h   |  228 ++++++++++++++++++++++++++++++++++++++++++
 security/dpriv/readme.txt |  102 +++++++++++++++++++
 9 files changed, 944 insertions(+), 0 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index fb363cd..b2e310e 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -159,6 +159,7 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
=20
+source security/dpriv/Kconfig
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
diff --git a/security/Makefile b/security/Makefile
index 95ecc06..2ca4d14 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -3,6 +3,7 @@
 #
=20
 obj-$(CONFIG_KEYS)			+=3D keys/
+subdir-$(CONFIG_SECURITY_DPRIV)         +=3D dpriv
 subdir-$(CONFIG_SECURITY_SELINUX)	+=3D selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+=3D smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        +=3D tomoyo
@@ -14,6 +15,7 @@ obj-y		+=3D commoncap.o min_addr.o
 obj-$(CONFIG_SECURITY)			+=3D security.o capability.o
 obj-$(CONFIG_SECURITYFS)		+=3D inode.o
 # Must precede capability.o in order to stack properly.
+obj-$(CONFIG_SECURITY_DPRIV)		+=3D dpriv/built-in.o
 obj-$(CONFIG_SECURITY_SELINUX)		+=3D selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+=3D smack/built-in.o
 obj-$(CONFIG_AUDIT)			+=3D lsm_audit.o
diff --git a/security/dpriv/Kconfig b/security/dpriv/Kconfig
new file mode 100644
index 0000000..17bf66a
--- /dev/null
+++ b/security/dpriv/Kconfig
@@ -0,0 +1,8 @@
+config SECURITY_DPRIV
+	bool "Privilege dropping"
+	depends on SECURITY
+	select SECURITYFS
+	default n
+	help
+	  This enabled the DPriv privilege dropping mechanism.
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/dpriv/Makefile b/security/dpriv/Makefile
new file mode 100644
index 0000000..0ff3b05
--- /dev/null
+++ b/security/dpriv/Makefile
@@ -0,0 +1 @@
+obj-y =3D dpriv.o policy.o fs.o
diff --git a/security/dpriv/dpriv.c b/security/dpriv/dpriv.c
new file mode 100644
index 0000000..263c5d0
--- /dev/null
+++ b/security/dpriv/dpriv.c
@@ -0,0 +1,124 @@
+/**
+ * dpriv/dpriv.c -- Linux Security Module interface for privilege dropping
+ *
+ * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
+ *=20
+ * This program is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation, either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *=20
+ * This program is distributed in the hope that it will be useful, but WIT=
HOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ *=20
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
+/* Credentials */
+static void dpriv_cred_free(struct cred *cred)
+{
+	kfree(cred->security);
+	cred->security =3D NULL;
+}
+
+static int dpriv_cred_prepare(struct cred *new, const struct cred *old,
+		gfp_t gfp)
+{
+	new->security =3D dpriv_task_dup(old->security);
+	return 0;
+}
+
+static int dpriv_dentry_open(struct file *file, const struct cred *cred)
+{
+	u16 perm, need;
+
+	/* Set parent link */
+	if (file->f_dentry->d_sb->s_root !=3D file->f_dentry &&
+			file->f_dentry->d_parent)
+		file->f_inode->i_security =3D file->f_dentry->d_parent->d_inode;
+	else
+		file->f_inode->i_security =3D NULL;
+
+
+	/* Check privs */
+	perm =3D dpriv_policy_get_perm(dpriv_cur_policy, file->f_inode);
+	need =3D flags_to_mode(file->f_flags);
+	need =3D imode_to_perm(need, file->f_inode);
+	if (deny(perm, need)) {
+		char path_buf[4096];
+		char *path =3D d_path(&file->f_path, path_buf, sizeof(path_buf));
+		pr_debug("denied perm=3D%o:%o path=3D%s\n", perm, need, path);
+		return -EACCES;
+	}
+	return 0;
+}
+
+/* Mostly for directory walking */
+static int dpriv_inode_permission(struct inode *inode, int mask)
+{
+	u16 perm =3D dpriv_policy_get_perm(dpriv_cur_policy, inode);
+	u16 need =3D imode_to_perm(mask, inode);
+	if (deny(perm, need)) {
+		pr_debug("denied perm=3D%o:%o:%o inode=3D%p\n",
+				perm, need, mask, inode);
+		return -EACCES;
+	}
+	return 0;
+}
+
+/* TODO: Use these to store the multiple pointers? */
+/*
+static int dpriv_inode_alloc_security(struct inode *inode)
+{
+	return 0;
+}
+static int dpriv_inode_init_security(struct inode *inode, struct inode *di=
r,
+		char **name, void **value, size_t *len)
+{
+	return 0;
+}
+static void dpriv_inode_free_security(struct inode *inode)
+{
+}
+*/
+
+/* Registration */
+static struct security_operations dpriv_security_ops =3D {
+	.name                 =3D "dpriv",
+	.cred_prepare         =3D dpriv_cred_prepare,
+	.cred_free            =3D dpriv_cred_free,
+	.dentry_open          =3D dpriv_dentry_open,
+	.inode_permission     =3D dpriv_inode_permission,
+	//.inode_alloc_security =3D dpriv_inode_alloc_security,
+	//.inode_init_security  =3D dpriv_inode_init_security,
+	//.inode_free_security  =3D dpriv_inode_free_security,
+	/* TODO: add path operations and update the policies when the
+	 * filesystem layout changes */
+};
+
+static int __init dpriv_init(void)
+{
+	struct cred *cred =3D (struct cred *)current_cred();
+
+	if (!security_module_enable(&dpriv_security_ops))
+		return 0;
+	if (register_security(&dpriv_security_ops))
+		panic("Failure registering DPriv");
+	cred->security =3D dpriv_task_new();
+	pr_info("DPriv initialized\n");
+	return 0;
+}
+
+security_initcall(dpriv_init);
diff --git a/security/dpriv/fs.c b/security/dpriv/fs.c
new file mode 100644
index 0000000..c0af74d
--- /dev/null
+++ b/security/dpriv/fs.c
@@ -0,0 +1,243 @@
+/**
+ * dpriv/fs.c -- Security FS interface for privilege dropping
+ *
+ * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
+ *=20
+ * This program is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation, either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *=20
+ * This program is distributed in the hope that it will be useful, but WIT=
HOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ *=20
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
+#include <asm/uaccess.h>
+
+#include "policy.h"
+
+/* Arbitrary maximum lengths */
+#define DPRIV_COMMAND_MAX 32
+#define DPRIV_PATH_MAX    4000
+
+/***************************
+ * Generic policy iterator *
+ ***************************/
+/* Use this for reading form any policy file */
+static void *generic_seq_start(struct seq_file *sf, loff_t *pos)
+{
+	struct dpriv_policy *policy =3D sf->private;
+	down_read(&policy->privs_lock);
+	return seq_list_start(&policy->privs, *pos);
+}
+
+static void *generic_seq_next(struct seq_file *sf, void *seq, loff_t *pos)
+{
+	struct dpriv_policy *policy =3D sf->private;
+	return seq_list_next(seq, &policy->privs, pos);
+}
+
+static void generic_seq_stop(struct seq_file *sf, void *seq)
+{
+	struct dpriv_policy *policy =3D sf->private;
+	up_read(&policy->privs_lock);
+}
+
+static int generic_seq_show(struct seq_file *sf, void *seq)
+{
+	struct dpriv_line *line =3D list_entry(seq, struct dpriv_line, list);
+	char perm_str[DPRIV_PERM_BITS+1];
+	perm_to_str(line->perm, perm_str);
+	seq_printf(sf, "%*s %s\n", DPRIV_PERM_BITS, perm_str, line->path);
+	return 0;
+}
+
+static struct seq_operations generic_seq_ops =3D {
+	.start =3D generic_seq_start,
+	.next  =3D generic_seq_next,
+	.stop  =3D generic_seq_stop,
+	.show  =3D generic_seq_show,
+};
+
+static int generic_seq_open(struct file *file, struct dpriv_policy *policy)
+{
+	/* From __seq_open_private
+	 * Not sure if this is correct way to store private data */
+	struct seq_file *sf;
+       	if (seq_open(file, &generic_seq_ops) < 0)
+		return -ENOMEM;
+ 	sf =3D file->private_data;
+	sf->private =3D policy;
+	return 0;
+};
+
+
+
+/**************
+ * Stage file *
+ **************/
+static int stage_open(struct inode *inode, struct file *file)
+{
+	return generic_seq_open(file, dpriv_cur_stage);
+};
+
+/* Move a char * forward until it reaches non-whitespace */
+#define strfwd(str) ({                 \
+	while (*str && isspace(*str))  \
+		str++;                 \
+	str;                           \
+})
+
+/* Move a char * forward until it reaches whitespace */
+#define strwfwd(str) ({                \
+	while (*str && !isspace(*str)) \
+		str++;                 \
+	str;                           \
+})
+
+/**
+ * Parse policy lines one at a time.
+ * Format: /\s*([rwxsguRWXSGU\-]*)\s*(.*)(\s*)?/
+ *   \1: See str_to_perm() for discussion
+ *   \2: A file path, \3 trailing whitespace is optional
+ */
+static ssize_t stage_write(struct file *filp, const char *buffer,
+		size_t length, loff_t* off)
+{
+	/* TODO: read multiple lines */
+	int perm;
+	struct file *file;
+	const int write_max =3D DPRIV_PERM_BITS+DPRIV_PATH_MAX+10; /* spaces */
+	char _buf[write_max+1] =3D {}, *bufp =3D _buf, *perm_str, *path_str;
+
+	if (length > write_max)
+		length =3D write_max;
+	if (copy_from_user(bufp, buffer, length))
+		return -EFAULT;
+
+	/* This parsing is kind of ugly, but should avoid buffer overflows */
+	/* Parse the perm */
+	perm_str =3D strfwd(bufp); /* save ptr */
+	if (!strwfwd(bufp)[0])   /* make sure we have file */
+		return -EINVAL;
+	bufp++[0] =3D '\0';        /* terminate mdoe_str */
+	if ((perm =3D str_to_perm(perm_str)) < 0)
+		return -EINVAL;
+
+	/* Parse the file path */
+	bufp =3D strfwd(bufp);     /* to path */
+	if (bufp[0] =3D=3D '\0')
+		return -EINVAL;
+	if (IS_ERR(file =3D filp_open(bufp, 0, 0))) {
+		/* file not found, try trimming spaces */
+		strstrip(bufp);
+		if (bufp[0] =3D=3D '\0')
+			return -EINVAL;
+		if (IS_ERR(file =3D filp_open(bufp, 0, 0)))
+			return -ENOENT;
+	}
+	path_str =3D kstrdup(bufp, GFP_KERNEL);
+
+	dpriv_policy_set_perm(dpriv_cur_stage, file->f_inode, path_str, perm);
+
+	pr_debug("dpriv_task=3D%p pid=3D%d perm=3D%o[%s] path=3D%p[%s]\n",
+		dpriv_cur_task, current->pid, perm, perm_str, file, path_str);
+
+	return length;
+}
+
+static const struct file_operations dpriv_stage_fops =3D {
+	.open    =3D stage_open,
+	.write   =3D stage_write,
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
+static int policy_open(struct inode *inode, struct file *file)
+{
+	return generic_seq_open(file, dpriv_cur_policy);
+};
+
+static const struct file_operations dpriv_policy_fops =3D {
+	.open    =3D policy_open,
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
+static ssize_t control_write(struct file *filp, const char *buffer,
+		size_t length, loff_t* off)
+{
+	char command[DPRIV_COMMAND_MAX+1] =3D {};
+
+	if (length > DPRIV_COMMAND_MAX)
+		length =3D DPRIV_COMMAND_MAX;
+
+	if (copy_from_user(command, buffer, length))
+		return -EFAULT;
+
+	strstrip(command);
+
+	if (!strcmp("commit", command)) {
+		pr_debug("committing stage for pid=3D%d\n", current->pid);
+		dpriv_policy_commit(dpriv_cur_stage, dpriv_cur_policy);
+		dpriv_policy_reset(dpriv_cur_stage);
+	} else {
+		pr_debug("unimplemented control coomand `%s'\n", command);
+	}
+
+	return length;
+}
+
+static const struct file_operations dpriv_control_fops =3D {
+	.write =3D control_write,
+};
+
+
+
+/****************
+ * Registration *
+ ****************/
+static int __init dpriv_fs_init(void)
+{
+	struct dentry *dpriv_dir =3D securityfs_create_dir("dpriv", NULL);
+	securityfs_create_file("stage",
+			0666, dpriv_dir, NULL, &dpriv_stage_fops);
+	securityfs_create_file("policy",
+			0444, dpriv_dir, NULL, &dpriv_policy_fops);
+	securityfs_create_file("control",
+			0222, dpriv_dir, NULL, &dpriv_control_fops);
+	pr_info("DPriv FS initialized\n");
+	return 0;
+}
+
+fs_initcall(dpriv_fs_init);
diff --git a/security/dpriv/policy.c b/security/dpriv/policy.c
new file mode 100644
index 0000000..14823a0
--- /dev/null
+++ b/security/dpriv/policy.c
@@ -0,0 +1,235 @@
+/**
+ * dpriv/policy.c -- Privilege dropping core functionality
+ *
+ * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
+ *=20
+ * This program is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation, either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *=20
+ * This program is distributed in the hope that it will be useful, but WIT=
HOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ *=20
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
+static char perm_bit_list[] =3D "rwxsguRWXSGU";
+static u16  perm_bit_table['z'] =3D {
+	['x'] DPRIV_EXEC,
+	['w'] DPRIV_WRITE,
+	['r'] DPRIV_READ,
+	['s'] DPRIV_KEEPSWP,
+	['g'] DPRIV_SETGID,
+	['u'] DPRIV_SETUID,
+	['X'] DPRIV_WALK,
+	['W'] DPRIV_CREATE,
+	['R'] DPRIV_LIST,
+	['S'] DPRIV_STICKY,
+	['G'] DPRIV_PASSGID,
+	['U'] DPRIV_PASSUID,
+	['-'] 0,
+}; /* plus 0.25k .. */
+
+u16 flags_to_mode(unsigned int flags)
+{
+	u16 mode =3D 0;
+	if (flags & FMODE_READ ) mode |=3D DPRIV_READ;
+	if (flags & FMODE_WRITE) mode |=3D DPRIV_WRITE;
+	if (flags & FMODE_EXEC ) mode |=3D DPRIV_EXEC;
+	if (flags & O_CREAT    ) mode |=3D DPRIV_CREATE;
+	return mode;
+}
+
+int str_to_perm(const char *str)
+{
+	int perm =3D 0;
+	for (; *str; str++) {
+		if ((!isalpha(*str) || !perm_bit_table[(int)*str]) &&
+				*str !=3D '-')
+			return -1;
+		perm |=3D perm_bit_table[(int)*str];
+	}
+	return perm;
+}
+
+void perm_to_str(u16 perm, char *str)
+{
+	char *c =3D perm_bit_list;
+	for (; *c; c++,str++)
+		*str =3D (perm & perm_bit_table[(int)*c]) ?  *c : '-';
+	*str =3D '\0';
+}
+
+
+
+/**************
+ * DPriv Line *
+ **************/
+struct dpriv_line *dpriv_line_new(const struct inode *inode,
+		const char *path, u16 perm)
+{
+	struct dpriv_line *line;
+	line =3D kzalloc(sizeof(struct dpriv_line), GFP_KERNEL);
+	line->inode =3D inode;
+	line->path  =3D path;
+	line->perm  =3D perm;
+	return line;
+}
+
+
+
+/****************
+ * DPriv Policy *
+ ****************/
+void dpriv_policy_init(struct dpriv_policy *policy)
+{
+	INIT_LIST_HEAD(&policy->privs);
+	init_rwsem(&policy->privs_lock);
+}
+
+void dpriv_policy_reset(struct dpriv_policy *policy)
+{
+	struct list_head *pos, *n;
+	struct dpriv_line *line;
+	list_for_each_safe(pos, n, &policy->privs){
+		 line =3D list_entry(pos, struct dpriv_line, list);
+		 list_del(pos);
+		 kfree(line);
+	}
+}
+
+struct dpriv_line *dpriv_policy_get_line(const struct dpriv_policy *policy,
+		const struct inode *inode)
+{
+	struct dpriv_line *line;
+	list_for_each_entry(line, &policy->privs, list)
+		if (line->inode =3D=3D inode)
+			return line;
+	return NULL;
+}
+
+u16 dpriv_policy_get_perm(const struct dpriv_policy *policy,
+		const struct inode *inode)
+{
+	/* Stop if a permissions is found for current node */
+	struct dpriv_line *line =3D dpriv_policy_get_line(policy, inode);
+	if (line)
+		return line->perm;
+
+	/* Allow everything if we've reach the root without finding perms */
+	/* TODO: recurse to parent filesystems */
+	if (inode->i_security =3D=3D NULL)
+		return USHORT_MAX;
+
+	/* Check parents for recursive permissions */
+	/* TODO: Check for multiple parents */
+	return dpriv_policy_get_perm(policy, inode->i_security);
+	// perm =3D USHORT_MAX;
+	// foreach parent:
+	// 	perm &=3D dpriv_policy_get_perm(policy, inode->d_parent);
+	// return perm;
+}
+
+/* We need the inode and path so we can create the line if it doesn't exis=
t */
+void dpriv_policy_set_perm(struct dpriv_policy *policy,
+		const struct inode *inode, const char *path, u16 perm)
+{
+	struct dpriv_line *line =3D dpriv_policy_get_line(policy, inode);
+	if (line) {
+		line->perm =3D perm;
+	} else {
+		line =3D dpriv_line_new(inode, path, perm);
+		list_add_tail(&line->list, &policy->privs);
+	}
+}
+
+/* Do a semi-deep copy, that is, copy enough that the policies are distinc=
t,
+ * but without duplicating conostant data such as paths and dentries */
+void dpriv_policy_append(struct dpriv_policy *from, struct dpriv_policy *t=
o)
+{
+	struct dpriv_line *fl, *tl;
+	list_for_each_entry(fl, &from->privs, list) {
+		tl =3D dpriv_line_new(fl->inode, fl->path, fl->perm);
+		list_add_tail(&tl->list, &to->privs);
+	}
+}
+
+void dpriv_policy_commit(struct dpriv_policy *from, struct dpriv_policy *t=
o)
+{
+	u16 perm;
+	struct dpriv_line *line, *n;
+	struct dpriv_policy merge;
+	dpriv_policy_init(&merge);
+
+	/* Merge paths from @to into merge */
+	list_for_each_entry(line, &to->privs, list) {
+		perm  =3D line->perm;
+		perm &=3D dpriv_policy_get_perm(from, line->inode);
+		dpriv_policy_set_perm(&merge, line->inode, line->path, perm);
+	}
+
+	/* Merge paths from @from into merge */
+	list_for_each_entry(line, &from->privs, list) {
+		perm  =3D line->perm;
+		perm &=3D dpriv_policy_get_perm(to, line->inode);
+		dpriv_policy_set_perm(&merge, line->inode, line->path, perm);
+	}
+
+	/* Free old entries */
+	dpriv_policy_reset(to);
+	list_for_each_entry_safe(line, n, &merge.privs, list)
+		list_move_tail(&line->list, &to->privs);
+}
+
+
+
+/**************
+ * DPriv Task *
+ **************/
+struct dpriv_task *dpriv_task_new(void)
+{
+	struct dpriv_task *task;
+	task =3D kzalloc(sizeof(struct dpriv_task), GFP_KERNEL);
+
+	dpriv_policy_init(&task->stage);
+	dpriv_policy_init(&task->policy);
+
+	INIT_LIST_HEAD(&task->fds);
+	init_rwsem(&task->fds_lock);
+
+	return task;
+}
+
+struct dpriv_task *dpriv_task_dup(struct dpriv_task *task)
+{
+	struct dpriv_task *copy =3D dpriv_task_new();
+	struct dpriv_line *tl, *cl;
+
+	/* Copy policies */
+	dpriv_policy_append(&task->stage,  &copy->stage);
+	dpriv_policy_append(&task->policy, &copy->policy);
+
+	/* Copy file descriptors */
+	list_for_each_entry(tl, &task->fds, list) {
+		cl =3D dpriv_line_new(tl->inode, tl->path, tl->perm);
+		list_add_tail(&cl->list, &copy->fds);
+	}
+	return copy;
+}
diff --git a/security/dpriv/policy.h b/security/dpriv/policy.h
new file mode 100644
index 0000000..70c0cbb
--- /dev/null
+++ b/security/dpriv/policy.h
@@ -0,0 +1,228 @@
+/**
+ * dpriv/policy.h -- Privilege dropping core functionality
+ *
+ * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
+ *=20
+ * This program is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation, either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *=20
+ * This program is distributed in the hope that it will be useful, but WIT=
HOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ *=20
+ * You should have received a copy of the GNU General Public License along=
 with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __DPRIV_POLICY_H__
+#define __DPRIV_POLICY_H__
+
+#define f_inode f_dentry->d_inode
+
+/**
+ * Terminology
+ *   mode   =3D `Unix' mode (u16 use for filesyste mode bits)
+ *   perm   =3D DPriv permission bits (see below)
+ *   privs  =3D List of files and associated perm
+ *   policy =3D Privs + whatever else
+ */
+
+#define dpriv_cur_task   ((struct dpriv_task *)current_security())
+#define dpriv_cur_stage  ((struct dpriv_policy *)&dpriv_cur_task->stage)
+#define dpriv_cur_policy ((struct dpriv_policy *)&dpriv_cur_task->policy)
+
+
+/*******************
+ * Permission bits *
+ *******************/
+/* File bits */
+#define DPRIV_EXEC    (1u<<0 ) /* x */
+#define DPRIV_WRITE   (1u<<1 ) /* w */
+#define DPRIV_READ    (1u<<2 ) /* r */
+#define DPRIV_KEEPSWP (1u<<3 ) /* s (ignored) */
+#define DPRIV_SETGID  (1u<<4 ) /* g */
+#define DPRIV_SETUID  (1u<<5 ) /* u */
+
+/* Directory bits */
+#define DPRIV_WALK    (1u<<6 ) /* X */
+#define DPRIV_CREATE  (1u<<7 ) /* W */
+#define DPRIV_LIST    (1u<<8 ) /* R */
+#define DPRIV_STICKY  (1u<<9 ) /* S */
+#define DPRIV_PASSGID (1u<<10) /* G */
+#define DPRIV_PASSUID (1u<<11) /* U (ignored) */
+
+/* Meta bits/masks */
+#define DPRIV_PERM_BITS 12
+#define DPRIV_MASK      0b111111111111
+#define DPRIV_FILE_MASK 0b000000111111
+#define DPRIV_DIR_MASK  0b111111000000
+
+/* Mode conversion functions */
+#define deny(perm, request) \
+	unlikely(perm >=3D 0 && ~perm & request)
+
+/* Convert from a unix directory mode to a perm */
+#define dmode_to_perm(mode) \
+	((mode<<6))
+
+/* Convert from a unix file mode to a perm */
+#define fmode_to_perm(mode) \
+	(mode)
+
+/* Convert from a unix perm to a mode based on inode type */
+#define imode_to_perm(mode, inode)     \
+	(S_ISDIR(inode->i_mode) ?      \
+		 dmode_to_perm(mode) : \
+		 fmode_to_perm(mode))
+
+/**
+ * Convert struct file->f_flags to a Unix mode
+ * <x>mode_to_perm should probably be called on the resulting mode
+ */
+u16 flags_to_mode(unsigned int flags);
+
+/**
+ * Parse a permission string into a perm
+ * @str:
+ *  - Format is "rwxsguRWXSGU" (see Permission bits)
+ *  - Order does not matter
+ *  - '-' is ignored, any other character is invalid
+ *  - return -1 on invalid str
+ */
+int str_to_perm(const char *str);
+
+/**
+ * Convert a perm to a string for printing
+ */
+void perm_to_str(u16 perm, char *str);
+
+
+
+/**************
+ * DPriv Line *
+ **************/
+/**
+ * An entry in the policy
+ *
+ * Example:
+ *   /var/tmp (rw-)
+ *
+ * @list:  list_head for stroing in policy or fds
+ * @inode: Some point in the filesystem, topically an inode
+ * @path:  Path given when the line was created, debugging only
+ * @perm:  Permissions given to location and it's kids
+ */
+struct dpriv_line {
+	struct list_head    list;
+	const struct inode *inode;
+	const char         *path;
+	u16                 perm;
+};
+
+/**
+ * Allocate and initalize a new dpriv_line
+ * @indoe, @path, @perm: fileds to store en line
+ */
+struct dpriv_line *dpriv_line_new(const struct inode *inode,
+		const char *path, u16 perm);
+
+
+
+/****************
+ * DPriv Policy *
+ ****************/
+/**
+ * Contains permisisons and operations allowed for given security policy
+ *
+ * @privs:      List of dpriv_lines for filesystem privilages
+ * @privs_lock: Used for printing (maybe other?)
+ *
+ * Example:
+ *   privs:=20
+ *     /         (r--)
+ *     /bin/     (r-x)
+ *     /tmp/     (rw-)
+ */
+struct dpriv_policy {
+	struct list_head privs;
+	struct rw_semaphore privs_lock;
+	/* TODO: add other security things */
+};
+
+/* Initialize a blank @policy */
+void dpriv_policy_init(struct dpriv_policy *policy);
+
+/* Clear/free data from @policy */
+void dpriv_policy_reset(struct dpriv_policy *policy);
+
+/* Return the line from @policy->privs that matches @inode */
+struct dpriv_line *dpriv_policy_get_line(const struct dpriv_policy *policy,
+		const struct inode *inode);
+
+/* Recursivly lookup perm for @inode in @policy */
+u16 dpriv_policy_get_perm(const struct dpriv_policy *policy,
+		const struct inode *inode);
+
+/* Set perm for @inode in @policy to @perm, create new line if necessasiar=
y */
+void dpriv_policy_set_perm(struct dpriv_policy *policy,
+		const struct inode *inode, const char *path, u16 perm);
+
+/* Copy lines from @from to @to making sure that no additional oeratoins a=
re
+ * allowed in @to after the commit is performed */
+void dpriv_policy_commit(struct dpriv_policy *from, struct dpriv_policy *t=
o);
+
+
+
+/**************
+ * DPriv Task *
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
+ * @fds:
+ *   Open file descriptors and their implied permissions based on @policy
+ *
+ * @policy can only be modified by commiting @stage to @policy. When this =
is
+ * done, it is insured that no additional operations will be allowed by @p=
olicy
+ * after the commit.
+ *
+ * @fds is used to cache permissions on open file descriptors. This allows
+ * permissions to be quickly passed down form parents when opening directo=
ry
+ * entries. Note that when opening a file descriptor with multiple parents
+ * (e.g. a hard link) the permissions from the parent are incomplete and t=
he
+ * permissions form the alternate parents must be determined as well.
+ *
+ * NOTE: @fds is currently not used, we recursivly iterate up to parents
+ * whenever it's needed. This might be faster anyway?
+ *
+ * Example:
+ *   stage:  (see dpriv_policy)
+ *   policy: (see dpriv_policy)
+ *   fds:
+ *     /foo     ~(r--)
+ *     /bin/foo ~(r-x)
+ *     /tmp/foo ~(rw-)
+ */
+struct dpriv_task {
+	struct dpriv_policy stage;
+	struct dpriv_policy policy;
+
+	struct list_head fds;
+	struct rw_semaphore fds_lock;
+};
+
+/* Allocate a blank task */
+struct dpriv_task *dpriv_task_new(void);
+
+/* Create a semi-deep copy of @task, suitable for passing to a child on ex=
ec */
+struct dpriv_task *dpriv_task_dup(struct dpriv_task *task);
+
+#endif
diff --git a/security/dpriv/readme.txt b/security/dpriv/readme.txt
new file mode 100644
index 0000000..073d15d
--- /dev/null
+++ b/security/dpriv/readme.txt
@@ -0,0 +1,102 @@
+Source code
+-----------
+  policy.[ch] - policy datatypes
+  dpriv.c     - security/credentials hooks
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
+   - Store the most recent processes access in each inode?=20
+
+Privs:=20
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
+  -rw-rw-rw- /securityfs/dpriv/stage
+  -r--r--r-- /securityfs/dpriv/policy
+  --w--w--w- /securityfs/dpriv/control
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
+=20
+control:
+  write:
+    "commit" - merge staged policy into policy
+      > for (inode in policy, staged):
+      >     new[inode] =3D
+      >         implied_privs(policy, inode) &
+      >         implied_privs(staged, inode)=20
+      > clear(staged)
+
+    When committing, privilages can only be revoked.
+  =20
+
+Examples
+--------
+Example 1:
+  set /src/     (rw-)
+  set /dst/     (r-x)
+ =20
+  $ mv /src/foo /dst
+ =20
+  get /src/     (rw-)
+  get /dst/     (r-x)
+  OR:
+    get /dst/foo  (rw-)
+    get /dst/foo ~(r-x)
+    get /dst/foo  (rw-) & ~(r-x) =3D (r--)
+
+Example 2:
+  $ ln /src/foo /dst
+ =20
+  set /src/     (rw-)
+  set /dst/     (rwx)
+ =20
+  get /src/     (rw-)
+  get /dst/     (rwx)
+  get /src/foo ~(rw-) & ~(rwx) =3D ~(rw-)
+  get /dst/foo ~(rw-) & ~(rwx) =3D ~(rw-)

--=_c-1139-1253741493-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq6k7UACgkQz1OYJ/s1XTCXyQCfavLLPCmzENoEIb1w4dCWXloC
dtUAnjvX+HOMm2AeAVmVuNwiOm0cBN9z
=1tny
-----END PGP SIGNATURE-----

--=_c-1139-1253741493-0001-2--
