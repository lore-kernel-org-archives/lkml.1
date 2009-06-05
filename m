Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZFFGqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZFFGqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZFFGqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:46:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32968 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZFFGqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:46:16 -0400
Date: Fri, 5 Jun 2009 15:16:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, patches@arm.linux.org.uk
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: zaurus needs generic pxa suspend/resume routines
Message-ID: <20090605131625.GC1376@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For suspend/resume to work, spitz needs pxa_pm_suspend/resume to be
called. Otherwise PSPR is not set properly, and system will die during
resume.

Signed-off-by: Pavel Machek <pavel@ucw.cz> 

PATCH FOLLOWS
KernelVersion: 2.6.30-rc6

--- linux-rc/arch/arm.ofic/common/sharpsl_pm.c	2009-05-29 01:10:31.000000000 +0200
+++ linux-rc/arch/arm/common/sharpsl_pm.c	2009-06-02 15:33:11.000000000 +0200
@@ -553,7 +556,7 @@
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
 		}
-		if(sharpsl_off_charge_battery()) {
+		if (sharpsl_off_charge_battery()) {
 			dev_dbg(sharpsl_pm.dev, "Charging. Suspend...\n");
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
@@ -774,7 +777,9 @@
 }
 
 #ifdef CONFIG_PM
 static struct platform_suspend_ops sharpsl_pm_ops = {
+	.prepare	= pxa_pm_prepare,
+	.finish		= pxa_pm_finish,
 	.enter		= corgi_pxa_pm_enter,
 	.valid		= suspend_valid_only_mem,
 };
diff -ur linux-rc/arch/arm.ofic/mach-pxa/include/mach/pm.h linux-rc/arch/arm/mach-pxa/include/mach/pm.h
--- linux-rc/arch/arm.ofic/mach-pxa/include/mach/pm.h	2009-05-29 01:11:00.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/include/mach/pm.h	2009-06-02 15:39:50.000000000 +0200
@@ -27,6 +27,8 @@
 extern void pxa_cpu_resume(void);
 
 extern int pxa_pm_enter(suspend_state_t state);
+extern int pxa_pm_prepare(void);
+extern void pxa_pm_finish(void);
 
 /* NOTE: this is for PM debugging on Lubbock,  it's really a big
  * ugly, but let's keep the crap minimum here, instead of direct
diff -ur linux-rc/arch/arm.ofic/mach-pxa/pm.c linux-rc/arch/arm/mach-pxa/pm.c
--- linux-rc/arch/arm.ofic/mach-pxa/pm.c	2009-05-29 01:11:02.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/pm.c	2009-06-01 12:01:07.000000000 +0200
@@ -79,7 +84,7 @@
 	return -EINVAL;
 }
 
-static int pxa_pm_prepare(void)
+int pxa_pm_prepare(void)
 {
 	int ret = 0;
 
@@ -89,7 +94,7 @@
 	return ret;
 }
 
-static void pxa_pm_finish(void)
+void pxa_pm_finish(void)
 {
 	if (pxa_cpu_pm_fns && pxa_cpu_pm_fns->finish)
 		pxa_cpu_pm_fns->finish();

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
