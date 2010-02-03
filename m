Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0BCOHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:07:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab0BCOHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:07:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=QevxiQ/kk+7aqqYXntE5V+aLJU7wuyBGPiygZbfC6EFDlBQmq+wydhT3oBdgup0zj
	acn6oG+SsQvNNAkqNdxCQ==
MIME-Version: 1.0
In-Reply-To: <1265205361.24455.533.camel@laptop>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
	 <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
	 <1265205361.24455.533.camel@laptop>
Date: Wed, 3 Feb 2010 15:07:09 +0100
Message-ID: <bd4cb8901002030607y519c191av733231ba2aec2e9c@mail.gmail.com>
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

On Wed, Feb 3, 2010 at 2:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-02-03 at 14:22 +0100, Stephane Eranian wrote:
>> In general, there are some problems with the PEBS buffer when
>> used in system-wide mode. If the depth is > 1, then you have a
>> problem attributing samples to pid,tid.
>>
>> Looks like this patch hardcodes the depth and threshold of the buffer.
>> I believe you need to add some flexibility in there.
>
> Sure you can, just drain the buffers on context switch. (You'll see that
> placing x86_pmu.drain_pebs() calls is one of the missing pieces).

I was talking about cpu-wide mode, where you don't do anything today.
So sure, if you had drain_pebs() in the context switch out, then this will
work.


>
>> I do not believe substituting PEBS whenever you detect it is available AND
>> event supports it is a good idea. PEBS is not more precise than regular
>> sampling, in fact, it is statistically of poorer quality. This is due to the way
>> it works and it cannot be mitigated by randomization (at least with depth > 1).
>
> Right, which is why I already mentioned intending to use depth == 1 for
> things like the auto-freq (and possible future randomization).
>
okay.

>> The only improvement that PEBS provides is that you get an IP and the
>> machine state at retirement of an instruction that caused the event to
>> increment. Thus, the IP points to the next dynamic instruction. The instruction
>> is not the one that cause the P-th occurence of the event, if you set the
>> period to P. It is at P+N, where N cannot be predicted and varies depending
>> on the event and executed code. This introduces some bias in the samples.
>
> I'm not sure I follow, it records the next event after overflow, doesn't
> that make it P+1?
>
That is not what I wrote. I did not say if records at P+1. I said it records
at P+N, where N varies from sample to sample and cannot be predicted.
N is expressed in the unit of the sampling event.

> It doesn't matter how many instructions are between the P-th and P+1th
> event, you're counting events.
>
I did not talk about instructions but occurrences of the sampling event.

> One thing that is not quite clear to me is the influence of PEBS Trap,
> IA32_PERF_CAPABILITIES[6], that says to record after (trap like) when
> set, and before (fault like) when cleared, but then it goes on saying
> the IP is always the instruction after.

I have never played with Trap vs. Fault. I leave it to default.

The IP is ALWAYS the address after the sampled instruction because it
is recorded at retirement of that instruction. Same thing with the machine
state. It is the state after the instruction retired. So if it
increments a register,
you get the value after the increment.

>
> If it means the register state before or after the instruction, then I
> don't know why they had to mess up the IP like they do :/
>
>> Given the behavior of PEBS, it would not be possible to correlate samples
>> obtained from two events with only one of them supporting PEBS. For instance,
>> if you sample on INST_RETIRED and UNHALTED_CORE_CYCLES. You
>> would get a PEBS profile for INST_RETIRED and a regular profile for CYCLES.
>> Given the skid differences, you would not be able to make fair comparisons.
>
> OK, good point.
>
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
