Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbXGYJE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbXGYJE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbXGYJEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:04:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57178 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbXGYJEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:04:50 -0400
Date: Wed, 25 Jul 2007 11:04:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070725090439.GA26286@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070725014912.35c7e325.akpm@linux-foundation.org> <20070725085204.GA22067@elte.hu> <20070725020003.63144fd6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725020003.63144fd6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> >  softlockup-add-irq-regs-h.patch
> >  softlockup-better-printout.patch
> >  softlockup-cleanups.patch
> >  softlockup-use-cpu-clock.patch
> > 
> > they are all necessary.
> 
> I think I have.  Seems that someone hasn't been naming their patches
> consistently (which is quite irksome).  I have:
> 
> fix-the-softlockup-watchdog-to-actually-work.patch
> softlockup-make-asm-irq_regsh-available-on-every-platform.patch
> softlockup-improve-debug-output.patch
> softlockup-watchdog-style-cleanups.patch
> softlockup-add-a-proc-tuning-parameter.patch
> softlockup-add-a-proc-tuning-parameter-fix.patch

you have the key one missing i think - attached below.

	Ingo

------------------------------------>
Subject: softlockup: use cpu_clock() instead of sched_clock()
From: Ingo Molnar <mingo@elte.hu>

sched_clock() is not a reliable time-source, use cpu_clock() instead.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -42,14 +42,16 @@ static struct notifier_block panic_block
  * resolution, and we don't need to waste time with a big divide when
  * 2^30ns == 1.074s.
  */
-static unsigned long get_timestamp(void)
+static unsigned long get_timestamp(int this_cpu)
 {
-	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
+	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
 }
 
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
+	int this_cpu = raw_smp_processor_id();
+
+	per_cpu(touch_timestamp, this_cpu) = get_timestamp(this_cpu);
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -95,7 +97,7 @@ void softlockup_tick(void)
 		return;
 	}
 
-	now = get_timestamp();
+	now = get_timestamp(this_cpu);
 
 	/* Wake up the high-prio watchdog task every second: */
 	if (now > (touch_timestamp + 1))
