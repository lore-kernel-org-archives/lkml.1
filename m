Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYGaWIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYGaWIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYGaWIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:08:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYGaWIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:08:38 -0400
Date: Fri, 1 Aug 2008 00:08:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function
	call IPIs
Message-ID: <20080731220825.GD23801@elte.hu>
References: <488FA8A9.6000005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488FA8A9.6000005@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This adds 8 queues for smp_call_function(), in order to avoid a 
> bottleneck on a single global lock and list for function calls.  When 
> initiating a function call, the sender chooses a queue based on its 
> own processor id (if there are more than 8 processors, they hash down 
> to 8 queues).  It then sends an IPI to the corresponding vector for 
> that queue to each target CPU.  The target CPUs use the vector number 
> to determine which queue they should scan for work.
>
> This should give smp_call_function the same performance 
> characteristics as the original x86-64 cross-cpu tlb flush code, which 
> used the same scheme.

heh, nice :-)

Before going into all the fine details an trying our luck in tip/master 
QA, i'm a bit worried about hw compatibility in general though. APICs 
have been flaky since the beginnings of times. We had erratas in the 
area of local timer IRQs(IPIs) overlapping with IPIs, etc. - so i'd not 
bet the farm on all APICs being able to handle a _lot_ more overlapped 
inter-CPU IPIs than we do currently. (which basically was just three of 
them until now, and now four with the new SMP cross-call IPIs)

So this _has_ to be approached defensively. It _should_ work, and i'm 
all in favor of utilizing hardware resources more fully, but it's an 
entirely new mode of operation for the hardware. I think a Kconfig 
option (which defaults to off), and a boot option to disable it would be 
nice, so that we can introduce this gently, at least initially. Then 
when we see that it's 100% trouble-free we can flip around the default.

Plus, would it be possible to shape this a bit more dynamically? I like 
8 as a nice round number, but i bet some folks would like to have 16, 
some would like to have 4 ... Perhaps even making it dynamic (so that we 
can turn it all off in the case of trouble with certain CPU/APIC 
versions).

Hm?

	Ingo
