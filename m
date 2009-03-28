Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZC1NXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZC1NXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZC1NXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:23:38 -0400
Received: from ozlabs.org ([203.10.76.45]:52787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbZC1NXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:23:37 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 28 Mar 2009 23:53:30 +1030
Subject: [PATCH 1/5] module_param: invbool should take a 'bool', not an 'int'
Cc: Brad Douglas <brad@neruo.com>, Michal Januszewski <spock@gentoo.org>
Cc: Michal Januszewski <spock@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282353.31033.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, minor API change

It takes an 'int' for historical reasons, and there are only two
users: simply switch it over to bool.

The other user (uvesafb.c) will get a (harmless-on-x86) warning until
the next patch is applied.

Cc: Brad Douglas <brad@neruo.com>
Cc: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/video/aty/aty128fb.c |    2 +-
 include/linux/moduleparam.h  |    2 +-
 kernel/params.c              |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

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

