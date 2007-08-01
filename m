Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXHAEcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXHAEcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbXHAEbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:31:42 -0400
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:37328 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752694AbXHAEbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:31:37 -0400
X-YMail-OSG: NuIZi2EVM1kRC0ve46G9eHjGrPo31WKdrQDLEjwk_k8r5tmpq1KUh3mJDNPIGL.4ShZTck1Ocw--
X-RocketYMMF: rancidfat
Date: Tue, 31 Jul 2007 21:31:35 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: [PATCH 1/2][RFC] v8  Simplified Mandatory Access Control Kernel
To: LSM List <linux-security-module@vger.kernel.org>,
       linux-kernel List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <655678.12956.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/Kconfig linux-2.6.22/security/Kconfig
--- linux-2.6.22-base/security/Kconfig	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/security/Kconfig	2007-07-10 01:08:05.000000000 -0700
@@ -94,6 +94,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/smack/Kconfig
 
 endmenu
 
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/Makefile linux-2.6.22/security/Makefile
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
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/smack/Kconfig linux-2.6.22/security/smack/Kconfig
--- linux-2.6.22-base/security/smack/Kconfig	1969-12-31 16:00:00.000000000
-0800
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
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/smack/Makefile linux-2.6.22/security/smack/Makefile
--- linux-2.6.22-base/security/smack/Makefile	1969-12-31 16:00:00.000000000
-0800
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
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/smack/smack_access.c
linux-2.6.22/security/smack/smack_access.c
--- linux-2.6.22-base/security/smack/smack_access.c	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.22/security/smack/smack_access.c	2007-07-24 15:36:18.000000000
-0700
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
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/smack/smackfs.c
linux-2.6.22/security/smack/smackfs.c
--- linux-2.6.22-base/security/smack/smackfs.c	1969-12-31 16:00:00.000000000
-0800
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
+static int smackfs_readlink(struct dentry *dentry, char __user *buffer, int
buflen)
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
+static void smackfs_put_link(struct dentry *dentry, struct nameidata *nd, void
*ptr)
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
diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/smack/smack.h linux-2.6.22/security/smack/smack.h
--- linux-2.6.22-base/security/smack/smack.h	1969-12-31 16:00:00.000000000
-0800
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


Casey Schaufler
casey@schaufler-ca.com
