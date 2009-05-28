Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZE1VgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZE1VgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZE1VgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:36:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbZE1VgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:36:00 -0400
Date: Thu, 28 May 2009 23:35:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, Philip Mucci <mucci@eecs.utk.edu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: [perfmon2] comments on Performance Counters for Linux (PCL)
Message-ID: <20090528213532.GA8589@elte.hu>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com> <1243527919.6645.75.camel@laptop> <4A1EFCC2.80805@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1EFCC2.80805@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> Just a few comments below on some excerpts from this very good discussion.
>
> Peter Zijlstra wrote:
>> On Thu, 2009-05-28 at 16:58 +0200, stephane eranian wrote:
>>>      - uint64_t irq_period
>>>
>>>        IRQ is an x86 related name. Why not use smpl_period instead?

irq is not an x86 related name at all. There's thousands of uses of 
it even in arch/powerpc:

  earth4:~/tip> git grep -i irq arch/powerpc/ | wc -l
  6441

>>
>> don't really care, but IRQ seems used throughout linux, we could 
>> name the thing interrupt or sample period.
>
> I agree with Stephane, the name irq_period struck me as somewhat 
> strange for what it does.  sample_period would be much better.

sample_period would be fine - but smpl_period definitely not ;-)

>>>      - uint32_t record_type
>>>
>>>        This field is a bitmask. I believe 32-bit is too small to 
>>>        accommodate future record formats.
>>
>> It currently controls 8 aspects of the overflow entry, do you 
>> really forsee the need for more than 32?
>
> record_type is probably not the best name for this either.  Maybe 
> "record_layout" or "sample_layout" or "sample_format" (to go along 
> with read_format)

'record' is pretty established for this - so record_layout would be 
fine. Peter?

>>>        I would assume that on the read() side, counts are accumulated as
>>>        64-bit integers. But if it is the case, then it seems there is an
>>>        asymmetry between period and counts.
>>>
>>>        Given that your API is high level, I don't think tools should have to
>>>        worry about the actual width of a counter. This is especially true
>>>        because they don't know which counters the event is going to go into
>>>        and if I recall correctly, on some PMU models, different counters can
>>>        have different width (Power, I think).
>>>
>>>        It is rather convenient for tools to always manipulate counters as
>>>        64-bit integers. You should provide a consistent view between counts
>>>        and periods.
>>
>> So you're suggesting to artificually strech periods by say 
>> composing a single overflow from smaller ones, ignoring the 
>> intermediate overflow events?
>>
>> That sounds doable, again, patch welcome.
>
> I definitely agree with Stephane's point on this one.  I had 
> assumed that long irq_periods (longer than the width of the 
> counter) would be synthesized as you suggest.  If this is not the 
> case, PCL should be changed so that it does, -or- at a minimum, 
> the user should get an error back stating that the period is too 
> long for the hardware counter.

this looks somewhat academic - at least on x86, even the fastest 
events (say cycles) with a 32 bit overflow means one event per 
second on 4GB. That's not a significant event count in practice. 
What's the minimum width we are talking about on Power?

	Ingo
