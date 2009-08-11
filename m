Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZHKTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZHKTkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZHKTkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:40:53 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:59389 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbZHKTkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=wVPtRJ4PiTrBihqCeP3jq7tBefbREDt9Obe1lBn3v3dKzAcgFk2JUuJVn+FW5gr/5g
         m537Kh4w0hwP5tViNbN2G9i945nIg6s+ztgVreDBibQ007nRk3HWrzxT1KYl9+UljKdp
         ViBrS/g2xvtkrEbx5cG8p3uwkbsejFu1ruJFQ=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1250006744.10001.29.camel@twins>
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com>
	 <1250006744.10001.29.camel@twins>
Date: Tue, 11 Aug 2009 21:40:51 +0200
Message-ID: <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com>
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

On Tue, Aug 11, 2009 at 6:05 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Tue, 2009-08-11 at 17:41 +0200, stephane eranian wrote:
>> Hi,
>>
>> It seems to me there is a problem with the group counter values
>> when you use PERF_SAMPLE_GROUP. The counts are bogus
>> for all events.
>>
>> Test case is pretty simple:
>>     - single group, 2 events
>>     - sampling on PERF_COUNT_HW_CYCLES
>>     - other event is PERF_COUNT_HW_CYCLES
>>     - leader has SAMPLE_IP|SAMPLE_GROUP
>>     - no inheritance
>>     - single thread
>>     - using sampling in one shot mode with PERF_COUNTER_IOC_REFRESH
>>     - all events but leader start with disabled = 0 (i.e., enabled)
>>     - sampling period is 240000000 (cycles)
>>
>> Notification 1: ip=0x401300  39100608 PERF_COUNT_HW_CPU_CYCLES (12)
>> Notification 2: ip=0x401300  17991616 PERF_COUNT_HW_CPU_CYCLES (12)
>> Notification 3: ip=0x401300  17981248 PERF_COUNT_HW_CPU_CYCLES (12)
>> Notification 4: ip=0x401300  9409478912 PERF_COUNT_HW_CPU_CYCLES (12)
>>
>> I would expect the value for the 2nd event to be close to 240000000.
>> But instead,
>> it is going up and down. The IP, nr and id (12) fields are correct, so
>> the parsing of
>> the buffer is correct. This is with the latest from Linus's 2.6.31-rc5.
>
> Could have broken somewhere along the line, the group stuff doesn't get
> tested a lot, if at all.
>
> perf used to have some support for it, not sure what the current state
> is.
>
> You seem to have forgotten to append your test.c though :-)
>
Can't send you the program because it uses extra bits and pieces
which are hard to remove. Otherwise I would have send it already.
But I think it boils down to the following piece of code in
perf_counter_output():
                leader = counter->group_leader;
                list_for_each_entry(sub, &leader->sibling_list, list_entry) {
                        if (sub != counter)
                                sub->pmu->read(sub);

                        group_entry.id = primary_counter_id(sub);
                        group_entry.counter = atomic64_read(&sub->count);

                        perf_output_put(&handle, group_entry);
                }


>> Related to PERF_SAMPLE_GROUP, I believe there is some information missing.
>> You need to provide the TIMING information because in the case of SAMPLE_GROUP
>> you'd like to be able to scale the values of the counters you are
>> collecting. And you
>> need the timing at the moment, the sample was recorded not later.
>
> Right, so something like the below, possibly complemented with having
> PERF_COUNTER_IOC_RESET also reset the run-times?
>
Yes, but don't you have a namespace issue between PERF_FORMAT_* and
PERF_SAMPLE_* in the patch below? I would think you want to keep them separate.

I am also wondering about why one would want one timing value and not the other.
In other words, why not group them under a single name. But maybe it is harder
to return more than one u64 per PERF_FORMAT?

> ---
>  include/linux/perf_counter.h |    3 +++
>  kernel/perf_counter.c        |   20 ++++++++++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index 2b36afe..44a056b 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -365,10 +365,13 @@ enum perf_event_type {
>         *      { u64                   period;   } && PERF_SAMPLE_PERIOD
>         *
>         *      { u64                   nr;
> +        *        { u64         time_enabled; } && PERF_FORMAT_ENABLED
> +        *        { u64         time_running; } && PERF_FORMAT_RUNNING
>         *        { u64 id, val; }      cnt[nr];  } && PERF_SAMPLE_GROUP
>         *
>         *      { u64                   nr,
>         *        u64                   ips[nr];  } && PERF_SAMPLE_CALLCHAIN
> +        *
>         *      { u32                   size;
>         *        char                  data[size];}&& PERF_SAMPLE_RAW
>         * };
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index e26d2fc..e61e701 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -2636,6 +2636,7 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
>  {
>        int ret;
>        u64 sample_type = counter->attr.sample_type;
> +       u64 read_format = counter->attr.read_format;
>        struct perf_output_handle handle;
>        struct perf_event_header header;
>        u64 ip;
> @@ -2703,6 +2704,10 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
>        if (sample_type & PERF_SAMPLE_GROUP) {
>                header.size += sizeof(u64) +
>                        counter->nr_siblings * sizeof(group_entry);
> +               if (read_format & PERF_FORMAT_ENABLED)
> +                       header.size += sizeof(u64);
> +               if (read_format & PERF_FORMAT_RUNNING)
> +                       header.size += sizeof(u64);
>        }
>
>        if (sample_type & PERF_SAMPLE_CALLCHAIN) {
> @@ -2765,9 +2770,20 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
>         */
>        if (sample_type & PERF_SAMPLE_GROUP) {
>                struct perf_counter *leader, *sub;
> -               u64 nr = counter->nr_siblings;
> +               u64 val;
> +
> +               val = counter->nr_siblings;
> +               perf_output_put(&handle, val);
>
> -               perf_output_put(&handle, nr);
> +               if (read_format & PERF_FORMAT_ENABLED) {
> +                       val = counter->total_time_enabled;
> +                       perf_output_put(&handle, val);
> +               }
> +
> +               if (read_format & PERF_FORMAT_RUNNING) {
> +                       val = counter->total_time_running;
> +                       perf_output_put(&handle, val);
> +               }
>
>                leader = counter->group_leader;
>                list_for_each_entry(sub, &leader->sibling_list, list_entry) {
>
>
>
