Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbXKGUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbXKGUbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXKGUbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:31:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbXKGUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:31:34 -0500
Date: Wed, 7 Nov 2007 12:30:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: is minimum udelay() not respected in preemptible SMP
 kernel-2.6.23?
Message-Id: <20071107123045.c6d4b855.akpm@linux-foundation.org>
In-Reply-To: <200711071921.52330.mitov@issp.bas.bg>
References: <200711071921.52330.mitov@issp.bas.bg>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 7 Nov 2007 19:21:52 +0200 Marin Mitov <mitov@issp.bas.bg> wrote:
> Hi all,
> 
> I have written a linux device driver for a frame grabber I use in my 
> every day experimental work.
> 
> In my device driver I have to write to a MMIO register, wait for a while 
> (using udelay(65)) for data being written to an internal register (i2c?)
> and test a flag (in another MMIO register) if the operation has completed. 
> (The hardware guarantees that the operation has completed in less than 
> 65 usec). If the flag is not reset I write a message via printk.
> After switching to the kernel-2.6.23 (compiled as PREEMPTIBLE SMP i686)
> (AMD dual core) I see this message in dmesg output sometime.
> 
> Testing with rdtscll() before and after udelay(65) shows the expected
> delay of 65 usec (after dividing by CPU frequency) when all is OK, but
> gives a big value (in the tenths msec range) when the error message 
> shows itself in dmesg. 
> 
> Bracketing udelay(65) by:
> 
> local_irq_disable();
> udelay(65);
> local_irq_enable();
> 
> as well as by
> 
> preempt_disable();
> udelay(65); 
> preempt_enable();
> 
> leads to message disappearing.
> 
> I believe the hardware is working correctly, so if the flag is not reset 
> I think udelay(65) returns prematurely (the flag clears some time latter)
> And it does not matter if I use udelay(65) or udelay(100).
> 
> What could be the reason for such a behavior?
> Is this a bug in udelay() due to preemption?
> (udelay() being preempted and migrated to another processor)
> 
> All my previous kernels used were SMP (but not PREEMPTIBLE)
> 
> My kernel is compiled with:
> CONFIG_PREEMPT=y
> CONFIG_IRQBALANCE=y
> CONFIG_HPET_TIMER=y
> 
> And I have this line in dmesg:
> Time: acpi_pm clocksource has been installed.
> Switched to high resolution mode on CPU 0
> Switched to high resolution mode on CPU 1
> 
> The south bridge is: VIA VT8237 (Asus A8V Delux)
> 
> Thank you in advance for your help in understanding  where
> the problem is coming from.
> 

Ow.  Yes, from my reading delay_tsc() can return early (or after
heat-death-of-the-universe) if the TSCs are offset and if preemption
migrates the calling task between CPUs.

I suppose a lameo fix would be to disable preemption in delay_tsc().
