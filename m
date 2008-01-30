Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbYA3Pbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbYA3Pbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYA3Pbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:31:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:29971 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYA3Pbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:31:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=FUAp+21JjK+7rbwkcjgCr6SSG90Dz0QdP6IRB2wRKw0Pp/on3jPh1QoxmFusE4vezjtRVtzbqaIfK0LFYh9Q9Mu2pkK0LpXrHXbuf7+YoI2PTw3nv7uZT6F4kLR1NwUknrl5vVG8vz1bYgjUcjUvGFDm0RkauND91V6RZbXak4o=
Date: Wed, 30 Jan 2008 16:31:14 +0100
To: Manuel Lauss <mano@roarinelk.homelinux.net>, linux@dominikbrodowski.net
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-pcmcia@lists.infradead.org, linux-sh <linux-sh@vger.kernel.org>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [HD64461_PCMCIA_driver] - Shared IRQ lines / Segfaults
Message-Id: <20080130163114.cca7a272.Kristoffer.ericson@gmail.com>
In-Reply-To: <20080130130559.GA30360@roarinelk.homelinux.net>
References: <20080130132036.87299f09.Kristoffer.ericson@gmail.com>
	<20080130130559.GA30360@roarinelk.homelinux.net>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 14:05:59 +0100
Manuel Lauss <mano@roarinelk.homelinux.net> wrote:

> On Wed, Jan 30, 2008 at 01:20:36PM +0100, Kristoffer Ericson wrote:
> > Greetings,
> > 
> > Driver detects card insertion / ejection and sets power properly. The mapping looks resonable also compairing to a working 2.6.17 driver.
> > modprobe hostap_cs
> > hostap_cs: Registered netdevice wifi0
> > Unable to handle kernel NULL pointer dereference at virtual address 00000028
> > pc = 8d0031b8
> > *pde = 00000000
> > Oops: 0000 [#1]
> > Modules linked in: hostap_cs hostap orinoco_cs orinoco hermes atmel_cs atmel
> > 
> > Pid : 283, Comm:             modprobe
> > PC is at generic_inw+0x8/0x20
> > PC  : 8d0031b8 SP  : 8ecaba74 SR  : 400000f0 TEA : c0045040    Not tainted
> > R0  : 00000028 R1  : 8d2d9030 R2  : 8d2ac050 R3  : 00000007
> > R4  : 00000028 R5  : 00000002 R6  : 00000080 R7  : 8ecf06a0
> > R8  : 8ee62000 R9  : 00008a32 R10 : c002a1b0 R11 : 8ee62000
> > R12 : 00000080 R13 : 8ee62000 R14 : 8ecf06a0
> > MACH: 0000458f MACL: 00001110 GBR : 296ce450 PR  : 8d0031b8
> > 
> > Call trace: 
> > [<c002a1fa>] prism2_interrupt+0x4a/0xc50 [hostap_cs]
> 
> The oops output suggests it crashes in 
> drivers/net/wireless/hostap/hostap_hw.c::prism2_check_magic(),
> specifically when it tries to read the HF384X_SWSUPPORT0_OFF register
> (which ist at offset 0x28, just like the oopsing address).
> So, looking at the HFA384X_INW macro, it seems dev->base_addr is NULL.
> I suspect this is because of set_io_map() callback in the hd64461.c
> socket driver.  The comment there says IO area is statically mapped,
> yet it returns null; I suggest you let it return the base address of
> the IO area instead.
> 

I've tried changing the s->io_offset = 0xf000 just to see if I get any reactions. The result is that now orinoco_cs segfaults, which it more or less should. 
Correct s->io_offset gives :
Segfault in hostap_cs

Bad s->io_offset gives :
Segfault in orinoco_cs
Segfault in hostap_cs

So basicly, the segfault in hostap_cs is not dependant on my io_offset at all.. :(

Orinoco_cs log :
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
pcmcia: request for exclusive IRQ could not be fulfilled.
pcmcia: the driver needs updating to supported shared IRQ lines.
flags = 200, csc_mask = 80, Vcc = 33 Vpp = 0 io_irq = 0
state->Vpp != sp->state.Vcc
hd64461_set_voltage: 33 Vcc, 0 Vpp
flags = 220, csc_mask = 80, Vcc = 33 Vpp = 0 io_irq = 78
hd64461_set_socket: SS_IOCARD and state changed
hd64461_set_socket: Lets reset and set to IO card 
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
Unable to handle kernel paging request at virtual address 0000f032
pc = 8d0034f2
*pde = 00000000
Oops: 0001 [#1]
Modules linked in: orinoco_cs orinoco hermes

Pid : 265, Comm:             modprobe
PC is at generic_writew+0x2/0x10
PC  : 8d0034f2 SP  : 8ec25960 SR  : 40000000 TEA : c00205c4    Not tainted
R0  : c001f0d0 R1  : 00000032 R2  : 8d0034f0 R3  : 00000000
R4  : 00000000 R5  : 0000f032 R6  : 00000004 R7  : 0000000b
R8  : 8ece617c R9  : 8ece6000 R10 : 000000c4 R11 : 8ece6424
R12 : 8ece6000 R13 : 8d2ac090 R14 : 00000000
MACH: 00007df8 MACL: 01936912 GBR : 296ce450 PR  : c001f0fc

Call trace: 
[<c0002f0c>] orinoco_init+0x2c/0xbb0 [orinoco]
[<8d111fbe>] vsnprintf+0x35e/0x570
[<8d007024>] call_dpf+0x10/0x30
[<c0002ee0>] orinoco_init+0x0/0xbb0 [orinoco]
[<8d1962c6>] register_netdevice+0x56/0x3f0
[<8d19668c>] register_netdev+0x2c/0x60
[<c000c53a>] orinoco_cs_probe+0x38a/0x450 [orinoco_cs]
[<8d08a340>] sync_buffer+0x0/0x50
[<8d22f354>] out_of_line_wait_on_bit+0x54/0x70
[<8d101046>] get_request+0xa6/0x310
[<8d10111a>] get_request+0x17a/0x310
[<8d106e01>] as_find_next_rq+0xb1/0xc0
[<8d0f0076>] ipcget_public+0x116/0x1a0
[<8d107df0>] as_add_request+0x50/0x150
[<8d02eafc>] update_wall_time+0x2dc/0x7e0
[<8d02eb34>] update_wall_time+0x314/0x7e0
[<8d00ccc8>] task_tick_fair+0x48/0xc0
[<8d00ddc0>] scheduler_tick+0x90/0x100
[<8d02e214>] getnstimeofday+0x64/0x100
[<8d112c90>] __lshrdi3+0x0/0x50
[<8d02b5ea>] ktime_get_ts+0x1a/0x60
[<8d02b630>] ktime_get+0x0/0x20
[<8d02bb90>] __remove_hrtimer+0x0/0xa0
[<8d02e1b0>] getnstimeofday+0x0/0x100
[<8d0310ea>] clockevents_program_event+0x9a/0x140
[<8d02b630>] ktime_get+0x0/0x20
[<8d0310f2>] clockevents_program_event+0xa2/0x140
[<8d031ac4>] tick_program_event+0x34/0xb0
[<8d031050>] clockevents_program_event+0x0/0x140
[<8d0200aa>] sys_rt_sigtimedwait+0x18a/0x280
[<8d01ca02>] free_uid+0x22/0x120
[<8d00f7c2>] __put_task_struct+0x32/0xd0
[<8d00f766>] free_task+0x16/0x40
[<8d025ae6>] __rcu_process_callbacks+0x56/0x280
[<8d025d1e>] rcu_process_callbacks+0xe/0x30
[<8d018a66>] tasklet_action+0x86/0xf0
[<8d0184e8>] __do_softirq+0x58/0xe0
[<8d0185d6>] do_softirq+0x66/0x80
[<8d106e01>] as_find_next_rq+0xb1/0xc0
[<8d0f0076>] ipcget_public+0x116/0x1a0
[<8d107df0>] as_add_request+0x50/0x150
[<8d02eafc>] update_wall_time+0x2dc/0x7e0
[<8d02eb34>] update_wall_time+0x314/0x7e0
[<8d00ccc8>] task_tick_fair+0x48/0xc0
[<8d00ddc0>] scheduler_tick+0x90/0x100
[<8d02e214>] getnstimeofday+0x64/0x100
[<8d112c90>] __lshrdi3+0x0/0x50
[<8d02b5ea>] ktime_get_ts+0x1a/0x60
[<8d02b630>] ktime_get+0x0/0x20
[<8d02bb90>] __remove_hrtimer+0x0/0xa0
[<8d02e1b0>] getnstimeofday+0x0/0x100
[<8d0310ea>] clockevents_program_event+0x9a/0x140
[<8d02b630>] ktime_get+0x0/0x20
[<8d0310f2>] clockevents_program_event+0xa2/0x140
[<8d031ac4>] tick_program_event+0x34/0xb0
[<8d031050>] clockevents_program_event+0x0/0x140
[<8d0200aa>] sys_rt_sigtimedwait+0x18a/0x280
[<8d01ca02>] free_uid+0x22/0x120
[<8d00f7c2>] __put_task_struct+0x32/0xd0
[<8d00f766>] free_task+0x16/0x40
[<8d025ae6>] __rcu_process_callbacks+0x56/0x280
[<8d025d1e>] rcu_process_callbacks+0xe/0x30
[<8d018a66>] tasklet_action+0x86/0xf0
[<8d0184e8>] __do_softirq+0x58/0xe0
[<8d0185d6>] do_softirq+0x66/0x80
[<8d176408>] pcmcia_device_probe+0xb8/0x190
[<8d0136c0>] printk+0x0/0x20
[<8d145354>] driver_probe_device+0xd4/0x180
[<8d145606>] __driver_attach+0xf6/0x160
[<8d10bf60>] strlen+0x0/0x60
[<8d144168>] bus_for_each_dev+0x48/0x90
[<8d145510>] __driver_attach+0x0/0x160
[<8d1440f0>] next_device+0x0/0x30
[<8d144a6a>] bus_add_driver+0x5a/0x1e0
[<8d17613c>] pcmcia_register_driver+0xac/0x140
[<8d0136c0>] printk+0x0/0x20
[<8d115540>] crc32_le+0x0/0xb0
[<8d10bf60>] strlen+0x0/0x60
[<8d22f540>] mutex_unlock+0x0/0x60
[<8d037474>] sys_init_module+0x154/0x1500
[<8d04da30>] kstrdup+0x0/0x50
[<8d22f540>] mutex_unlock+0x0/0x60
[<8d1929f0>] netif_device_detach+0x0/0xc0
[<8d007238>] syscall_call+0xc/0x10
[<8d037320>] sys_init_module+0x0/0x1500

Process: modprobe (pid: 265, stack limit = 8ec24001)
Stack: (0x8ec25960 to 0x8ec26000)
5960: c0002f0c 8ece6424 8ece6000 8ece6000 8ece6360 000000c4 8ece6000 8ece617c 
5980: 8d23e378 00000000 ffffffff 8d111fbe 8ec25a10 8ec259ec 8d2bab38 ffffffff 
59a0: 00000002 8ec25a20 8ec25a13 0000000a 8d007024 00000190 c0002ee0 40000000 
59c0: 00000000 8ece6000 fff3fa0f 00000004 0000000b 8ece6000 8ece6000 8ece6040 
59e0: 8d2ee964 8ece7040 8ece6000 8ece7009 8ec25a14 8d1962c6 8ece7009 8ece6000 
5a00: 8ece7040 8d2ee964 8ece6040 8ece6000 8ece6000 8ece7000 8d19668c 8ece7020 
5a20: 8ece7022 8ece6000 00000000 c000c53a 8ece7000 8ece627c 761901c1 3619d535 
5a40: ff460536 0000ffff 00000004 00000052 8ec42690 8ecdbc68 00000000 8ec42690 
5a60: 8d08a340 8d22f354 8ec25b10 8ece767c 8ecdaaf0 8ec25b10 8ece7600 00000000 
5a80: 00000021 00000021 00000021 00011210 00011200 8ec42690 8ec42690 00000001 
5aa0: 00000000 00006000 8d101046 00000000 00000001 8ecdaaf0 8d10111a 8ec25b00 
5ac0: 00000000 8ecdbc1b 00000110 00000000 000000a6 40000e1b 0000000e 8ec25a38 
5ae0: 00017801 8d106e01 8d0f0076 8ecdbc68 000493e0 000802c8 8d107df0 002dc6c0 
5b00: 002dc6c0 000186a0 8ecdbc00 8ecd3bc4 8d02eafc 8d02eb34 00000000 ffffa9a2 
5b20: ffffffff ffffcfd3 ffffff00 fffffffb 00000052 c69b0000 ffffffff 8ecdbc68 
5b40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 ffffffff 
5b60: 8d000146 00000000 00000040 c4b40000 8d2daaac 8ec22cf0 004b645c 00000000 
5b80: 8d00ccc8 8ec25b84 8ec25b84 8d2daa7c 8d2daaac 8ec22cf0 8d00ddc0 8d02e214 
5ba0: 8d112c90 00007ee8 8d02b5ea 8d02b630 8d02bb90 8d02e1b0 8d2e0da0 8d2e0d80 
5bc0: 8d0310ea 8d02b630 8d0310f2 8d031ac4 8d031050 00000000 8d2ae5a4 00000041 
5be0: 0e111300 000000ff 0000ffff 8d0200aa 8d01ca02 8d00f7c2 8d00f766 8d2e0a40 
5c00: 8d025ae6 8d2e0a40 00000004 00000000 8d025d1e ffffffff 8d018a66 ffffffff 
5c20: ffffff0f 00000000 8d0184e8 8d2df7a0 0000000a 8d2e0a04 00000001 8d2df7f4 
5c40: 00000000 8d0185d6 00000000 0000013a 8d2db300 00017801 8d106e01 8d0f0076 
5c60: 8ecdbc68 000493e0 000802c8 8d107df0 002dc6c0 002dc6c0 000186a0 8ecdbc00 
5c80: 8ecd3bc4 8d02eafc 8d02eb34 00000000 ffffa9a2 ffffffff ffffcfd3 ffffff00 
5ca0: fffffffb 00000052 c69b0000 ffffffff 8ecdbc68 00000000 00000000 00000000 
5cc0: 00000000 00000000 00000000 00000000 ffffffff 8d000146 00000000 00000040 
5ce0: c4b40000 8d2daaac 8ec22cf0 004b645c 00000000 8d00ccc8 8ec25b84 8ec25b84 
5d00: 8d2daa7c 8d2daaac 8ec22cf0 8d00ddc0 8d02e214 8d112c90 00007ee8 8d02b5ea 
5d20: 8d02b630 8d02bb90 8d02e1b0 8d2e0da0 8d2e0d80 8d0310ea 8d02b630 8d0310f2 
5d40: 8d031ac4 8d031050 00000000 8d2ae5a4 00000041 0e111300 000000ff 0000ffff 
5d60: 8d0200aa 8d01ca02 8d00f7c2 8d00f766 8d2e0a40 8d025ae6 8d2e0a40 00000004 
5d80: 00000000 8d025d1e ffffffff 8d018a66 ffffffff ffffff0f 00000000 8d0184e8 
5da0: 8d2df7a0 0000000a 8d2e0a04 00000001 8d2df7f4 00000000 8d0185d6 00000000 
5dc0: 0000013a 8d2db300 8ece65a4 8ece6424 0000002b 8ec8e880 00000000 00000002 
5de0: 8ec0981a 00000110 00000000 0000009d ff00071a 8d176408 8d0136c0 8d2c04f8 
5e00: 8d2ee150 8ece7000 00000001 8ece708c c000f4b0 00000001 000003e0 00000001 
5e20: 00000000 00000000 00000000 00000000 8d145354 00000000 c000f4c8 8ece7108 
5e40: 8ece708c 8d145606 8d10bf60 c000f4c8 c000f4c8 8ece70cc 8ece708c 8d144168 
5e60: 8d145510 8d1440f0 00000000 8d2c0590 8d2c0590 8ece70d4 8d144a6a 000000bc 
5e80: c000f4d0 c000f4c8 00000000 8d17613c 8d0136c0 8d115540 8d10bf60 c000f4b0 
5ea0: c000f47c c000f4c8 c000f458 8d22f540 8d037474 00000025 8d04da30 00000000 
5ec0: 8d22f540 c000f550 c000f60c 00000025 00000000 00000000 8ecf4a60 8ecf6a58 
5ee0: c003ee10 c003ecbe 8ecf0de0 c004b840 00000025 00000024 0000000a 00000000 
5f00: 00000000 0000000f 00000000 00000009 00000000 00000000 00000000 00000000 
5f20: 00000000 00000000 00000000 00000000 00000000 c000f550 000000b1 00000000 
5f40: 8d1929f0 00000001 8ec24000 00000000 00000004 00000010 00000004 00000010 
5f60: 00000025 c000f55c c0022030 c000f64c 000005c8 c000dbca c002555c 00000002 
5f80: 8d007238 7bb23b7c 7bb23b60 00000002 ffffff0f 00000001 8ec25ff8 8d037320 
5fa0: 00000000 00400f84 00000000 00000080 296cf000 0002a0c0 004160f0 004160f0 
5fc0: 00000000 00000000 7bb23e48 7bb23fbc 00000002 7bb23b60 7bb23b7c 7bb23b7c 
5fe0: 296580e6 0040320c 00000001 296ce450 90c30b48 00000000 00000054 00000160 
---[ end trace 8e22eb4bf0f2bd15 ]---
Segmentation fault







Hostap_cs log :
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hostap_cs: Registered netdevice wifi0
Unable to handle kernel NULL pointer dereference at virtual address 00000028
pc = 8d0031b8
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: hostap_cs hostap
Pid : 265, Comm:             modprobe
PC is at generic_inw+0x8/0x20
PC  : 8d0031b8 SP  : 8ecaba74 SR  : 400000f0 TEA : 00000028    Not tainted
R0  : 00000028 R1  : 8d2d9030 R2  : 8d2ac050 R3  : 00000007
R4  : 00000028 R5  : 00000002 R6  : 00000080 R7  : 8ecf0a60
R8  : 8ee3c000 R9  : 00008a32 R10 : c00571b0 R11 : 8ee3c000
R12 : 00000080 R13 : 8ee3c000 R14 : 8ecf0a60
MACH: 0000481c MACL: 00001110 GBR : 296ce450 PR  : 8d0031b8
Call trace: 
[<c00571fa>] prism2_interrupt+0x4a/0xc50 [hostap_cs]
[<8d03ce74>] request_irq+0xc4/0x120
[<c00571b0>] prism2_interrupt+0x0/0xc50 [hostap_cs]
[<8d17920c>] pcmcia_request_irq+0x19c/0x210
[<c005bb34>] hostap_cs_probe+0x9d4/0xe50 [hostap_cs]
[<8d00c666>] sched_slice+0x76/0xa0
[<8d00ccc8>] task_tick_fair+0x48/0xc0
[<8d00ddc0>] scheduler_tick+0x90/0x100
[<8d02e214>] getnstimeofday+0x64/0x100
[<8d112c90>] __lshrdi3+0x0/0x50
[<8d02b5ea>] ktime_get_ts+0x1a/0x60
[<8d0136d0>] printk+0x10/0x20
[<8d17afe0>] hd64461_set_mem_map+0x30/0x90
[<8d1730f8>] set_cis_map+0x48/0x1a0
[<8d1731c6>] set_cis_map+0x116/0x1a0
[<8d17334c>] pcmcia_read_cis_mem+0xfc/0x1a0
[<8d17364a>] read_cis_cache+0xea/0x140
[<8d007024>] call_dpf+0x10/0x30
[<8d176408>] pcmcia_device_probe+0xb8/0x190
[<8d0136c0>] printk+0x0/0x20
[<8d145354>] driver_probe_device+0xd4/0x180
[<8d145606>] __driver_attach+0xf6/0x160
[<8d10bf60>] strlen+0x0/0x60
[<8d144168>] bus_for_each_dev+0x48/0x90
[<8d145510>] __driver_attach+0x0/0x160
[<8d1440f0>] next_device+0x0/0x30
[<8d144a6a>] bus_add_driver+0x5a/0x1e0
[<8d17613c>] pcmcia_register_driver+0xac/0x140
[<8d0136c0>] printk+0x0/0x20
[<8d115540>] crc32_le+0x0/0xb0
[<8d10bf60>] strlen+0x0/0x60
[<8d037474>] sys_init_module+0x154/0x1500
[<8d04da30>] kstrdup+0x0/0x50
[<8d22f540>] mutex_unlock+0x0/0x60
[<8d18be60>] kfree_skb+0x0/0x60
[<8d007238>] syscall_call+0xc/0x10
[<8d037320>] sys_init_module+0x0/0x1500

Process: modprobe (pid: 265, stack limit = 8ecaa001)
Stack: (0x8ecaba74 to 0x8ecac000)
ba60:                                              c00571fa 8ecf0e20 8ee3c444 
ba80: 00000000 0000004e 00000080 8ee3c000 8ecf0a60 8ecabab8 8d03ce74 8ecf0a60 
baa0: 8ee3c000 00000080 0000004e c00571b0 00000000 8ecf0e20 8d17920c 8ec91130 
bac0: 8ece7000 00000000 8ece7034 8d2ee500 0000004e 00000040 8ee3c000 00000080 
bae0: 8ece7144 c005bb34 8ee3c444 0000017c 8ece7400 8ece7000 8ee3c000 0000002e 
bb00: 00000000 00000000 8ecdb61b 00000110 00000000 000000a6 40000e1b 0000560e 
bb20: 8ecabb24 761901c1 3619d535 ff460536 0000ffff 475b0000 00000000 8ecdb6c8 
bb40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
bb60: 8d00c666 8ec22c00 00000000 00000021 00000021 00000021 004b645c 00000000 
bb80: 8d00ccc8 8ecabb84 8ecabb84 8d2daa7c 8d2daaac 8ec22cf0 8d00ddc0 8d02e214 
bba0: 8d112c90 000030da 8d02b5ea 00016401 73756201 6d630076 2f616963 000493e0 
bbc0: 000802c8 74736f68 002dc6c0 002dc6c0 000186a0 64646100 56454400 48544150 
bbe0: 75622f3d 63702f73 6169636d 6972642f 73726576 736f6800 5f706174 53007363 
bc00: 59534255 4d455453 6972643d 73726576 51455300 00000000 00383432 00000000 
bc20: 00000000 00000000 00000000 00000146 00000000 00000040 8d3340c0 8d3340e0 
bc40: 8d334100 8d334120 8d334140 8d334160 8d334180 8d3341a0 8d3341c0 8d3341e0 
bc60: 8d334200 8d334220 8d334240 8d334260 8d334280 8d3342a0 8d3342c0 8d3342e0 
bc80: 8d334300 8d334320 8d334340 8d334360 8d334380 8d3343a0 8d3343c0 8d3343e0 
bca0: 8d332400 8d332420 8d332440 8d332460 000000ff 0000ffff 8d3300c0 8d3324e0 
bcc0: 8d332500 8d332520 8d332540 8d332560 8d332580 8d3325a0 8d3325c0 8d3325e0 
bce0: 8d332600 8d332620 8d332640 8d332660 8d332680 8d3326a0 00000000 00000000 
bd00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
bd20: 0000004b 00000000 8d0136d0 8d2ee5bc 00000000 0000013a 8d2ee4a4 8d2ee519 
bd40: 00000000 8d2ee518 8d17afe0 00000000 00000000 00000021 b8000000 00000000 
bd60: 8d1730f8 00000021 8d2ee518 8d1731c6 8d2ee500 8d17334c 8d2ee500 8ec8e880 
bd80: 00000007 0000009d 8d2ee500 00000002 00000021 00000001 8ec91270 8ec8e880 
bda0: 00000001 8d17364a 8d2ee500 00000000 8d007024 8ece708c 8ee3c000 8ee3c580 
bdc0: 8ee3c17c 8ee3c17c 0000053c 00000000 8d3311c0 c0061e88 8ece708c 8ece7009 
bde0: 8ece7020 8ece7022 8ece702a 8ece7040 8ece7060 8d176408 8d0136c0 8d2c04f8 
be00: 8d2ee150 8ece7000 00000001 8ece708c c0061e88 00000001 000003e0 00000001 
be20: 00000000 00000000 00000000 00000000 8d145354 00000000 c0061ea0 8ece7108 
be40: 8ece708c 8d145606 8d10bf60 c0061ea0 c0061ea0 8ece70cc 8ece708c 8d144168 
be60: 8d145510 8d1440f0 00000000 8d2c0590 8d2c0590 8ece70d4 8d144a6a 000000bc 
be80: c0061ea8 c0061ea0 00000000 8d17613c 8d0136c0 8d115540 8d10bf60 c0061e88 
bea0: c0061d9c c0061ea0 c0061d78 8ecabed0 8d037474 00000027 8d04da30 00000000 
bec0: 8d22f540 c0061f90 c006204c 00000027 00000000 00000000 8ecf4a60 8ecf6a04 
bee0: c00374b4 c0037357 8ecf0d60 c0051108 00000027 00000026 0000000b 00000000 
bf00: 00000000 00000011 00000000 0000000a 00000000 00000000 00000000 00000000 
bf20: 00000000 00000000 00000000 00000000 00000000 c0061f90 00000142 00000000 
bf40: 8d18be60 00000001 8ecaa000 00000000 00000020 00000080 00000020 00000080 
bf60: 00000027 c0061f9c c0000030 c006208c 00000618 c0060292 c000c45c 00000000 
bf80: 8d007238 7b925b8c 7b925b70 00000002 ffffff0f 00000001 8ecabff8 8d037320 
bfa0: 00000000 00400f84 00000000 00000080 296cf000 00052434 00416130 00416130 
bfc0: 00000000 00000000 7b925e58 7b925fbd 00000002 7b925b70 7b925b8c 7b925b8c 
bfe0: 296580e6 0040320c 00000001 296ce450 90c30b48 00000000 00000054 00000160 

---[ end trace e5b4492a82e3b2bc ]---

Segmentation fault


> -- 
>  Manuel Lauss
