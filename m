Return-Path: <linux-kernel-owner+w=401wt.eu-S1765465AbYBGAz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765465AbYBGAz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933050AbYBGAvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:51:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53149 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072AbYBGAv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:51:28 -0500
Date: Thu, 7 Feb 2008 01:51:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: softlockup: automatically detect hung TASK_UNINTERRUPTIBLE
	tasks
Message-ID: <20080207005110.GA1457@elte.hu>
References: <200801252259.m0PMxHmD012059@hera.kernel.org> <20080205164626.f9c920e0.akpm@linux-foundation.org> <1202309402.6310.0.camel@lappy> <20080206100513.133587fa.akpm@linux-foundation.org> <20080207000425.GA21918@elte.hu> <20080206163111.54088622.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206163111.54088622.akpm@linux-foundation.org>
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

> Nope.
> 
> But I tested it on mainline, and mainline exhibits the 
> never-powers-off symptom, whereas 
> ed50d6cbc394cd0966469d3e249353c9dd1d38b9 demonstrates the 
> powers-off-after-20-seconds symptom.
> 
> So we _may_ be dealing with two bugs here, and your patch might have 
> fixed the first, but that success is obscured by the second.  I guess 
> I need to prepare a tree which has 
> ed50d6cbc394cd0966469d3e249353c9dd1d38b9 at its tip.  (Wonders how to 
> do that).

the way i do it in bisection is to do:

  mkdir patches
  git-log -1 -p ed50d6cbc394cd0966469d3 > patches/fix.patch
  echo fix.patch > patches/series

and then before testing a bisection point, i do a 'quilt push'. Before 
telling git-bisect about the quality of that bisection point (good/bad) 
i pop it off via 'quilt pop'.

this way the 'required fix' can be kept during the bisection, to find 
the secondary bug.

> btw, mainline (plus this patch, not that it changed anything) prints
> 
> <stopping disk stuff>
> Disabling non-boot CPUs
> CPU 1 is now offline
> 
> and that's it.   This machine has eight cpus.  Might be a hint?

what should be the proper message?

my suspects, besides there being something wrong in the hung-tasks code 
of the softlockup watchdog, would be the cpu-hotplug commits, or some 
arch/x86 commit. (although we didnt really have anything specifically 
touching the the reboot path)

does a stupid patch like the one below tell you more about what the 
other CPUs are doing during this hang? [32-bit only patch]

	Ingo

---
 arch/i386/kernel/nmi.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86/kernel/nmi_64.c
+++ linux/arch/x86/kernel/nmi_64.c
@@ -331,6 +331,14 @@ __kprobes int nmi_watchdog_tick(struct p
 	int touched = 0;
 	int cpu = smp_processor_id();
 	int rc=0;
+	static int count[NR_CPUS];
+
+	if (!count[cpu]) {
+		count[cpu] = nmi_hz;
+		printk("CPU#%d, tick\n", cpu);
+		show_regs(regs);
+	}
+	count[cpu]--;
 
 	/* check for other users first */
 	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
