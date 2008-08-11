Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYHKQDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYHKQDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbYHKQCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:02:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbYHKQCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:02:53 -0400
Date: Mon, 11 Aug 2008 18:02:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86_64 UV: Use blinking LED for heartbeat display
Message-ID: <20080811160235.GC4524@elte.hu>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com> <20080808005652.543469000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808005652.543469000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> +#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
> +static void uv_display_heartbeat(void)
> +{
> +	int cpu;
> +
> +	uv_hub_info->led_heartbeat_count = nr_cpu_ids;
> +
> +	for_each_online_cpu(cpu) {
> +		struct uv_hub_info_s *hub = uv_cpu_hub_info(cpu);
> +
> +		if (hub->led_heartbeat_count > 0) {
> +			uv_set_led_bits_on(cpu, LED_CPU_BLINK,
> +						LED_CPU_HEARTBEAT);
> +			--hub->led_heartbeat_count;
> +		}

this too is a bad idea. Imagine 16K cores and assume that each such 
iteration takes a few usecs (we write cross CPU) and you've got a 
GHz-ish CPU. That can easily be _milliseconds_ of delay (or more) - and 
in a function (the clocksource watchdog) that is all about precise 
timings.

It is also very non-preemptable.

Why not have a separate per cpu kthread for this that does this in a 
preemptable manner?

Also, why not let each CPU's heartbeat be set in a hierarchy instead of 
by _all_ CPUs. That way you get a nice constant-ish overhead instead of 
the current crazy quadratic(nr_cpus) behavior. I.e. let each CPU be 
monitored by its neighbor (cpu_id + 1), by it's second-order neighbor 
(cpu_id + 2), third-order neighbor (cpu_id + 4), etc.

That still gives pretty good coverage in practice while avoiding the 
quadratic nature.

	Ingo
