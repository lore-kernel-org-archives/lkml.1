Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXLJKXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXLJKXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXLJKXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:23:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54459 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXLJKXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:23:14 -0500
Date: Mon, 10 Dec 2007 11:21:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071210102157.GB31103@elte.hu>
References: <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu> <475B24F4.3090904@gmail.com> <20071209074647.GE22981@elte.hu> <20071210081952.GA7215@in.ibm.com> <475CFF01.2090502@gmail.com> <20071210091052.GA14487@elte.hu> <20071210101500.GB12880@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210101500.GB12880@in.ibm.com>
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


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> > i'm wondering, what's the proper CPU-hotplug safe sequence here 
> > then? I'm picking a CPU number from cpu_online_map, and that CPU 
> > could go away while i'm still using it, right? What's saving us 
> > here?
> 
> In this particular case, we are trying to see if any task on a 
> particular cpu has not been scheduled for a really long time. If we do 
> this check on a cpu which has gone offline, then a) If the tasks have 
> not been migrated on to another cpu yet, we will still perform that 
> check and yell if something has been holding any task for a 
> sufficiently long time. b) If the tasks have been migrated off, then 
> we have nothing to check.

say we've got 100 CPUs, so we've got 100 watchdog tasks running - one 
for each CPU. Checking for hung tasks is a global operation not a 
per-CPU operation (we iterate over the global tasklist), hence only one 
CPU should really be calling this function. That online-cpus logic 
achieves this by picking a single CPU. Perhaps it would be better to 
keep a hung_task_checker_cpu variable that is driven from a 
CPU-hotplug-down notifier? That way if a CPU is brought down we can 
update hung_task_checker_cpu to another, still-online CPU. (this would 
also be faster, because event-driven)

	Ingo
