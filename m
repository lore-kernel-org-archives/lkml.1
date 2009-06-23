Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZFWOZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZFWOZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZFWOZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:25:36 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41158 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbZFWOZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=xx8kTZpV5UHNMd4O3LoCXEu6M7lQEXrFSyGN3BgGwUXrOLu/Z8FT/uwqYFG7JQ4rQq
         sR+7KDWci0mdKVce5qyQrt9nk6YqvIeovI8cA/6anv5M5AsSOgEeynHC48b3GozYIaID
         KHC4oBnu+kto7PMEcmRgw0QlVL+T7egDOnAQQ=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090623140538.GA10451@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622120018.GR24366@elte.hu> <4A3F9062.6000303@renci.org>
	 <1245737987.19816.1477.camel@twins>
	 <7c86c4470906230119g6df76304xbec11dc682176b09@mail.gmail.com>
	 <20090623140538.GA10451@elte.hu>
Date: Tue, 23 Jun 2009 16:25:37 +0200
Message-ID: <7c86c4470906230725t2d86cd2eybabeba454f3aff81@mail.gmail.com>
Subject: Re: [perfmon2] IV.3 - AMD IBS
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rob Fowler <rjf@renci.org>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 4:05 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * stephane eranian <eranian@googlemail.com> wrote:
>
>> > The most natural way to support IBS would be to have a special
>> > sampling cycle counter and use that as group lead and add non
>> > sampling siblings to that group to get individual elements.
>> >
>> As discussed in my message, I think the way to support IBS is to
>> create two pseudo-events (like your perf_hw_event_ids), one for
>> fetch and one for op (because they could be measured
>> simultaneously). The sample_period field would be used to express
>> the IBS*CTL maxcnt, subject to the verification that the bottom 4
>> bits must be 0. And then, you add two new sampling formats
>> PERF_SAMPLE_IBSFETCH, PERF_SAMPLE_IBSOP. Those would only work
>> with IBS pseudo events. Once you have the randomize option in
>> perf_counter_attr, you could even enable IBSFETCH randomization.
>
> I'd suggest to start smaller, and first express the 'precise' nature
> of IBS transparently, by simply mapping it to one of the generic
> events. (cycles and instructions both appears to be possible)
>
IBS is precise by nature. It does not work like PEBS. It tags an instruction
and then collects info about it. When it retires, IBS freezes and triggers an
interrupt like a regular counter interrupt. Except this time, you don't care
about the interrupted IP, you use the instruction address in the IBS data
register, it is guaranteed to correspond to the tagged instruction.

The sampling period expresses the delay before picking the instruction
to tag. And as I said before, it is only 20 bits and the bottom 4 bits must
be zero (as they cannot be encoded).



> No extra sampling, no extra events - just a transparent side channel
> implementation for the specific case of PERF_COUNT_HW_CPU_CYCLES. (A
> bit like the fixed-purpose counters are done on the Intel side - a
> special-case - but none of the generic code knows about it.)
>

> This gives us immediate results with less code, and also gives us
> the platform to see how IBS is structured, what kind of general
> problems/quirks it has, and how popular its precision is, etc. We
> can always add extra sampling formats on top of that (i'm not
> opposed to that), to expose more and more of IBS.
>
> The same can be done on the PEBS side as well.
>
> Would you be interested in pursuing this?
>
>        Ingo
>
