Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbYBGAgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbYBGAgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765155AbYBGAEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:04:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36263 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765143AbYBGAEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:04:45 -0500
Date: Thu, 7 Feb 2008 01:04:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: softlockup: automatically detect hung TASK_UNINTERRUPTIBLE
	tasks
Message-ID: <20080207000425.GA21918@elte.hu>
References: <200801252259.m0PMxHmD012059@hera.kernel.org> <20080205164626.f9c920e0.akpm@linux-foundation.org> <1202309402.6310.0.camel@lappy> <20080206100513.133587fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206100513.133587fa.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Does that kernel have:
> > 
> > commit ed50d6cbc394cd0966469d3e249353c9dd1d38b9
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Sat Feb 2 00:23:08 2008 +0100
> > 
> >     debug: softlockup looping fix
> 
> yup.  It was fetched less than 24 hours ago.

does the patch below improve the situation?

	Ingo

---
 arch/x86/kernel/reboot.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/reboot.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/reboot.c
+++ linux-x86.q/arch/x86/kernel/reboot.c
@@ -396,8 +396,20 @@ void machine_shutdown(void)
 	if (!cpu_isset(reboot_cpu_id, cpu_online_map))
 		reboot_cpu_id = smp_processor_id();
 
-	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	/*
+	 * Make certain we only run on the appropriate processor,
+	 * and with sufficient priority:
+	 */
+	{
+		struct sched_param schedparm;
+		schedparm.sched_priority = 99;
+		int ret;
+
+		ret = sched_setscheduler(current, SCHED_RR, &schedparm);
+		WARN_ON_ONCE(1);
+
+		set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	}
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
