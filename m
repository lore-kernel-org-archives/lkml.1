Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab0CCRiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:38:21 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:57750
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755259Ab0CCRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:38:19 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lab9bhzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYPVNE-02-A5O-02
X-M-MSG: 
Date: Wed, 3 Mar 2010 18:38:02 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, fweisbec@gmail.com
Subject: Re: [RFC][PATCH 06/11] perf, x86: PEBS infrastructure
Message-ID: <20100303173802.GL13205@erda.amd.com>
References: <20100303163936.906011640@chello.nl>
 <20100303164306.299625712@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100303164306.299625712@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Mar 2010 17:38:03.0306 (UTC) FILETIME=[46A080A0:01CABAF8]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.03.10 17:39:42, Peter Zijlstra wrote:
> Implement a simple PEBS model that always takes a single PEBS event at
> a time. This is done so that the interaction with the rest of the
> system is as expected (freq adjust, period randomization, lbr).
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---

[...]

> +static int validate_event(struct perf_event *event)
> +{
> +	struct cpu_hw_events *fake_cpuc;
> +	struct event_constraint *c;
> +	int ret = 0;
> +
> +	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
> +	if (!fake_cpuc)
> +		return -ENOMEM;
> +
> +	c = x86_pmu.get_event_constraints(fake_cpuc, event);
> +
> +	if (!c || !c->weight)
> +		ret = -ENOSPC;
> +
> +	if (x86_pmu.put_event_constraints)
> +		x86_pmu.put_event_constraints(fake_cpuc, event);

A fake cpu with the struct filled with zeros will cause a null pointer
exception in amd_get_event_constraints():

	struct amd_nb *nb = cpuc->amd_nb;

Shouldn't x86_schedule_events() sufficient to decide if a single
counter is available? I did not yet look at group events, this might
happen there too.

-Robert

> +
> +	kfree(fake_cpuc);
> +
> +	return ret;
> +}
> +
> +/*
>   * validate a single event group
>   *
>   * validation include:
> @@ -1495,6 +1426,8 @@ const struct pmu *hw_perf_event_init(str
>  
>  		if (event->group_leader != event)
>  			err = validate_group(event);
> +		else
> +			err = validate_event(event);
>  
>  		event->pmu = tmp;
>  	}

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

