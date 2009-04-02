Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbZDBKwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbZDBKwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZDBKwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:52:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZDBKwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:52:06 -0400
Date: Thu, 2 Apr 2009 12:51:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] RFC perf_counter: singleshot support
Message-ID: <20090402105151.GB10828@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.257773792@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402091319.257773792@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> By request, provide a way for counters to disable themselves and 
> signal at the first counter overflow.
> 
> This isn't complete, we really want pending work to be done ASAP 
> after queueing it. My preferred method would be a self-IPI, that 
> would ensure we run the code in a usable context right after the 
> current (IRQ-off, NMI) context is done.

Hm. I do think self-IPIs can be fragile but the more work we do in 
NMI context the more compelling of a case can be made for a 
self-IPI. So no big arguments against that.

Regarding single-shot - i think the code you posted fails to do the 
single-shot aspect: the counter does not stop, to wait for the 
signal handler to get its act together.

So i'd suggest to separate the two concepts: add signal support and 
single-shot via two attributes. User-space might decide to use 
single-shot if it does not want to deal with queued signals or lost 
events due to not processing the previous signal fast enough.

Also, user-space might want to use single-shot _without_ signals 
perhaps.

And that brings up that user-space might want to generate N events 
and stop then, reliably. I.e. single-shot is a specific form of a 
"trigger limit".

Plus the question comes up: dont we need an ioctl to let user-space 
refill/re-enable the trigger limit?

That is an issue for the signal case as well: we stop the counter 
... what restarts it? Does the signal handler have to close the 
counter and re-create it just to get the next single-shot event?

So i think we need 3 separate things:

 - the ability to set a signal attribute of the counter (during 
   creation) via a (signo,tid) pair. 

   Semantics:

    - it can be a regular signal (signo < 32),
      or an RT/queued signal (signo >= 32).

    - It may be sent to the task that generated the event (tid == 0), 
      or it may be sent to a specific task (tid > 0),
      or it may be sent to a task group (tid < 0).

 - 'event limit' attribute: the ability to pause new events after N 
   events. This limit auto-decrements on each event.
   limit==1 is the special case for single-shot.

 - new ioctl method to refill the limit, when user-space is ready to 
   receive new events. A special-case of this is when a signal 
   handler calls ioctl(refill_limit, 1) in the single-shot case - 
   this re-enables events after the signal has been handled.

Another observation: i think perf_counter_output() needs to depend 
on whether the counter is signalling, not on the single-shot-ness of 
the counter.

A completely valid use of this would be for user-space to create an 
mmap() buffer of 1024 events, then set the limit to 1024, and wait 
for the 1024 events to happen - process them and close the counter. 
Without any signalling.

Basically the 'limit' allows counter events to be used as a tracer 
in essence. So i think it's a nice touch of the whole scheme, and it 
should be decoupled from the signal attribute.

Hm?

	Ingo
