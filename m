Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbXHKR6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbXHKR6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 13:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXHKR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 13:57:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:19127 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbXHKR5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 13:57:46 -0400
Message-ID: <46BDF88B.2060301@schaufler-ca.com>
Date: Sat, 11 Aug 2007 10:57:31 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Cc: torvalds@osdl.org
Subject: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Smack is the Simplified Mandatory Access Control Kernel.

Smack implements mandatory access control (MAC) using labels
attached to tasks and data containers, including files, SVIPC,
and other tasks. Smack is a kernel based scheme that requires
an absolute minimum of application support and a very small
amount of configuration data.

Smack is implemented as a clean LSM. It requires no external
code changes and the patch modifies only the Kconfig and Makefile
in the security directory. Smack uses extended attributes and
provides a set of general mount options, borrowing technics used
elsewhere. Smack uses netlabel for CIPSO labeling. Smack provides
a pseudo-filesystem smackfs that is used for manipulation of
system Smack attributes.

Smack provides mandatory access controls based on the label attached
to a task and the label attached to the object it is attempting to
access. Smack labels are deliberately short (1-7 characters) text
strings. Single character labels using special characters are reserved
for system use. The only operation applied to Smack labels is equality
comparison. No wildcards or expressions, regular or otherwise, are
used.

A file always gets the Smack label of the task that created it.

Smack defines and uses these labels:

    "*" - pronounced "star"
    "_" - pronounced "floor"
    "^" - pronounced "hat"
    "?" - pronounced "huh"

The access rules enforced by Smack are, in order:

1. Any access requested by a task labeled "*" is denied.
2. A read or execute access requested by a task labeled "^"
   is permitted.
3. A read or execute access requested on an object labeled "_"
   is permitted.
4. Any access requested on an object labeled "*" is permitted.
5. Any access requested by a task on an object with the same
   label is permitted.
6. Any access requested that is explicitly defined in the loaded
   rule set is permitted.
7. Any other access is denied.

Rules may be explicitly defined by writing subject,object,access
triples to /smack/load.

Smack rule sets can be easily defined that describe Bell&LaPadula
sensitivity, Biba integrity, and a variety of interesting
configurations. Smack rule sets can be modified on the fly to
accomodate changes in the operating environment or even the time
of day.

Some practical use cases:

Hierarchical levels. The less common of the two usual uses
for MLS systems is to define hierarchical levels, often
unclassified, confidential, secret, and so on. To set up smack
to support this, these rules could be defined:

   C        Unclass rx
   S        C       rx
   S        Unclass rx
   TS       S       rx
   TS       C       rx
   TS       Unclass rx

A TS process can read S, C, and Unclass data, but cannot write it.
An S process can read C and Unclass. Note that specifying that
TS can read S and S can read C does not imply TS can read C, it
has to be explicitly stated.

Non-hierarchical categories. This is the more common of the
usual uses for an MLS system. Since the default rule is that a
subject cannot access an object with a different label no
access rules are required to implement compartmentalization.

A case that the Bell & LaPadula policy does not allow is demonstrated
with this Smack access rule:

A case that Bell&LaPadula does not allow that Smack does:

    ESPN    ABC   r
    ABC     ESPN  r

On my portable video device I have two applications, one that
shows ABC programming and the other ESPN programming. ESPN wants
to show me sport stories that show up as news, and ABC will
only provide minimal information about a sports story if ESPN
is covering it. Each side can look at the other's info, neither
can change the other. Neither can see what FOX is up to, which
is just as well all things considered.

Another case that I especially like:

    SatData Guard   w
    Guard   Publish w

A program running with the Guard label opens a UDP socket and
accepts messages sent by a program running with a SatData label.
The Guard program inspects the message to ensure it is wholesome
and if it is sends it to a program running with the Publish label.
This program then puts the information passed in an appropriate
place. Note that the Guard program cannot write to a Publish
file system object because file system semanitic require read as
well as write.

The four cases (categories, levels, mutual read, guardbox) here
are all quite real, and problems I've been asked to solve over
the years. The first two are easy to do with traditonal MLS systems
while the last two you can't without invoking privilege, at least
for a while.


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 security/Kconfig              |    1
 security/Makefile             |    2
 security/smack/Kconfig        |   10
 security/smack/Makefile       |    8
 security/smack/smack.h        |  246 +++++
 security/smack/smack_access.c |  113 ++
 security/smack/smack_lsm.c    | 1989 ++++++++++++++++++++++++++++++++++++++++++
 security/smack/smackfs.c      |  994 ++++++++++++++++++++
 8 files changed, 3363 insertions(+)

diff -uprN -X linux-2.6.22-base/Documentation/dontdiff linux-2.6.22-base/security/Kconfig linux-2.6.22/security/Kconfig
--- linux-2.6.22-base/security/Kconfig	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/security/Kconfig	2007-07-10 01:08:05.000000000 -0700
@@ -94,6 +94,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/smack/Kconfig
 
 endmenu
 
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff linux-2.6.22-base/security/Makefile linux-2.6.22/security/Makefile
--- linux-2.6.22-base/security/Makefile	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/security/Makefile	2007-07-10 01:08:05.000000000 -0700
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
+subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 
 # if we don't select a security model, use the default capabilities
 ifneq ($(CONFIG_SECURITY),y)
@@ -14,5 +15,6 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
+obj-$(CONFIG_SECURITY_SMACK)		+= commoncap.o smack/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff linux-2.6.22-base/security/smack/Kconfig linux-2.6.22/security/smack/Kconfig
--- linux-2.6.22-base/security/smack/Kconfig	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/security/smack/Kconfig	2007-07-10 01:08:05.000000000 -0700
@@ -0,0 +1,10 @@
+config SECURITY_SMACK
+	bool "Simplified Mandatory Access Control Kernel Support"
+	depends on NETLABEL && SECURITY_NETWORK
+	default n
+	help
+	  This selects the Simplified Mandatory Access Control Kernel.
+	  SMACK is useful for sensitivity, integrity, and a variety
+          of other madatory security schemes.
+	  If you are unsure how to answer this question, answer N.
+
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff linux-2.6.22-base/security/smack/Makefile linux-2.6.22/security/smack/Makefile
--- linux-2.6.22-base/security/smack/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/security/smack/Makefile	2007-07-10 01:08:05.000000000 -0700
@@ -0,0 +1,8 @@
+#
+# Makefile for the SMACK LSM
+#
+
+obj-$(CONFIG_SECURITY_SMACK) := smack.o
+
+smack-y := smack_lsm.o smack_access.o smackfs.o
+
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff linux-2.6.22-base/security/smack/smack_access.c linux-2.6.22/security/smack/smack_access.c
--- linux-2.6.22-base/security/smack/smack_access.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/security/smack/smack_access.c	2007-07-24 15:36:18.000000000 -0700
@@ -0,0 +1,113 @@
+/*
+ * Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2.
+ *
+ * Author:
+ *      Casey Schaufler <casey@schaufler-ca.com>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include "smack.h"
+
+extern struct smk_list_entry *smack_list;
+
+static int smk_get_access(smack_t sub, smack_t obj)
+{
+	struct smk_list_entry *sp = smack_list;
+
+	for (; sp != NULL; sp = sp->smk_next)
+		if (sp->smk_rule.smk_subject == sub &&
+		    sp->smk_rule.smk_object == obj)
+			return sp->smk_rule.smk_access;
+	/*
+	 * No access is explicitly defined for this pair.
+	 */
+	return MAY_NOT;
+}
+
+int smk_access(smack_t *sub_label, smack_t *obj_label, int request)
+{
+	smack_t sub = *sub_label;
+	smack_t obj = *obj_label;
+	/*
+	 * Hardcoded comparisons.
+	 *
+	 * A star subject can't access any object.
+	 */
+	if (sub == SMK_STAR)
+		return -EACCES;
+	/*
+	 * A star object can be accessed by any subject.
+	 */
+	if (obj == SMK_STAR)
+		return 0;
+	/*
+	 * An object can be accessed in any way by a subject
+	 * with the same label.
+	 */
+	if (sub == obj)
+		return 0;
+	/*
+	 * A hat subject can read any object.
+	 * A floor object can be read by any subject.
+	 */
+	if (sub == SMK_HAT && ((request & MAY_ANYREAD) == request))
+		return 0;
+
+	if (obj == SMK_FLOOR && ((request & MAY_ANYREAD) == request))
+		return 0;
+	/*
+	 * Beyond here an explicit relationship is required.
+	 * If the requested access is contained in the available
+	 * access (e.g. read is included in readwrite) it's
+	 * good.
+	 *
+	 * Yes, that is supposed to be a single ampersand.
+	 */
+	if ((request & smk_get_access(sub, obj)) == request)
+		return 0;
+
+	return -EACCES;
+}
+
+int smk_curacc(smack_t *obj_label, u32 mode)
+{
+	struct task_smack *tsp = current->security;
+	int rc;
+
+	rc = smk_access(&tsp->smk_task, obj_label, mode);
+	if (rc == 0)
+		return 0;
+	
+	if (capable(CAP_MAC_OVERRIDE))
+		return 0;
+
+	return rc;
+}
+
+/*
+ * The value that this adds is that everything after any
+ * character that's not allowed in a smack will be null
+ */
+smack_t smk_from_string(char *str)
+{
+	smack_t smack = 0LL;
+	char *cp;
+	int i;
+
+	for (cp = (char *)&smack, i = 0; i < sizeof(smack_t); str++,cp++,i++) {
+		if (*str <= ' ' || *str > '~')
+			return smack;
+		*cp = *str;
+	}
+	/*
+	 * Too long.
+	 */
+	return SMK_INVALID;
+}
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff linux-2.6.22-base/security/smack/smackfs.c linux-2.6.22/security/smack/smackfs.c
--- linux-2.6.22-base/security/smack/smackfs.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/security/smack/smackfs.c	2007-07-24 21:51:30.000000000 -0700
@@ -0,0 +1,994 @@
+/*
+ * Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *  	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation, version 2.
+ *
+ * Author:
+ * 	Casey Schaufler <casey@schaufler-ca.com>
+ * 
+ * Special thanks to the authors of selinuxfs. They had a good idea.
+ * 
+ *	Karl MacMillan <kmacmillan@tresys.com>
+ *	James Morris <jmorris@redhat.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/vmalloc.h>
+#include <linux/security.h>
+#include <linux/mutex.h>
+#include <net/netlabel.h>
+#include "../../net/netlabel/netlabel_domainhash.h"
+#include <net/cipso_ipv4.h>
+#include "smack.h"
+
+/*
+ * smackfs pseudo filesystem.
+ */
+
+
+enum smk_inos {
+	SMK_ROOT_INO =	2,
+	SMK_LOAD =	3,	/* load policy */
+	SMK_LINKS = 	4,	/* symlinks */
+	SMK_CIPSO = 	5,	/* load label -> CIPSO mapping */
+	SMK_DOI = 	6,	/* CIPSO DOI */
+	SMK_DIRECT = 	7,	/* CIPSO level indicating direct label */
+	SMK_AMBIENT = 	8,	/* internet ambient label */
+	SMK_NLTYPE = 	9,	/* label scheme to use by default */
+	SMK_TMP =	100,	/* MUST BE LAST! /smack/tmp */
+};
+
+/*
+ * This is the "ambient" label for network traffic.
+ * If it isn't somehow marked, use this.
+ * It can be reset via smackfs/ambient
+ */
+smack_t smack_net_ambient = SMK_FLOOR;
+
+/*
+ * This is the default packet marking scheme for network traffic.
+ * It can be reset via smackfs/nltype
+ */
+int smack_net_nltype = NETLBL_NLTYPE_CIPSOV4;
+
+/*
+ * This is the level in a CIPSO header that indicates a
+ * smack label is contained directly in the category set.
+ * It can be reset via smackfs/direct
+ */
+int smack_cipso_direct = SMACK_CIPSO_DIRECT_DEFAULT;
+static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
+
+static struct smk_cipso_entry smack_cipso_floor = {
+        .smk_next = NULL,
+        .smk_smack = SMK_FLOOR,
+        .smk_level = 0,
+        .smk_catset = 0LL,
+};
+struct smk_cipso_entry *smack_cipso = &smack_cipso_floor;
+static DEFINE_MUTEX(smack_cipso_lock);
+
+static int smack_list_count;
+struct smk_list_entry *smack_list;
+static DEFINE_MUTEX(smack_list_lock);
+
+/*
+ * 'ssssssss oooooooo mmmm\n\0' 
+ */
+#define SMACK_RULE_LINE_SIZE (2 * (sizeof(smack_t) + 1) + 6)
+
+static ssize_t smk_read_load(struct file *filp, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	ssize_t bytes;
+	struct smk_list_entry *slp = smack_list;
+	struct smack_rule *srp;
+	char *result;
+	char *cp;
+	int realbytes = 0;
+	
+	bytes = SMACK_RULE_LINE_SIZE * smack_list_count;
+	if (bytes == 0)
+		return 0;
+
+	result = kzalloc(bytes, GFP_KERNEL);
+	if (result == NULL)
+		return -ENOMEM;
+
+	for (cp = result; slp != NULL; slp = slp->smk_next) {
+		srp = &slp->smk_rule;
+		sprintf(cp, "%-8s %-8s",
+			(char *)&srp->smk_subject, (char *)&srp->smk_object);
+		cp += strlen(cp);
+		if (srp->smk_access != 0) 
+			*cp++ = ' ';
+		if ((srp->smk_access & MAY_READ) != 0)
+			*cp++ = 'r';
+		if ((srp->smk_access & MAY_WRITE) != 0)
+			*cp++ = 'w';
+		if ((srp->smk_access & MAY_EXEC) != 0)
+			*cp++ = 'x';
+		if ((srp->smk_access & MAY_APPEND) != 0)
+			*cp++ = 'a';
+		*cp++ = '\n';
+	}
+	*cp++ = '\0';
+	realbytes = strlen(result);
+
+	bytes = simple_read_from_buffer(buf, count, ppos, result, realbytes);
+	
+	kfree(result);
+
+	return bytes;
+}
+
+/*
+ * For purposes of SMACK:
+ *    append is a form of write
+ *    exec is a form of read
+ * This isn't reflected here, but I thought I should mention it.
+ */
+
+static void smk_set_access(struct smack_rule *srp)
+{
+	struct smk_list_entry *sp;
+	struct smk_list_entry *newp;
+
+	mutex_lock(&smack_list_lock);
+
+	for (sp = smack_list; sp != NULL; sp = sp->smk_next)
+		if (sp->smk_rule.smk_subject == srp->smk_subject &&
+		    sp->smk_rule.smk_object == srp->smk_object) {
+			sp->smk_rule.smk_access = srp->smk_access;
+			break;
+		}
+
+	if (sp == NULL) {
+		newp = kzalloc(sizeof(struct smk_list_entry), GFP_KERNEL);
+		newp->smk_rule = *srp;
+		newp->smk_next = smack_list;
+		smack_list = newp;
+		smack_list_count++;
+	}
+
+	mutex_unlock(&smack_list_lock);
+
+	return;
+}
+
+
+static ssize_t smk_write_load(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct smack_rule rule;
+	ssize_t rc = count;
+	char *data = NULL;
+	char modestr[8];
+	char *cp;
+
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+	/*
+	 * No partial writes.
+	 */
+	if (*ppos != 0)
+		return -EINVAL;
+
+	/*
+	 * 80 characters per line ought to be enough.
+	 */
+	if (count > SMACK_LIST_MAX * 80)
+		return -ENOMEM;
+
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	*(data + count) = '\0';
+
+	for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
+		if (*++cp == '\0')
+			break;
+		if (sscanf(cp, "%7s %7s %7s\n",
+			   (char *)&rule.smk_subject,
+			   (char *)&rule.smk_object, modestr) != 3) {
+			printk("%s:%d bad scan\n",
+				__FUNCTION__, __LINE__);
+			break;
+		}
+		rule.smk_subject =
+			smk_from_string((char *)&rule.smk_subject);
+		if (rule.smk_subject == SMK_INVALID)
+			break;
+		rule.smk_object =
+			smk_from_string((char *)&rule.smk_object);
+		if (rule.smk_object == SMK_INVALID)
+			break;
+		rule.smk_access = 0;
+		if (strchr(modestr, 'r') || strchr(modestr, 'R'))
+			rule.smk_access |= MAY_READ;
+		if (strchr(modestr, 'w') || strchr(modestr, 'W'))
+			rule.smk_access |= MAY_WRITE;
+		if (strchr(modestr, 'x') || strchr(modestr, 'X'))
+			rule.smk_access |= MAY_EXEC;
+		if (strchr(modestr, 'a') || strchr(modestr, 'A'))
+			rule.smk_access |= MAY_APPEND;
+		smk_set_access(&rule);
+		printk("%s:%d rule %s %s 0x%x\n",
+			__FUNCTION__, __LINE__,
+			(char *)&rule.smk_subject,
+			(char *)&rule.smk_object,
+			rule.smk_access);
+	}
+
+	kfree(data);
+	return rc;
+}
+
+static struct file_operations smk_load_ops = {
+	.read		= smk_read_load,
+	.write		= smk_write_load,
+};
+
+static char *smk_digit(char *cp)
+{
+	for (; *cp != '\0'; cp++)
+		if (*cp >= '0' && *cp <= '9')
+			return cp;
+
+	return NULL;
+}
+
+static int smk_cipso_doied;
+static int smk_cipso_written;
+
+/*
+ * This code reaches too deeply into netlabel internals
+ * for comfort, however there is no netlabel KAPI that
+ * allows for kernel based initialization of a CIPSO DOI.
+ * Until Paul and Casey can work out an appropriate
+ * interface Smack will do it this way.
+ */
+static void smk_cipso_doi(void)
+{
+	int rc;
+	struct cipso_v4_doi *doip;
+	struct netlbl_dom_map *ndmp;
+	struct netlbl_audit audit_info;
+
+	if (smk_cipso_doied != 0)
+		return;
+	smk_cipso_doied = 1;
+
+	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
+	if (doip == NULL)
+		panic("smack:  Failed to initialize cipso DOI.\n");
+	doip->map.std = NULL;
+
+	ndmp = kmalloc(sizeof(struct netlbl_dom_map), GFP_KERNEL);
+	if (ndmp == NULL)
+		panic("smack:  Failed to initialize cipso ndmp.\n");
+
+	doip->doi = smk_cipso_doi_value;
+	doip->type = CIPSO_V4_MAP_PASS;
+	doip->tags[0] = CIPSO_V4_TAG_RBITMAP;
+	for (rc = 1; rc < CIPSO_V4_TAG_MAXCNT; rc++)
+		doip->tags[rc] = CIPSO_V4_TAG_INVALID;
+
+	rc = cipso_v4_doi_add(doip);
+	if (rc != 0)
+		printk("%s:%d add doi rc = %d\n", __FUNCTION__, __LINE__, rc);
+
+	ndmp->domain = NULL;
+	ndmp->type = NETLBL_NLTYPE_CIPSOV4;
+	ndmp->type_def.cipsov4 = doip;
+
+	rc = netlbl_domhsh_remove_default(&audit_info);
+	if (rc != 0)
+		printk("%s:%d remove rc = %d\n", __FUNCTION__, __LINE__, rc);
+
+	rc = netlbl_domhsh_add_default(ndmp, &audit_info);
+	if (rc != 0)
+		printk("%s:%d add rc = %d\n", __FUNCTION__, __LINE__, rc);
+}
+
+/*
+ * label level[/cat[,cat]]
+ */
+static ssize_t smk_read_cipso(struct file *filp, char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	ssize_t bytes;
+	struct smk_cipso_entry *slp = smack_cipso;
+	char sep;
+	char *result;
+	char *cp;
+	char *cbp;
+	int realbytes = 0;
+	int cat = -1;
+	unsigned char m;
+
+	smk_cipso_doi();
+
+	result = kzalloc(smk_cipso_written, GFP_KERNEL);
+	if (result == NULL)
+		return -ENOMEM;
+	cp = result;
+
+	for (slp = smack_cipso; slp != NULL; slp = slp->smk_next) {
+		sprintf(cp, "%-8s %3d", (char *)&slp->smk_smack,slp->smk_level);
+		cp += strlen(cp);
+		cat = 1;
+		sep = '/';
+		for (cbp = (char *)&slp->smk_catset; *cbp != 0; cbp++) {
+			for (m = 0x80; m != 0; m >>= 1) {
+				if ((m & *cbp) != 0) {
+					sprintf(cp, "%c%d", sep, cat);
+					cp += strlen(cp);
+					sep = ',';
+				}
+				cat++;
+			}
+		}
+		*cp++ = '\n';
+	}
+	*cp++ = '\0';
+	realbytes = strlen(result);
+
+	bytes = simple_read_from_buffer(buf, count, ppos, result, realbytes);
+	
+	kfree(result);
+
+	return bytes;
+}
+
+static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct smk_cipso_entry *scp;
+	smack_t mapsmack;
+	smack_t mapcatset;
+	int maplevel;
+	ssize_t rc = count;
+	char *data = NULL;
+	char *cp;
+	char *eolp;
+	char *linep;
+	int cat;
+	int i;
+
+	smk_cipso_doi();
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+	/*
+	 * No partial writes.
+	 */
+	if (*ppos != 0)
+		return -EINVAL;
+	/*
+	 * 80 characters per line ought to be enough.
+	 */
+	if (count > SMACK_LIST_MAX * 80)
+		return -ENOMEM;
+
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	*(data + count) = '\0';
+	smk_cipso_written += count;
+
+	for (eolp = strchr(data, '\n'), linep = data;
+		eolp != NULL && rc >= 0;
+		linep = eolp + 1, eolp = strchr(linep, '\n')) {
+
+		if (eolp == linep)
+			continue;
+		*eolp = '\0';
+
+		mapsmack = smk_from_string(linep);
+		mapcatset = 0ll;
+
+		if (mapsmack == SMK_INVALID)
+			continue;
+
+		cp = smk_digit(linep + strlen((char *)&mapsmack));
+		if (cp == NULL)
+			continue;
+
+		i = sscanf(cp, "%d", &maplevel);
+		if (i != 1)
+			continue;
+
+		cp = strchr(cp, '/');
+		if (cp != NULL) {
+			cp = smk_digit(cp);
+			if (cp == NULL)
+				continue;
+
+			do {
+				i = sscanf(cp, "%d", &cat);
+				if (i != 1)
+					break;
+				if (cat > SMACK_CIPSO_MAXCAT) {
+					i = 0;
+					break;
+				}
+				smack_catset_bit(cat, &mapcatset);
+
+				cp = strchr(cp, ',');
+				if (cp != NULL)
+					cp = smk_digit(cp);
+			} while (cp != NULL);
+		}
+
+		if (i != 1)
+			continue;
+
+		mutex_lock(&smack_cipso_lock);
+
+		for (scp = smack_cipso; scp != NULL; scp = scp->smk_next)
+			if (mapsmack == scp->smk_smack)
+				break;
+
+		if (scp == NULL) {
+			scp = kzalloc(sizeof(struct smk_cipso_entry),
+				GFP_KERNEL);
+			if (scp == NULL)
+				rc = -ENOMEM;
+			else {
+				scp->smk_next = smack_cipso;
+				scp->smk_smack = mapsmack;
+				scp->smk_level = maplevel;
+				scp->smk_catset = mapcatset;
+				smack_cipso = scp;
+				/*
+				 * Add this to ensure that there are
+				 * enough bytes for the regurgitation
+				 */
+				smk_cipso_written += sizeof(smack_t);
+			}
+		}
+
+		mutex_unlock(&smack_cipso_lock);
+	}
+
+	kfree(data);
+	return rc;
+}
+
+static struct file_operations smk_cipso_ops = {
+	.read		= smk_read_cipso,
+	.write		= smk_write_cipso,
+};
+
+static ssize_t smk_read_doi(struct file *filp, char __user *buf,
+			        size_t count, loff_t *ppos)
+{
+	char temp[80];
+	ssize_t rc;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(temp, "%d", smk_cipso_doi_value);
+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+
+	return rc;
+}
+
+static ssize_t smk_write_doi(struct file *file, const char __user *buf,
+			         size_t count, loff_t *ppos)
+{
+	char temp[80];
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count > sizeof(temp))
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	if (sscanf(temp, "%d", &i) != 1)
+		return -EINVAL;
+
+	smk_cipso_doi_value = i;
+
+	return count;
+}
+
+static struct file_operations smk_doi_ops = {
+	.read		= smk_read_doi,
+	.write		= smk_write_doi,
+};
+
+static ssize_t smk_read_direct(struct file *filp, char __user *buf,
+			        size_t count, loff_t *ppos)
+{
+	char temp[80];
+	ssize_t rc;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(temp, "%d", smack_cipso_direct);
+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+
+	return rc;
+}
+
+static ssize_t smk_write_direct(struct file *file, const char __user *buf,
+			         size_t count, loff_t *ppos)
+{
+	char temp[80];
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count > sizeof(temp))
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	if (sscanf(temp, "%d", &i) != 1)
+		return -EINVAL;
+
+	smack_cipso_direct = i;
+
+	return count;
+}
+
+static struct file_operations smk_direct_ops = {
+	.read		= smk_read_direct,
+	.write		= smk_write_direct,
+};
+
+static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
+			        size_t count, loff_t *ppos)
+{
+	ssize_t rc;
+
+	if (count < sizeof(smack_t))
+		return -EINVAL;
+
+	if (*ppos != 0)
+		return 0;
+
+	rc = simple_read_from_buffer(buf, count, ppos, &smack_net_ambient,
+		sizeof(smack_t));
+
+	return rc;
+}
+
+static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
+			         size_t count, loff_t *ppos)
+{
+	smack_t smack;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count > sizeof(smack_t))
+		return -EINVAL;
+
+	if (copy_from_user(&smack, buf, count) != 0)
+		return -EFAULT;
+
+	smack = smk_from_buffer(&smack, count);
+	if (smack == SMK_INVALID)
+		return -EINVAL;
+	/*
+	 * Better check to be sure this is OK.
+	 */
+	smack_net_ambient = smack;
+
+	return count;
+}
+
+static struct file_operations smk_ambient_ops = {
+	.read		= smk_read_ambient,
+	.write		= smk_write_ambient,
+};
+
+struct option_names {
+	int	o_number;
+	char	*o_name;
+	char	*o_alias;
+};
+
+static struct option_names netlbl_choices[] = {
+	{ NETLBL_NLTYPE_RIPSO,
+		NETLBL_NLTYPE_RIPSO_NAME,	"ripso" },
+	{ NETLBL_NLTYPE_CIPSOV4,
+		NETLBL_NLTYPE_CIPSOV4_NAME,	"cipsov4" },
+	{ NETLBL_NLTYPE_CIPSOV4,
+		NETLBL_NLTYPE_CIPSOV4_NAME,	"cipso" },
+	{ NETLBL_NLTYPE_CIPSOV6,
+		NETLBL_NLTYPE_CIPSOV6_NAME,	"cipsov6" },
+	{ NETLBL_NLTYPE_UNLABELED,
+		NETLBL_NLTYPE_UNLABELED_NAME,	"unlabeled" },
+};
+#define NCHOICES (sizeof(netlbl_choices) / sizeof(struct option_names))
+
+static ssize_t smk_read_nltype(struct file *filp, char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	char bound[40];
+	ssize_t rc;
+	int i;
+
+	if (count < sizeof(smack_t))
+		return -EINVAL;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(bound, "unknown");
+
+	for (i = 0; i < NCHOICES; i++)
+		if (smack_net_nltype == netlbl_choices[i].o_number) {
+			sprintf(bound, "%s", netlbl_choices[i].o_name);
+			break;
+		}
+
+	rc = simple_read_from_buffer(buf, count, ppos, bound, strlen(bound));
+
+	return rc;
+}
+
+static ssize_t smk_write_nltype(struct file *file, const char __user *buf,
+			        size_t count, loff_t *ppos)
+{
+	char bound[40];
+	char *cp;
+	int i;
+
+	if (!capable(CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (count >= 40)
+		return -EINVAL;
+
+	if (copy_from_user(bound, buf, count) != 0)
+		return -EFAULT;
+
+	bound[count] = '\0';
+	cp = strchr(bound, ' ');
+	if (cp != NULL)
+		*cp = '\0';
+	cp = strchr(bound, '\n');
+	if (cp != NULL)
+		*cp = '\0';
+
+	for (i = 0; i < NCHOICES; i++)
+		if ((strcmp(bound, netlbl_choices[i].o_name) == 0) ||
+		    (strcmp(bound, netlbl_choices[i].o_alias) == 0)) {
+			smack_net_nltype = netlbl_choices[i].o_number;
+			return count;
+		}
+	/*
+	 * Not a valid choice.
+	 */
+	return -EINVAL;
+}
+
+static struct file_operations smk_nltype_ops = {
+	.read		= smk_read_nltype,
+	.write		= smk_write_nltype,
+};
+
+/*
+ * mapping for symlinks
+ */
+#define SMK_TMPPATH_SIZE        32
+#define SMK_TMPPATH_ROOT        "/moldy/"
+
+struct smk_link {
+	struct smk_link	*sl_next;
+	int		sl_inum;
+	char		sl_name[SMK_TMPPATH_SIZE];
+	char		sl_target[SMK_TMPPATH_SIZE];
+};
+
+static struct super_block *smk_sb = NULL;
+static struct smk_link *smk_links = NULL;
+static int smk_links_count = 0;
+
+static void *smackfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct task_smack *tsp = current->security;
+	smack_t *sp = &tsp->smk_task;
+	char *cp;
+	int inum = dentry->d_inode->i_ino;
+	struct smk_link *slp;
+
+	for (slp = smk_links; slp != NULL; slp = slp->sl_next)
+		if (slp->sl_inum == inum)
+			break;
+
+	if (slp == NULL) {
+		printk("%s:%d failed\n", __FUNCTION__, __LINE__);
+		return NULL;
+	}
+	cp = kzalloc(SMK_TMPPATH_SIZE, GFP_KERNEL);
+	if (cp == NULL)
+		return NULL;
+
+	strcpy(cp, slp->sl_target);
+	strcat(cp, (char *)sp);
+	nd_set_link(nd, cp);
+	/*
+	 * Unlike the relink below, hang on to the memory allocated
+	 * because nd_set_link passes it along.
+	 */
+	return NULL;
+}
+
+static int smackfs_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+{
+	smack_t *csp = smk_of_task(current);
+	char *cp;
+	int len;
+	int inum = dentry->d_inode->i_ino;
+	struct smk_link *slp;
+
+	for (slp = smk_links; slp != NULL; slp = slp->sl_next)
+		if (slp->sl_inum == inum)
+			break;
+
+	if (slp == NULL) {
+		printk("%s:%d failed\n", __FUNCTION__, __LINE__);
+		return -EACCES;
+	}
+
+	cp = kzalloc(SMK_TMPPATH_SIZE, GFP_KERNEL);
+	if (cp == NULL)
+		return -ENOMEM;
+
+	strcpy(cp, slp->sl_target);
+	strcat(cp, (char *)csp);
+	len = strlen(cp);
+	len = (len > buflen) ? buflen : len;
+
+	if (copy_to_user(buffer, cp, len) != 0)
+		len = -EFAULT;
+
+	kfree(cp);
+	return len;
+}
+
+static void smackfs_put_link(struct dentry *dentry, struct nameidata *nd, void *ptr)
+{
+	kfree(nd_get_link(nd));
+}
+
+static struct inode_operations smackfs_symlink_inode_operations = {
+	.readlink	= smackfs_readlink,
+	.follow_link	= smackfs_follow_link,
+	.put_link	= smackfs_put_link,
+};
+
+static void smk_add_symlink(char *name, char *target)
+{
+	static int inum = SMK_TMP;
+	struct inode *inode;
+	struct dentry *dentry;
+	struct smk_link *slp;
+
+	for (slp = smk_links; slp != NULL; slp = slp->sl_next) {
+		if (strcmp(slp->sl_name, name) != 0)
+			continue;
+		strcpy(slp->sl_target, target);
+		return;
+	}
+
+	slp = kzalloc(sizeof(struct smk_link), GFP_KERNEL);
+	if (slp == NULL)
+		return;
+
+	dentry = d_alloc_name(smk_sb->s_root, name);
+	if (dentry == NULL) {
+		printk("%s:%d link dentry failed\n", __FUNCTION__, __LINE__);
+		return;
+	}
+
+	inode = new_inode(smk_sb);
+	if (inode == NULL) {
+		printk("%s:%d link inode failed\n", __FUNCTION__, __LINE__);
+		return;
+	}
+
+	inode->i_mode = S_IFLNK | S_IRWXUGO;
+	inode->i_uid = 0;
+	inode->i_gid = 0;
+	inode->i_blocks = 0;
+	inode->i_atime = CURRENT_TIME;
+	inode->i_mtime = inode->i_atime;
+	inode->i_ctime = inode->i_atime;
+	inode->i_ino = inum++;
+	inode->i_op = &smackfs_symlink_inode_operations;
+	d_add(dentry, inode);
+
+	strcpy(slp->sl_name, name);
+	strcpy(slp->sl_target, target);
+	slp->sl_inum = inode->i_ino;
+	slp->sl_next = smk_links;
+	smk_links = slp;
+	smk_links_count++;
+
+	return;
+}
+
+static ssize_t smk_read_links(struct file *filp, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	ssize_t bytes = sizeof(struct smk_link) * smk_links_count;
+	struct smk_link *slp;
+	char *result;
+	char *cp;
+	
+
+	result = kzalloc(bytes, GFP_KERNEL);
+	if (result == NULL)
+		return -ENOMEM;
+	*result = '\0';
+
+	for (slp = smk_links, cp = result; slp != NULL; slp = slp->sl_next) {
+		sprintf(cp, "%s %s\n", slp->sl_name, slp->sl_target);
+		cp += strlen(slp->sl_name) + strlen(slp->sl_target);
+	}
+
+	bytes = simple_read_from_buffer(buf,count,ppos,result,strlen(result));
+	
+	kfree(result);
+
+	return bytes;
+}
+
+static ssize_t smk_write_links(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	ssize_t rc = count;
+	char *data;
+	char *cp;
+	char name[SMK_TMPPATH_SIZE];
+	char target[SMK_TMPPATH_SIZE];
+
+	/*
+	 * No partial writes.
+	 */
+	if (*ppos != 0)
+		return -EINVAL;
+	/*
+	 * 80 characters per line ought to be enough.
+	 */
+	if (count > SMACK_LIST_MAX * 80)
+		return -ENOMEM;
+
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	*(data + count) = '\0';
+
+	for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
+		if (*++cp == '\0')
+			break;
+		if (sscanf(cp, "%14s %30s\n", name, target) != 2) {
+			printk("%s:%d bad scan\n",
+				__FUNCTION__, __LINE__);
+			break;
+		}
+		smk_add_symlink(name, target);
+		printk("%s:%d add %s -> %s\n",
+			__FUNCTION__, __LINE__, name, target);
+	}
+
+	kfree(data);
+	return rc;
+}
+
+static struct file_operations smk_links_ops = {
+	.read		= smk_read_links,
+	.write		= smk_write_links,
+};
+
+static int smk_fill_super(struct super_block *sb, void * data, int silent)
+{
+	int rc;
+	struct inode *root_inode;
+
+	static struct tree_descr smack_files[] = {
+		[SMK_LOAD] = {"load", &smk_load_ops, S_IRUGO|S_IWUSR},
+		[SMK_LINKS] = {"links", &smk_links_ops, S_IRUGO|S_IWUSR},
+		[SMK_CIPSO] = {"cipso", &smk_cipso_ops, S_IRUGO|S_IWUSR},
+		[SMK_DOI] = {"doi", &smk_doi_ops, S_IRUGO|S_IWUSR},
+		[SMK_DIRECT] = {"direct", &smk_direct_ops, S_IRUGO|S_IWUSR},
+		[SMK_AMBIENT] = {"ambient", &smk_ambient_ops, S_IRUGO|S_IWUSR},
+		[SMK_NLTYPE] = {"nltype", &smk_nltype_ops, S_IRUGO|S_IWUSR},
+		/* last one */ {""}
+	};
+
+	/*
+	 * There will be only one smackfs. Casey says so.
+	 */
+	smk_sb = sb;
+
+	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);
+	if (rc != 0) {
+		printk(KERN_ERR "%s failed %d while creating inodes\n",
+			__FUNCTION__, rc);
+		return rc;
+	}
+
+	root_inode = sb->s_root->d_inode;
+	root_inode->i_security = new_inode_smack(SMK_FLOOR);
+
+	/*
+	 * Create a directory for /smack/tmp
+	 */
+	smk_add_symlink("tmp", SMK_TMPPATH_ROOT);
+
+	return 0;
+}
+
+static int smk_get_sb(struct file_system_type *fs_type,
+		      int flags, const char *dev_name, void *data,
+		      struct vfsmount *mnt)
+{
+	return get_sb_single(fs_type, flags, data, smk_fill_super, mnt);
+}
+
+static struct file_system_type smk_fs_type = {
+	.name		= "smackfs",
+	.get_sb		= smk_get_sb,
+	.kill_sb	= kill_litter_super,
+};
+
+static struct vfsmount *smackfs_mount;
+
+static int __init init_smk_fs(void)
+{
+	int err;
+
+	err = register_filesystem(&smk_fs_type);
+	if (!err) {
+		smackfs_mount = kern_mount(&smk_fs_type);
+		if (IS_ERR(smackfs_mount)) {
+			printk(KERN_ERR "smackfs:  could not mount!\n");
+			err = PTR_ERR(smackfs_mount);
+			smackfs_mount = NULL;
+		}
+	}
+
+	mutex_init(&smack_list_lock);
+	mutex_init(&smack_cipso_lock);
+	return err;
+}
+
+__initcall(init_smk_fs);
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff linux-2.6.22-base/security/smack/smack.h linux-2.6.22/security/smack/smack.h
--- linux-2.6.22-base/security/smack/smack.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/security/smack/smack.h	2007-07-24 16:16:27.000000000 -0700
@@ -0,0 +1,246 @@
+/*
+ * Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2.
+ *
+ * Author:
+ *      Casey Schaufler <casey@schaufler-ca.com>
+ *
+ */
+
+#ifndef _SECURITY_SMACK_H
+#define _SECURITY_SMACK_H
+
+#include <linux/capability.h>
+#include <net/netlabel.h>
+
+/*
+ * A smack_t contains an 8 byte string, 7 characters
+ * and a terminating NULL. Yes, it's short and 12.5%
+ * wasted.
+ * 
+ * There is likely to be experimentation with alternative
+ * representations, perhaps a u32 so that it's the same
+ * as what's used in Other LSM MAC schemes, or an array
+ * of 20 chars so that the names aren't so tightly constrained.
+ */
+typedef u64 smack_t;
+
+struct superblock_smack {
+	smack_t smk_root;
+	smack_t smk_floor;
+	smack_t smk_hat;
+	smack_t smk_default;
+	int	smk_initialized;
+};
+
+/*
+ * Task smack data
+ */
+struct task_smack {
+	smack_t	smk_task;	/* label of the task */
+};
+
+/*
+ * Socket smack data
+ */
+struct socket_smack {
+	smack_t	smk_out;	/* label to associate with outbound packets */
+	smack_t	smk_in;		/* label to check on incoming packets */
+	smack_t smk_packet;	/* label of incoming packet on request */
+};
+
+/*
+ * Inode smack data
+ */
+struct inode_smack {
+	smack_t		smk_inode;	/* label of the fso */
+	struct mutex	smk_lock;	/* initialization lock */
+	int		smk_flags;	/* smack inode flags */
+};
+
+#define	SMK_INODE_INSTANT	0x01	/* inode is instantiated */
+
+/*
+ * A label access rule.
+ */
+struct smack_rule {
+	smack_t		smk_subject;
+	smack_t		smk_object;
+	int		smk_access;
+};
+
+/*
+ * An entry in the table of permitted label accesses.
+ */
+struct smk_list_entry {
+	struct smk_list_entry	*smk_next;
+	struct smack_rule	smk_rule;
+};
+
+/*
+ * An entry in the table mapping smack values to
+ * CIPSO level/category-set values.
+ */
+struct smk_cipso_entry {
+	struct smk_cipso_entry		*smk_next;
+	int				smk_level;	/* for CIPSO */
+	smack_t				smk_smack;
+	smack_t				smk_catset;
+};
+
+/*
+ * Mount options
+ */
+#define SMK_FSDEFAULT	"smackfsdef="
+#define SMK_FSFLOOR	"smackfsfloor="
+#define SMK_FSHAT	"smackfshat="
+#define SMK_FSROOT	"smackfsroot="
+
+/*
+ * xattr names
+ */
+#define XATTR_SMACK_SUFFIX	"SMACK64"
+#define XATTR_SMACK_IPIN	"SMACK64IPIN"
+#define XATTR_SMACK_IPOUT	"SMACK64IPOUT"
+#define XATTR_SMACK_PACKET	"SMACK64PACKET"
+#define XATTR_NAME_SMACK	XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
+
+/*
+ * smackfs macic number
+ */
+#define SMACK_MAGIC	0x43415d53 /* "SMAC" */
+
+/*
+ * A limit on the number of entries in the lists
+ * makes some of the list administration easier.
+ */
+#define SMACK_LIST_MAX	10000
+
+/*
+ * CIPSO defaults.
+ */
+#define SMACK_CIPSO_DOI_DEFAULT		3	/* Historical */
+#define SMACK_CIPSO_DIRECT_DEFAULT	250	/* Arbitrary */
+#define SMACK_CIPSO_MAXCAT		63	/* Bigger gets harder */
+
+/*
+ * Pre-defined smack label values.
+ */
+#define SMK_INVALID	0x00LL		/* NULLSTRING */
+#define SMK_HAT		0x5ELL		/* "^" */
+#define SMK_FLOOR	0x5FLL		/* "_" */
+#define SMK_STAR	0x2ALL		/* "*" */
+#define SMK_HUH		0x3FLL		/* "?" */
+#define SMK_UNSET	0x5445534e55LL	/* "UNSET" */
+/*
+ * There's a place in the CIPSO initialization that
+ * wants this.
+ */
+#define SMK32_FLOOR	0x5F /* "_" */
+
+#define SMK_MAXLEN	(sizeof(smack_t) - 1)	/* NULL terminated */
+/*
+ * Just to make the common cases easier to deal with
+ */
+#define MAY_ANY		(MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+#define MAY_ANYREAD	(MAY_READ | MAY_EXEC)
+#define MAY_ANYWRITE	(MAY_WRITE | MAY_APPEND)
+#define MAY_READWRITE	(MAY_READ | MAY_WRITE)
+#define MAY_NOT		0
+
+/*
+ * There are not enough CAP bits available to make this
+ * real, so Casey borrowed the capability that looks to
+ * him like it has the best balance of similarity amd
+ * low use.
+ */
+#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
+
+/*
+ * These functions are in smack_lsm.c
+ */
+struct inode_smack *new_inode_smack(smack_t);
+
+/*
+ * These functions are in smack_access.c
+ */
+int smk_access(smack_t *, smack_t *, int);
+int smk_curacc(smack_t *, u32);
+smack_t smk_from_string(char *);
+
+/*
+ * Stricly for CIPSO level manipulation.
+ * Set the category bit number in a smack_t.
+ */
+static inline void smack_catset_bit(int cat, smack_t *catsetp)
+{
+        char *cp = (char *)catsetp;
+
+        if (cat > sizeof(smack_t) * 8)
+                return;
+
+        cp[(cat - 1) / 8] |= 0x80 >> ((cat - 1) % 8);
+}
+
+/*
+ * Present a pointer to the smack label in a task blob.
+ */
+static inline smack_t *smk_of_task(const struct task_struct *tsp)
+{
+	struct task_smack *stp = tsp->security;
+	return &stp->smk_task;
+}
+
+/*
+ * Present a pointer to the smack label in an inode blob.
+ */
+static inline smack_t *smk_of_inode(const struct inode *isp)
+{
+	struct inode_smack *sip = isp->i_security;
+	return &sip->smk_inode;
+}
+
+/*
+ * allocate a new smack label.
+ */
+static inline smack_t *new_smack_t(smack_t value)
+{
+	smack_t *bp;
+
+	bp = kzalloc(sizeof(smack_t), GFP_KERNEL);
+	if (bp != NULL)
+		*bp = value;
+
+	return bp;
+}
+
+/*
+ * Copy a smack label from the buffer. The smack label may
+ * actually be shorter than size. In any case, null pad
+ * beyond the end.
+ */
+static inline smack_t smk_from_buffer(const void *value, int size)
+{
+	smack_t smack;
+	char *from = (char *)value;
+	char *to = (char *)&smack;
+	int found;
+	int i;
+
+	for (i = 0, found = 0; i < sizeof(smack_t); i++, to++) {
+		if (found)
+			*to = '\0';
+		else if (i >= size || *from > '~' || *from <= ' ') {
+			*to = '\0';
+			found = 1;
+		}
+		else
+			*to = *from++;
+	}
+	return smack;
+}
+
+#endif  /* _SECURITY_SMACK_H */
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff linux-2.6.22-base/security/smack/smack_lsm.c linux-2.6.22/security/smack/smack_lsm.c
--- linux-2.6.22-base/security/smack/smack_lsm.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/security/smack/smack_lsm.c	2007-07-24 15:02:16.000000000 -0700
@@ -0,0 +1,1989 @@
+/*
+ *  Simplified MAC Kernel (smack) security module
+ *
+ *  This file contains the smack hook function implementations.
+ *
+ *  Author:
+ *	Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *  Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2,
+ *      as published by the Free Software Foundation.
+ */
+
+#include <linux/xattr.h>
+#include <linux/pagemap.h>
+#include <linux/mount.h>
+#include <linux/stat.h>
+#include <linux/ext2_fs.h>
+#include <linux/kd.h>
+#include <asm/ioctls.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/mutex.h>
+#include <net/netlabel.h>
+#include <net/cipso_ipv4.h>
+
+#include "smack.h"
+
+/*
+ * I hope these are the hokeyist lines of code in the module. Casey.
+ */
+#define DEVPTS_SUPER_MAGIC	0x1cd1
+#define SOCKFS_MAGIC		0x534F434B
+#define PIPEFS_MAGIC		0x50495045
+#define TMPFS_MAGIC		0x01021994
+
+/*
+ * These are maintained in smackfs
+ */
+extern smack_t smack_net_ambient;
+extern int smack_net_nltype;
+extern int smack_cipso_direct;
+extern struct smk_cipso_entry *smack_cipso;
+
+
+/*
+ * Fetch the smack label from a file.
+ */
+static int smk_fetch(struct inode *ip, struct dentry *dp, smack_t *isp)
+{
+	int rc;
+	smack_t smack;
+
+	if (ip->i_op->getxattr == NULL)
+		return -EOPNOTSUPP;
+
+	rc = ip->i_op->getxattr(dp, XATTR_NAME_SMACK, &smack, sizeof(smack_t));
+	if (rc > 0)
+		*isp = smk_from_buffer(&smack, rc);
+
+	return rc;
+}
+
+static smack_t *free_smack_t(smack_t *sp)
+{
+	kfree(sp);
+        return NULL;
+}
+
+struct inode_smack *new_inode_smack(smack_t smack)
+{
+	struct inode_smack *isp;
+
+        isp = kzalloc(sizeof(struct inode_smack), GFP_KERNEL);
+        if (isp == NULL)
+                return NULL;
+
+	isp->smk_inode = smack;
+	isp->smk_flags = 0;
+	mutex_init(&isp->smk_lock);
+
+	return isp;
+}
+
+/*
+ * LSM hooks.
+ * We he, that is fun!
+ */
+static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp)
+{
+	smack_t *psp = smk_of_task(ptp);
+	smack_t *csp = smk_of_task(ctp);
+	int rc;
+
+	rc = cap_ptrace(ptp, ctp);
+	if (rc != 0)
+		return rc;
+
+	rc = smk_access(psp, csp, MAY_READWRITE);
+	if (rc != 0 && __capable(ptp, CAP_MAC_OVERRIDE))
+		return 0;
+
+	return rc;
+}
+
+static int smack_syslog(int type)
+{
+	int rc;
+	smack_t *sp = smk_of_task(current);
+
+	rc = cap_syslog(type);
+	if (rc == 0)
+		 if (*sp != SMK_FLOOR)
+			rc = -EACCES;
+
+	return rc;
+}
+
+static int smack_task_alloc_security(struct task_struct *tsk)
+{
+	struct task_smack *tsp;
+	struct task_smack *ctsp = current->security;
+
+	tsp = kzalloc(sizeof(struct task_smack), GFP_KERNEL);
+	if (tsp == NULL)
+		return -ENOMEM;
+
+	*tsp = *ctsp;
+	tsk->security = tsp;
+
+	return 0;
+}
+
+static void smack_task_free_security(struct task_struct *task)
+{
+	kfree(task->security);
+	task->security = NULL;
+}
+
+static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_setnice(struct task_struct *p, int nice)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_setioprio(struct task_struct *p, int ioprio)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_getioprio(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_READ);
+	return rc;
+}
+
+static int smack_task_setscheduler(struct task_struct *p, int policy,
+				   struct sched_param *lp)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_getscheduler(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_READ);
+	return rc;
+}
+
+static int smack_task_movememory(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_kill(struct task_struct *p, struct siginfo *info,
+			   int sig, u32 secid)
+{
+	smack_t *tsp = smk_of_task(p);
+	int rc;
+
+	/*
+	 * Sending a signal requires that the sender
+	 * can write the receiver.
+	 */
+	rc = smk_curacc(tsp, MAY_WRITE);
+
+	return rc;
+}
+
+/*
+ * Superblock Hooks.
+ */
+static int smack_sb_alloc_security(struct super_block *sb)
+{
+	struct superblock_smack *sbsp;
+
+	sbsp = kzalloc(sizeof(struct superblock_smack), GFP_KERNEL);
+
+	if (sbsp == NULL)
+		return -ENOMEM;
+
+	sbsp->smk_root = SMK_FLOOR;
+	sbsp->smk_default = SMK_FLOOR;
+	sbsp->smk_floor = SMK_FLOOR;
+	sbsp->smk_hat = SMK_HAT;
+	sbsp->smk_initialized = 0;
+
+	sb->s_security = sbsp;
+
+	return 0;
+}
+
+static void smack_sb_free_security(struct super_block *sb)
+{
+	kfree(sb->s_security);
+	sb->s_security = NULL;
+}
+
+static int smack_sb_copy_data(struct file_system_type *type, void *orig,
+			      void *smackopts)
+{
+	char *cp, *commap, *otheropts, *dp;
+
+	/* Binary mount data: just copy */
+	if (type->fs_flags & FS_BINARY_MOUNTDATA) {
+		copy_page(smackopts, orig);
+		return 0;
+	}
+
+	otheropts = (char *)get_zeroed_page(GFP_KERNEL);
+	if (otheropts == NULL)
+		return -ENOMEM;
+
+	for (cp = orig, commap = orig; commap != NULL; cp = commap + 1) {
+		if (strstr(cp, SMK_FSDEFAULT) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSFLOOR) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSHAT) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSROOT) == cp)
+			dp = smackopts;
+		else
+			dp = otheropts;
+
+		commap = strchr(cp, ',');
+		if (commap != NULL)
+			*commap = '\0';
+
+		if (*dp != '\0')
+			strcat(dp, ",");
+		strcat(dp, cp);
+	}
+
+	strcpy(orig, otheropts);
+	free_page((unsigned long)otheropts);
+
+	return 0;
+}
+
+static int smack_sb_kern_mount(struct super_block *sb, void *data)
+{
+	int rc;
+	struct dentry *root = sb->s_root;
+	struct inode *inode = root->d_inode;
+	struct superblock_smack *sp = sb->s_security;
+	struct inode_smack *isp;
+	char *op;
+	char *commap;
+
+	if (sp == NULL) {
+		rc = smack_sb_alloc_security(sb);
+		if (rc != 0)
+			return rc;
+	}
+	if (sp->smk_initialized != 0)
+		return 0;
+	if (inode == NULL)
+		return 0;
+
+	sp->smk_initialized = 1;
+
+	for (op = data; op != NULL; op = commap) {
+		commap = strchr(op, ',');
+		if (commap != NULL)
+			*commap++ = '\0';
+
+		if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
+			op += strlen(SMK_FSHAT);
+			if (strlen(op) <= SMK_MAXLEN)
+				sp->smk_hat = smk_from_string(op);
+		} else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
+			op += strlen(SMK_FSFLOOR);
+			if (strlen(op) <= SMK_MAXLEN)
+				sp->smk_floor = smk_from_string(op);
+		} else if (strncmp(op,SMK_FSDEFAULT,strlen(SMK_FSDEFAULT))==0) {
+			op += strlen(SMK_FSDEFAULT);
+			if (strlen(op) <= SMK_MAXLEN)
+				sp->smk_default = smk_from_string(op);
+		} else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
+			op += strlen(SMK_FSROOT);
+			if (strlen(op) <= SMK_MAXLEN)
+				sp->smk_root = smk_from_string(op);
+		}
+	}
+
+	/*
+	 * Initialize the root inode.
+	 */
+	isp = inode->i_security;
+	if (isp == NULL)
+		inode->i_security = new_inode_smack(sp->smk_root);
+	else
+		isp->smk_inode = sp->smk_root;
+
+	return 0;
+}
+
+static int smack_sb_statfs(struct dentry *dentry)
+{
+	struct superblock_smack *sbp;
+
+	if (dentry == NULL || dentry->d_sb == NULL ||
+	    dentry->d_sb->s_security == NULL)
+		return 0;
+
+	sbp = dentry->d_sb->s_security;
+
+	return smk_curacc(&sbp->smk_floor, MAY_READ);
+}
+
+static int smack_sb_mount(char *dev_name, struct nameidata *nd,
+        char *type, unsigned long flags, void *data)
+{
+	struct superblock_smack *sbp;
+	int rc;
+
+	if (nd == NULL || nd->mnt == NULL || nd->mnt->mnt_sb == NULL ||
+	    nd->mnt->mnt_sb->s_security == NULL)
+		return 0;
+
+	sbp = nd->mnt->mnt_sb->s_security;
+
+	rc = smk_curacc(&sbp->smk_floor, MAY_WRITE);
+	return rc;
+}
+
+static int smack_sb_umount(struct vfsmount *mnt, int flags)
+{
+	struct superblock_smack *sbp;
+	int rc;
+
+	sbp = mnt->mnt_sb->s_security;
+
+	rc = smk_curacc(&sbp->smk_floor, MAY_WRITE);
+	return rc;
+}
+
+/*
+ * Inode hooks
+ */
+static int smack_inode_alloc_security(struct inode *inode)
+{
+	smack_t *csp = smk_of_task(current);
+
+        inode->i_security = new_inode_smack(*csp);
+        if (inode->i_security == NULL)
+                return -ENOMEM;
+	return 0;
+}
+
+static void smack_inode_free_security(struct inode *inode)
+{
+	kfree(inode->i_security);
+	inode->i_security = NULL;
+}
+
+static int smack_inode_init_security(struct inode *inode, struct inode *dir,
+                               char **name, void **value, size_t *len)
+{
+	smack_t *isp = smk_of_inode(inode);
+
+	if (name && (*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_KERNEL)) == NULL)
+		return -ENOMEM;
+
+	if (value && (*value = kstrdup((char *)isp, GFP_KERNEL)) == NULL)
+		return -ENOMEM;
+
+	if (len)
+		*len = strlen((char *)isp) + 1;
+
+	return 0;
+}
+
+static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
+			    struct dentry *new_dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_symlink(struct inode *dir, struct dentry *dentry,
+			       const char *name)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_mknod(struct inode *dir, struct dentry *dentry,
+			     int mode, dev_t dev)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_rename(struct inode *old_inode,
+			      struct dentry *old_dentry,
+			      struct inode *new_inode,
+			      struct dentry *new_dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(old_inode), MAY_READWRITE);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(new_inode), MAY_READWRITE);
+	return rc;
+}
+
+static int smack_inode_readlink(struct dentry *dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return rc;
+}
+
+static int smack_inode_follow_link(struct dentry *dentry,
+				   struct nameidata *nameidata)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return rc;
+}
+
+static int smack_inode_permission(struct inode *inode, int mask,
+				  struct nameidata *nd)
+{
+	int rc;
+
+	/*
+	 * No permission to check. Existence test. Yup, it's there.
+	 */
+	if (mask == 0)
+		return 0;
+
+	rc = smk_curacc(smk_of_inode(inode), mask);
+	return rc;
+}
+
+static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
+{
+	int rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+
+	return rc;
+}
+
+static int smack_inode_setxattr(struct dentry *dentry, char *name,
+			        void *value, size_t size, int flags)
+{
+	int rc;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
+		!__capable(current, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	rc = cap_inode_setxattr(dentry, name, value, size, flags);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+
+	return rc;
+}
+
+static void smack_inode_post_setxattr(struct dentry *dentry, char *name,
+				      void *value, size_t size, int flags)
+{
+	int i;
+	smack_t *vsp;
+	smack_t *isp;
+	char *nuller;
+
+	/*
+	 * Not SMACK
+	 */
+	if (strcmp(name, XATTR_NAME_SMACK))
+		return;
+
+	if (size >= sizeof(smack_t))
+		return;
+
+	vsp = (smack_t *)value;
+	isp = smk_of_inode(dentry->d_inode);
+	nuller = (char *)isp;
+
+	*isp = *vsp;
+
+	for (i = size; i < sizeof(smack_t); i++)
+		nuller[i] = '\0';
+
+	return;
+}
+
+static int smack_inode_getxattr(struct dentry *dentry, char *name)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return rc;
+}
+
+static int smack_inode_listxattr(struct dentry *dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return rc;
+}
+
+static int smack_inode_removexattr(struct dentry *dentry, char *name)
+{
+	int rc;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
+		!__capable(current, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	rc = cap_inode_removexattr(dentry, name);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+
+	return rc;
+}
+
+static const char *smack_inode_xattr_getsuffix(void)
+{
+	return XATTR_SMACK_SUFFIX;
+}
+
+static int smack_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
+{
+	struct socket_smack *ssp;
+	struct socket *sock;
+	struct super_block *sbp;
+	struct inode *ip = (struct inode *)inode;
+	smack_t *bsp = buffer;
+	smack_t *isp;
+
+	if (size < sizeof(smack_t) || name == NULL || bsp == NULL ||
+	    inode == NULL || inode->i_security == NULL)
+		return 0;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		isp = smk_of_inode(inode);
+		*bsp = *isp;
+		return strlen((char *)isp) + 1;
+	}
+
+	/*
+	 * The rest of the Smack xattrs are only on sockets.
+	 */
+	sbp = ip->i_sb;
+	if (sbp->s_magic != SOCKFS_MAGIC)
+		return -EOPNOTSUPP;
+
+	sock = SOCKET_I(ip);
+	if (sock == NULL)
+		return -EOPNOTSUPP;
+
+	ssp = sock->sk->sk_security;
+
+	if (strcmp(name, XATTR_SMACK_PACKET) == 0)
+		*bsp = ssp->smk_packet;
+	else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		*bsp = ssp->smk_in;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
+		*bsp = ssp->smk_out;
+	else
+		return -EOPNOTSUPP;
+
+	return strlen((char *)bsp) + 1;
+}
+
+static int smack_inode_setsecurity(struct inode *inode, const char *name,
+				   const void *value, size_t size, int flags)
+{
+	smack_t smack;
+	smack_t *isp = smk_of_inode(inode);
+	struct socket_smack *ssp;
+	struct socket *sock;
+	struct super_block *sbp;
+	struct inode *ip = (struct inode *)inode;
+
+	if (value == NULL || size > sizeof(smack_t))
+		return -EACCES;
+
+	smack = smk_from_buffer(value, size);
+	if (smack == SMK_INVALID)
+		return -EINVAL;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		*isp = smack;
+		return 0;
+	}
+	/*
+	 * The rest of the Smack xattrs are only on sockets.
+	 */
+	sbp = ip->i_sb;
+	if (sbp->s_magic != SOCKFS_MAGIC)
+		return -EOPNOTSUPP;
+
+	sock = SOCKET_I(ip);
+	if (sock == NULL)
+		return -EOPNOTSUPP;
+
+	ssp = sock->sk->sk_security;
+
+	if (strcmp(name, XATTR_SMACK_PACKET) == 0)
+		ssp->smk_packet = smack;
+	else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		ssp->smk_in = smack;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
+		ssp->smk_out = smack;
+	else
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static int smack_inode_listsecurity(struct inode *inode, char *buffer,
+				    size_t buffer_size)
+{
+	int len = strlen(XATTR_NAME_SMACK);
+
+	if (buffer != NULL && len <= buffer_size) {
+		memcpy(buffer, XATTR_NAME_SMACK, len);
+		return len;
+	}
+	return -EINVAL;
+}
+
+static void smack_d_instantiate (struct dentry *opt_dentry, struct inode *inode)
+{
+	struct super_block *sbp;
+	struct superblock_smack *sbsp;
+	struct inode_smack *isp;
+	smack_t *csp = smk_of_task(current);
+	smack_t sbs;
+	smack_t final = SMK_UNSET;
+	struct dentry *dp;
+	int rc;
+
+	if (inode == NULL)
+		return;
+
+	if (inode->i_security == NULL)
+		inode->i_security = new_inode_smack(SMK_UNSET);
+
+	isp = inode->i_security;
+
+	mutex_lock(&isp->smk_lock);
+	/*
+	 * If the inode is already instantiated
+	 * take the quick way out
+	 */
+	if (isp->smk_flags & SMK_INODE_INSTANT)
+		goto unlockandout;
+
+	sbp = inode->i_sb;
+	sbsp = sbp->s_security;
+	/*
+	 * We're going to use the superblock default label
+	 * if there's no label on the file.
+	 */
+	sbs = sbsp->smk_default;
+
+	/*
+	 * This is pretty hackish.
+	 * Casey says that we shouldn't have to do
+	 * file system specific code, but it does help
+	 * with keeping it simple.
+	 */
+	switch (sbp->s_magic) {
+	case SMACK_MAGIC:
+		/*
+		 * Casey says that it's a little embarassing
+		 * that the smack file system doesn't do
+		 * extended attributes.
+		 */
+		final = SMK_STAR;
+		break;
+	case PIPEFS_MAGIC:
+		/*
+		 * Casey says pipes are easy (?)
+		 */
+		final = SMK_STAR;
+		break;
+	case DEVPTS_SUPER_MAGIC:
+		/*
+		 * devpts seems content with the label of the task.
+		 * Programs that change smack have to treat the
+		 * pty with respect.
+		 */
+		final = *csp;
+		break;
+	case SOCKFS_MAGIC:
+		/*
+		 * Casey says sockets get the smack of the task.
+		 */
+		final = *csp;
+		break;
+	case PROC_SUPER_MAGIC:
+		/*
+		 * Casey says procfs appears not to care.
+		 */
+		final = sbs;
+		break;
+	case TMPFS_MAGIC:
+		/*
+		 * Device labels should come from the filesystem,
+		 * but watch out, because they're volitile,
+		 * getting recreated on every reboot.
+		 */
+		sbs = SMK_STAR;
+		/*
+		 * No break.
+		 *
+		 * If a smack value has been set we want to use it,
+		 * but since tmpfs isn't giving us the opportunity
+		 * to set mount options simulate setting the
+		 * superblock default.
+		 */
+	default:
+		/*
+		 * This isn't an understood special case.
+		 * Get the value from the xattr.
+		 *
+		 * No xattr support means, alas, no SMACK label.
+		 * Use the aforeapplied default.
+		 * It would be curious if the label of the task
+		 * does not match that assigned.
+		 */
+		if (inode->i_op->getxattr == NULL) {
+			final = sbs;
+			break;
+		}
+		/*
+		 * Get the dentry for xattr.
+		 */
+		if (opt_dentry == NULL) {
+			dp = d_find_alias(inode);
+			if (dp == NULL) {
+				final = sbs;
+				break;
+			}
+		} else {
+			dp = dget(opt_dentry);
+			if (dp == NULL) {
+				final = sbs;
+				break;
+			}
+		}
+		
+		rc = smk_fetch(inode, dp, &final);
+		if (rc < 0)
+			final = sbs;
+
+		dput(dp);
+		break;
+	}
+
+	if (final == SMK_UNSET) {
+		printk("%s:%d unset? Investigate!\n", __FUNCTION__, __LINE__);
+		final = *csp;
+	}
+	isp->smk_inode = final;
+	isp->smk_flags |= SMK_INODE_INSTANT;
+
+unlockandout:
+	mutex_unlock(&isp->smk_lock);
+	return;
+}
+
+/*
+ * File Hooks
+ */
+
+static int smack_file_alloc_security(struct file *file)
+{
+	smack_t *csp = smk_of_task(current);
+
+	file->f_security = new_smack_t(*csp);
+	if (file->f_security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_file_free_security(struct file *file)
+{
+	file->f_security = free_smack_t(file->f_security);
+}
+
+/*
+ * Should access checks be done on each read or write?
+ * UNICOS and SELinux say yes.
+ * Trusted Solaris, Trusted Irix, and just about everyone else says no.
+ *
+ * I'll say no for now. Smack does not do the frequent
+ * label changing that SELinux does.
+ */
+static int smack_file_permission(struct file *file, int mask)
+{
+	return 0;
+}
+
+static int smack_file_ioctl(struct file *file, unsigned int cmd,
+                            unsigned long arg)
+{
+	int rc = 0;
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE)
+		rc = smk_curacc(file->f_security, MAY_WRITE);
+
+	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
+		rc = smk_curacc(file->f_security, MAY_READ);
+
+	return rc;
+}
+
+static int smack_file_lock(struct file *file, unsigned int cmd)
+{
+	int rc;
+
+	rc = smk_curacc(file->f_security, MAY_WRITE);
+	return rc;
+}
+
+static int smack_file_fcntl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	int rc;
+
+	switch (cmd) {
+	case F_DUPFD:
+	case F_GETFD:
+	case F_GETFL:
+	case F_GETLK:
+	case F_GETOWN:
+	case F_GETSIG:
+		rc = smk_curacc(file->f_security, MAY_READ);
+		break;
+	case F_SETFD:
+	case F_SETFL:
+	case F_SETLK:
+	case F_SETLKW:
+	case F_SETOWN:
+	case F_SETSIG:
+		rc = smk_curacc(file->f_security, MAY_WRITE);
+		break;
+	default:
+		rc = smk_curacc(file->f_security, MAY_READWRITE);
+	}
+
+	return rc;
+}
+
+static int smack_file_send_sigiotask(struct task_struct *tsk,
+                                     struct fown_struct *fown, int signum)
+{
+	struct file *file;
+	int rc;
+
+	/*
+	 * struct fown_struct is never outside the context of a struct file
+	 */
+	file = (struct file *)((long)fown - offsetof(struct file,f_owner));
+	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
+	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
+		return 0;
+	return rc;
+}
+
+static inline int file_may(struct file *file)
+{
+	if (file->f_mode & FMODE_READ)
+		return (file->f_mode & FMODE_WRITE) ? MAY_READWRITE : MAY_READ;
+
+	return (file->f_mode & FMODE_WRITE) ? MAY_WRITE : 0;
+}
+
+static int smack_file_receive(struct file *file)
+{
+	int may = 0;
+	int rc;
+
+	/*
+	 * This code relies on bitmasks.
+	 */
+	if (file->f_mode & FMODE_READ)
+		may = MAY_READ;
+	if (file->f_mode & FMODE_WRITE)
+		may |= MAY_WRITE;
+
+	rc = smk_curacc(file->f_security, may);
+	return rc;
+}
+
+/*
+ * Socket hooks.
+ */
+
+/*
+ * Initialize the socket blob from the associated task.
+ */
+static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t priority)
+{
+	smack_t *csp = smk_of_task(current);
+	struct socket_smack *ssp;
+
+	ssp = kzalloc(sizeof(struct socket_smack), priority);
+	if (ssp == NULL)
+		return -ENOMEM;
+
+	ssp->smk_in = *csp;
+	ssp->smk_out = *csp;
+	ssp->smk_packet = SMK_INVALID;
+
+	sk->sk_security = ssp;
+
+	return 0;
+}
+
+/*
+ * Free the blob.
+ */
+static void smack_sk_free_security(struct sock *sk)
+{
+	kfree(sk->sk_security);
+	sk->sk_security = NULL;
+}
+
+static void smack_set_catset(smack_t catset, struct netlbl_lsm_secattr *sap)
+{
+	unsigned char *cp;
+	unsigned char m;
+	int cat;
+	int rc;
+
+	if (catset == 0LL)
+		return;
+
+	sap->flags |= NETLBL_SECATTR_MLS_CAT;
+	sap->mls_cat = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
+	sap->mls_cat->startbit = 0;
+
+	for (cat = 1, cp = (unsigned char *)&catset; *cp != 0; cp++)
+		for (m = 0x80; m != 0; m >>= 1, cat++) {
+			if ((m & *cp) == 0)
+				continue;
+			rc = netlbl_secattr_catmap_setbit(sap->mls_cat, cat,
+							  GFP_ATOMIC);
+		}
+}
+
+/*
+ * Casey says that CIPSO is good enough for now.
+ * It can be used to effect.
+ * It can also be abused to effect when necessary.
+ * Appologies to the TSIG group in general and GW in particular.
+ */
+static void smack_to_secattr(smack_t smack, struct netlbl_lsm_secattr *nlsp)
+{
+	struct smk_cipso_entry *scp;
+
+	switch (smack_net_nltype) {
+	case NETLBL_NLTYPE_CIPSOV4:
+		nlsp->domain = NULL;
+		nlsp->flags = NETLBL_SECATTR_DOMAIN;
+		nlsp->flags |= NETLBL_SECATTR_MLS_LVL;
+
+		for (scp = smack_cipso; scp != NULL; scp = scp->smk_next)
+			if (scp->smk_smack == smack)
+				break;
+
+		if (scp != NULL) {
+			nlsp->mls_lvl = scp->smk_level;
+			smack_set_catset(scp->smk_catset, nlsp);
+		} else {
+			nlsp->mls_lvl = smack_cipso_direct;
+			smack_set_catset(smack, nlsp);
+		}
+		break;
+	case NETLBL_NLTYPE_NONE:
+	case NETLBL_NLTYPE_UNLABELED:
+		break;
+	default:
+		break;
+	}
+}
+
+static int smack_netlabel(struct sock *sk)
+{
+	struct socket_smack *ssp = sk->sk_security;
+	struct netlbl_lsm_secattr secattr;
+	int rc;
+
+	netlbl_secattr_init(&secattr);
+	smack_to_secattr(ssp->smk_out, &secattr);
+	if (secattr.flags != NETLBL_SECATTR_NONE)
+		rc = netlbl_sock_setattr(sk, &secattr);
+	else
+		rc = -EINVAL;
+
+	netlbl_secattr_destroy(&secattr);
+	return rc;
+}
+
+static int smack_socket_post_create(struct socket *sock, int family,
+				    int type, int protocol, int kern)
+{
+	struct inode_smack *isp;
+	smack_t *csp;
+	int rc = 0;
+
+	isp = SOCK_INODE(sock)->i_security;
+
+	if (isp == NULL) {
+		if (kern)
+			isp = new_inode_smack(SMK_FLOOR);
+		else {
+			csp = smk_of_task(current);
+			isp = new_inode_smack(*csp);
+		}
+		SOCK_INODE(sock)->i_security = isp;
+	}
+
+	if (family != PF_INET)
+		return 0;
+
+	/*
+	 * Set the outbound netlbl.
+	 */
+	rc = smack_netlabel(sock->sk);
+
+	return rc;
+}
+
+static int smack_inode_create(struct inode *dir, struct dentry *dentry,
+			      int mode)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *ip = dentry->d_inode;
+	int rc;
+
+	/*
+	 * You need write access to the thing you're unlinking
+	 */
+	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
+	if (rc == 0)
+		/*
+		 * You also need write access to the containing directory
+		 */
+		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+
+	return rc;
+}
+
+static int smack_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *ip = dentry->d_inode;
+	int rc;
+
+	/*
+	 * You need write access to the thing you're removing
+	 */
+	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
+	if (rc == 0)
+		/*
+		 * You also need write access to the containing directory
+		 */
+		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+
+	return rc;
+}
+
+static int smack_file_set_fowner(struct file *file)
+{
+	smack_t *fsp = file->f_security;
+	smack_t *csp = smk_of_task(current);
+
+	*fsp = *csp;
+
+	return 0;
+}
+
+static int smack_task_getpgid(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_READ);
+	return rc;
+}
+
+static int smack_task_getsid(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_READ);
+	return rc;
+}
+
+static void smack_task_getsecid(struct task_struct *p, u32 *secid)
+{
+	/*
+	 * This is supposed to be called once, at boot,
+	 * by the netlabel system.
+	 */
+	*secid = SMK32_FLOOR;
+}
+
+static int smack_flags_to_may(int flags)
+{
+	int may = 0;
+
+	if (flags & S_IRUGO)
+		may |= MAY_READ;
+	if (flags & S_IWUGO)
+		may |= MAY_WRITE;
+	if (flags & S_IXUGO)
+		may |= MAY_EXEC;
+
+	return may;
+}
+
+static int smack_msg_msg_alloc_security(struct msg_msg *msg)
+{
+	smack_t *csp = smk_of_task(current);
+
+	msg->security = new_smack_t(*csp);
+	if (msg->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_msg_msg_free_security(struct msg_msg *msg)
+{
+	msg->security = free_smack_t(msg->security);
+}
+
+
+static smack_t *smack_of_shm(struct shmid_kernel *shp)
+{
+	if (shp == NULL)
+		return NULL;
+
+	return (smack_t *)shp->shm_perm.security;
+}
+
+static int smack_shm_alloc_security(struct shmid_kernel *shp)
+{
+	smack_t *csp = smk_of_task(current);
+	struct kern_ipc_perm *isp = &shp->shm_perm;
+
+	isp->security = new_smack_t(*csp);
+	if (isp->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_shm_free_security(struct shmid_kernel *shp)
+{
+	struct kern_ipc_perm *isp = &shp->shm_perm;
+
+	isp->security = free_smack_t(isp->security);
+}
+
+static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
+{
+	smack_t *ssp = smack_of_shm(shp);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(shmflg);
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
+{
+	smack_t *ssp = smack_of_shm(shp);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case IPC_STAT:
+	case SHM_STAT:
+		rc = MAY_READ;
+		break;
+	case IPC_SET:
+	case SHM_LOCK:
+	case SHM_UNLOCK:
+	case IPC_RMID:
+		rc = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case SHM_INFO:
+		/*
+		 * System level information.
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg)
+{
+	smack_t *ssp = smack_of_shm(shp);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(shmflg);
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static smack_t *smack_of_sem(struct sem_array *sma)
+{
+	if (sma == NULL)
+		return NULL;
+
+	return (smack_t *)sma->sem_perm.security;
+}
+
+static int smack_sem_alloc_security(struct sem_array *sma)
+{
+	smack_t *csp = smk_of_task(current);
+	struct kern_ipc_perm *isp = &sma->sem_perm;
+
+	isp->security = new_smack_t(*csp);
+	if (isp->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_sem_free_security(struct sem_array *sma)
+{
+	struct kern_ipc_perm *isp = &sma->sem_perm;
+
+	isp->security = free_smack_t(isp->security);
+}
+
+
+static int smack_sem_associate(struct sem_array *sma, int semflg)
+{
+	smack_t *ssp = smack_of_sem(sma);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(semflg);
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static int smack_sem_semctl(struct sem_array *sma, int cmd)
+{
+	smack_t *ssp = smack_of_sem(sma);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case GETPID:
+	case GETNCNT:
+	case GETZCNT:
+	case GETVAL:
+	case GETALL:
+	case IPC_STAT:
+	case SEM_STAT:
+		rc = MAY_READ;
+		break;
+	case SETVAL:
+	case SETALL:
+	case IPC_RMID:
+	case IPC_SET:
+		rc = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case SEM_INFO:
+		/*
+		 * System level information
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops, unsigned nsops, int alter)
+{
+	smack_t *ssp = smack_of_sem(sma);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	rc = smk_curacc(ssp, MAY_READWRITE);
+	return rc;
+}
+
+static int smack_msg_queue_alloc_security(struct msg_queue *msq)
+{
+	smack_t *csp = smk_of_task(current);
+	struct kern_ipc_perm *kisp = &msq->q_perm;
+
+	kisp->security = new_smack_t(*csp);
+	if (kisp->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_msg_queue_free_security(struct msg_queue *msq)
+{
+	struct kern_ipc_perm *kisp = &msq->q_perm;
+
+	kisp->security = free_smack_t(kisp->security);
+}
+
+static smack_t *smack_of_msq(struct msg_queue *msq)
+{
+	if (msq == NULL)
+		return NULL;
+
+	return (smack_t *)msq->q_perm.security;
+}
+
+static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
+{
+	smack_t *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(msqflg);
+	rc = smk_curacc(msp, rc);
+	return rc;
+}
+
+static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
+{
+	smack_t *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case IPC_STAT:
+	case MSG_STAT:
+		rc = MAY_READ;
+		break;
+	case IPC_SET:
+	case IPC_RMID:
+		rc = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case MSG_INFO:
+		/*
+		 * System level information
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	rc = smk_curacc(msp, rc);
+	return rc;
+}
+
+static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg, int msqflg)
+{
+	smack_t *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(msqflg);
+	rc = smk_curacc(msp, rc);
+	return rc;
+}
+
+static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg, struct task_struct *target, long type, int mode)
+{
+	smack_t *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	rc = smk_curacc(msp, MAY_READWRITE);
+	return rc;
+}
+
+static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
+{
+	smack_t *isp = ipp->security;
+	int rc;
+
+	rc = smack_flags_to_may(flag);
+	rc = smk_curacc(isp, rc);
+
+	return rc;
+}
+
+static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
+{
+	smack_t *tsp = smk_of_task(p);
+	smack_t *isp = smk_of_inode(inode);
+
+	*isp = *tsp;
+}
+
+static int smack_task_wait(struct task_struct *p)
+{
+	smack_t *tsp = smk_of_task(p);
+	smack_t *csp = smk_of_task(current);
+	int rc;
+
+	rc = smk_access(csp, tsp, MAY_WRITE);
+	if (rc == 0)
+		return 0;
+
+	/*
+	 * Allow the operation to succeed if either task
+	 * has privilege to perform operations that might
+	 * account for the smack labels having gotten to
+	 * be different in the first place.
+	 *
+	 * This breaks the strict subjet/object access
+	 * control ideal, taking the object's privilege
+	 * state into account in the decision as well as
+	 * the smack value.
+	 */
+	if (__capable(current, CAP_MAC_OVERRIDE) ||
+		__capable(p, CAP_MAC_OVERRIDE))
+		return 0;
+	
+	return rc;
+}
+
+static int smack_getprocattr(struct task_struct *p, char *name, char **value)
+{
+	smack_t *sp = smk_of_task(p);
+	int slen = strlen((char *)sp);
+
+	if (strcmp(name, "current") == 0) {
+		*value = (char *)new_smack_t(*sp);
+		return slen;
+	}
+
+	return -EINVAL;
+}
+
+static int smack_setprocattr(struct task_struct *p, char *name,
+			     void *value, size_t size)
+{
+	smack_t *psp = smk_of_task(p);
+	smack_t newsmack = 0LL;
+
+	if (!__capable(p, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (value == NULL || size == 0 || size >= sizeof(smack_t))
+		return -EINVAL;
+
+	if (strcmp(name, "current") == 0) {
+		newsmack = smk_from_buffer(value, size);
+		if (newsmack == SMK_INVALID)
+			return -EINVAL;
+		*psp = newsmack;
+		return size;
+	}
+	return -EINVAL;
+}
+
+static int smack_unix_stream_connect(struct socket *sock,
+				     struct socket *other, struct sock *newsk)
+{
+	struct inode *sp = SOCK_INODE(sock);
+	struct inode *op = SOCK_INODE(other);
+	int rc;
+
+	rc = smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_READWRITE);
+	return rc;
+}
+
+static int smack_unix_may_send(struct socket *sock, struct socket *other)
+{
+	struct inode *sp = SOCK_INODE(sock);
+	struct inode *op = SOCK_INODE(other);
+	int rc;
+
+	rc = smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_WRITE);
+	return rc;
+}
+
+/*
+ * Convert a netlabel mls_lvl/mls_cat pair into a smack value.
+ */
+
+static smack_t smack_from_secattr(struct netlbl_lsm_secattr *sap)
+{
+	struct smk_cipso_entry *scp;
+	smack_t smack = 0LL;
+	int pcat;
+
+	if ((sap->flags & NETLBL_SECATTR_MLS_LVL) == 0) {
+		/*
+		 * If there are flags but no level netlabel isn't
+		 * behaving the way we expect it to.
+		 *
+		 * Without guidance regarding the smack value
+		 * for the packet fall back on the network
+		 * ambient value.
+		 */
+		return smack_net_ambient;
+	}
+	/*
+	 * Get the categories, if any
+	 */
+	if ((sap->flags & NETLBL_SECATTR_MLS_CAT) != 0)
+		for (pcat = -1;;) {
+			pcat = netlbl_secattr_catmap_walk(sap->mls_cat, pcat+1);
+			if (pcat < 0)
+				break;
+			smack_catset_bit(pcat, &smack);
+		}
+	/*
+	 * If it is CIPSO using smack direct mapping
+	 * we are already done. WeeHee.
+	 */
+	if (sap->mls_lvl == smack_cipso_direct)
+		return smack;
+
+	/*
+	 * Look it up in the supplied table if it is not a direct mapping.
+	 */
+	for (scp = smack_cipso; scp != NULL; scp = scp->smk_next)
+		if (scp->smk_level == sap->mls_lvl && scp->smk_catset == smack)
+			return scp->smk_smack;
+	/*
+	 * It is CIPSO, but not one we know.
+	 */
+
+	return SMK_HUH;
+}
+
+static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	struct netlbl_lsm_secattr secattr;
+	struct socket_smack *ssp = sk->sk_security;
+	smack_t si;
+	int rc;
+
+	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
+		return 0;
+
+	/*
+	 * Translate what netlabel gave us.
+	 */
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_skbuff_getattr(skb, &secattr);
+	if (rc == 0)
+		si = smack_from_secattr(&secattr);
+	else
+		si = smack_net_ambient;
+	netlbl_secattr_destroy(&secattr);
+	/*
+	 * Receiving a packet requires that the other end
+	 * be able to write here. Read access is not required.
+	 * This is the simplist possible security model
+	 * for networking.
+	 */
+	rc = smk_access(&si, &ssp->smk_in, MAY_WRITE);
+
+	/*
+	 * Set the receive packet on success.
+	 */
+	if (rc == 0)
+		ssp->smk_packet = si;
+
+	return rc;
+}
+
+static void smack_sock_graft(struct sock *sk, struct socket *parent)
+{
+	struct socket_smack *ssp;
+	struct netlbl_lsm_secattr secattr;
+	smack_t ssi;
+	int rc;
+
+	if (sk == NULL || parent == NULL || parent->sk == NULL)
+		return;
+
+	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
+		return;
+
+	ssp = parent->sk->sk_security;
+
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_sock_getattr(sk, &secattr);
+	if (rc == 0)
+		ssi = smack_from_secattr(&secattr);
+	else
+		ssi = SMK_HUH;
+	netlbl_secattr_destroy(&secattr);
+
+	netlbl_secattr_init(&secattr);
+
+	smack_to_secattr(ssi, &secattr);
+	if (secattr.flags != NETLBL_SECATTR_NONE)
+		rc = netlbl_sock_setattr(parent->sk, &secattr);
+	netlbl_secattr_destroy(&secattr);
+}
+
+static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
+				   struct request_sock *req)
+{
+	struct netlbl_lsm_secattr skb_secattr;
+	struct socket_smack *ssp = sk->sk_security;
+	smack_t sb;
+	int rc;
+	
+	if (skb == NULL)
+		return -EACCES;
+
+	netlbl_secattr_init(&skb_secattr);
+	rc = netlbl_skbuff_getattr(skb, &skb_secattr);
+	if (rc == 0)
+		sb = smack_from_secattr(&skb_secattr);
+	else
+		sb = SMK_HUH;
+	netlbl_secattr_destroy(&skb_secattr);
+	/*
+	 * Receiving a packet requires that the other end
+	 * be able to write here. Read access is not required.
+	 */
+	rc = smk_access(&sb, &ssp->smk_in, MAY_WRITE);
+	return rc;
+}
+
+/*
+ * Key management security hooks
+ *
+ * Casey has not tested key support very heavily.
+ * The permission check is most likely too restrictive.
+ * If you care about keys please have a look.
+ */
+#ifdef CONFIG_KEYS
+static int smack_key_alloc(struct key *key, struct task_struct *tsk,
+			   unsigned long flags)
+{
+	key->security = new_smack_t(smack_of_task(tsk));
+	if (key->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_key_free(struct key *key)
+{
+	key->security = free_smack_t(key->security);
+}
+
+/*
+ * Casey says that until he understands the key permissions
+ * better the task is only going to have access to the key
+ * if it has read and write access.
+ */
+static int smack_key_permission(key_ref_t key_ref,
+			        struct task_struct *context, key_perm_t perm)
+{
+	struct key *keyp;
+	smack_t *ksp;
+	smack_t *tsp;
+	int rc;
+
+	keyp = key_ref_to_ptr(key_ref);
+	if (keyp == NULL)
+		return -EINVAL;
+
+	ksp = keyp->security;
+	tsp = smk_of_task(context);
+
+	rc = smk_access(tsp, ksp, MAY_READWRITE);
+
+	return rc;
+}
+#endif /* CONFIG_KEYS */
+
+static struct security_operations smack_ops = {
+	.ptrace = 			smack_ptrace,
+	.capget = 			cap_capget,
+	.capset_check = 		cap_capset_check,
+	.capset_set = 			cap_capset_set,
+	.capable = 			cap_capable,
+	/* .acct			No hook required */
+	/* .sysctl			No hook required */
+	/* .quotactl			No hook required */
+	/* .quota_on			No hook required */
+	.syslog = 			smack_syslog,
+	.settime = 			cap_settime,
+	.vm_enough_memory = 		cap_vm_enough_memory,
+
+	/* .bprm_alloc_security		No hook required */
+	/* .bprm_free_security		No hook required */
+	.bprm_apply_creds = 		cap_bprm_apply_creds,
+	/* .bprm_post_apply_creds	No hook required */
+	.bprm_set_security = 		cap_bprm_set_security,
+	/* .bprm_check_security		No hook required */
+	.bprm_secureexec = 		cap_bprm_secureexec,
+
+	.sb_alloc_security = 		smack_sb_alloc_security,
+	.sb_free_security = 		smack_sb_free_security,
+	.sb_copy_data = 		smack_sb_copy_data,
+	.sb_kern_mount = 		smack_sb_kern_mount,
+	.sb_statfs = 			smack_sb_statfs,
+	.sb_mount = 			smack_sb_mount,
+	/* .sb_check_sb			No hook required */
+	.sb_umount = 			smack_sb_umount,
+	/* .sb_umount_close		No hook required */
+	/* .sb_umount_busy		No hook required */
+	/* .sb_post_remount		No hook required */
+	/* .sb_post_mountroot		No hook required */
+	/* .sb_post_addmount		No hook required */
+	/* .sb_pivotroot		No hook required */
+	/* .sb_post_pivotroot		No hook required */
+
+	.inode_alloc_security = 	smack_inode_alloc_security,
+	.inode_free_security = 		smack_inode_free_security,
+	.inode_init_security = 		smack_inode_init_security,
+	.inode_create = 		smack_inode_create,
+	.inode_link = 			smack_inode_link,
+	.inode_unlink = 		smack_inode_unlink,
+	.inode_symlink = 		smack_inode_symlink,
+	.inode_mkdir = 			smack_inode_mkdir,
+	.inode_rmdir = 			smack_inode_rmdir,
+	.inode_mknod = 			smack_inode_mknod,
+	.inode_rename = 		smack_inode_rename,
+	.inode_readlink = 		smack_inode_readlink,
+	.inode_follow_link = 		smack_inode_follow_link,
+	.inode_permission = 		smack_inode_permission,
+	.inode_setattr = 		smack_inode_setattr,
+	.inode_getattr = 		smack_inode_getattr,
+	/* .inode_delete		No hook required */
+	.inode_setxattr = 		smack_inode_setxattr,
+	.inode_post_setxattr = 		smack_inode_post_setxattr,
+	.inode_getxattr = 		smack_inode_getxattr,
+	.inode_listxattr = 		smack_inode_listxattr,
+	.inode_removexattr = 		smack_inode_removexattr,
+	.inode_xattr_getsuffix = 	smack_inode_xattr_getsuffix,
+	.inode_getsecurity = 		smack_inode_getsecurity,
+	.inode_setsecurity = 		smack_inode_setsecurity,
+	.inode_listsecurity = 		smack_inode_listsecurity,
+
+	.file_permission = 		smack_file_permission,
+	.file_alloc_security = 		smack_file_alloc_security,
+	.file_free_security = 		smack_file_free_security,
+	.file_ioctl = 			smack_file_ioctl,
+	/* .file_mmap			No hook required */
+	/* .file_mprotect		No hook required */
+	.file_lock = 			smack_file_lock,
+	.file_fcntl = 			smack_file_fcntl,
+	.file_set_fowner = 		smack_file_set_fowner,
+	.file_send_sigiotask = 		smack_file_send_sigiotask,
+	.file_receive = 		smack_file_receive,
+
+	/* .task_create			No hook required */
+	.task_alloc_security = 		smack_task_alloc_security,
+	.task_free_security = 		smack_task_free_security,
+	/* .task_setuid			No hook required */
+	.task_post_setuid =		cap_task_post_setuid,
+	/* .task_setgid			No hook required */
+	.task_setpgid = 		smack_task_setpgid,
+	.task_getpgid = 		smack_task_getpgid,
+	.task_getsid = 			smack_task_getsid,
+	.task_getsecid = 		smack_task_getsecid,
+	/* .task_setgroups		No hook required */
+	.task_setnice = 		smack_task_setnice,
+	.task_setioprio = 		smack_task_setioprio,
+	.task_getioprio = 		smack_task_getioprio,
+	/* .task_setrlimit		No hook required */
+	.task_setscheduler = 		smack_task_setscheduler,
+	.task_getscheduler = 		smack_task_getscheduler,
+	.task_movememory = 		smack_task_movememory,
+	.task_kill = 			smack_task_kill,
+	.task_wait = 			smack_task_wait,
+	/* .task_prctl			No hook required */
+	.task_reparent_to_init =	cap_task_reparent_to_init,
+	.task_to_inode = 		smack_task_to_inode,
+
+	.ipc_permission = 		smack_ipc_permission,
+
+	.msg_msg_alloc_security = 	smack_msg_msg_alloc_security,
+	.msg_msg_free_security = 	smack_msg_msg_free_security,
+
+	.msg_queue_alloc_security = 	smack_msg_queue_alloc_security,
+	.msg_queue_free_security = 	smack_msg_queue_free_security,
+	.msg_queue_associate = 		smack_msg_queue_associate,
+	.msg_queue_msgctl = 		smack_msg_queue_msgctl,
+	.msg_queue_msgsnd = 		smack_msg_queue_msgsnd,
+	.msg_queue_msgrcv = 		smack_msg_queue_msgrcv,
+
+	.shm_alloc_security = 		smack_shm_alloc_security,
+	.shm_free_security = 		smack_shm_free_security,
+	.shm_associate = 		smack_shm_associate,
+	.shm_shmctl = 			smack_shm_shmctl,
+	.shm_shmat = 			smack_shm_shmat,
+
+	.sem_alloc_security = 		smack_sem_alloc_security,
+	.sem_free_security = 		smack_sem_free_security,
+	.sem_associate = 		smack_sem_associate,
+	.sem_semctl = 			smack_sem_semctl,
+	.sem_semop = 			smack_sem_semop,
+
+	.netlink_send =			cap_netlink_send,
+	.netlink_recv = 		cap_netlink_recv,
+
+	/* .register_security		No hook required */
+	/* .unregister_security		No hook required */
+
+	.d_instantiate = 		smack_d_instantiate,
+
+	.getprocattr = 			smack_getprocattr,
+	.setprocattr = 			smack_setprocattr,
+	/* .secid_to_secctx		No hook required */
+	/* .release_secctx		No hook required */
+
+	.unix_stream_connect = 		smack_unix_stream_connect,
+	.unix_may_send = 		smack_unix_may_send,
+
+	/* .socket_create 		No hook required */
+	.socket_post_create = 		smack_socket_post_create,
+	/* .socket_bind 		No hook required */
+	/* .socket_connect 		No hook required */
+	/* .socket_listen 		No hook required */
+	/* .socket_accept 		No hook required */
+	/* .socket_post_accept 		No hook required */
+	/* .socket_sendmsg 		No hook required */
+	/* .socket_recvmsg 		No hook required */
+	/* .socket_getsockname		No hook required */
+	/* .socket_getpeername		No hook required */
+	/* .socket_getsockopt		No hook required */
+	/* .socket_setsockopt		No hook required */
+	/* .socket_shutdown		No hook required */
+	.socket_sock_rcv_skb = 		smack_socket_sock_rcv_skb,
+	/* .socket_getpeersec_stream	No hook required */
+	/* .socket_getpeersec_dgram	No hook required */
+	.sk_alloc_security = 		smack_sk_alloc_security,
+	.sk_free_security = 		smack_sk_free_security,
+	/* .sk_clone_security 		No hook required */
+	/* .sk_getsecid 		No hook required */
+	.sock_graft = 			smack_sock_graft,
+	.inet_conn_request = 		smack_inet_conn_request,
+	/* .inet_csk_clone		No hook required */
+	/* .inet_conn_established	No hook required */
+
+	/* .req_classify_flow 		No hook required */
+	/* .xfrm_policy_alloc_security	no xfrm for smack */
+	/* .xfrm_policy_clone_security	no xfrm for smack */
+	/* .xfrm_policy_free_security	no xfrm for smack */
+	/* .xfrm_policy_delete_security	no xfrm for smack */
+	/* .xfrm_state_alloc_security	no xfrm for smack */
+	/* .xfrm_state_free_security	no xfrm for smack */
+	/* .xfrm_state_delete_security	no xfrm for smack */
+	/* .xfrm_policy_lookup		no xfrm for smack */
+	/* .xfrm_state_pol_flow_match	no xfrm for smack */
+	/* .xfrm_decode_session		no xfrm for smack */
+
+ /* key management security hooks */
+#ifdef CONFIG_KEYS
+	.key_alloc = 			smack_key_alloc,
+	.key_free = 			smack_key_free,
+	.key_permission = 		smack_key_permission,
+#endif /* CONFIG_KEYS */
+
+};
+
+static __init int smack_init(void)
+{
+	struct task_smack *tsp;
+	printk(KERN_INFO "Smack:  Initializing.\n");
+
+	/* Set the security state for the initial task. */
+
+	tsp = kzalloc(sizeof(struct task_smack), GFP_KERNEL);
+	if (tsp == NULL)
+		panic("smack:  Failed to initialize initial task.\n");
+
+	tsp->smk_task = SMK_FLOOR;
+	current->security = tsp;
+
+	if (register_security(&smack_ops))
+		panic("smack: Unable to register with kernel.\n");
+
+	return 0;
+}
+
+/* smack requires early initialization in order to label
+   all processes and objects when they are created. */
+security_initcall(smack_init);
+



