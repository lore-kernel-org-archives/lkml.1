Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0BCNWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 08:22:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41419 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab0BCNWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 08:22:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=xD27oaEo1sfnw8UgmSyAj2FMO8RtLcIMGsZlcV+/6BPIT3wSeAy2rRUqSXbnEpqrL
	PzoJ0YQz9Gzb2Yxr8rJMg==
MIME-Version: 1.0
In-Reply-To: <1265135588.24455.350.camel@laptop>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
Date: Wed, 3 Feb 2010 14:22:11 +0100
Message-ID: <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf_events, x86: PEBS support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, there are some problems with the PEBS buffer when
used in system-wide mode. If the depth is > 1, then you have a
problem attributing samples to pid,tid.

Looks like this patch hardcodes the depth and threshold of the buffer.
I believe you need to add some flexibility in there.

You are currently only extracting IP. You need a way to extract the rest
of the recorded state. There are some useful measurements you can do
with it. I believe something like PERF_SAMPLE_REGS would work.
Part of the pt_regs are already exported by signals (sigcontext).

It should be noted that providing PERF_SAMPLE_REGS in non-PEBS
situations is also a requirement. But it needs to be clear this is the
interrupted state and not the at-overflow state.

I do not believe substituting PEBS whenever you detect it is available AND
event supports it is a good idea. PEBS is not more precise than regular
sampling, in fact, it is statistically of poorer quality. This is due to the way
it works and it cannot be mitigated by randomization (at least with depth > 1).

The only improvement that PEBS provides is that you get an IP and the
machine state at retirement of an instruction that caused the event to
increment. Thus, the IP points to the next dynamic instruction. The instruction
is not the one that cause the P-th occurence of the event, if you set the
period to P. It is at P+N, where N cannot be predicted and varies depending
on the event and executed code. This introduces some bias in the samples.

Given the behavior of PEBS, it would not be possible to correlate samples
obtained from two events with only one of them supporting PEBS. For instance,
if you sample on INST_RETIRED and UNHALTED_CORE_CYCLES. You
would get a PEBS profile for INST_RETIRED and a regular profile for CYCLES.
Given the skid differences, you would not be able to make fair comparisons.

The user needs to understand what is being measured.





On Tue, Feb 2, 2010 at 7:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-02-02 at 19:26 +0100, Ingo Molnar wrote:
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> > @@ -203,8 +203,9 @@ struct perf_event_attr {
>> >                             enable_on_exec :  1, /* next exec enables     */
>> >                             task           :  1, /* trace fork/exit       */
>> >                             watermark      :  1, /* wakeup_watermark      */
>> > +                           precise        :  1,
>>
>> I think we want to default to precise events even if not specifically
>> requested by user-space, in the cases where that's possible on the CPU
>> without additional limitations.
>>
>> That way people will default to better (and possibly cheaper) PEBS profiling
>> on modern Intel CPUs.
>
> Sure, I'll look at that once it starts working :-)
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
