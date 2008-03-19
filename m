Return-Path: <linux-kernel-owner+w=401wt.eu-S942694AbYCSXXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942694AbYCSXXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbYCSV55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:57:57 -0400
Received: from gw.goop.org ([64.81.55.164]:60620 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964782AbYCSV5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:57:55 -0400
Message-ID: <47E18B8E.8080104@goop.org>
Date: Wed, 19 Mar 2008 14:54:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <patchbomb.1205797011@localhost> <20080319190536.GA11432@elte.hu> <20080319194648.GA20088@elte.hu> <47E17171.9090108@goop.org> <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu>
In-Reply-To: <20080319213343.GA2195@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> kernel crash for sale ;-)
>
> bisected it down to:
>
> | commit aaa7d17e66bc0990d7bee8db5d37e12ae087e206
> | Author: Jeremy Fitzhardinge <jeremy@goop.org>
> | Date:   Mon Mar 17 16:37:16 2008 -0700
> |
> |     x86: only enable interrupts when kernel state has been set up
>
> the bug is that you leak irqs off state into C code... which crashes in 
> the block layer.
>
> Crash log below. For now i've disabled this patch. I suspect you can 
> reproduce this by running a DEBUG_PAGEALLOC+PROVE_LOCKING kernel.
>   

Hm, OK.  I can't see how it can avoid enabling interrupts on that path, 
but I'll look more closely.  What's the .config.  32-bit, obviously.  
Paravirt?

> 	Ingo
>
> ------------>
> [   66.336389] PM: Adding info for No Bus:vcsa1
> [   66.344927] device: 'vcs1': device_unregister
> [   66.348200] PM: Removing info for No Bus:vcs1
> [   66.353463] device: 'vcs1': device_create_release
> [   66.356305] device: 'vcsa1': device_unregister
> [   66.360244] PM: Removing info for No Bus:vcsa1
> [   66.365345] device: 'vcsa1': device_create_release
> [   66.392837] BUG: sleeping function called from invalid context at include/linux/pagemap.h:169
> [   66.396173] in_atomic():0, irqs_disabled():1
> [   66.396173] 1 lock held by init/1772:
> [   66.396173]  #0:  (&mm->mmap_sem){....}, at: [<c01166f3>] do_page_fault+0x93/0x7c0
> [   66.396173] Pid: 1772, comm: init Not tainted 2.6.25-rc6-x86-latest.git #11
> [   66.396173]  [<c011f692>] __might_sleep+0xc2/0xe0
> [   66.396173]  [<c0162c26>] __do_fault+0x3f6/0x490
> [   66.396173]  [<c01641d1>] handle_mm_fault+0x151/0x570
> [   66.396173]  [<c013b046>] ? down_read_trylock+0x56/0x60
> [   66.396173]  [<c0116751>] do_page_fault+0xf1/0x7c0
> [   66.396173]  [<c0116660>] ? do_page_fault+0x0/0x7c0
> [   66.396173]  [<c082fd42>] ? error_code+0x6a/0x70
> [   66.396173]  [<c030f772>] ? __put_user_4+0x12/0x18
> [   66.396173]  [<c0116660>] ? do_page_fault+0x0/0x7c0
> [   66.396173]  [<c082fd42>] error_code+0x6a/0x70
> [   66.396173]  =======================
> [   66.397045] device: 'vcs1': device_add
> [   66.400497] PM: Adding info for No Bus:vcs1
> [   66.411267] device: 'vcsa1': device_add
> [   66.412445] PM: Adding info for No Bus:vcsa1
> [   66.481137] ------------[ cut here ]------------
> [   66.484179] kernel BUG at fs/buffer.c:1274!
> [   66.484179] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [   66.484179] 
> [   66.484179] Pid: 1775, comm: rc.sysinit Not tainted (2.6.25-rc6-x86-latest.git #11)
> [   66.484179] EIP: 0060:[<c0197a35>] EFLAGS: 00010046 CPU: 0
> [   66.484179] EIP is at __find_get_block+0x185/0x1b0
> [   66.484179] EAX: 00000096 EBX: 00000000 ECX: 00000000 EDX: 00212800
> [   66.484179] ESI: 00212800 EDI: 00000000 EBP: f71a6b40 ESP: f71a6b0c
> [   66.484179]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [   66.484179] Process rc.sysinit (pid: 1775, ti=f71a6000 task=f7190000 task.ti=f71a6000)
> [   66.484179] Stack: f7802300 c0141f68 c050595b 00000000 00000280 00000000 f7190000 f71a6b48 
> [   66.484179]        0000030f 00000000 00000000 00000000 f784b424 f71a6ba8 c0197a80 00001000 
> [   66.484179]        c0141f68 c0a965a0 f7693ae4 00000286 00212800 00000000 f7802300 f7190000 
> [   66.484179] Call Trace:
> [   66.484179]  [<c0141f68>] ? __lock_acquire+0x168/0x730
> [   66.484179]  [<c050595b>] ? ata_bmdma_start+0x1b/0x20
> [   66.484179]  [<c0197a80>] ? __getblk+0x20/0x2b0
> [   66.484179]  [<c0141f68>] ? __lock_acquire+0x168/0x730
> [   66.484179]  [<c01c0994>] ? ext3_getblk+0xb4/0x1c0
> [   66.484179]  [<c02fea6d>] ? __generic_unplug_device+0x1d/0x30
> [   66.484179]  [<c01c199a>] ? ext3_bread+0x1a/0x80
> [   66.484179]  [<c01c4370>] ? dx_probe+0x40/0x2f0
> [   66.484179]  [<c010666b>] ? common_interrupt+0x23/0x28
> [   66.484179]  [<c01c50b2>] ? ext3_find_entry+0x252/0x680
> [   66.484179]  [<c082fad0>] ? _spin_unlock_irq+0x20/0x40
> [   66.484179]  [<c0171161>] ? check_bytes_and_report+0x21/0xc0
> [   66.484179]  [<c0141f68>] ? __lock_acquire+0x168/0x730
> [   66.484179]  [<c01c5e9a>] ? ext3_lookup+0x3a/0xd0
> [   66.484179]  [<c017e5a8>] ? do_lookup+0x138/0x180
> [   66.484179]  [<c017fd6c>] ? __link_path_walk+0x6bc/0xd00
> [   66.484179]  [<c0171161>] ? check_bytes_and_report+0x21/0xc0
> [   66.484179]  [<c0108521>] ? do_IRQ+0x81/0xc0
> [   66.484179]  [<c01803f0>] ? link_path_walk+0x40/0xa0
> [   66.484179]  [<c082f9bd>] ? _spin_unlock+0x1d/0x40
> [   66.484179]  [<c01753e0>] ? get_unused_fd_flags+0xc0/0xe0
> [   66.484179]  [<c0180468>] ? path_walk+0x18/0x20
> [   66.484179]  [<c018063e>] ? do_path_lookup+0x6e/0x180
> [   66.484179]  [<c01811ed>] ? __path_lookup_intent_open+0x4d/0x90
> [   66.484179]  [<c01812af>] ? path_lookup_open+0x1f/0x30
> [   66.484179]  [<c018139b>] ? open_namei+0x5b/0x5e0
> [   66.484179]  [<c0141f68>] ? __lock_acquire+0x168/0x730
> [   66.484179]  [<c017568c>] ? do_filp_open+0x2c/0x50
> [   66.484179]  [<c082f9bd>] ? _spin_unlock+0x1d/0x40
> [   66.484179]  [<c01753e0>] ? get_unused_fd_flags+0xc0/0xe0
> [   66.484179]  [<c01756f5>] ? do_sys_open+0x45/0x80
> [   66.484179]  [<c017576c>] ? sys_open+0x1c/0x20
> [   66.484179]  [<c0105caa>] ? syscall_call+0x7/0xb
> [   66.484179]  =======================
> [   66.484179] Code: 40 08 04 75 3b 8b 7d d0 85 ff 0f 84 30 ff ff ff 8b 45 d0 e8 3e f4 ff ff e9 23 ff ff ff 89 d8 e8 32 f4 ff ff 89 f6 e9 78 ff ff ff <0f> 0b eb fe 8d b4 26 00 00 00 00 e8 db 57 69 00 e9 fc fe ff ff 
> [   66.484179] EIP: [<c0197a35>] __find_get_block+0x185/0x1b0 SS:ESP 0068:f71a6b0c
> [   66.484179] ---[ end trace f33d03609d276480 ]---
> [   66.493421] device: 'vcs1': device_unregister
>
>   

    J
