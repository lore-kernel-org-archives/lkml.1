Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZBIH4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZBIH4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZBIH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:56:12 -0500
Received: from ozlabs.org ([203.10.76.45]:34166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZBIH4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:56:12 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 09 Feb 2009 18:22:26 +1030
CC: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 2/4] module_param: invbool should take a 'bool', not an 'int'
Cc: Brad Douglas <brad@neruo.com>
Cc: Michal Januszewski <spock@gentoo.org>
Message-Id: <20090209075609.001C9DDD1C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It takes an 'int' for historical reasons, and there are only two
users: simply switch it over to bool.

The other user (uvesafb.c) will get a (harmless-on-x86) warning until
the next patch is applied.

Cc: Brad Douglas <brad@neruo.com>
Cc: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -354,7 +355,7 @@ static int default_lcd_on __devinitdata 
 static int default_lcd_on __devinitdata = 1;
 
 #ifdef CONFIG_MTRR
-static int mtrr = 1;
+static bool mtrr = true;
 #endif
 
 #ifdef CONFIG_PMAC_BACKLIGHT
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -187,7 +187,7 @@ extern int param_get_bool(char *buffer, 
 
 extern int param_set_invbool(const char *val, struct kernel_param *kp);
 extern int param_get_invbool(char *buffer, struct kernel_param *kp);
-#define param_check_invbool(name, p) __param_check(name, p, int)
+#define param_check_invbool(name, p) __param_check(name, p, bool)
 
 /* Comma-separated array: *nump is set to number they actually specified. */
 #define module_param_array_named(name, array, type, nump, perm)		\
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -257,13 +257,13 @@ int param_set_invbool(const char *val, s
 	dummy.arg = &boolval;
 	ret = param_set_bool(val, &dummy);
 	if (ret == 0)
-		*(int *)kp->arg = !boolval;
+		*(bool *)kp->arg = !boolval;
 	return ret;
 }
 
 int param_get_invbool(char *buffer, struct kernel_param *kp)
 {
-	return sprintf(buffer, "%c", (*(int *)kp->arg) ? 'N' : 'Y');
+	return sprintf(buffer, "%c", (*(bool *)kp->arg) ? 'N' : 'Y');
 }
 
 /* We break the rule and mangle the string. */

