Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbXLGRyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbXLGRyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbXLGRwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:52:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39560 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753AbXLGRwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:52:15 -0500
Date: Fri, 7 Dec 2007 18:51:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071207175134.GA18916@elte.hu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207151150.GB24254@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> thanks for tracking it down. Does the patch below help?

oops, that should be the patch below. Otherwise the watchdog kernel 
threads will just loop around.

	Ingo

---
 kernel/softlockup.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
 
@@ -213,8 +217,9 @@ static int watchdog(void *__bind_cpu)
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
-		msleep_interruptible(10000);
+		schedule();
 
 		/*
 		 * Only do the hung-tasks check on one CPU:
