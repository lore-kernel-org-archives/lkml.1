Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYHWJtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYHWJtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 05:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYHWJs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 05:48:56 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39750 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYHWJsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 05:48:54 -0400
Date: Sat, 23 Aug 2008 11:48:30 +0200 (MEST)
Message-Id: <200808230948.m7N9mUc1016360@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [BUG] get_rtc_time() triggers NMI watchdog in hpet_rtc_interrupt()
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.27-rc1 my Core2Duo has been getting sporadic oopses
from hpet_rtc_interrupt, usually during shutdown or reboot,
but occasionally also early in init. Today I finally managed
to capture one via a serial cable:

INIT: version 2.86 booting
		Welcome to Fedora Core
		Press 'I' to enter interactive startup.
BUG: NMI Watchdog detected LOCKUP on CPU0, ip c0117092, registers:
Modules linked in: ehci_hcd uhci_hcd usbcore

Pid: 311, comm: nash-hotplug Not tainted (2.6.27-rc4 #1)
EIP: 0060:[<c0117092>] EFLAGS: 00000097 CPU: 0
EIP is at hpet_rtc_interrupt+0x2d2/0x310
EAX: 00000000 EBX: 00000002 ECX: 00000046 EDX: 00000002
ESI: 000000a6 EDI: ffff8e25 EBP: 00000008 ESP: f7bd7f28
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process nash-hotplug (pid: 311, ti=f7bd6000 task=f7b70460 task.ti=f7bd6000)
Stack: f7bd7f6c c0139cc0 00000000 c035ba04 00000000 00000000 00000000 00000000 
       00000000 00000000 00000000 00000000 00000000 f7b845a0 00000000 00000000 
       00000008 c01478a8 c035bf80 f7b845a0 c035bfb0 00000008 c0148f71 00000400 
Call Trace:
 [<c0139cc0>] hrtimer_run_pending+0x20/0x90
 [<c01478a8>] handle_IRQ_event+0x28/0x50
 [<c0148f71>] handle_edge_irq+0xa1/0x120
 [<c010615b>] do_IRQ+0x3b/0x70
 [<c0113225>] smp_apic_timer_interrupt+0x55/0x80
 [<c0103c4f>] common_interrupt+0x23/0x28
 [<c02c0000>] unix_release_sock+0xc0/0x220
 =======================
Code: 89 44 24 18 0f b6 c2 e8 5d 74 0c 00 8b 0d d8 9c 3b c0 89 44 24 1c 8b 44 24 0c 48 89 44 24 20 e9 84 fd ff ff 90 8d 74 26 00 f3 90 <a1> 80 ba 35 c0 29 f8 83 f8 01 76 f2 e9 e1 fe ff ff 90 8d 74 26 

This points to the following loop in hpet_rtc_interrupt:

0xc0117090 <hpet_rtc_interrupt+720>:    pause  
0xc0117092 <hpet_rtc_interrupt+722>:    mov    0xc035ba80,%eax
0xc0117097 <hpet_rtc_interrupt+727>:    sub    %edi,%eax
0xc0117099 <hpet_rtc_interrupt+729>:    cmp    $0x1,%eax
0xc011709c <hpet_rtc_interrupt+732>:    jbe    0xc0117090 <hpet_rtc_interrupt+720>

Note: 0xc035ba80 == &jiffies

This loop originates from asm-generic/rtc.h:get_rtc_time()

		while (jiffies - uip_watchdog < 2*HZ/100) {
			barrier();
			cpu_relax();
		}

Note: HZ == CONFIG_HZ == 100

The bug may not originate from the 2.6.27-rc series as I only recently
enabled HPET in this machine's kernels (not due to HPET problems, it
inherited its .config way back from an older machine w/o HPET).

/Mikael
