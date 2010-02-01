Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0BAQOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:14:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:48093 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0BAQOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:14:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Mg+Nf1xhDauILiEP8LLLPLzYy4KcHXiRn+jwpGqRHfvDiMBw5nU7WWNDiKTZuv1iF
	Gz2/4T21mLw35MLRK1PMQ==
MIME-Version: 1.0
In-Reply-To: <1265040260.24455.200.camel@laptop>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
	 <1265038508.24455.177.camel@laptop>
	 <1265040260.24455.200.camel@laptop>
Date: Mon, 1 Feb 2010 17:14:02 +0100
Message-ID: <bd4cb8901002010814x12e5a26v195f13c63b0f7567@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bug in hw_perf_enable()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 5:04 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-01 at 16:35 +0100, Peter Zijlstra wrote:
>> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
>> @@ -243,8 +243,18 @@ static struct event_constraint intel_cor
>>
>>  static struct event_constraint intel_core2_event_constraints[] =
>>  {
>> -       FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
>> -       FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
>> +       FIXED_EVENT_CONSTRAINT(0x00c0, 1ULL << 32), /* INST_RETIRED.ANY */
>> +       FIXED_EVENT_CONSTRAINT(0x003c, 1ULL << 33), /* CPU_CLK_UNHALTED.CORE */
>> +       /*
>> +        * FIXED_EVENT_CONSTRAINT(0x013c, 1ULL << 34),  CPU_CLK_UNHALTED.REF
>> +        *
>> +        * Core2 has Fixed Counter 2 listed as CPU_CLK_UNHALTED.REF and event
>> +        * 0x013c as CPU_CLK_UNHALTED.BUS and specifies there is a fixed
>> +        * ratio between these counters.
>> +        *
>> +        * TODO: find/measure the fixed ratio and apply it so that we can
>> +        * enable this fixed purpose counter in a transparent way.
>> +        */
>>         INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
>>         INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
>>         INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
>
> >From what I can measure on the available Core2 systems this ratio is
> exactly 1, which would be consistent with the Nehalem and Westmere
> tables calling this event .REF
>
> Stephane, have you ever observed this ratio to be anything other than 1?
>

Using perfmon on Core 2 on a 10s noploop:

pfmon -eunhalted_reference_cycles,unhalted_core_cycles,cpu_clk_unhalted:bus
 noploop 10
noploop for 10 seconds
23869090125 UNHALTED_REFERENCE_CYCLES
23849336873 UNHALTED_CORE_CYCLES
 2652122099 CPU_CLK_UNHALTED:BUS


> If not, I think we can simply stick this counter back in and not worry
> about it.
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
