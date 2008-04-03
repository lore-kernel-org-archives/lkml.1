Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbYDCDV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbYDCDV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 23:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbYDCDVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 23:21:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41212 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136AbYDCDVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 23:21:48 -0400
Message-ID: <47F44D25.6030001@jp.fujitsu.com>
Date: Thu, 03 Apr 2008 12:21:09 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       andi@firstfloor.org
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
References: <47F21BE3.5030705@jp.fujitsu.com>	<20080401065534.a6267b96.pj@sgi.com>	<47F34625.6000600@jp.fujitsu.com> <20080402061405.197c0c90.pj@sgi.com>
In-Reply-To: <20080402061405.197c0c90.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Hidetoshi wrote:
>> Put simply, if the system tend to be idle, then "push to idle" strategy
>> works well.  OTOH if the system tend to be busy, then "pull by idle"
>> strategy works well.  Else, both strategy will work but besides of all
>> there is a question: how much searching cost can you pay?
> 
> So each flag has value in some cases ... that much seems reasonable to me.
> 
> But you're saying that you'd like to avoid having to turn on both, just to
> get the benefit of one of them, in order to avoid the searching costs of
> the other flag that was not valuable on that load, right?
> 
> But is this necessarily so?

I'd like to turn on both(since I know it is best for my application/system),
but it can't be denied that there are other situations loving only one of
them...  At least there is a small possible conflict:
   "Are you idle?" - "No, I'm busy to search a busy CPU!"

To be honest, I don't have strong reason to have them to be divided.
Just I thought that they could work independently and it might be usable
interface for other people.
(... well, I would be a little happy if I don't need to rewrite almost all
  of the additional piece of Documentation/cpuset.txt, but don't care :-D)

So, if there is no one can find use of two flags, I'll change it to one.
Comments from any others?

> If "pull by idle" is attempted on a system
> which tends to be idle, then while it is true that the search for something
> to pull will usually find nothing, what does it matter that we wasted some
> otherwise idle cycles, looking for pullable, runnable tasks that cannot be
> found, on a system that is mostly idle?
> 
> If "push to idle" is attempted on a system that is quite busy, then
> couldn't that be coded to notice rather quickly if any nearby CPUs are
> idle, and not search if there are no idle neighbors.  One could imagine
> a word of memory for each smaller domain ("neighborhood") of CPUs (say
> all the logical CPUs in a package), with one bit per logical CPU, that
> was set if-and-only-if that CPU was in idle.  Then it would be very
> quick for all the CPUs in that domain to see if there are (or just
> were ... close enough) any idle CPUs, and skip trying to "push to idle"
> if that word was all zero bits.  That is, there would be no sense
> trying to push to idle if there were no idle CPUs to push to.  The only
> writing and the only locking of that word would be from idle loop code,
> and only from nearby CPUs in the same small domain, so it would not be
> an impediment to large system scaling or a waste of many CPU cycles on
> busy systems.
> 
> With a little work such as this, we could make it so that anytime you
> needed either flag, you could turn on both, and the other one would be
> harmless enough ... just a minor consumer of otherwise idle cycles.
> 
> Then with that, we could have one flag, that did both.

I believe there are quite technical reasons why we have no "idle_map."
Excellent answers would be brought by scheduler folks...

>> It looks easy... but how do you handle if cpusets are overlapping?
> 
> Yeah - that part might be challenging.  Would it work to always take
> the largest domain balancing requested?

Hum... if one requests "smaller" and another is "don't care = default",
we always take "default" range.

Anyway, I'd like to give a lot of care to well-defined cpusets, and
I know that balancing on overlapping cpusets are easy to be confused,
so I'll update my patch to take levels, getting in your suggestion.

Thanks,
H.Seto
