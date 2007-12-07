Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbXLGPMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbXLGPMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 10:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbXLGPMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 10:12:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXLGPMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 10:12:23 -0500
Date: Fri, 7 Dec 2007 16:11:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071207151150.GB24254@elte.hu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47595A0A.5000502@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 12/05/2007 06:17 AM, Andrew Morton wrote:
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/
> 
> >  git-sched.patch
> 
> breaks suspend here since -rc3-mm2. More precisely, this one:
> softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks
> 
> 2.6.24-rc4-mm1 minus this one works just fine. Otherwise disks stop, graphics
> stops and then it hangs not powering down.
> 
> Core 2 Duo, SMP kernel, voluntary preempt, 250 HZ, SLUB, 64 bit.
> 
> Ideas?

thanks for tracking it down. Does the patch below help?

	Ingo

---
 kernel/softlockup.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -101,7 +101,11 @@ void softlockup_tick(void)
 
 	now = get_timestamp(this_cpu);
 
-	/* Warn about unreasonable delays: */
+	/* Wake up the high-prio watchdog task every second: */
+	if (now > (touch_timestamp + 1))
+		wake_up_process(per_cpu(watchdog_task, this_cpu));
+
+	/* Warn about unreasonable 10+ seconds delays: */
 	if (now <= (touch_timestamp + softlockup_thresh))
 		return;
 
@@ -214,7 +218,7 @@ static int watchdog(void *__bind_cpu)
 	 */
 	while (!kthread_should_stop()) {
 		touch_softlockup_watchdog();
-		msleep_interruptible(10000);
+		schedule();
 
 		/*
 		 * Only do the hung-tasks check on one CPU:
