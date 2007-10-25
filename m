Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbXJYVQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbXJYVQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXJYVQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:16:07 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:4655 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbXJYVQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:16:06 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47210780.2060706@am.sony.com>
Date: Thu, 25 Oct 2007 14:15:44 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: IRQ off latency of printk is very high
References: <4720F21F.9090404@am.sony.com> <20071025201948.GO17536@waste.org>
In-Reply-To: <20071025201948.GO17536@waste.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2007 21:15:53.0800 (UTC) FILETIME=[39FE9C80:01C8174C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Thu, Oct 25, 2007 at 12:44:31PM -0700, Tim Bird wrote:
>> I've been looking at 'IRQ off' latency in the Linux kernel, on
>> version 2.6.22 for target using an ARM processor.
>> I use a serial console, at 115200 bps.
> 
> Printk to the serial console uses polled I/O to get deterministic,
> reliable, and -timely- output. If our very next statement (or interrupt)
> may lock up the box, we want to be sure our printk has actually been
> delivered before that happens.

Whether the actual output uses polled I/O doesn't seem to matter.
release_console_sem() (which is where the chars drain out)
used to be called with interrupts enabled (up to at about v. 2.6.17).

While the cpu is in the printk code itself any submitted printks will go
to the log buffer.  It's the draining that's running with
ints off.

> Kindof a bummer for realtime, but also rather hard to get around.

Ingo moved the irq_restore to below the release_console_sem()
call, with this commit: a0f1ccfd8d...  Up until then it had
been before the call to release_console_sem.

Here's the code before Ingo's change:
		printk_cpu = UINT_MAX;
		spin_unlock_irqrestore(&logbuf_lock, flags);

		/*
		 * Console drivers may assume that per-cpu resources have
		 * been allocated. So unless they're explicitly marked as
		 * being able to cope (CON_ANYTIME) don't call them until
		 * this CPU is officially up.
		 */
		if (cpu_online(smp_processor_id()) || have_callable_console()) {
			console_may_schedule = 0;
			release_console_sem();
		} else {
			/* Release by hand to avoid flushing the buffer. */
			console_locked = 0;
			up(&console_sem);
		}

And here's the code after:
		printk_cpu = UINT_MAX;
		spin_unlock(&logbuf_lock);

		/*
		 * Console drivers may assume that per-cpu resources have
		 * been allocated. So unless they're explicitly marked as
		 * being able to cope (CON_ANYTIME) don't call them until
		 * this CPU is officially up.
		 */
		if (cpu_online(smp_processor_id()) || have_callable_console()) {
			console_may_schedule = 0;
			release_console_sem();
		} else {
			/* Release by hand to avoid flushing the buffer. */
			console_locked = 0;
			up(&console_sem);
		}
		lockdep_on();
		local_irq_restore(flags);

In even earlier versions of the kernel, the irqrestore was just before
the call to release_console_sem().

I'm just trying to see if the irq_restore can be moved back
where it was, or if there's more going on.
 -- Tim



=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

