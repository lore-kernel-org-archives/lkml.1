Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZHKVI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZHKVI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZHKVI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:08:57 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62158 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZHKVI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=EtjIQoPt05+ck8FYNwuzX3tA46RfEmiZs3F2baGV8lWm24eAu2FimPRQldD2x/bz0R
         vvH7ApVDsI9HdP7PwK2731Hj6youlwAyC1/52AZs1GJwOzPS7J7D9bibgpMJEwYZVgD7
         U+Oa9DSsIbqpwOnz6UrXfmyUt0zontzCz5AJY=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1250024143.7091.7.camel@laptop>
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com>
	 <1250006744.10001.29.camel@twins>
	 <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com>
	 <1250024143.7091.7.camel@laptop>
Date: Tue, 11 Aug 2009 23:08:56 +0200
Message-ID: <7c86c4470908111408x256e294i13ac90035fd8f5c8@mail.gmail.com>
Subject: Re: perf_counters issue with PERF_SAMPLE_GROUP
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 10:55 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Tue, 2009-08-11 at 21:40 +0200, stephane eranian wrote:
>
>> > You seem to have forgotten to append your test.c though :-)
>> >
>> Can't send you the program because it uses extra bits and pieces
>> which are hard to remove. Otherwise I would have send it already.
>
> Those other bits aren't open source? tskk :-)
>

You don't know me well!
They will be but they are not ready yet.

>> But I think it boils down to the following piece of code in
>> perf_counter_output():
>>                 leader = counter->group_leader;
>>                 list_for_each_entry(sub, &leader->sibling_list, list_entry) {
>>                         if (sub != counter)
>>                                 sub->pmu->read(sub);
>>
>>                         group_entry.id = primary_counter_id(sub);
>>                         group_entry.counter = atomic64_read(&sub->count);
>>
>>                         perf_output_put(&handle, group_entry);
>>                 }
>
> Well, likely, but nothing obviously wrong stands out there, so now I get
> to write a reproduces to see what's going wrong.
>

>> >> Related to PERF_SAMPLE_GROUP, I believe there is some information missing.
>> >> You need to provide the TIMING information because in the case of SAMPLE_GROUP
>> >> you'd like to be able to scale the values of the counters you are
>> >> collecting. And you
>> >> need the timing at the moment, the sample was recorded not later.
>> >
>> > Right, so something like the below, possibly complemented with having
>> > PERF_COUNTER_IOC_RESET also reset the run-times?
>> >
>> Yes, but don't you have a namespace issue between PERF_FORMAT_* and
>> PERF_SAMPLE_* in the patch below? I would think you want to keep them separate.
>
> Maybe, otoh we've consistently used it whenever exposing the timing
> data.
>
How do you make sure the bits used by the PERF_FORMAT_* stuff does not collide
with PERF_SAMPLE_*?

>> I am also wondering about why one would want one timing value and not the other.
>> In other words, why not group them under a single name. But maybe it is harder
>> to return more than one u64 per PERF_FORMAT?
>
> Not really, Paul did it like that initially and we've been consistently
> doing it like that -- changing it now is a bit late.
>

But aren't you going to change the cpu, pid target stuff we discussed a couple
of weeks ago anyway?
