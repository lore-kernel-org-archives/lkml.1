Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0CJTnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 14:43:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:7802 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0CJTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 14:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wtVpDzL247pCJKUt7AfetiqI96Uyoqw6j5/uqHu09rkMjIpuS4T2pUQwAa3tFCmEkK
         LORoKdSTxCtARUw4pJxa7Ndh5FKqQ3EOAnTnSxvN5yPZe3KLgCFSBuZgGArEf8l53u16
         sKLeTIzxqA0tmzYrPJpjXCZELhllzKe8Gjmi0=
Date: Wed, 10 Mar 2010 22:43:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
Message-ID: <20100310194344.GD8070@lenovo>
References: <20100310183102.GC8070@lenovo> <20100310192928.GD7219@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310192928.GD7219@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 08:29:28PM +0100, Robert Richter wrote:
> On 10.03.10 21:31:02, Cyrill Gorcunov wrote:
> >  arch/x86/include/asm/perf_event.h      |    2 
> >  arch/x86/include/asm/perf_p4.h         |  707 +++++++++++++++++++++++++++++++++
> 
> If so, it should be perf_event_p4.h.
> 

Accepted, thanks!

> >  arch/x86/kernel/cpu/perf_event.c       |   46 +-
> >  arch/x86/kernel/cpu/perf_event_amd.c   |    2 
> >  arch/x86/kernel/cpu/perf_event_intel.c |   15 
> >  arch/x86/kernel/cpu/perf_event_p4.c    |  612 ++++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/perf_event_p6.c    |    2 
> >  7 files changed, 1363 insertions(+), 23 deletions(-)
> 
> > Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> > =====================================================================
> > --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> > +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> > @@ -190,6 +190,8 @@ struct x86_pmu {
> >  	void		(*enable_all)(void);
> >  	void		(*enable)(struct perf_event *);
> >  	void		(*disable)(struct perf_event *);
> > +	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
> > +	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
> 
> I don't like this extension since it widened the interface without
> additional use.
> 
> (*hw_config) could be instead implemented in (*event_map).

Well, I fear I don't see how exactly. event_map has the event number
without any-kind of attributes, or you mean to extend event_map up that
way to pass attribs there as well?

> (*schedule_events) could be implemented by a special p4 handler for
> (*enable) in struct pmu. Maybe there are other solutions for both
> cases, but it should be possible by adoption of existing functions.
> 

Assignment scheme is completely different from those which are in
use for architectural events.

> The current implementation of model specific functions is
> sufficient. We have already the following:
> 
> * event initialization: x86_pmu.raw_event(), x86_pmu.event_map()
> * event enable:   event->pmu->enable(), x86_pmu.enable()
> * event disable:  event->pmu->disable(), x86_pmu.disable()
> 
> Maybe I miss something in the list above. The introduction of more
> function pointers should be reduced to a minimum.
> 
> If the pmu differs heavily you even could return a different pmu for
> such an event.
> 

This would require much more code and will lead to a code duplication
as well.

> -Robert
> 

All in one, Robert, I would like to make this code less intrusive into
the former perf sources. But at moment I don't see an easy way for this.

Which means -- I would like to collect comments/complains and so on
to improve it.

> >  	unsigned	eventsel;
> >  	unsigned	perfctr;
> >  	u64		(*event_map)(int);
> > @@ -415,6 +417,25 @@ set_ext_hw_attr(struct hw_perf_event *hw
> >  	return 0;
> >  }
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
> 
	-- Cyrill
