Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYHYRzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYHYRzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYHYRzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:55:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59323 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754347AbYHYRzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:55:45 -0400
Message-ID: <48B2F21F.7080001@sgi.com>
Date: Mon, 25 Aug 2008 10:55:43 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86_64 UV: Use blinking LED for heartbeat display
References: <20080808005639.505189000@polaris-admin.engr.sgi.com> <20080808005652.543469000@polaris-admin.engr.sgi.com> <20080811160235.GC4524@elte.hu>
In-Reply-To: <20080811160235.GC4524@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> +#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
>> +static void uv_display_heartbeat(void)
>> +{
>> +	int cpu;
>> +
>> +	uv_hub_info->led_heartbeat_count = nr_cpu_ids;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		struct uv_hub_info_s *hub = uv_cpu_hub_info(cpu);
>> +
>> +		if (hub->led_heartbeat_count > 0) {
>> +			uv_set_led_bits_on(cpu, LED_CPU_BLINK,
>> +						LED_CPU_HEARTBEAT);
>> +			--hub->led_heartbeat_count;
>> +		}
> 
> this too is a bad idea. Imagine 16K cores and assume that each such 
> iteration takes a few usecs (we write cross CPU) and you've got a 
> GHz-ish CPU. That can easily be _milliseconds_ of delay (or more) - and 
> in a function (the clocksource watchdog) that is all about precise 
> timings.
> 
> It is also very non-preemptable.
> 
> Why not have a separate per cpu kthread for this that does this in a 
> preemptable manner?
> 
> Also, why not let each CPU's heartbeat be set in a hierarchy instead of 
> by _all_ CPUs. That way you get a nice constant-ish overhead instead of 
> the current crazy quadratic(nr_cpus) behavior. I.e. let each CPU be 
> monitored by its neighbor (cpu_id + 1), by it's second-order neighbor 
> (cpu_id + 2), third-order neighbor (cpu_id + 4), etc.
> 
> That still gives pretty good coverage in practice while avoiding the 
> quadratic nature.
> 
> 	Ingo

Yes, I agree 100%.  There was a trade off with various approaches but I
was hoping for some feedback on alternate approaches (and thanks for that!)

Mike
