Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXJOU6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXJOU6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbXJOU6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:58:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60034 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXJOU6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:58:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] PM: Rework struct platform_suspend_ops fixup
Date: Mon, 15 Oct 2007 23:14:17 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Joseph Fannin <jfannin@gmail.com>,
       Domen Puncer <domen.puncer@telargo.com>,
       Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152314.18690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

A recently merged powerpc update has overlapped with the changes introduced by
the following patches:

pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch

As a result, mpc5200 and lite5200 need to be modified to follow the reworked
suspend core.

Thanks to Joseph Fannin <jfannin@gmail.com> for reporting the problem and
helping to fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/powerpc/platforms/52xx/lite5200_pm.c |   33 ++++++++++++++++++++----------
 arch/powerpc/platforms/52xx/mpc52xx_pm.c  |    4 +--
 include/asm-powerpc/mpc52xx.h             |    6 +++--
 3 files changed, 28 insertions(+), 15 deletions(-)

Index: linux-2.6.23-mm1/include/asm-powerpc/mpc52xx.h
===================================================================
--- linux-2.6.23-mm1.orig/include/asm-powerpc/mpc52xx.h
+++ linux-2.6.23-mm1/include/asm-powerpc/mpc52xx.h
@@ -18,6 +18,8 @@
 #include <asm/prom.h>
 #endif /* __ASSEMBLY__ */
 
+#include <linux/suspend.h>
+
 
 /* ======================================================================== */
 /* Structures mapping of some unit register set                             */
@@ -267,9 +269,9 @@ extern int mpc52xx_set_wakeup_gpio(u8 pi
 extern int __init lite5200_pm_init(void);
 
 /* lite5200 calls mpc5200 suspend functions, so here they are */
-extern int mpc52xx_pm_prepare(suspend_state_t);
+extern int mpc52xx_pm_prepare(void);
 extern int mpc52xx_pm_enter(suspend_state_t);
-extern int mpc52xx_pm_finish(suspend_state_t);
+extern void mpc52xx_pm_finish(void);
 extern char saved_sram[0x4000]; /* reuse buffer from mpc52xx suspend */
 #endif
 #endif /* CONFIG_PM */
Index: linux-2.6.23-mm1/arch/powerpc/platforms/52xx/lite5200_pm.c
===================================================================
--- linux-2.6.23-mm1.orig/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ linux-2.6.23-mm1/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -1,5 +1,5 @@
 #include <linux/init.h>
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <asm/io.h>
 #include <asm/time.h>
 #include <asm/mpc52xx.h>
@@ -18,6 +18,8 @@ static void __iomem *sram;
 static const int sram_size = 0x4000;	/* 16 kBytes */
 static void __iomem *mbar;
 
+static suspend_state_t lite5200_pm_target_state;
+
 static int lite5200_pm_valid(suspend_state_t state)
 {
 	switch (state) {
@@ -29,13 +31,22 @@ static int lite5200_pm_valid(suspend_sta
 	}
 }
 
-static int lite5200_pm_prepare(suspend_state_t state)
+static int lite5200_pm_set_target(suspend_state_t state)
+{
+	if (lite5200_pm_valid(state)) {
+		lite5200_pm_target_state = state;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int lite5200_pm_prepare(void)
 {
 	/* deep sleep? let mpc52xx code handle that */
-	if (state == PM_SUSPEND_STANDBY)
-		return mpc52xx_pm_prepare(state);
+	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY)
+		return mpc52xx_pm_prepare();
 
-	if (state != PM_SUSPEND_MEM)
+	if (lite5200_pm_target_state != PM_SUSPEND_MEM)
 		return -EINVAL;
 
 	/* map registers */
@@ -190,17 +201,17 @@ static int lite5200_pm_enter(suspend_sta
 	return 0;
 }
 
-static int lite5200_pm_finish(suspend_state_t state)
+static void lite5200_pm_finish(void)
 {
 	/* deep sleep? let mpc52xx code handle that */
-	if (state == PM_SUSPEND_STANDBY) {
-		return mpc52xx_pm_finish(state);
+	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY) {
+		mpc52xx_pm_finish();
 	}
-	return 0;
 }
 
-static struct pm_ops lite5200_pm_ops = {
+static struct platform_suspend_ops lite5200_pm_ops = {
 	.valid		= lite5200_pm_valid,
+	.set_target	= lite5200_pm_set_target,
 	.prepare	= lite5200_pm_prepare,
 	.enter		= lite5200_pm_enter,
 	.finish		= lite5200_pm_finish,
@@ -208,6 +219,6 @@ static struct pm_ops lite5200_pm_ops = {
 
 int __init lite5200_pm_init(void)
 {
-	pm_set_ops(&lite5200_pm_ops);
+	suspend_set_ops(&lite5200_pm_ops);
 	return 0;
 }
Index: linux-2.6.23-mm1/arch/powerpc/platforms/52xx/mpc52xx_pm.c
===================================================================
--- linux-2.6.23-mm1.orig/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ linux-2.6.23-mm1/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -57,7 +57,7 @@ int mpc52xx_set_wakeup_gpio(u8 pin, u8 l
 	return 0;
 }
 
-static int mpc52xx_pm_prepare(void)
+int mpc52xx_pm_prepare(void)
 {
 	/* map the whole register space */
 	mbar = mpc52xx_find_and_map("mpc5200");
@@ -163,7 +163,7 @@ int mpc52xx_pm_enter(suspend_state_t sta
 	return 0;
 }
 
-static void mpc52xx_pm_finish(void)
+void mpc52xx_pm_finish(void)
 {
 	/* call board resume code */
 	if (mpc52xx_suspend.board_resume_finish)
