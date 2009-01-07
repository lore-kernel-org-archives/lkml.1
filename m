Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbZAGA6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbZAGA6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZAGA5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:57:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbZAGA5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:57:33 -0500
Date: Tue, 6 Jan 2009 16:57:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Gabriel C <nix.or.die@googlemail.com>
cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID updates for 2.6.29
In-Reply-To: <4963EE3C.3070106@googlemail.com>
Message-ID: <alpine.LFD.2.00.0901061655070.3057@localhost.localdomain>
References: <alpine.LNX.1.10.0901040115060.5377@jikos.suse.cz> <alpine.LNX.1.10.0901051055120.5377@jikos.suse.cz> <4963EE3C.3070106@googlemail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Gabriel C wrote:
> 
> After this merge I get the following panic , by just touching my  Wireless USB Mouse :
> 
> ...
> 
> [  223.999461] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> [  224.000446] IP: [<ffffffff80224e65>] __ticket_spin_lock+0x9/0x1a
> [  224.000446] PGD 7b4a5067 PUD 7a24b067 PMD 0
> [  224.000446] Oops: 0002 [#1] PREEMPT SMP
> [  224.000446] last sysfs file: /sys/devices/pci0000:00/0000:00:19.0/irq
> [  224.000446] CPU 0
> [  224.000446] Modules linked in: i915 binfmt_misc acpi_cpufreq freq_table w83627ehf hwmon_vid fuse loop lp ppdev parport_pc parport joydev pcspkr i2c_i801 intel_agp button sg evdev processor
> [  224.000446] Pid: 0, comm: swapper Not tainted 2.6.28-06127-g238c6d5 #31
> [  224.000446] RIP: 0010:[<ffffffff80224e65>]  [<ffffffff80224e65>] __ticket_spin_lock+0x9/0x1a
> [  224.000446] RSP: 0018:ffffffff807e3bd0  EFLAGS: 00010002
> [  224.000446] RAX: 0000000000000100 RBX: 0000000000000082 RCX: 0000000000000000
> [  224.000446] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000050
> [  224.000446] RBP: ffffffff807e3bd0 R08: ffff88007d254000 R09: ffffffff806db440
> [  224.000446] R10: ffffffff8023d95c R11: ffff88007e0a3d80 R12: 0000000000000050
> [  224.000446] R13: ffffffff807e3c70 R14: 0000000000000006 R15: 0000000000000050
> [  224.000446] FS:  0000000000000000(0000) GS:ffffffff807ec000(0000) knlGS:0000000000000000
> [  224.000446] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [  224.000446] CR2: 0000000000000050 CR3: 000000007e1c0000 CR4: 00000000000006e0
> [  224.000446] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  224.000446] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  224.000446] Process swapper (pid: 0, threadinfo ffffffff80772000, task ffffffff806d8340)
> [  224.000446] Stack:
> [  224.000446]  ffffffff807e3be0 ffffffff80224f2f ffffffff807e3c00 ffffffff805673a7
> [  224.000446]  ffff88007d22c180 0000000000000000 ffffffff807e3c50 ffffffff80496bc0
> [  224.000446]  ffff880001014740 ffff88000101af00 ffff88000101af00 ffff88007d22c180
> [  224.000446] Call Trace:
> [  224.000446]  <IRQ> <0> [<ffffffff80224f2f>] default_spin_lock_flags+0x9/0xe
> [  224.000446]  [<ffffffff805673a7>] _spin_lock_irqsave+0x37/0x40
> [  224.000446]  [<ffffffff80496bc0>] hiddev_send_event+0x2e/0xe9

Looks like "hiddev" is NULL in hiddev_send_event(), so then the

	spin_lock_irqsave(&hiddev->list_lock, flags);

does an offset from NULL, and tries to access memory at 0x0050.

> [  224.000446]  [<ffffffff80496ccd>] hiddev_report_event+0x52/0x54
> [  224.000446]  [<ffffffff8048cd93>] hid_report_raw_event+0xb3/0x3b3
> [  224.000446]  [<ffffffff8048d15c>] hid_input_report+0xc9/0xdc
> [  224.000446]  [<ffffffff80494939>] hid_irq_in+0x90/0x194
> [  224.000446]  [<ffffffff804535ef>] usb_hcd_giveback_urb+0x58/0x87
> [  224.000446]  [<ffffffff80469f0f>] uhci_giveback_urb+0x108/0x19d
> [  224.000446]  [<ffffffff8046a666>] uhci_scan_schedule+0x5a8/0x86b
> [  224.000446]  [<ffffffff8046c5bc>] uhci_irq+0x13f/0x158
> [  224.000446]  [<ffffffff80453168>] usb_hcd_irq+0x42/0x90
> [  224.000446]  [<ffffffff80278485>] handle_IRQ_event+0x2e/0x65
> [  224.000446]  [<ffffffff80279994>] handle_fasteoi_irq+0x8b/0xcb
> [  224.000446]  [<ffffffff8020f08c>] do_IRQ+0x70/0xe4
> [  224.000446]  [<ffffffff8020ce93>] ret_from_intr+0x0/0x29

Jiri?

		Linus
