Return-Path: <linux-kernel-owner+w=401wt.eu-S2992518AbXCWQxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992518AbXCWQxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992527AbXCWQxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:53:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35789 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992518AbXCWQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:53:33 -0400
Subject: [Patch -mm 1/1] SLIM Integrity Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, akpm@osdl.org
Content-Type: text/plain
Date: Fri, 23 Mar 2007 12:52:01 -0400
Message-Id: <1174668721.18725.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a minor patch to SLIM that only addresses the integrity service
issues, to be reviewed in conjuction with the integrity service 
framework and provider that were just posted.

(A major patch will be released to address the other issues previously 
discussed on the lkml mailing list shortly.)

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---

Index: linux-2.6.21-rc4-mm1/security/slim/slm_main.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/security/slim/slm_main.c
+++ linux-2.6.21-rc4-mm1/security/slim/slm_main.c
@@ -1,7 +1,7 @@
 /*
  * SLIM - Simple Linux Integrity Module
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  * 	   Kylene Hall <kjhall@us.ibm.com>
  *
@@ -32,6 +32,29 @@
 extern struct security_operations dummy_security_ops;
 
 unsigned int slm_debug = SLM_BASE;
+
+#ifdef CONFIG_SECURITY_SLIM_BOOTPARAM
+int slim_enabled = CONFIG_SECURITY_SLIM_BOOTPARAM_VALUE;
+
+static int __init slim_enabled_setup(char *str)
+{
+	slim_enabled = simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("slim=", slim_enabled_setup);
+#else
+int slim_enabled = 1;
+#endif
+
+unsigned int integrity_enforce = 0;
+static int __init integrity_enforce_setup(char *str)
+{
+	integrity_enforce = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("slim_integrity_enforce=", integrity_enforce_setup);
+
 #define XATTR_NAME "security.slim.level"
 
 #define ZERO_STR "0"
@@ -319,16 +342,13 @@ static int slm_get_xattr(struct dentry *
 			"(rc: %d - status: %d)\n",
 			dentry->d_name.name, rc, *status);
 
-	} else if (rc >=0 && *status == INTEGRITY_PASS && xattr_value) {
-		rc = slm_parse_xattr(xattr_value, xattr_len, level);
+	} else {
+		if (!integrity_enforce)
+			*status = INTEGRITY_PASS;
+
+		if (rc >= 0 && xattr_value && *status != INTEGRITY_FAIL)
+			rc = slm_parse_xattr(xattr_value, xattr_len, level);
 		kfree(xattr_value);
-		if (rc == 0 && level->iac_level != SLM_IAC_UNTRUSTED) {
-			rc = integrity_verify_data(dentry, status);
-			if ((rc < 0) || (*status != INTEGRITY_PASS))
-				dprintk(SLM_BASE, "%s integrity_verify_data failed "
-				" (rc: %d status: %d)\n", dentry->d_name.name,
-					rc, *status);
-		}
 	}
 	return rc;
 }
@@ -392,13 +412,12 @@ static void update_level(struct dentry *
 			break;
 		}
 	} else {
-		switch(status) {
-			case INTEGRITY_FAIL:
-			case INTEGRITY_NOLABEL:
-				dprintk(SLM_INTEGRITY, "%s: %s FAIL/NOLABEL (%d)\n",
+		switch (status) {
+		case INTEGRITY_FAIL:
+			dprintk(SLM_INTEGRITY, "%s: %s FAIL(%d)\n",
 				__FUNCTION__, dentry->d_name.name, rc);
-				set_level_untrusted(level);
-				break;
+			set_level_untrusted(level);
+			break;
 		}
 	}
 }
@@ -699,8 +718,28 @@ static int slm_inode_permission(struct i
 
 	slm_get_level(dentry, &level);
 
-	/* measure all SYSTEM level integrity objects */
-	if (level.iac_level == SLM_IAC_SYSTEM)
+	/* verify data for all trusted integrity objects */
+	if (level.iac_level != SLM_IAC_UNTRUSTED) {
+		int status;
+
+		rc = integrity_verify_data(dentry, &status);
+		switch (status) {
+		case INTEGRITY_FAIL:
+			dprintk(SLM_INTEGRITY, "%s: %s (Integrity status: "
+				" FAIL)\n", __FUNCTION__, fname);
+			if (integrity_enforce)
+				set_level_untrusted(&level);
+			break;
+		case INTEGRITY_NOLABEL:
+			dprintk(SLM_INTEGRITY, "%s: %s (Integrity status: "
+				" NOLABEL)\n", __FUNCTION__, fname);
+		default:
+			break;
+		}
+	}
+
+	/* measure all SYSTEM level integrity objects to be read */
+	if ((level.iac_level == SLM_IAC_SYSTEM) && (mask == MAY_READ))
 		integrity_measure(dentry, fname, mask);
 
 	rc = slm_set_taskperm(mask, &level, fname);
@@ -789,7 +828,6 @@ static int slm_set_xattr(struct slm_file
 		memcpy(bufp, slm_iac_str[level->iac_level], len);
 		bufp += len;
 	}
-	*bufp++ = ' ';
 	xattr_len = bufp - buf;
 
 	/* point after 'security.' */
@@ -1410,23 +1448,25 @@ static int slm_bprm_check_security(struc
 
 	/* Possible return codes: PERMIT, DENY, NOLABEL */
 	rc = integrity_verify_data(dentry, &status);
-	if (rc < 0)
+	if ((rc < 0) && integrity_enforce)
 		return rc;
 
-	switch(status) {
+	switch (status) {
 	case INTEGRITY_FAIL:
 		if (!is_kernel_thread(current)) {
 			dprintk(SLM_BASE,
 				"%s: %s (Integrity status: FAIL)\n",
 				__FUNCTION__, bprm->filename);
-			return -EACCES;
+			if (integrity_enforce)
+				return -EACCES;
 		}
 		break;
 	case INTEGRITY_NOLABEL:
 		dprintk(SLM_BASE,
 			"%s: %s (Integrity status: NOLABEL)\n",
 			__FUNCTION__, bprm->filename);
-		level.iac_level = SLM_IAC_UNTRUSTED;
+		if (integrity_enforce)
+			level.iac_level = SLM_IAC_UNTRUSTED;
 	}
 
 	rc = enforce_integrity_execute(bprm, &level, cur_tsec);
@@ -1609,18 +1649,6 @@ static struct security_operations slm_se
 	.d_instantiate = slm_d_instantiate
 };
 
-#ifdef CONFIG_SECURITY_SLIM_BOOTPARAM
-int slim_enabled = CONFIG_SECURITY_SLIM_BOOTPARAM_VALUE;
-
-static int __init slim_enabled_setup(char *str)
-{
-	slim_enabled = simple_strtol(str, NULL, 0);
-	return 1;
-}
-__setup("slim=", slim_enabled_setup);
-#else
-int slim_enabled = 1;
-#endif
 static int __init init_slm(void)
 {
 	int rc;
Index: linux-2.6.21-rc4-mm1/security/slim/Kconfig
===================================================================
--- linux-2.6.21-rc4-mm1.orig/security/slim/Kconfig
+++ linux-2.6.21-rc4-mm1/security/slim/Kconfig
@@ -23,7 +23,7 @@ config SECURITY_SLIM_BOOTPARAM_VALUE
 	int "SLIM boot parameter default value"
 	depends on SECURITY_SLIM_BOOTPARAM
 	range 0 1
-	default 1
+	default 0
 	help
 	  This option sets the default value for the kernel parameter
 	  'slim', which allows SLIM to be disabled at boot.  If this
@@ -32,5 +32,5 @@ config SECURITY_SLIM_BOOTPARAM_VALUE
 	  set to 1 (one), the SLIM kernel parameter will default to 1,
 	  enabling SLIM at bootup.
 
-	  If you are unsure how to answer this question, answer 1.
+	  If you are unsure how to answer this question, answer 0.
 



