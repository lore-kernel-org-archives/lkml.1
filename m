Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZAZQIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZAZQIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZAZQIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:08:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbZAZQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:08:12 -0500
Date: Mon, 26 Jan 2009 08:07:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in
 preemptible
In-Reply-To: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901260807290.5284@localhost.localdomain>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 Jan 2009, Maciej Rutecki wrote:
>
> During suspend to ram:
> [  131.287012] BUG: using smp_processor_id() in preemptible [00000000]
> code: suspend_to_ram./2958
> [  131.287012] caller is retrigger_next_event+0x13/0xb0
> [  131.287012] Pid: 2958, comm: suspend_to_ram. Not tainted 2.6.29-rc2 #1
> [  131.287012] Call Trace:
> [  131.287012]  [<c025b41f>] debug_smp_processor_id+0xbf/0xd0
> [  131.287012]  [<c01473b3>] retrigger_next_event+0x13/0xb0
> [  131.287012]  [<c01489b7>] raw_notifier_call_chain+0x17/0x20
> [  131.287012]  [<c014b938>] timekeeping_resume+0xe8/0x110
> [  131.287012]  [<c02cc651>] __sysdev_resume+0x11/0x50
> [  131.287012]  [<c02cc6d7>] sysdev_resume+0x47/0x80
> [  131.287012]  [<c02d2478>] device_power_up+0x8/0x10

Very scary.

device_power_up() calls sysdev_resume _before_ it enables interrupts so it 
sounds like something else has - very incorrectly - enabled interrupts too 
early in your resume sequence. 

The patch that Andrew sent out and that apparently fixed things for you 
should absolutely not have made any difference. This is suspend_enter():

	        arch_suspend_disable_irqs();
	        BUG_ON(!irqs_disabled());

	        if ((error = device_power_down(PMSG_SUSPEND))) {
	                printk(KERN_ERR "PM: Some devices failed to power down\n");
	                goto Done;
	        }
	
	        if (!suspend_test(TEST_CORE))
	                error = suspend_ops->enter(state);

	        device_power_up(PMSG_RESUME);
	 Done:
	        arch_suspend_enable_irqs();

and notice how the whole thing is surrounded by that 
arch_suspend_disable/enable_irqs().

So it looks like some sysdev driver (device_power_up does the sysdev 
drivers first, so it can't be the regular low-level PCI drivers) is 
enabling interrupts in its resume function. Scary and very wrong.

It could easily be ACPI, of course. There was some other case where ACPI 
did that, iirc.

		Linus
