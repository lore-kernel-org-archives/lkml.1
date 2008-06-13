Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYFMA4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYFMA4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757108AbYFMAz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:55:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbYFMAz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:55:58 -0400
Date: Thu, 12 Jun 2008 17:55:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@infradead.org,
       andreas.herrmann3@amd.com
Subject: Re: [patch 6/6] x86: add c1e aware idle function
Message-Id: <20080612175533.5b6c1736.akpm@linux-foundation.org>
In-Reply-To: <20080610171712.465591661@linutronix.de>
References: <20080610171639.551369443@linutronix.de>
	<20080610171712.465591661@linutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 10:29:00 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> +static void c1e_idle(void)
> +{
> +	static cpumask_t c1e_mask = CPU_MASK_NONE;
> +	static int c1e_detected;
> +
> +	if (need_resched())
> +		return;
> +
> +	if (!c1e_detected) {
> +		u32 lo, hi;
> +
> +		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
> +		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
> +			c1e_detected = 1;
> +			mark_tsc_unstable("TSC halt in C1E");
> +			printk(KERN_INFO "System has C1E enabled\n");
> +		}
> +	}
> +
> +	if (c1e_detected) {
> +		int cpu = smp_processor_id();
> +
> +		if (!cpu_isset(cpu, c1e_mask)) {
> +			cpu_set(cpu, c1e_mask);
> +			/* Force broadcast so ACPI can not interfere */
> +			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
> +					   &cpu);
> +			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
> +			       cpu);
> +		}
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
> +		default_idle();
> +		local_irq_disable();
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> +		local_irq_enable();

I worked it out!  It took me a while.

This function is called with local irqs disabled.

default_idle() is entered with local irqs disabled but returns with them
enabled.

clockevents_notify() is supposed to be called with local irqs disabled.

This functions returns with local irqs enabled.

Was I right?  None of any of that is documented anywhere.  But it should
be.


> +	} else
> +		default_idle();
> +}
