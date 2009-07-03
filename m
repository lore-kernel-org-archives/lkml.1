Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZGCH6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZGCH6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZGCH6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:58:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40470 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZGCH6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:58:30 -0400
Date: Fri, 3 Jul 2009 09:58:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
Message-ID: <20090703075822.GA13505@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu> <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy> <20090629210206.GB13125@elte.hu> <Pine.LNX.4.64.0907021702380.13747@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907021702380.13747@pianoman.cluster.toy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

> On Mon, 29 Jun 2009, Ingo Molnar wrote:
>>
>> * Vince Weaver <vince@deater.net> wrote:
>>
>>>> If the 5 thousand cycles measurement overhead _still_ matters to
>>>> you under such circumstances then by all means please submit the
>>>> patches to improve it. Despite your claims this is totally
>>>> fixable with the current perfcounters design, Peter outlined the
>>>> steps of how to solve it, you can utilize ptrace if you want to.
>>>
>>> Is it really "totally" fixible?  I don't just mean getting the
>>> overhead from ~3000 down to ~100, I mean down to zero.
>>
>> The thing is, not even pfmon gets it down to zero:
>>
>>  pfmon -e INSTRUCTIONS_RETIRED --follow-fork --aggregate-results ~/million
>>  1000001 INSTRUCTIONS_RETIRED
>>
>> So ... do you take the hardliner purist view and consider it crap
>> due to that imprecision, or do you take the pragmatist view of also
>> considering the relative relevance of any imperfection? ;-)
>
> as I said in a previous post, on most x86 chips the 
> instructions_retired counter also includes any hardware interrupts 
> that occur during the process runtime.  So any clock interrupts, 
> etc, show up as an extra instruction.  So on the "million" 
> benchmark, it's usually +/- 2 extra instructions.

yeah. But it has nothing to do with the function you are measuring, 
right?

My general point is really that what matters is the statistical 
validity of the end result. I dont think you ever disagreed with 
that point - you just seem to have a lower noise acceptance 
threshold ;-)

> It looks like support might be added to perfcounters to track 
> these hardware interrupt stats per-process, which would be great, 
> as it's been really hard to quantify that currently.

Yeah. There's a patch-set in the works that attempts to do something 
in this area - see these mails on lkml:

    perf_counter: Add Generalized Hardware interrupt support

Right now they are just convenience wrappers around CPU model 
specific hw events - but we could extend the whole thing with 
software counters as well and isolate per IRQ vector events and 
counts, by adding a callback to do_IRQ().

That would give a mixture of hardware and software counter based IRQ 
instrumentation features that looks quite compelling. Any comments 
on what features/capabilities you'd like to see in this area?

> In any case, it looks like the changes to make perf have lower 
> overhead have been merged, which makes me happy.  Thank you.

You are welcome :)

Btw., perfcounters still has no support for older Intel CPUs such as 
P3's and P2's - and they have pretty sane PMUs - so if you have such 
a machine (which your perfmon contribution suggests you might 
have/had) and are interested it would be nice to get support for 
them. P4 support is interesting too but more challenging.

	Ingo
