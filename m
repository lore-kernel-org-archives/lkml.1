Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYIOQ5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYIOQ5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYIOQ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:57:14 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38244 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751515AbYIOQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:57:13 -0400
Date: Mon, 15 Sep 2008 18:57:09 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>,
       Bob McGwier <rwmcgwier@gmail.com>
Subject: Re: [Cbe-oss-dev] ps3: BUG: spinlock lockup on CPU#1, udevd/505 or
 modprobe/633
In-Reply-To: <Pine.LNX.4.64.0809121654170.3735@vixen.sonytel.be>
Message-ID: <Pine.LNX.4.64.0809151849490.14420@vixen.sonytel.be>
References: <Pine.LNX.4.64.0809121654170.3735@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1175607702-1221497699=:14420"
Content-ID: <Pine.LNX.4.64.0809151855090.14420@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1175607702-1221497699=:14420
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0809151855091.14420@vixen.sonytel.be>

On Fri, 12 Sep 2008, Geert Uytterhoeven wrote:
> >From time to time, I get a lockup in udevd or modprobe when booting a recent
> kernel on a PS3. Anyone with an idea what's going on, or how to investigate
> this further?

Some more results of my investigation...

> <7>usb-storage: device scan complete
> <7>eth0: no IPv6 routers present
> <0>BUG: spinlock lockup on CPU#1, udevd/505, c00000000062d880
> Call Trace:
> [c000000006b6f4a0] [c00000000000f334] .show_stack+0x70/0x184 (unreliable)
> [c000000006b6f550] [c0000000001fa6c8] ._raw_spin_lock+0x138/0x174
> [c000000006b6f5f0] [c00000000039b87c] .lock_kernel+0x38/0x5c

The common part of all logs is that some code calls lock_kernel() to acquire
the BKL....

> [c000000006b6f670] [c00000000011e084] .proc_lookup_de+0x34/0x144
> [c000000006b6f710] [c000000000118064] .proc_root_lookup+0x28/0x70
> [c000000006b6f7b0] [c0000000000c93ac] .do_lookup+0x110/0x260
> [c000000006b6f870] [c0000000000cbd40] .__link_path_walk+0xa34/0xf70
> [c000000006b6f960] [c0000000000cc2d4] .path_walk+0x58/0xc4
> [c000000006b6fa10] [c0000000000cc4d0] .do_path_lookup+0x130/0x174
> [c000000006b6fac0] [c0000000000cd284] .__path_lookup_intent_open+0x70/0xd0
> [c000000006b6fb70] [c0000000000cd548] .do_filp_open+0xc4/0x7ec
> [c000000006b6fd00] [c0000000000bd044] .do_sys_open+0x88/0x158
> [c000000006b6fdb0] [c0000000000fe0f0] .compat_sys_open+0x24/0x38
> [c000000006b6fe30] [c0000000000074dc] syscall_exit+0x0/0x40
> <3>BUG: soft lockup - CPU#0 stuck for 61s! [vol_id:661]
> Modules linked in: joydev evdev
> irq event stamp: 141818
> hardirqs last  enabled at (141817): [<c000000000007a1c>] restore+0x1c/0xe4
> hardirqs last disabled at (141818): [<c000000000003600>] decrementer_common+0x100/0x180
> softirqs last  enabled at (141814): [<c0000000000202bc>] .call_do_softirq+0x14/0x24
> softirqs last disabled at (141809): [<c0000000000202bc>] .call_do_softirq+0x14/0x24
> NIP: c000000000082270 LR: c0000000000825d8 CTR: 0000000000324f98
> REGS: c00000001cbe7410 TRAP: 0901   Not tainted  (2.6.27-rc6-00036-ga551b98-dirty)
> MSR: 8000000000008032 <EE,IR,DR>  CR: 42004422  XER: 20000000
> TASK = c00000001cbe1440[661] 'vol_id' THREAD: c00000001cbe4000 CPU: 0
> <6>GPR00: 0000000000000001 c00000001cbe7690 c000000000602c20 c00000001cbe7700 
> <6>GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
> <6>GPR08: 0000000000000000 0000000000000001 0000000000000000 c00000000003add8 
> <6>GPR12: 8000000000008032 c000000000635300 
> NIP [c000000000082270] .csd_flag_wait+0x4/0x1c
> LR [c0000000000825d8] .smp_call_function_single+0x13c/0x164
> Call Trace:
> [c00000001cbe7690] [c0000000000825d8] .smp_call_function_single+0x13c/0x164 (unreliable)
> [c00000001cbe7750] [c0000000000826e4] .smp_call_function_mask+0xe4/0x240
> [c00000001cbe78b0] [c000000000056780] .on_each_cpu+0x24/0x94
> [c00000001cbe7950] [c0000000000ebc1c] .invalidate_bh_lrus+0x24/0x3c
> [c00000001cbe79d0] [c0000000000f2ca4] .kill_bdev+0x2c/0x58
> [c00000001cbe7a50] [c0000000000f36b4] .__blkdev_put+0x94/0x1d4

... while it's already taken by __blkdev_put().

> [c00000001cbe7af0] [c0000000000c0684] .__fput+0x114/0x1fc
> [c00000001cbe7ba0] [c0000000000bcf04] .filp_close+0xac/0xd4
> [c00000001cbe7c30] [c000000000052e24] .put_files_struct+0xb4/0x13c
> [c00000001cbe7cd0] [c0000000000549b4] .do_exit+0x244/0x7c0
> [c00000001cbe7da0] [c000000000054fc4] .do_group_exit+0x94/0xc8
> [c00000001cbe7e30] [c0000000000074dc] syscall_exit+0x0/0x40
> Instruction dump:
> 7d005828 7c00592d 40a2fff8 4c00012c 2f880000 3860fff0 409e000c 38600000 
> f88b0008 ebc1fff0 4e800020 7c0004ac <80030020> 780907e1 4d820020 7c210b78 

The BKL is never released by __blkdev_put(), as the IPI initiated by
smp_call_function_single() never seems to finish. So it keeps on spinning in
csd_flag_wait().

Adding debug code to the PS3-specific IPI message_pass() routine
ps3_smp_message_pass() seems to cause the problem to go away.

I have lockdep enabled (as most other locking debug stuff), but CONFIG_PREEMPT
is not set.

As Bob McGwier sees it on PS3, but not on the QS21 or Mercury Cell blades, it
looks like the problem is really PS3-specific.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1175607702-1221497699=:14420--
