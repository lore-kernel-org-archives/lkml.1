Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbXKCJdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbXKCJdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 05:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXKCJdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 05:33:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbXKCJdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 05:33:04 -0400
Date: Sat, 3 Nov 2007 10:32:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Restore deterministic CPU accounting on powerpc
Message-ID: <20071103093240.GA22932@elte.hu>
References: <18218.44089.274628.680088@cargo.ozlabs.ibm.com> <20071103085420.GA14551@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071103085420.GA14551@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Since powerpc started using CONFIG_GENERIC_CLOCKEVENTS, the 
> > deterministic CPU accounting (CONFIG_VIRT_CPU_ACCOUNTING) has been 
> > broken on powerpc, because we end up counting user time twice: once in 
> > timer_interrupt() and once in update_process_times().
> > 
> > This fixes the problem by pulling the code in update_process_times 
> > that updates utime and stime into a separate function called 
> > account_process_tick.  If CONFIG_VIRT_CPU_ACCOUNTING is not defined, 
> > there is a version of account_process_tick in kernel/timer.c that 
> > simply accounts a whole tick to either utime or stime as before.  If 
> > CONFIG_VIRT_CPU_ACCOUNTING is defined, then arch code gets to 
> > implement account_process_tick.
> > 
> > This also lets us simplify the s390 code a bit; it means that the s390 
> > timer interrupt can now call update_process_times even when 
> > CONFIG_VIRT_CPU_ACCOUNTING is turned on, and can just implement a 
> > suitable account_process_tick().
> > 
> > Signed-off-by: Paul Mackerras <paulus@samba.org>
> 
> lets push this towards Linus via the scheduler tree, ok?

hm, i've removed it for now because it doesnt even build due toj:

+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+void account_process_tick(int user_tick)
+{
+       if (user_tick) {
+               account_user_time(p, jiffies_to_cputime(1));
+               account_user_time_scaled(p, jiffies_to_cputime(1));

	Ingo
