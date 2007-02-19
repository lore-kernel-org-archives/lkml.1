Return-Path: <linux-kernel-owner+w=401wt.eu-S932833AbXBSWQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbXBSWQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXBSWQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:16:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:44258 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbXBSWQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:16:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y6VBPZUIMfTEUmsUDn8GicBQhfW4IxYozXhSB/7GTCrYQ+wb50F/mLX4/1F0X25XLLFEPxhh3Cjg+2QwKYOcMe9nG75PQrEK/iF1Ge2ueW6XpKiHc+sOy/71LiPnvsOU/8HSOOs6sXGKm2SXAUIyT6yubA48E+LcVo+8uldNKgI=
Message-ID: <f2b55d220702191416k479aa8c0gad4f42e306f26ecb@mail.gmail.com>
Date: Mon, 19 Feb 2007 14:16:41 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Jose Goncalves" <jose.goncalves@inov.pt>,
       "Frederik Deweerdt" <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
In-Reply-To: <20070219213151.GJ27370@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070220142442.GF566@slug> <20070220144814.GJ566@slug>
	 <20070219150508.GD27370@flint.arm.linux.org.uk>
	 <45D9D073.7020701@inov.pt>
	 <20070219164200.GF27370@flint.arm.linux.org.uk>
	 <45D9E46C.4030408@inov.pt>
	 <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com>
	 <20070219205153.GH27370@flint.arm.linux.org.uk>
	 <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com>
	 <20070219213151.GJ27370@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > setup_irq() is where things go wrong, at least for us, at least on
> > 2.6.16.x.  Interrupts are not disabled at the point in request_irq()
> > when the interrupt controller is poked to enable the IRQ source.  If
> > you're lucky, and you're on an architecture where the UART interrupt
> > is properly level-triggered, and the worst thing that happens when you
> > attempt to service an interrupt that isn't yours is that it stays on,
> > then you get a soft lockup with two or three recursive __irq_svc hits
> > in the backtrace.  If you're not lucky you do a fandango on core.
>
> That should not happen if your interrupt handling is correct - okay, you
> might get an interrupt at that point, but while servicing that interrupt
> the source will be disabled on the interrupt controller.

Right.  But as soon as you turn the source back on, in the postamble
of the interrupt dispatch handler, it fires again.  At least on ARM,
that gives you recursive hits to __irq_svc and a couple of nested
calls within it.  Here's a backtrace (embedded in a chat log with some
commentary):

6:42 PM me: we have definitely confirmed that the serial ISR is
failing to clear the interrupt and the (presumably level-triggered)
IRQ is firing again on exit from the ISR.

6:43 PM The reason that __do_softirq is usually the last function
entrypoint in the backtrace before the __irq_svc associated with the
timer is that it is the first place where interrupts are enabled
during the IRQ dispatcher postamble.

6:44 PM Here is a backtrace from a case where the timer interrupt hit
during the perpetually firing ISR instead of during the dispatch code
surrounding it (which is not visible in backtraces)

6:45 PM [ 54.230000] Freeing init memory: 92K
[ 52.240000] rcu_do_batch: rcu node is 0xC03D7540, callback is 0xC00864C8
[ 52.240000] rcu_do_batch: rcu node is 0xC02CCDA0, callback is 0xC006E7E4
[ 52.250000] rcu_do_batch: rcu node is 0xC03D7730, callback is 0xC00864C8
[ 52.260000] rcu_do_batch: rcu node is 0xC03D7920, callback is 0xC00864C8
[ 51.240000] BUG: soft lockup detected on CPU#0!
[ 52.240000] [<c0025834>] (dump_stack+0x0/0x14) from [<c0050e40>]
(softlockup_tick+0xa8/0xe8)
[ 52.240000] [<c0050d98>] (softlockup_tick+0x0/0xe8) from [<c003bb18>]
(run_local_timers+0x18/0x1c)
[ 52.240000] r8 = 00010105 r7 = 00000005 r6 = 00000000 r5 = 00000000
[ 52.240000] r4 = C0299B40
[ 52.240000] [<c003bb00>] (run_local_timers+0x0/0x1c) from
[<c003bdec>] (update_process_times+0x50/0x7c)
[ 52.240000] [<c003bd9c>] (update_process_times+0x0/0x7c) from
[<c0024f24>] (timer_tick+0xc4/0xe0)
[ 52.240000] r6 = 00000000 r5 = C029DB48 r4 = C029DB48
[ 52.240000] [<c0024e60>] (timer_tick+0x0/0xe0) from [<c002a79c>]
(mv88w8xx8_timer_interrupt+0x30/0x68)
[ 52.240000] r6 = 00000000 r5 = C029DB48 r4 = C024775C
[ 52.240000] [<c002a76c>] (mv88w8xx8_timer_interrupt+0x0/0x68) from
[<c0020c84>] (__do_irq+0xf0/0x140)
[ 52.240000] r5 = 00000000 r4 = C0204280
6:46 PM [ 52.240000] [<c0020b94>] (__do_irq+0x0/0x140) from
[<c0020f48>] (do_level_IRQ+0x70/0xc8)
[ 52.240000] [<c0020ed8>] (do_level_IRQ+0x0/0xc8) from [<c00212b8>]
(asm_do_IRQ+0x50/0x134)
[ 52.240000] r6 = C029DB48 r5 = C0240E24 r4 = 00000005
[ 52.240000] [<c0021268>] (asm_do_IRQ+0x0/0x134) from [<c001f978>]
(__irq_svc+0x38/0x190)
[ 52.240000] r6 = 00000020 r5 = C029DB7C r4 = FFFFFFFF
[ 52.240000] [<c0020b94>] (__do_irq+0x0/0x140) from [<c0020f48>]
(do_level_IRQ+0x70/0xc8)
[ 52.240000] [<c0020ed8>] (do_level_IRQ+0x0/0xc8) from [<c00212b8>]
(asm_do_IRQ+0x50/0x134)
[ 52.240000] r6 = C029DBFC r5 = C0240F5C r4 = 0000000B
[ 52.240000] [<c0021268>] (asm_do_IRQ+0x0/0x134) from [<c001f978>]
(__irq_svc+0x38/0x190)
[ 52.240000] r6 = 00000800 r5 = C029DC30 r4 = FFFFFFFF
[ 52.240000] [<c0036d68>] (__do_softirq+0x0/0xd8) from [<c00370e0>]
(irq_exit+0x48/0x5c)
[ 52.240000] r6 = C029DC94 r5 = C0240E24 r4 = 00000005
[ 52.240000] [<c0037098>] (irq_exit+0x0/0x5c) from [<c0021384>]
(asm_do_IRQ+0x11c/0x134)
[ 52.240000] [<c0021268>] (asm_do_IRQ+0x0/0x134) from [<c001f978>]
(__irq_svc+0x38/0x190)
[ 52.240000] r6 = 00000820 r5 = C029DCC8 r4 = FFFFFFFF
[ 52.240000] [<c0020968>] (setup_irq+0x0/0x15c) from [<c0020b68>]
(request_irq+0xa4/0xd0)
[ 52.240000] r7 = 00000000 r6 = 00000000 r5 = 0000000B r4 = C0C1B5C0
[ 52.240000] [<c0020ac4>] (request_irq+0x0/0xd0) from [<c0100c24>]
(serial_link_irq_chain+0x264/0x2a0)
[ 52.240000] [<c01009c0>] (serial_link_irq_chain+0x0/0x2a0) from
[<c0101558>] (serial8250_startup+0x2f4/0x4f0)
[ 52.240000] [<c0101264>] (serial8250_startup+0x0/0x4f0) from
[<c00f85ec>] (uart_startup+0x164/0x48c)
 [ 52.240000] [<c00f8488>] (uart_startup+0x0/0x48c) from [<c00fca98>]
(uart_open+0x1a8/0x238)
[ 52.240000] [<c00fc8f0>] (uart_open+0x0/0x238) from [<c00f2160>]
(tty_open+0x1cc/0x390)
[ 52.240000] [<c00f1f94>] (tty_open+0x0/0x390) from [<c0077e44>]
(chrdev_open+0x1e4/0x220)
[ 52.240000] [<c0077c60>] (chrdev_open+0x0/0x220) from [<c006ba58>]
(__dentry_open+0x13c/0x294)
[ 52.240000] r8 = C028E2A0 r7 = C0077C60 r6 = C0C29B94 r5 = 00000000
[ 52.240000] r4 = C02CC300
[ 52.240000] [<c006b91c>] (__dentry_open+0x0/0x294) from [<c006bc58>]
(nameidata_to_filp+0x34/0x48)
[ 52.240000] [<c006bc24>] (nameidata_to_filp+0x0/0x48) from
[<c006bcb0>] (do_filp_open+0x44/0x4c)
[ 52.240000] r4 = 00000002
[ 52.240000] [<c006bc6c>] (do_filp_open+0x0/0x4c) from [<c006bd08>]
(do_sys_open+0x50/0x94)
[ 52.240000] r5 = 00000000 r4 = 00000002
[ 52.240000] [<c006bcb8>] (do_sys_open+0x0/0x94) from [<c006bd84>]
(sys_open+0x24/0x28)
[ 52.240000] r8 = 00000000 r7 = 00000000 r6 = 00000001 r5 = C001C3F0
[ 52.240000] r4 = C024048C
[ 52.240000] [<c006bd60>] (sys_open+0x0/0x28) from [<c001f168>]
(init+0x13c/0x21c)
[ 52.240000] [<c001f02c>] (init+0x0/0x21c) from [<c0034384>] (do_exit+0x0/0x908)
[ 52.240000] r6 = 00000000 r5 = 00000000 r4 = 00000000

6:47 PM (ignore the rcu_do_batch lines; we chased the bottom-half
scheduler from __do_softirq to tasklet_action to rcu_do_batch trying
to understand what was getting perpetually scheduled)

6:50 PM (At this stage in the boot process, there are active softirq
handlers associated with the timer queue and the tasklet queue,
several tasklets of which the most active is the rcu callback batch
scheduler, and several types of frequently posted rcu callbacks; these
two are the postponed free() paths associated with the fs cache and
the dentry cache. They are to be expected at this juncture.)

> You should _never_ _ever_ get recusive interrupts for the same interrupt
> source.  Ever.  If you do, your platforms interrupt handling is seriously
> buggy.

Er, who wrote the ARMv5t implementations of __irq_svc, asm_do_IRQ,
do_level_irq, and __do_irq?  :-)  I don't think there's actually
anything wrong with the interrupt servicing here, and I think it's a
good thing that these routines appear recursively in the backtrace
when the root cause of a lockup is an unserviced level-based IRQ.

> > But its context is not.  Shared IRQ lines are a _problem_.  You cannot
> > safely enable an IRQ until all devices that share it have had their
> > ISRs installed, unless you can absolutely guarantee at a hardware
> > level that the unitialized ones cannot assert the IRQ line.
>
> Linux assumes that all interrupt sources on a shared IRQ line are
> disabled at the point in time when the kernel boots.  When a device
> is to be used, an interrupt handler is installed and then the kernel
> will enable the interrupt on the device, not before.

Linux assumes incorrectly in this instance.  It would improve the
kernel if all drivers' __init code were refactored into an
IRQ-discovery-ISR-installation pass, followed by a
chip-reset-data-structure-initialization pass, followed by a
chip-configuration-driver-activation pass.  This is unlikely to happen
overnight.  In the meantime, weird UART states on entry into
platform_device_init are a reality.

> We follow that rule in the 8250 driver - in fact, when we initialise
> we ensure that interrupts are disabled on any devices we find.

No, you rely on the caller of serial8250_init to have punctured the
abstraction and forced any and all UARTs to a state where they cannot
possibly generate an IRQ.  Embedded hardware being what it is, this is
IMHO not a great design choice.

Cheers,
- Michael
