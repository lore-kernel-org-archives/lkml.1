Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZHST36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZHST36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 15:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZHST36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 15:29:58 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:52523 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZHST35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 15:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YrhXIuI7z5j/J+z6KMoB1tvlLEwlZl/7Y0XHumG2GV1v2yYlvNCT0QreTGhE9cz75s
         RI3pgnH0QvCd72WeQ4MRdj5sTBGqHHm+wGgnUx4tQVOthv5ZabkjUrAOePtHUqLMlVly
         gqY5sGbhkNfTnGbgQZdhRcrZ+RZlwquuW+8mQ=
MIME-Version: 1.0
Date: Wed, 19 Aug 2009 21:29:56 +0200
Message-ID: <12bfabe40908191229g598bf531yc3a56e383ff4f950@mail.gmail.com>
Subject: [BUG] 2.6.30.5: inconsistent lock state
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got this message from dmesg(notice that I was just rebooting
after my system got totally freezed and I had to manually reboot by
powering-off, but I don't know if the 2 things are related):
[  910.030251] Freeing unused kernel memory: 2616k freed
[  910.031662] Write protecting the kernel read-only data: 6572k
[  910.145394] irq 18: nobody cared (try booting with the "irqpoll" option)
[  910.145545] Pid: 0, comm: swapper Not tainted 2.6.30.5-my001 #1
[  910.145690] Call Trace:
[  910.145828]  <IRQ>  [<ffffffff802b1da7>] __report_bad_irq+0x45/0xab
[  910.146007]  [<ffffffff802b1f2f>] note_interrupt+0x122/0x19f
[  910.146152]  [<ffffffff802b27a2>] handle_fasteoi_irq+0xb4/0xf4
[  910.146300]  [<ffffffff80229a48>] handle_irq+0x95/0xb5
[  910.146445]  [<ffffffff80676db2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  910.146593]  [<ffffffff80228fe6>] do_IRQ+0x6a/0xe9
[  910.146736]  [<ffffffff80227893>] ret_from_intr+0x0/0xf
[  910.146879]  <EOI>  [<ffffffff8022f07c>] ? mwait_idle+0xa3/0xd2
[  910.147055]  [<ffffffff8022f073>] ? mwait_idle+0x9a/0xd2
[  910.147200]  [<ffffffff80225e7d>] ? enter_idle+0x33/0x49
[  910.147344]  [<ffffffff80225f42>] ? cpu_idle+0xaf/0xf2
[  910.147490]  [<ffffffff8066f9ca>] ? start_secondary+0x197/0x1b2
[  910.147635] handlers:
[  910.147772] [<ffffffff805274ef>] (usb_hcd_irq+0x0/0xac)
[  910.147971] Disabling IRQ #18
[  910.247005]
[  910.247005] =================================
[  910.247282] [ INFO: inconsistent lock state ]
[  910.247423] 2.6.30.5-my001 #1
[  910.247562] ---------------------------------
[  910.247703] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[  910.247849] swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[  910.247992]  (&irq_desc_lock_class){?.-...}, at:
[<ffffffff802b1b7a>] try_one_irq+0x32/0x132
[  910.248331] {IN-HARDIRQ-W} state was registered at:
[  910.248474]   [<ffffffffffffffff>] 0xffffffffffffffff
[  910.248645] irq event stamp: 244386
[  910.248785] hardirqs last  enabled at (244386):
[<ffffffff806772f3>] _spin_unlock_irq+0x3a/0x56
[  910.249070] hardirqs last disabled at (244385):
[<ffffffff806776b0>] _spin_lock_irq+0x23/0x8f
[  910.249353] softirqs last  enabled at (152262):
[<ffffffff8026d59a>] __do_softirq+0x193/0x1c1
[  910.249637] softirqs last disabled at (244379):
[<ffffffff8022803c>] call_softirq+0x1c/0x82
[  910.249920]
[  910.249920] other info that might help us debug this:
[  910.250197] 1 lock held by swapper/0:
[  910.250336]  #0:  (kernel/irq/spurious.c:21){+.-...}, at:
[<ffffffff8027268e>] run_timer_softirq+0x15c/0x294
[  910.250703]
[  910.250704] stack backtrace:
[  910.250976] Pid: 0, comm: swapper Not tainted 2.6.30.5-my001 #1
[  910.251120] Call Trace:
[  910.251257]  <IRQ>  [<ffffffff80292765>] valid_state+0x187/0x1ae
[  910.251433]  [<ffffffff80293205>] ? check_usage_backwards+0x0/0x76
[  910.251579]  [<ffffffff802928ae>] mark_lock+0x122/0x255
[  910.251723]  [<ffffffff80293be8>] __lock_acquire+0x2c2/0xc17
[  910.251868]  [<ffffffff802b1b7a>] ? try_one_irq+0x32/0x132
[  910.252013]  [<ffffffff802b1b7a>] ? try_one_irq+0x32/0x132
[  910.252158]  [<ffffffff80294609>] lock_acquire+0xcc/0x104
[  910.252302]  [<ffffffff802b1b7a>] ? try_one_irq+0x32/0x132
[  910.252448]  [<ffffffff806775b6>] _spin_lock+0x40/0x89
[  910.252592]  [<ffffffff802b1b7a>] ? try_one_irq+0x32/0x132
[  910.252736]  [<ffffffff802b1b7a>] try_one_irq+0x32/0x132
[  910.252881]  [<ffffffff8027268e>] ? run_timer_softirq+0x15c/0x294
[  910.253027]  [<ffffffff802b1ce7>] ? poll_spurious_irqs+0x0/0x49
[  910.253173]  [<ffffffff802b1cbb>] poll_all_shared_irqs+0x41/0x6d
[  910.253319]  [<ffffffff802b1d03>] poll_spurious_irqs+0x1c/0x49
[  910.253464]  [<ffffffff8027271f>] run_timer_softirq+0x1ed/0x294
[  910.253610]  [<ffffffff8027268e>] ? run_timer_softirq+0x15c/0x294
[  910.253756]  [<ffffffff80289655>] ? clocksource_read+0x1d/0x33
[  910.253902]  [<ffffffff8026d4ce>] __do_softirq+0xc7/0x1c1
[  910.254048]  [<ffffffff8022803c>] call_softirq+0x1c/0x82
[  910.254193]  [<ffffffff802297bc>] do_softirq+0x48/0xb0
[  910.254337]  [<ffffffff8026cffa>] irq_exit+0x61/0xb7
[  910.254482]  [<ffffffff8023d7cc>] smp_apic_timer_interrupt+0x94/0xba
[  910.254629]  [<ffffffff80227a53>] apic_timer_interrupt+0x13/0x20
[  910.254773]  <EOI>  [<ffffffff8022f07c>] ? mwait_idle+0xa3/0xd2
[  910.254948]  [<ffffffff8022f073>] ? mwait_idle+0x9a/0xd2
[  910.255093]  [<ffffffff80225e7d>] ? enter_idle+0x33/0x49
[  910.255237]  [<ffffffff80225f42>] ? cpu_idle+0xaf/0xf2
[  910.255382]  [<ffffffff8066f9ca>] ? start_secondary+0x197/0x1b2
[  910.278258] usb usb1: uevent


If you need more info, just ask.

Giangiacomo
