Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971Ab0AQOmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0AQOmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952Ab0AQOmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:42:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24671 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0AQOmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:42:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=h3DZrm97jHRsuXfZrmDdz5EEy7p4I67/WQ5kMdpLgNDrxOYVeul3CNAtPoHUASW5O
	S2Gdys12aKIWUsUKZLTiQ==
MIME-Version: 1.0
In-Reply-To: <20100117141233.GF5035@nowhere>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <1263312616.4244.153.camel@laptop>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
	 <1263400193.4244.238.camel@laptop>
	 <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com>
	 <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
	 <20100117141233.GF5035@nowhere>
Date: Sun, 17 Jan 2010 15:42:16 +0100
Message-ID: <bd4cb8901001170642w5d0b79b6jdbb5190a297f45b6@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,


Here is what I have now in the x86 code.

As for your comment on disabling the x86 event, we don't
need to do this because it is not actually activated yet when
we return from hw_perf_group_sched_in(). Activation occurs
really in hw_perf_enable().


static int x86_event_sched_in(struct perf_event *event,
                          struct perf_cpu_context *cpuctx, int cpu)
{
        int ret = 0;

        event->state = PERF_EVENT_STATE_ACTIVE;
        event->oncpu = cpu;
        event->tstamp_running += event->ctx->time - event->tstamp_stopped;

        if (is_software_event(event))
                ret = event->pmu->enable(event);

        if (!ret && !is_software_event(event))
                cpuctx->active_oncpu++;

        if (!ret && event->attr.exclusive)
                cpuctx->exclusive = 1;

        return ret;
}

static void x86_event_sched_out(struct perf_event *event,
                            struct perf_cpu_context *cpuctx, int cpu)
{
        event->state = PERF_EVENT_STATE_INACTIVE;
        event->oncpu = -1;

        event->tstamp_running -= event->ctx->time - event->tstamp_stopped;

        if (is_software_event(event))
                event->pmu->disable(event);

        if (!is_software_event(event))
                cpuctx->active_oncpu--;

        if (event->attr.exclusive || !cpuctx->active_oncpu)
                cpuctx->exclusive = 0;
}


On Sun, Jan 17, 2010 at 3:12 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Jan 13, 2010 at 06:22:54PM +0100, Stephane Eranian wrote:
>> Ok,
>>
>> Something like that should problably do it:
>>
>> static void event_sched_out(struct perf_event *event, int cpu)
>> {
>>         event->state = PERF_EVENT_STATE_INACTIVE;
>>         event->oncpu = -1;
>> }
>
>
>
> You need to also call pmu->disable() if it is a software event,
> because a breakpoint needs to be unregistered in hardware level
> too.
>
> And disable it in x86 level if it is an x86 event?
>
>
>
>> hw_perf_group_sched_in()
>> {
>>        ....
>>        n = 1;
>>         list_for_each_entry(sub, &leader->sibling_list, group_entry) {
>>                 if (sub->state > PERF_EVENT_STATE_OFF) {
>>                         ret = event_sched_in(sub, cpu);
>>                         if (ret)
>>                                 goto undo;
>
>
>
> Yeah we indeed really need to check that.
>
> Thanks.
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
