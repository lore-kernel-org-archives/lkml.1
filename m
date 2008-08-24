Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYHXKdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYHXKdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 06:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYHXKdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 06:33:12 -0400
Received: from aun.it.uu.se ([130.238.12.36]:51525 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbYHXKdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 06:33:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18609.14516.873317.52292@harpo.it.uu.se>
Date: Sun, 24 Aug 2008 12:32:20 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [BUG] get_rtc_time() triggers NMI watchdog in hpet_rtc_interrupt()
In-Reply-To: <19f34abd0808240214o22748804s45e8487d62b34cb8@mail.gmail.com>
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se>
	<19f34abd0808240214o22748804s45e8487d62b34cb8@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum writes:
 > Hi,
 > 
 > On Sat, Aug 23, 2008 at 11:48 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
 > > Since 2.6.27-rc1 my Core2Duo has been getting sporadic oopses
 > > from hpet_rtc_interrupt, usually during shutdown or reboot,
 > > but occasionally also early in init. Today I finally managed
 > > to capture one via a serial cable:
 > >
 > > INIT: version 2.86 booting
 > >                Welcome to Fedora Core
 > >                Press 'I' to enter interactive startup.
 > > BUG: NMI Watchdog detected LOCKUP on CPU0, ip c0117092, registers:
 > > Modules linked in: ehci_hcd uhci_hcd usbcore
 > >
 > > Pid: 311, comm: nash-hotplug Not tainted (2.6.27-rc4 #1)
 > > EIP: 0060:[<c0117092>] EFLAGS: 00000097 CPU: 0
 > > EIP is at hpet_rtc_interrupt+0x2d2/0x310
 > > EAX: 00000000 EBX: 00000002 ECX: 00000046 EDX: 00000002
 > > ESI: 000000a6 EDI: ffff8e25 EBP: 00000008 ESP: f7bd7f28
 > >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
 > > Process nash-hotplug (pid: 311, ti=f7bd6000 task=f7b70460 task.ti=f7bd6000)
 > > Stack: f7bd7f6c c0139cc0 00000000 c035ba04 00000000 00000000 00000000 00000000
 > >       00000000 00000000 00000000 00000000 00000000 f7b845a0 00000000 00000000
 > >       00000008 c01478a8 c035bf80 f7b845a0 c035bfb0 00000008 c0148f71 00000400
 > > Call Trace:
 > >  [<c0139cc0>] hrtimer_run_pending+0x20/0x90
 > >  [<c01478a8>] handle_IRQ_event+0x28/0x50
 > >  [<c0148f71>] handle_edge_irq+0xa1/0x120
 > >  [<c010615b>] do_IRQ+0x3b/0x70
 > >  [<c0113225>] smp_apic_timer_interrupt+0x55/0x80
 > >  [<c0103c4f>] common_interrupt+0x23/0x28
 > >  [<c02c0000>] unix_release_sock+0xc0/0x220
 > >  =======================
 > > Code: 89 44 24 18 0f b6 c2 e8 5d 74 0c 00 8b 0d d8 9c 3b c0 89 44 24 1c 8b 44 24 0c 48 89 44 24 20 e9 84 fd ff ff 90 8d 74 26 00 f3 90 <a1> 80 ba 35 c0 29 f8 83 f8 01 76 f2 e9 e1 fe ff ff 90 8d 74 26
 > >
 > > This points to the following loop in hpet_rtc_interrupt:
 > >
 > > 0xc0117090 <hpet_rtc_interrupt+720>:    pause
 > > 0xc0117092 <hpet_rtc_interrupt+722>:    mov    0xc035ba80,%eax
 > > 0xc0117097 <hpet_rtc_interrupt+727>:    sub    %edi,%eax
 > > 0xc0117099 <hpet_rtc_interrupt+729>:    cmp    $0x1,%eax
 > > 0xc011709c <hpet_rtc_interrupt+732>:    jbe    0xc0117090 <hpet_rtc_interrupt+720>
 > >
 > > Note: 0xc035ba80 == &jiffies
 > >
 > > This loop originates from asm-generic/rtc.h:get_rtc_time()
 > >
 > >                while (jiffies - uip_watchdog < 2*HZ/100) {
 > >                        barrier();
 > >                        cpu_relax();
 > >                }
 > >
 > > Note: HZ == CONFIG_HZ == 100
 > >
 > > The bug may not originate from the 2.6.27-rc series as I only recently
 > > enabled HPET in this machine's kernels (not due to HPET problems, it
 > > inherited its .config way back from an older machine w/o HPET).
 > 
 > I also just got this during shutdown:
 > 
 > Syncing hardware clock to system time BUG: NMI Watchdog detected
 > LOCKUP on CPU0, ip c011d922, registers:
 > Pid: 4181, comm: hwclock Not tainted (2.6.27-rc3-00464-g1fca254-dirty #42)
 > EIP: 0060:[<c011d922>] EFLAGS: 00200097 CPU: 0
 > EIP is at hpet_rtc_interrupt+0x282/0x2e0
 > EAX: 00000000 EBX: 00200096 ECX: f3990000 EDX: 00010000
 > ESI: 000000a6 EDI: 0004f806 EBP: f3991edc ESP: f3991e98
 >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
 > Process hwclock (pid: 4181, ti=f3990000 task=f359d340 task.ti=f3990000)
 > Stack: f359d340 c08621c0 00000000 f359d340 00001d12 00000000 00000000 00000000
 >        00000000 00000000 00000000 00000000 00000000 00000000 f6b4f788 00000000
 >        00000008 f3991ef4 c017ac08 00000000 c0862180 f6b4f788 00000008 f3991f0c
 > Call Trace:
 >  [<c017ac08>] ? handle_IRQ_event+0x28/0x70
 >  [<c017c1cf>] ? handle_edge_irq+0xaf/0x140
 >  [<c0107138>] ? do_IRQ+0x48/0xa0
 >  [<c036e254>] ? trace_hardirqs_off_thunk+0xc/0x18
 >  [<c0104a3c>] ? common_interrupt+0x28/0x30
 >  [<c03c007b>] ? tty_get_baud_rate+0x3b/0x60
 >  [<c036e641>] ? copy_from_user+0x1/0x80
 >  [<c01bba1f>] ? sys_select+0x5f/0x190
 >  [<c01ba157>] ? do_vfs_ioctl+0x57/0x2b0
 >  [<c036e244>] ? trace_hardirqs_on_thunk+0xc/0x10
 >  [<c015bc64>] ? trace_hardirqs_on_caller+0xd4/0x160
 >  [<c0103f3b>] ? sysenter_do_call+0x12/0x3f
 >  =======================
 > Code: 65 10 25 00 89 45 d8 0f b6 45 cc e8 59 10 25 00 89 45 dc 0f b6
 > 45 c8 e8 4d 10 25 00 83 e8 01 89 45 e0 e9 04 fe f
 > f ff 66 90 f3 90 <a1> 00 1b 86 c0 29 f8 83 f8 13 76 f2 e9 01 ff ff ff
 > 83 c0 64 89

See my reply in the thread following Ingo's patch
<http://lkml.org/lkml/2008/8/23/158>. I've only seen the lockup
while hwclock was setting or flushing the system time, so I suspect
broken interaction between the hpet rtc emulation and the rtc
user-space interface.
