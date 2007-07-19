Return-Path: <linux-kernel-owner+w=401wt.eu-S936761AbXGSHYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936761AbXGSHYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762371AbXGSHXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:23:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757591AbXGSHXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:23:50 -0400
Date: Thu, 19 Jul 2007 00:22:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-Id: <20070719002231.069ebbdd.akpm@linux-foundation.org>
In-Reply-To: <20070717154934.GA24231@elte.hu>
References: <20070717114453.GA8212@elte.hu>
	<469CCF8F.4010107@goop.org>
	<20070717154934.GA24231@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 17:49:34 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> Subject: fix the softlockup watchdog to actually work
> From: Ingo Molnar <mingo@elte.hu>
> 
> this Xen related commit:
> 
>    commit 966812dc98e6a7fcdf759cbfa0efab77500a8868
>    Author: Jeremy Fitzhardinge <jeremy@goop.org>
>    Date:   Tue May 8 00:28:02 2007 -0700
> 
>        Ignore stolen time in the softlockup watchdog
> 
> broke the softlockup watchdog to never report any lockups. (!)
> 
> print_timestamp defaults to 0, this makes the following condition
> always true:
> 
> 	if (print_timestamp < (touch_timestamp + 1) ||
> 
> and we'll in essence never report soft lockups.
> 
> apparently the functionality of the soft lockup watchdog was never
> actually tested with that patch applied ...
> 
> [this is -stable material too.]

This seems terribly sensitive.

Someone has broken the Vaio (shock, horror).  It now has mysterious
jerkiness: when leaning on autorepeat it stalls for maybe 0.25 seconds
every 1.5 seconds.  The stalls are far less than a second.  Yet this
is enough to trigger random softlockup warnings.

Some of those warnings are below.  Note that the traces are all pretty
useless, as softlockup warnings so often seem to be.

Of course, it could be that whatever is causing these pauses really _is_
stalling for a whole second occasionally, dunno.  But I didn't notice any
long stalls in the console output when a particular storm of softlockup
warnings came out.

But I'll sit on this patch for a while until this gets sorted out. 
Meanwhile, please double-check the elapsed-time arithmetic in there,
maybe do a bit of runtime testing?



[   78.820961] BUG: soft lockup detected on CPU#0!
[   78.821083]  [<c0122475>] update_process_times+0x32/0x54
[   78.821216]  [<c012fe7a>] tick_sched_timer+0x61/0x9c
[   78.821340]  [<c012c2e7>] hrtimer_interrupt+0x142/0x1d4
[   78.821463]  [<c012fe19>] tick_sched_timer+0x0/0x9c
[   78.821587]  [<c012f74a>] tick_do_broadcast+0x1f/0x3f
[   78.821707]  [<c012fa01>] tick_handle_oneshot_broadcast+0x47/0x72
[   78.821852]  [<c01067ca>] timer_interrupt+0x1a/0x20
[   78.821968]  [<c014291e>] handle_IRQ_event+0x1a/0x3f
[   78.822089]  [<c0143521>] handle_edge_irq+0x9d/0xcc
[   78.822206]  [<c0105d7b>] do_IRQ+0x53/0x6c
[   78.822307]  [<c012f4f0>] tick_notify+0x15c/0x208
[   78.822422]  [<c01044cf>] common_interrupt+0x23/0x28
[   78.822539]  [<c012f1d4>] clockevents_notify+0x8/0x36
[   78.822663]  [<c020d199>] acpi_processor_idle+0x1d2/0x36d
[   78.822798]  [<c0102345>] cpu_idle+0x44/0x5e
[   78.822900]  [<c03baa8d>] start_kernel+0x26d/0x275
[   78.823017]  [<c03ba3fe>] unknown_bootoption+0x0/0x202
[   78.823142]  =======================
[  106.282830] BUG: soft lockup detected on CPU#0!
[  106.282967]  [<c0122475>] update_process_times+0x32/0x54
[  106.283116]  [<c012fe7a>] tick_sched_timer+0x61/0x9c
[  106.283255]  [<c012c2e7>] hrtimer_interrupt+0x142/0x1d4
[  106.283391]  [<c012fe19>] tick_sched_timer+0x0/0x9c
[  106.283530]  [<c012f74a>] tick_do_broadcast+0x1f/0x3f
[  106.283663]  [<c012fa01>] tick_handle_oneshot_broadcast+0x47/0x72
[  106.283821]  [<c01067ca>] timer_interrupt+0x1a/0x20
[  106.283949]  [<c014291e>] handle_IRQ_event+0x1a/0x3f
[  106.284084]  [<c0143521>] handle_edge_irq+0x9d/0xcc
[  106.284215]  [<c0105d7b>] do_IRQ+0x53/0x6c
[  106.284326]  [<c012f4f0>] tick_notify+0x15c/0x208
[  106.284455]  [<c01044cf>] common_interrupt+0x23/0x28
[  106.284587]  [<c012f1d4>] clockevents_notify+0x8/0x36
[  106.284725]  [<c020d199>] acpi_processor_idle+0x1d2/0x36d
[  106.284875]  [<c0102345>] cpu_idle+0x44/0x5e
[  106.284988]  [<c03baa8d>] start_kernel+0x26d/0x275
[  106.285117]  [<c03ba3fe>] unknown_bootoption+0x0/0x202
[  106.285257]  =======================
[  109.266423] BUG: soft lockup detected on CPU#0!
[  109.266558]  [<c0122475>] update_process_times+0x32/0x54
[  109.266703]  [<c012fe7a>] tick_sched_timer+0x61/0x9c
[  109.270745]  [<c012c2e7>] hrtimer_interrupt+0x142/0x1d4
[  109.274790]  [<c012fe19>] tick_sched_timer+0x0/0x9c
[  109.278865]  [<c012f74a>] tick_do_broadcast+0x1f/0x3f
[  109.282950]  [<c012fa01>] tick_handle_oneshot_broadcast+0x47/0x72
[  109.287026]  [<c01067ca>] timer_interrupt+0x1a/0x20
[  109.291012]  [<c014291e>] handle_IRQ_event+0x1a/0x3f
[  109.294950]  [<c0143521>] handle_edge_irq+0x9d/0xcc
[  109.298864]  [<c0105d7b>] do_IRQ+0x53/0x6c
[  109.302818]  [<c012f4f0>] tick_notify+0x15c/0x208
[  109.306740]  [<c01044cf>] common_interrupt+0x23/0x28
[  109.310641]  [<c012f1d4>] clockevents_notify+0x8/0x36
[  109.314543]  [<c020d199>] acpi_processor_idle+0x1d2/0x36d
[  109.318461]  [<c0102345>] cpu_idle+0x44/0x5e
[  109.322348]  [<c03baa8d>] start_kernel+0x26d/0x275
[  109.326267]  [<c03ba3fe>] unknown_bootoption+0x0/0x202
[  109.330188]  =======================

(ah, the Vaio breakage seems to be -mm-only, whew)

