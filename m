Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab0BOUch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:32:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:30759 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0BOUcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:32:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XmsbQF4tfsn53vP2vdZm1QIp2zpB0BbjczpvgdY/BRLt1JYpZDUD4RBhoBzkiHGVOY
         5GJyiHySjgJ1UyUFjrx1ZaqvpPqULj5sPBQx9JaIjFVL56cj8mfFzm+SS///2IpES/Bb
         yfFAW7KGa0d3sAEwQuVyRj1E6vw5zdALJ35RM=
Date: Mon, 15 Feb 2010 23:32:30 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC perf,x86] P4 PMU early draft
Message-ID: <20100215203230.GE5119@lenovo>
References: <20100208184504.GB5130@lenovo> <20100215201102.GN13205@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215201102.GN13205@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 09:11:02PM +0100, Robert Richter wrote:
> On 08.02.10 21:45:04, Cyrill Gorcunov wrote:
> > Hi all,
> > 
> > first of all the patches are NOT for any kind of inclusion. It's not
> > ready yet. More likely I'm asking for glance review, ideas, criticism.
> > 
> > The main problem in implementing P4 PMU is that it has much more
> > restrictions for event to MSR mapping. So to fit into current
> > perf_events model I made the following:
> > 
> > 1) Event representation. P4 uses a tuple of ESCR+CCCR+COUNTER
> >    as an "event". Since every CCCR register mapped directly to
> >    counter itself and ESCR and CCCR uses only 32bits of their
> >    appropriate MSRs, I decided to use "packed" config in
> >    in hw_perf_event::config. So that upper 31 bits are ESCR
> >    and lower 32 bits are CCCR values. The bit 64 is for HT flag.
> > 
> >    So the base idea here is to pack into 64bit hw_perf_event::config
> >    as much info as possible.
> > 
> >    Due to difference in bitfields I needed to implement
> >    hw_perf_event::config helper which unbind hw_perf_event::config field
> >    from processor specifics and allow to use it in P4 PMU.
> 
> If we introduce model specific configuration, we should put more model
> specific code in here and then remove
> 
>   u64             (*raw_event)(u64);
> 
> in struct x86_pmu.
> 

It seems we should still support raw_events, if I understand the idea
right -- raw_events could be used for say OProfile (if we are going
to substitute oprofile with perfevents subsystem). So the only
difference with other architectural events is that raw_event
need to be "packed" before being set into.

Putting/packing more specific code into config could make code
even more complex. Dunno Robert...

> > 3) I've started unbinding x86_schedule_events into per x86_pmu::schedule_events
> >    and there I hit hardness in binding HT bit. Have to think...
> 
> Instead of implemting x86_pmu.schedule_events() you should rather
> abstract x86_pmu_enable(). This will be much more flexible to
> implement other model spcific features.

But I would need collect events and so on -- ie code duplication
will be there. Or you mean something else?

> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
> 
	-- Cyrill
