Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbXJMRHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbXJMRHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXJMRHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:07:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52195 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbXJMRHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:07:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joseph Fannin <jfannin@gmail.com>
Subject: Re: 2.6.23-mm1 pm_prepare() and _finish() w/ args vs. without
Date: Sat, 13 Oct 2007 19:22:48 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Domen Puncer <domen.puncer@telargo.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071013155010.GA11864@nineveh.local>
In-Reply-To: <20071013155010.GA11864@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710131922.49094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 October 2007 17:50, Joseph Fannin wrote:
> On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> 
> 
> Domen Puncer's change to support "MPC5200 low power mode" (in
> powerpc-git, which is in Linus's tree now) adds new code calling
> mpc52xx_pm_prepare and _finish with suspend_state_t as an argument,
> while Rafael Wysocki's pm-rework-struct-platform_suspend_ops.patch
> converts those to take no arguments.  So the build fails:

Ouch.

I think that the appended patch is needed.  Unfortunately, I can't test it here.

Greetings,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/powerpc/platforms/52xx/lite5200_pm.c |   35 +++++++++++++++++++-----------
 include/asm-powerpc/mpc52xx.h             |    4 +--
 2 files changed, 25 insertions(+), 14 deletions(-)

Index: linux-2.6.23-mm1/include/asm-powerpc/mpc52xx.h
===================================================================
--- linux-2.6.23-mm1.orig/include/asm-powerpc/mpc52xx.h
+++ linux-2.6.23-mm1/include/asm-powerpc/mpc52xx.h
@@ -267,9 +267,9 @@ extern int mpc52xx_set_wakeup_gpio(u8 pi
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
@@ -190,24 +201,24 @@ static int lite5200_pm_enter(suspend_sta
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
 };
 
-int __init lite5200_pm_init(void)
+int __init lite5200_suspend_init(void)
 {
-	pm_set_ops(&lite5200_pm_ops);
+	suspend_set_ops(&lite5200_pm_ops);
 	return 0;
 }
