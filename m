Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYH0Vhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYH0Vhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYH0Vhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:37:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45747 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYH0Vhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:37:37 -0400
Date: Wed, 27 Aug 2008 23:38:54 +0200
From: Pavel Machek <pavel@suse.cz>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86_64 UV: Use blinking LED for heartbeat display
Message-ID: <20080827213853.GC9342@elf.ucw.cz>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com> <20080808005652.543469000@polaris-admin.engr.sgi.com> <20080811160235.GC4524@elte.hu> <20080813095715.GB27074@atrey.karlin.mff.cuni.cz> <48B46D5C.5020504@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B46D5C.5020504@sgi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-26 13:53:48, Mike Travis wrote:
> Pavel Machek wrote:
> >> * Mike Travis <travis@sgi.com> wrote:
> >>
> >>> +#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
> >>> +static void uv_display_heartbeat(void)
> >>> +{
> >>> +	int cpu;
> >>> +
> >>> +	uv_hub_info->led_heartbeat_count = nr_cpu_ids;
> >>> +
> >>> +	for_each_online_cpu(cpu) {
> >>> +		struct uv_hub_info_s *hub = uv_cpu_hub_info(cpu);
> >>> +
> >>> +		if (hub->led_heartbeat_count > 0) {
> >>> +			uv_set_led_bits_on(cpu, LED_CPU_BLINK,
> >>> +						LED_CPU_HEARTBEAT);
> >>> +			--hub->led_heartbeat_count;
> >>> +		}
> >> this too is a bad idea. Imagine 16K cores and assume that each such 
> >> iteration takes a few usecs (we write cross CPU) and you've got a 
> >> GHz-ish CPU. That can easily be _milliseconds_ of delay (or more) - and 
> >> in a function (the clocksource watchdog) that is all about precise 
> >> timings.
> >>
> >> It is also very non-preemptable.
> > 
> > LED subsystem already has nice heartbeat trigger.
> > 									Pavel
> 
> From Documentation/leds-class.txt:

> Future Development
> ==================
> 
> At the moment, a trigger can't be created specifically for a single LED.
> There are a number of cases where a trigger might only be mappable to a
> particular LED (ACPI?). The addition of triggers provided by the LED driver
> should cover this option and be possible to add without breaking the
> current interface.

I don't think this affects you.

> --
> The SGI system has a set of leds per cpu, and the goal is that the leds
> display heartbeat and "idle-ness" information specific to that cpu.  At
> first glance I don't see this capability in the LED subsystem.  Am I
> missing something?

Set the heartbeat trigger to the led you care about. Should be doable
with simple echo to /sys after you implement your leds properly.

> Additionally, the 8 leds are written as one byte with each led being
> full on or full off.  It seems to be a big overhead to support the led
> class  since I'd have to kluge together some means of sharing the current
> led register value [we really don't want to have to read the current reg
> value before updating a single led.]

Big overhead? Just use shadow register of led state in ram.

> But I will definitely look at the led_heartbeat_function more closely.
> 
> Any advice gladly welcomed!

You still did not cc LED developers.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
