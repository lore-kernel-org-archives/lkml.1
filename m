Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZAZQ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZAZQ4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZAZQ4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:56:03 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40753 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZAZQ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:56:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=uPclCWEW7nb4fUKGQTmsRBq79aw5BD1dtdH1r6q3m4bk+Utq14bdmbtOhjaWNpqv/+
         sHY6QD2qDubABDMWR4by8YoTbjHUaUhsxVps7BxcLeKxYY7hozHMjyyTQ1203fTH5eXB
         oe8Qn+9KJVD+Lq+FvOVhw0fux7Fp19ll5UuJY=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090126151746.GH9128@elte.hu>
References: <20090121185021.GA8852@elte.hu>
	 <497D0C81.5040406@linux.vnet.ibm.com>
	 <7c86c4470901260113r4db6b15cpa0fa88ab3f8a516c@mail.gmail.com>
	 <20090126151746.GH9128@elte.hu>
Date: Mon, 26 Jan 2009 17:55:58 +0100
Message-ID: <7c86c4470901260855y4431a11fu8d6546160fd274c6@mail.gmail.com>
Subject: Re: [announce] Performance Counters for Linux, v6
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
       "perfmon2-devel@lists.sourceforge.net" 
	<perfmon2-devel@lists.sourceforge.net>,
       Papi <ptools-perfapi@cs.utk.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 4:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * stephane eranian <eranian@googlemail.com> wrote:
>
>> Hi,
>>
>>  Corey brings up an interesting problem which I wanted to comment on.
>>
>> The current proposal hinges on the idea that by interpreting a single
>> value the kernel can understand what the user wants to measure. For
>> instance, if I pass type=0, then the kernel understands I want to
>> measure CPU_CYCLES. Given that the number of events and their unit mask
>> combinations can be large, the proposal also provides a "raw" mode,
>> where the content of the type field is interpreted as the raw value to
>> put into a register.
>>
>> This is where there is an issue because with several PMU models,
>> including on X86, using the raw bit + 64 value is not enough to figure
>> out what the user wants to measure. This happens when the PMU has more
>> than counters. Thus, interpreting each raw value has the event code may
>> be wrong. To remain on familiar territory, the Nehalem uncore PMU has an
>> opcode matcher register, that uses a 64-bit value. On AMD64 Family 10h,
>> you have IBS. But I could give examples on Itanium with opcode matchers,
>> range restrictions. Corey provided other examples for Power. The API has
>> to provide a way to express what the raw value is meant for: counter,
>> matcher, filter...
>
> this can be done in a number of ways (in order of increasing levels of
> abstraction):
>
> - the raw type is kept wide enough. Paul already requested the raw type
>  to be widened to 128 bits to express certain PowerPC features.

Yes, 1 bit is not enough. With 128 that would be enough to encode all
the resources I can think of for existing Itanium, X86.

But then, I think fields would have to be renamed to make it clearer.
Raw would denote a type of resource and the current type field
could be renamed 'code' or 'val' or 'id' which reflects more what the
content actually would be.

As for Netburst, both CCCR and ESCR only use the bottom 32-bit so they
could be stuffed into the 64-bit 'type' field. But that would not work if a PMU
were to require wider values. Those values are part of the event encoding and
should not be considered optional nor attributes. That is why using a separate
call to program the second value does not seem appropriate to me.

>
> - or the PMU capability is expressed as a special counter type (if it's
>  useful enough) - and then either the write() method or ioctl is extended
>  to express attributes we want to set/change while a counter is running.
>
> - or the highest level counter / hw event data type is extended with new
>  attribute field(s).
>
> My feeling is that we generally want such hw features to start small -
> i.e. at the raw type level initially. Then we can allow them to climb the
> ladder, if they prove their utility in practice. We've got space reserved
> in the ABI to allow for growth like this.
>
>        Ingo
>
