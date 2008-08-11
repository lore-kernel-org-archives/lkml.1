Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYHKPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYHKPxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYHKPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:53:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYHKPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:53:38 -0400
Date: Mon, 11 Aug 2008 17:53:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/6] x86_64 UV: Use LED to indicate CPU is active
Message-ID: <20080811155318.GB4524@elte.hu>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com> <20080808005649.986660000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808005649.986660000@polaris-admin.engr.sgi.com>
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

> +/*
> + * Illuminate "activity" LED when CPU is going "active",
> + * extinguish when going "idle".
> + */
> +static int uv_idle(struct notifier_block *nfb, unsigned long action, void *junk)
> +{
> +	if (action == IDLE_START)
> +		uv_set_led_bits(0, LED_CPU_ACTIVITY);
> +
> +	else if (action == IDLE_END)
> +		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block uv_idle_notifier = {
> +	.notifier_call = uv_idle,
> +};
>  
> +/*
> + * Initialize idle led callback function
> + */
> +static __init void uv_init_led_idle_display(void)
> +{
> +	/* initialize timer for activity monitor */
> +	idle_notifier_register(&uv_idle_notifier);
> +}

hm, i think this is a bad idea. While putting it into the go-to-idle 
codepath probably doesnt matter, putting anything into the idle wakeup 
path increases latency of a rather critical codepath. The MMR write that 
the LED driver is using will go out to the local bus, which, even if 
it's POST-ed, if it's done frequently enough will be the cost of an IO 
cycle.

No human needs to know the LED status at _that_ frequency anyway, so 
it's quite pointless as well.

A much better (and faster) approach would be to sample the utilization 
of the CPU and indicate that via the LED(s).

	Ingo
