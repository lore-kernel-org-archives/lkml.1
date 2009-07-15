Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZGOWjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZGOWjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbZGOWjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:39:21 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:55110 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZGOWjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qnwjn9BGmjtl26/WzzCa58v2tLm6hn+vCAeMvrJL2v7ecfPGtwo39d1S67v/qxVrBr
         Q1+gjq701IK/L9pNVMzQqwQvtgbIwQTSp61bz2FXqZihFxvGKfsuJZl4RyZDkhjt3l7E
         G0K5CpI0I7fNeZrUxFqYeGLd9GdDgVG5B5gXQ=
MIME-Version: 1.0
In-Reply-To: <20090715223400.GF14993@cs.fsu.edu>
References: <1247412708.6704.105.camel@laptop> <4A5B61DF.8090101@nortel.com>
	 <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	 <1247589099.7500.191.camel@twins>
	 <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
	 <20090715205503.GA14993@cs.fsu.edu> <4A5E4FDD.7090307@nortel.com>
	 <20090715223400.GF14993@cs.fsu.edu>
Date: Thu, 16 Jul 2009 04:09:18 +0530
Message-ID: <8aa016e10907151539t16fb1d7fk3122d77e69ac7de5@mail.gmail.com>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Chris Friesen <cfriesen@nortel.com>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 4:04 AM, Ted Baker<baker@cs.fsu.edu> wrote:
> On Wed, Jul 15, 2009 at 03:53:33PM -0600, Chris Friesen wrote:
>
>> >From an API standpoint, the "group scheduling" functionality in linux
>> allows for the creation of an arbitrary hierarchy of groups, each of
>> which may contain zero or more tasks.  (Each task is associated with
>> exactly one group.)
>>
>> There is a distinction between groups containing realtime tasks, and
>> groups containing non-realtime tasks.  For realtime groups, each group
>> is allocated a specific amount of cpu time.  For non-realtime groups,
>> each group is allocated a specific weight.
>>
>> A realtime group may use up to its specified amount of cpu time.  Any
>> cpu time not used by a realtime group is distributed to the non-realtime
>> groups according to their relative weights.
>>
>> This does add a whole different API to the mix, but allows for controls
>> to be set by the administrator on existing POSIX apps without needing to
>> recompile them.
>
> This is in the right direction, but there is a lot about Linux groups
> that I either do not understand or which falls short of what is needed.
> Perhaps you can point me to an up to date detailed explanation of
> how they work?
>
> From what I've been able to infer from my brief foray into that
> part of the kernel code (a year ago), there seemed to be several
> aspects of the group scheduling that did not seem to admit
> schedulability analysis.  (I admit that I may have read it wrong,
> and these statements are false.)
>
> 1) The priority of a group seemed to be defined by the priority of
> the highest-priority thread in the group's run-queue, which means
> it varies dynamically according to which threads in the group are
> contending.
>

This is true, but it also ensures that the time allocated to the group
is also consumed by group if it wants to.

> 2) Budget enforcement seemed to only occur at system tick
> boundaries, which means precision can only be achieved at the cost
> of frequent clock interrupts.
>
> 3) It seemed that a thread could belong to more than one group,
> and so distributed charges arbitrarily between groups.
> If so, budget allocation would seem very difficult.
>

No. A thread can only be a part of one group at a time.

> 4) On an SMP, more than one thread could be running against
> the same budget at the same time, resulting in budget over-charges.
>

The rt group scheduler does split the budget per cpu. On expiring the
budget, it tries to borrow from other CPUs if possible.

Thanks,
Dhaval
-- 

Spike Milligan  - "All I ask is the chance to prove that money can't
make me happy." -
http://www.brainyquote.com/quotes/authors/s/spike_milligan.html
