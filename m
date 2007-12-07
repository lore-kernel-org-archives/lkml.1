Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXLGIwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXLGIwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXLGIwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:52:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbXLGIwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:52:12 -0500
Date: Fri, 7 Dec 2007 09:51:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       "Andrew Morton"@pimp.vs19.net
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207085121.GA12625@elte.hu>
References: <20071207021952.6f0ac922@morte> <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain> <3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com> <20071207090252.1caf1509@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207090252.1caf1509@inria.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> > Something like http://lkml.org/lkml/2007/3/16/291 that would need 
> > some refresh?
> 
> And here is a refreshed one just for testing with 2.6-git. The 64 bit 
> part is a shamelessly untested copy/paste as I cannot test it.

yeah, we can do something like this in 2.6.25 - this will improve the 
quality of sched_clock(). The other patch i sent should solve the 
problem for 2.6.24 - printk should not be using raw sched_clock() calls. 
(as the name says it's for the scheduler's internal use.) I've also 
queued up the patch below - it removes the now unnecessary printk clock 
code.

	Ingo

--------------------->
Subject: sched: remove printk_clock()
From: Ingo Molnar <mingo@elte.hu>

printk_clock() is obsolete - it has been replaced with cpu_clock().

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/time.c  |   11 -----------
 arch/ia64/kernel/time.c |   27 ---------------------------
 kernel/printk.c         |    5 -----
 3 files changed, 43 deletions(-)

Index: linux/arch/arm/kernel/time.c
===================================================================
--- linux.orig/arch/arm/kernel/time.c
+++ linux/arch/arm/kernel/time.c
@@ -79,17 +79,6 @@ static unsigned long dummy_gettimeoffset
 }
 #endif
 
-/*
- * An implementation of printk_clock() independent from
- * sched_clock().  This avoids non-bootable kernels when
- * printk_clock is enabled.
- */
-unsigned long long printk_clock(void)
-{
-	return (unsigned long long)(jiffies - INITIAL_JIFFIES) *
-			(1000000000 / HZ);
-}
-
 static unsigned long next_rtc_update;
 
 /*
Index: linux/arch/ia64/kernel/time.c
===================================================================
--- linux.orig/arch/ia64/kernel/time.c
+++ linux/arch/ia64/kernel/time.c
@@ -344,33 +344,6 @@ udelay (unsigned long usecs)
 }
 EXPORT_SYMBOL(udelay);
 
-static unsigned long long ia64_itc_printk_clock(void)
-{
-	if (ia64_get_kr(IA64_KR_PER_CPU_DATA))
-		return sched_clock();
-	return 0;
-}
-
-static unsigned long long ia64_default_printk_clock(void)
-{
-	return (unsigned long long)(jiffies_64 - INITIAL_JIFFIES) *
-		(1000000000/HZ);
-}
-
-unsigned long long (*ia64_printk_clock)(void) = &ia64_default_printk_clock;
-
-unsigned long long printk_clock(void)
-{
-	return ia64_printk_clock();
-}
-
-void __init
-ia64_setup_printk_clock(void)
-{
-	if (!(sal_platform_features & IA64_SAL_PLATFORM_FEATURE_ITC_DRIFT))
-		ia64_printk_clock = ia64_itc_printk_clock;
-}
-
 /* IA64 doesn't cache the timezone */
 void update_vsyscall_tz(void)
 {
Index: linux/kernel/printk.c
===================================================================
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -573,11 +573,6 @@ static int __init printk_time_setup(char
 
 __setup("time", printk_time_setup);
 
-__attribute__((weak)) unsigned long long printk_clock(void)
-{
-	return sched_clock();
-}
-
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
