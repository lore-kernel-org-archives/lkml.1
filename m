Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbXJNTre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbXJNTre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXJNTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:47:27 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:2383 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbXJNTrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SSwD/NKVbZBknFZuKAYBlTwUdGD7ARIKNdhWI70pO5WgXNNaxtQ/wfjxOTxJ3pX3Jm0vJN2dRMsauPcxigLf7n5Lkw77/M2d9YOnerszBZtBh1PQ0UORTk9ZRik91IcZk4KLNCKcBLNbckWksxRvQEZQfe071NYyhhC7x8lt9Pc=
Date: Sun, 14 Oct 2007 15:47:20 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joseph Fannin <jfannin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Domen Puncer <domen.puncer@telargo.com>
Subject: Re: 2.6.23-mm1 pm_prepare() and _finish() w/ args vs. without
Message-ID: <20071014194719.GB11864@nineveh.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Joseph Fannin <jfannin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Domen Puncer <domen.puncer@telargo.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <200710131922.49094.rjw@sisk.pl> <20071013184006.GA2114@nineveh.local> <200710132113.14138.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710132113.14138.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 09:13:13PM +0200, Rafael J. Wysocki wrote:

> Yes.  Corrected patch follows.

A bit more is needed due to the rename of lite5200_pm_init() to
lite5200_suspend_init().  An amended patch follows that builds and
boots on my powermac.


---

diff -aurN linux-2.6.23-mm1.orig/arch/powerpc/platforms/52xx/lite5200.c linux-2.6.23-mm1/arch/powerpc/platforms/52xx/lite5200.c
--- linux-2.6.23-mm1.orig/arch/powerpc/platforms/52xx/lite5200.c	2007-10-12 16:21:47.000000000 -0400
+++ linux-2.6.23-mm1/arch/powerpc/platforms/52xx/lite5200.c	2007-10-14 11:49:29.000000000 -0400
@@ -126,7 +126,7 @@
 #ifdef CONFIG_PM
 	mpc52xx_suspend.board_suspend_prepare = lite5200_suspend_prepare;
 	mpc52xx_suspend.board_resume_finish = lite5200_resume_finish;
-	lite5200_pm_init();
+	lite5200_suspend_init();
 #endif
 
 #ifdef CONFIG_PCI
diff -aurN linux-2.6.23-mm1.orig/arch/powerpc/platforms/52xx/lite5200_pm.c linux-2.6.23-mm1/arch/powerpc/platforms/52xx/lite5200_pm.c
--- linux-2.6.23-mm1.orig/arch/powerpc/platforms/52xx/lite5200_pm.c	2007-10-14 11:10:57.000000000 -0400
+++ linux-2.6.23-mm1/arch/powerpc/platforms/52xx/lite5200_pm.c	2007-10-14 09:06:36.000000000 -0400
@@ -1,5 +1,5 @@
 #include <linux/init.h>
-#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <asm/io.h>
 #include <asm/time.h>
 #include <asm/mpc52xx.h>
@@ -18,6 +18,8 @@
 static const int sram_size = 0x4000;	/* 16 kBytes */
 static void __iomem *mbar;
 
+static suspend_state_t lite5200_pm_target_state;
+
 static int lite5200_pm_valid(suspend_state_t state)
 {
 	switch (state) {
@@ -29,13 +31,22 @@
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
@@ -190,24 +201,24 @@
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
diff -aurN linux-2.6.23-mm1.orig/arch/powerpc/platforms/52xx/mpc52xx_pm.c linux-2.6.23-mm1/arch/powerpc/platforms/52xx/mpc52xx_pm.c
--- linux-2.6.23-mm1.orig/arch/powerpc/platforms/52xx/mpc52xx_pm.c	2007-10-14 11:10:57.000000000 -0400
+++ linux-2.6.23-mm1/arch/powerpc/platforms/52xx/mpc52xx_pm.c	2007-10-14 09:06:36.000000000 -0400
@@ -57,7 +57,7 @@
 	return 0;
 }
 
-static int mpc52xx_pm_prepare(void)
+int mpc52xx_pm_prepare(void)
 {
 	/* map the whole register space */
 	mbar = mpc52xx_find_and_map("mpc5200");
@@ -163,7 +163,7 @@
 	return 0;
 }
 
-static void mpc52xx_pm_finish(void)
+void mpc52xx_pm_finish(void)
 {
 	/* call board resume code */
 	if (mpc52xx_suspend.board_resume_finish)
diff -aurN linux-2.6.23-mm1.orig/include/asm-powerpc/mpc52xx.h linux-2.6.23-mm1/include/asm-powerpc/mpc52xx.h
--- linux-2.6.23-mm1.orig/include/asm-powerpc/mpc52xx.h	2007-10-14 11:10:57.000000000 -0400
+++ linux-2.6.23-mm1/include/asm-powerpc/mpc52xx.h	2007-10-14 11:42:59.000000000 -0400
@@ -18,6 +18,8 @@
 #include <asm/prom.h>
 #endif /* __ASSEMBLY__ */
 
+#include <linux/suspend.h>
+
 
 /* ======================================================================== */
 /* Structures mapping of some unit register set                             */
@@ -264,12 +266,12 @@
 extern int mpc52xx_set_wakeup_gpio(u8 pin, u8 level);
 
 #ifdef CONFIG_PPC_LITE5200
-extern int __init lite5200_pm_init(void);
+extern int __init lite5200_suspend_init(void);
 
 /* lite5200 calls mpc5200 suspend functions, so here they are */
-extern int mpc52xx_pm_prepare(suspend_state_t);
+extern int mpc52xx_pm_prepare(void);
 extern int mpc52xx_pm_enter(suspend_state_t);
-extern int mpc52xx_pm_finish(suspend_state_t);
+extern void mpc52xx_pm_finish(void);
 extern char saved_sram[0x4000]; /* reuse buffer from mpc52xx suspend */
 #endif
 #endif /* CONFIG_PM */

--
Joseph Fannin
jfannin@gmail.com

