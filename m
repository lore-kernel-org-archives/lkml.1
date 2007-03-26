Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbXCZFjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbXCZFjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbXCZFjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:39:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:40547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933593AbXCZFjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:39:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,327,1170662400"; 
   d="scan'208"; a="219205727:sNHT30392453"
Subject: Re: [RFC][PATCH 3/3] add the 'menu' cpuidle governor
From: Shaohua Li <shaohua.li@intel.com>
To: Adam Belay <abelay@novell.com>
Cc: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Pallipadi@vger.kernel.org,
       Venkatesh <venkatesh.pallipadi@intel.com>, linux-acpi@vger.kernel.org
In-Reply-To: <1174722427.32554.84.camel@localhost.localdomain>
References: <1174722427.32554.84.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 13:36:28 +0800
Message-Id: <1174887388.5523.7.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sat, 2007-03-24 at 03:47 -0400, Adam Belay wrote:
> This patch adds the 'menu' governor, as was described in my first email.
> 

> +/**
> + * menu_select - selects the next idle state to enter
> + * @dev: the CPU
> + */
> +static int menu_select(struct cpuidle_device *dev)
> +{
> +	struct menu_device *data = &__get_cpu_var(menu_devices);
> +	int i, expected_us, max_state = dev->state_count;
> +
> +	/* discard BM history because it is sticky */
> +	cpuidle_get_bm_activity();
Why discard BM history here? This way the next bm check almost always
return 0.
BTW, bm activity is global (Not cpu specific), we'd better account it
system wide.

> +	/* determine the expected residency time */
> +	expected_us = (s32) ktime_to_ns(tick_nohz_get_sleep_length()) / 1000;
> +	expected_us = min(expected_us, data->break_last_us);
> +
> +	/* determine the maximum state compatible with current BM status */
> +	if (cpuidle_get_bm_activity())
> +		data->bm_elapsed_us = 0;
> +	if (data->bm_elapsed_us <= data->bm_holdoff_us)
> +		max_state = data->deepest_bm_state + 1;
> +
> +	/* find the deepest idle state that satisfies our constraints */
> +	for (i = 1; i < max_state; i++) {
> +		struct cpuidle_state *s = &dev->states[i];
> +		if (s->target_residency > expected_us)
> +			break;
> +		if (s->exit_latency > system_latency_constraint())
> +			break;
> +	}
> +
> +	data->last_state_idx = i - 1;
> +	data->idle_jiffies = tick_nohz_get_idle_jiffies();
> +	return i - 1;
> +}
> +
> +/**
> + * menu_reflect - attempts to guess what happened after entry
> + * @dev: the CPU
> + *
> + * NOTE: it's important to be fast here because this operation will add to
> + *       the overall exit latency.
> + */
> +static void menu_reflect(struct cpuidle_device *dev)
> +{
> +	struct menu_device *data = &__get_cpu_var(menu_devices);
> +	int last_idx = data->last_state_idx;
> +	int measured_us = cpuidle_get_last_residency(dev);
> +	struct cpuidle_state *target = &dev->states[last_idx];
> +
> +	/*
> +	 * Ugh, this idle state doesn't support residency measurements, so we
> +	 * are basically lost in the dark.  As a compromise, assume we slept
> +	 * for one full standard timer tick.  However, be aware that this
> +	 * could potentially result in a suboptimal state transition.
> +	 */
> +	if (!(target->flags & CPUIDLE_FLAG_TIME_VALID))
> +		measured_us = USEC_PER_SEC / HZ;
> +
> +	data->bm_elapsed_us += measured_us;
> +	data->break_elapsed_us += measured_us;
See the system state: idle->running->idle
Looks the bm_elapsed_us and break_elapsed_us account ingored the running
state between the two idles. Eg, the 'running' might generate a lot of
bm activity, then maybe we should reset bm_elapsed_us in the next
'idle'.

Thanks,
Shaohua
