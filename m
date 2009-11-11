Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbZKKTYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbZKKTYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbZKKTX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:23:59 -0500
Received: from fallback2.mail.ru ([94.100.176.87]:38379 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472AbZKKTX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:23:59 -0500
Date: Wed, 11 Nov 2009 22:23:15 +0300
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: linux-arm-kernel@lists.infradead.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [REGRESSION] 2eca40a8 breaks StrongARM compilation
Message-ID: <20091111192315.GA29757@rainbow>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit 2eca40a8 which went into 2.6.32-rc6 breaks compilation
for ipaq h3600 and probably other SA1100 machines when CONFIG_CPU_FREQ
is unset:

  CC      arch/arm/mach-sa1100/generic.o
arch/arm/mach-sa1100/generic.c:117: error: redefinition of 'cpufreq_get'
include/linux/cpufreq.h:299: error: previous definition of 'cpufreq_get'
was here
make[1]: *** [arch/arm/mach-sa1100/generic.o] Error 1
make: *** [arch/arm/mach-sa1100] Error 2

The problem is that before 2eca40a8  StrongArm aready had its own
version of cpufreq_get for CONFIG_CPU_FREQ=n case and now it clashed
with one introduced in 2eca40a8. Removing strongarm version will cure
compilation, but it then will break sa1100_fb driver in runtime, as it
blindly uses value which cpufreq_get returns for calculating pixel clock
divisor (see line 926 in drivers/video/sa1100fb.c) and 2eca40a8's cpufreq_get
returns 0.

One option would be to make sa1100_fb use hardcoded frequency 206.4MHz
(default on StrongARM CPUs) for CONFIG_CPU_FREQ=n case - see attached
patch. But I'm not sure if this is a proper fix.

Any ideas are welcome.

-- 
Best regards,
Dmitry "MAD" Artamonow


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fix-strongarm-build.diff"

diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 23cfdd5..59a21c6 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -110,15 +110,6 @@ unsigned int sa11x0_getspeed(unsigned int cpu)
 	return cclk_frequency_100khz[PPCR & 0xf] * 100;
 }
 
-#else
-/*
- * We still need to provide this so building without cpufreq works.
- */
-unsigned int cpufreq_get(unsigned int cpu)
-{
-	return cclk_frequency_100khz[PPCR & 0xf] * 100;
-}
-EXPORT_SYMBOL(cpufreq_get);
 #endif
 
 /*
diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index cdaa873..4f2e4fe 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -923,7 +923,12 @@ static int sa1100fb_activate_var(struct fb_var_screeninfo *var, struct sa1100fb_
 		LCCR2_BegFrmDel(var->upper_margin) +
 		LCCR2_EndFrmDel(var->lower_margin);
 
+#ifdef CONFIG_CPU_FREQ
 	pcd = get_pcd(var->pixclock, cpufreq_get(0));
+#else
+	pcd = get_pcd(var->pixclock, 206400);
+#endif
+
 	new_regs.lccr3 = LCCR3_PixClkDiv(pcd) | fbi->lccr3 |
 		(var->sync & FB_SYNC_HOR_HIGH_ACT ? LCCR3_HorSnchH : LCCR3_HorSnchL) |
 		(var->sync & FB_SYNC_VERT_HIGH_ACT ? LCCR3_VrtSnchH : LCCR3_VrtSnchL);

--ZPt4rx8FFjLCG7dd--
