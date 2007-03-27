Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbXC0TZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbXC0TZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXC0TZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:25:14 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37131 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXC0TZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:25:10 -0400
X-Greylist: delayed 1227 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 15:25:10 EDT
Subject: Re: [RFC][PATCH 3/3] add the 'menu' cpuidle governor
From: Adam Belay <abelay@novell.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, venkatesh.pallipadi@intel.com,
       linux-acpi@vger.kernel.org
In-Reply-To: 1174887388.5523.7.camel@sli10-conroe.sh.intel.com
References: <1174722427.32554.84.camel@localhost.localdomain>
	 1174887388.5523.7.camel@sli10-conroe.sh.intel.com
Content-Type: text/plain
Date: Tue, 27 Mar 2007 15:04:35 -0400
Message-Id: <1175022275.5599.0.camel@linux-n33p.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 13:36 +0800, Shaohua Li wrote:
> Hi,
> On Sat, 2007-03-24 at 03:47 -0400, Adam Belay wrote:
> > This patch adds the 'menu' governor, as was described in my first email.
> > 
> 
> > +/**
> > + * menu_select - selects the next idle state to enter
> > + * @dev: the CPU
> > + */
> > +static int menu_select(struct cpuidle_device *dev)
> > +{
> > +	struct menu_device *data = &__get_cpu_var(menu_devices);
> > +	int i, expected_us, max_state = dev->state_count;
> > +
> > +	/* discard BM history because it is sticky */
> > +	cpuidle_get_bm_activity();
> Why discard BM history here? This way the next bm check almost always
> return 0.

Yes, although in testing it detects BM activity more often then one
might think, I agree, this is probably too aggressive.  At the time, I
was trying to avoid situations where BM_STS goes high early during a
long busy period and as a result becomes stale.

> BTW, bm activity is global (Not cpu specific), we'd better account it
> system wide.

Yes, but do we need to support BM_STS in the SMP case?

> 
> > +	/* determine the expected residency time */
> > +	expected_us = (s32) ktime_to_ns(tick_nohz_get_sleep_length()) / 1000;
> > +	expected_us = min(expected_us, data->break_last_us);
> > +
> > +	/* determine the maximum state compatible with current BM status */
> > +	if (cpuidle_get_bm_activity())
> > +		data->bm_elapsed_us = 0;
> > +	if (data->bm_elapsed_us <= data->bm_holdoff_us)
> > +		max_state = data->deepest_bm_state + 1;
> > +
> > +	/* find the deepest idle state that satisfies our constraints */
> > +	for (i = 1; i < max_state; i++) {
> > +		struct cpuidle_state *s = &dev->states[i];
> > +		if (s->target_residency > expected_us)
> > +			break;
> > +		if (s->exit_latency > system_latency_constraint())
> > +			break;
> > +	}
> > +
> > +	data->last_state_idx = i - 1;
> > +	data->idle_jiffies = tick_nohz_get_idle_jiffies();
> > +	return i - 1;
> > +}
> > +
> > +/**
> > + * menu_reflect - attempts to guess what happened after entry
> > + * @dev: the CPU
> > + *
> > + * NOTE: it's important to be fast here because this operation will add to
> > + *       the overall exit latency.
> > + */
> > +static void menu_reflect(struct cpuidle_device *dev)
> > +{
> > +	struct menu_device *data = &__get_cpu_var(menu_devices);
> > +	int last_idx = data->last_state_idx;
> > +	int measured_us = cpuidle_get_last_residency(dev);
> > +	struct cpuidle_state *target = &dev->states[last_idx];
> > +
> > +	/*
> > +	 * Ugh, this idle state doesn't support residency measurements, so we
> > +	 * are basically lost in the dark.  As a compromise, assume we slept
> > +	 * for one full standard timer tick.  However, be aware that this
> > +	 * could potentially result in a suboptimal state transition.
> > +	 */
> > +	if (!(target->flags & CPUIDLE_FLAG_TIME_VALID))
> > +		measured_us = USEC_PER_SEC / HZ;
> > +
> > +	data->bm_elapsed_us += measured_us;
> > +	data->break_elapsed_us += measured_us;
> See the system state: idle->running->idle
> Looks the bm_elapsed_us and break_elapsed_us account ingored the running
> state between the two idles. Eg, the 'running' might generate a lot of
> bm activity, then maybe we should reset bm_elapsed_us in the next
> 'idle'.

I ignore the time between idle states because I'm only interested in
accounting the idle sleep behavior.  A more sophisticated strategy might
also account the running time between idles in some way.  However, it is
worth noting that a busy system has the indirect effect of shortening
the idle residency times. 

I think removing the BM_STS clear attempt at the beginning should help
to reset bm_elapsed_us after sufficiently long busy periods.

> 
> Thanks,
> Shaohua

Thanks for the feedback.

-Adam


