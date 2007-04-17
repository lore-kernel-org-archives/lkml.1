Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXDQGTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXDQGTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDQGTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:19:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37380 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbXDQGTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:19:14 -0400
Date: Tue, 17 Apr 2007 08:18:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417061849.GA12385@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704170053.58611.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@gmail.com> wrote:

> This one (v2-rc2) is not a keeper I'm sorry to say, Ingo.  v2-rc0 was 
> much better.  Watching amanda run with htop, kmails composer is being 
> subjected to 5 to 10 second pauses, and htop says that gzip -best 
> isn't getting more that 15% of the cpu, and the /amandatapes drive is 
> being written to in a regular pattern that seems to be the cause of 
> the pauses according to gkrellm, which also seems to track the size of 
> the writes, and can show anything from 4.3k to 54 megs as being 
> written in one cycle of its screen update.

ok - fortunately the delta between -v2-rc0 and -v2-final is pretty 
small. One difference is the child-runs-first fix. To restore the 
parent-runs-first logic, do this: 

	echo 0 > /proc/sys/kernel/sched_child_runs_first

does this make any difference?

If not then pretty much the only other change was the nice level tweak i 
did. Could you try to grab a few snapshots of scheduling state via 
something like:

   while sleep 1; do cat /proc/sched_debug >> to-ingo.txt; done

(and tell me the PID of the kmail composer, to make sure i'm checking 
the right task's behavior.)

also, as a separate experiment, could you perhaps run this script as 
root:

   cd /proc; for N in [1-9]*; do renice -n 0 $N; done

this will move all tasks in the system to nice level 0 and should make 
any nice level handling logic in the scheduler irrelevant. Do you have X 
reniced perhaps?

Lots of system threads have negative or positive nice levels, so once 
you have executed this script, only a reboot will be a practical way to 
restore it to the previous settings.

	Ingo
