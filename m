Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0CJT3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 14:29:47 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:32738 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0CJT3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 14:29:45 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lab9bhzz1202hzzz32i2a8h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KZ2ZH7-01-M5H-02
X-M-MSG: 
Date: Wed, 10 Mar 2010 20:29:28 +0100
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
Message-ID: <20100310192928.GD7219@erda.amd.com>
References: <20100310183102.GC8070@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100310183102.GC8070@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Mar 2010 19:29:28.0564 (UTC) FILETIME=[003E2B40:01CAC088]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.03.10 21:31:02, Cyrill Gorcunov wrote:
>  arch/x86/include/asm/perf_event.h      |    2 
>  arch/x86/include/asm/perf_p4.h         |  707 +++++++++++++++++++++++++++++++++

If so, it should be perf_event_p4.h.

>  arch/x86/kernel/cpu/perf_event.c       |   46 +-
>  arch/x86/kernel/cpu/perf_event_amd.c   |    2 
>  arch/x86/kernel/cpu/perf_event_intel.c |   15 
>  arch/x86/kernel/cpu/perf_event_p4.c    |  612 ++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/perf_event_p6.c    |    2 
>  7 files changed, 1363 insertions(+), 23 deletions(-)

> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> @@ -190,6 +190,8 @@ struct x86_pmu {
>  	void		(*enable_all)(void);
>  	void		(*enable)(struct perf_event *);
>  	void		(*disable)(struct perf_event *);
> +	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
> +	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);

I don't like this extension since it widened the interface without
additional use.

(*hw_config) could be instead implemented in (*event_map).
(*schedule_events) could be implemented by a special p4 handler for
(*enable) in struct pmu. Maybe there are other solutions for both
cases, but it should be possible by adoption of existing functions.

The current implementation of model specific functions is
sufficient. We have already the following:

* event initialization: x86_pmu.raw_event(), x86_pmu.event_map()
* event enable:   event->pmu->enable(), x86_pmu.enable()
* event disable:  event->pmu->disable(), x86_pmu.disable()

Maybe I miss something in the list above. The introduction of more
function pointers should be reduced to a minimum.

If the pmu differs heavily you even could return a different pmu for
such an event.

-Robert

>  	unsigned	eventsel;
>  	unsigned	perfctr;
>  	u64		(*event_map)(int);
> @@ -415,6 +417,25 @@ set_ext_hw_attr(struct hw_perf_event *hw
>  	return 0;
>  }

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

