Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbXJMS6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbXJMS6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbXJMS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:57:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52614 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbXJMS5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:57:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joseph Fannin <jfannin@gmail.com>
Subject: Re: 2.6.23-mm1 pm_prepare() and _finish() w/ args vs. without
Date: Sat, 13 Oct 2007 21:13:13 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Domen Puncer <domen.puncer@telargo.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <200710131922.49094.rjw@sisk.pl> <20071013184006.GA2114@nineveh.local>
In-Reply-To: <20071013184006.GA2114@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710132113.14138.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 October 2007 20:40, Joseph Fannin wrote:
> On Sat, Oct 13, 2007 at 07:22:48PM +0200, Rafael J. Wysocki wrote:
> > On Saturday, 13 October 2007 17:50, Joseph Fannin wrote:
> > > On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> > > >
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > >
> > >
> > > Domen Puncer's change to support "MPC5200 low power mode" (in
> > > powerpc-git, which is in Linus's tree now) adds new code calling
> > > mpc52xx_pm_prepare and _finish with suspend_state_t as an argument,
> > > while Rafael Wysocki's pm-rework-struct-platform_suspend_ops.patch
> > > converts those to take no arguments.  So the build fails:
> >
> > Ouch.
> >
> > I think that the appended patch is needed.  Unfortunately, I can't test it here.
> >
> 
> > --- linux-2.6.23-mm1.orig/include/asm-powerpc/mpc52xx.h
> > +++ linux-2.6.23-mm1/include/asm-powerpc/mpc52xx.h
> > @@ -267,9 +267,9 @@ extern int mpc52xx_set_wakeup_gpio(u8 pi
> >  extern int __init lite5200_pm_init(void);
> >
> >  /* lite5200 calls mpc5200 suspend functions, so here they are */
> > -extern int mpc52xx_pm_prepare(suspend_state_t);
> > +extern int mpc52xx_pm_prepare(void);
> >  extern int mpc52xx_pm_enter(suspend_state_t);
> > -extern int mpc52xx_pm_finish(suspend_state_t);
> > +extern void mpc52xx_pm_finish(void);
> 
> These declarations are extern, but
> pm-rework-struct-platform_suspend_ops.patch makes the function
> definitions static, which doesn't seem to be allowed.

Yes.  Corrected patch follows.

> After removing the static bits from those two functions in
> mpc52xx_pm.c it builds, but there are lots of warnings, which seem to
> be related:

Well, suspend_state_t is undefined in mpc52xx.h .  I've added
#include <linux/suspend.h> to the corrected patch below, although I'm not sure
if that's the right thing to do here.

Greetings,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/powerpc/platforms/52xx/lite5200_pm.c |   35 +++++++++++++++++++-----------
 arch/powerpc/platforms/52xx/mpc52xx_pm.c  |    4 +--
 include/asm-powerpc/mpc52xx.h             |    6 +++--
 3 files changed, 29 insertions(+), 16 deletions(-)

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
