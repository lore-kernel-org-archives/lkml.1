Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046Ab0AQQTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0AQQTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994Ab0AQQTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:19:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:18855 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0AQQTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ku+jZq08XqSoE7SUUcleS2aQOAMrzTgCO66YQZpwGRVhtxDPnnuja7ao1QFMiNBfe3
         G1enx6X1qbyrzpBMEAIcNif+t26ZgltRDsrSYEvJj02b1jVfUoqDJbg6NK7C5XNpJ163
         5wOMkAston/5SMGuZfcH7F23EK1zfeMDKBQAs=
Date: Sun, 17 Jan 2010 17:19:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
Subject: Re: [PATCH] perf_events: improve x86 event scheduling
Message-ID: <20100117161859.GG5035@nowhere>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com> <1263312616.4244.153.camel@laptop> <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com> <1263400193.4244.238.camel@laptop> <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com> <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com> <20100117141233.GF5035@nowhere> <bd4cb8901001170642w5d0b79b6jdbb5190a297f45b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8901001170642w5d0b79b6jdbb5190a297f45b6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 03:42:16PM +0100, Stephane Eranian wrote:
> Frederic,
> 
> 
> Here is what I have now in the x86 code.
> 
> As for your comment on disabling the x86 event, we don't
> need to do this because it is not actually activated yet when
> we return from hw_perf_group_sched_in(). Activation occurs
> really in hw_perf_enable().


Ah, indeed.


> 
> 
> static int x86_event_sched_in(struct perf_event *event,
>                           struct perf_cpu_context *cpuctx, int cpu)
> {
>         int ret = 0;
> 
>         event->state = PERF_EVENT_STATE_ACTIVE;
>         event->oncpu = cpu;
>         event->tstamp_running += event->ctx->time - event->tstamp_stopped;
> 
>         if (is_software_event(event))
>                 ret = event->pmu->enable(event);
> 
>         if (!ret && !is_software_event(event))
>                 cpuctx->active_oncpu++;
> 
>         if (!ret && event->attr.exclusive)
>                 cpuctx->exclusive = 1;
> 
>         return ret;
> }
> 
> static void x86_event_sched_out(struct perf_event *event,
>                             struct perf_cpu_context *cpuctx, int cpu)
> {
>         event->state = PERF_EVENT_STATE_INACTIVE;
>         event->oncpu = -1;
> 
>         event->tstamp_running -= event->ctx->time - event->tstamp_stopped;
> 
>         if (is_software_event(event))
>                 event->pmu->disable(event);
> 
>         if (!is_software_event(event))
>                 cpuctx->active_oncpu--;
> 
>         if (event->attr.exclusive || !cpuctx->active_oncpu)
>                 cpuctx->exclusive = 0;
> }



Yeah looks good.

Thanks.

