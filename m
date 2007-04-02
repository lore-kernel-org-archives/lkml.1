Return-Path: <linux-kernel-owner+w=401wt.eu-S965694AbXDBS5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbXDBS5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965695AbXDBS5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:57:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965694AbXDBS45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:56:57 -0400
Date: Mon, 2 Apr 2007 20:56:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402185607.GA2081@elte.hu>
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070402092818.GE2456@in.ibm.com> <20070402111828.GA14771@elte.hu> <20070402124200.GA9566@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402124200.GA9566@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> flush_workqueue() <- One of biggest offenders of lock_cpu_hotplug() to date
> 	for_each_online_cpu(cpu)
> 		flush_cpu_workqueue
> 			TASK_UNINTERRUPTIBLE sleep
> 
> If we don't wait for this thread from being frozen "voluntarily" 
> (because it is in TASK_UNINTERRUPTIBLE sleep), then flush_workqueue is 
> clearly racy wrt cpu hotplug.

ok. But the only real problem would be for_each_online_cpu() loops that 
might sleep, correct? I did a quick audit and those seem to be in the 
minority by a factor of 1:10.

So ... to make the audit obviously safe, how about mechanically 
converting 100% of the for_each_online_cpu() loops to something like:

	mask = get_each_online_cpu_mask();
	for_each_cpu_mask(mask) {
		...
	}
	put_each_online_cpu_mask(mask);

where get_each_online_cpu_mask() also does a preempt_disable() 
implicitly, and put_each_online_cpu_mask() does a preempt_enable(). 
(Note that no locking is needed - only preemption-disabling.)

the 10% loops that _can_ schedule would trigger the __might_sleep() 
atomicity test in schedule()), and those would have to be converted a 
bit more cleverly, on a case by case basis. (for example a number of 
them might not even have to sleep on the for_each_online_cpu() loop)

hm?

	Ingo
