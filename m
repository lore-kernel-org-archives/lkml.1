Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbXEGW6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbXEGW6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966607AbXEGW6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:58:42 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:60543 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbXEGW6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:58:41 -0400
Message-ID: <463FAF1C.8060500@simon.arlott.org.uk>
Date: Mon, 07 May 2007 23:58:36 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: sleeping function called from invalid context at block/cfq-iosched.c
 (Was: Re: 2.6.21-mm1)
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>	<463E3C50.9080207@simon.arlott.org.uk> <20070506135403.a6785f7d.akpm@linux-foundation.org>
In-Reply-To: <20070506135403.a6785f7d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/07 21:54, Andrew Morton wrote:
> On Sun, 06 May 2007 21:36:32 +0100 Simon Arlott <simon@fire.lp0.eu> wrote:
> 
>> On 05/05/07 09:49, Andrew Morton wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
>> Not sure exactly what's going on here, but it happened with a lock held on my 
>> (XFS) filesystem while compiling part of the kernel because I can't do anything 
>> with it now.
>>
>> [ 1128.122000] BUG: sleeping function called from invalid context at block/cfq-iosched.c:1895
>> [ 1128.122000] in_atomic():1, irqs_disabled():0
>> [ 1128.122000] INFO: lockdep is turned off.
>> [ 1128.122000] BUG: unable to handle kernel paging request at virtual address 8b0c4034
>> [ 1128.122000]  printing eip:
>> [ 1128.122000] b0104e36
>> [ 1128.123000] *pde = 00000000
>> [ 1128.123000] Oops: 0000 [#1]
>> [ 1128.123000] PREEMPT
>> [ 1128.123000] Modules linked in: drbd mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
>> [ 1128.123000] CPU:    0
>> [ 1128.123000] EIP:    0060:[<b0104e36>]    Not tainted VLI
>> [ 1128.123000] EFLAGS: 00010246   (2.6.21-git #195)
>> [ 1128.123000] EIP is at dump_trace+0x66/0xb0
>> [ 1128.123000] eax: 00000000   ebx: b18f6fd0   ecx: b06323ec   edx: b05afc71
>> [ 1128.123000] esi: 8b0c4000   edi: 8b0c4ffd   ebp: b18f6fd0   esp: b18f6fb8
>> [ 1128.123000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
>> [ 1128.123000] Process pdflush (pid: 186, ti=b18f6000 task=eff88b10 task.ti=b18f7000)
>> [ 1128.123000] Stack: b000205d 00000000 fffffffc b05b9937 efd1adb4 00000010 b18f6ff0 b0104f3a
>> [ 1128.123000]        b06323ec b05b9937 00000000 b05d33e6 efd1adb4 b05d33e6 b18f7000 b0104f62
>> [ 1128.123000]        b05b9937 b18f700c
>> [ 1128.123000] Call Trace:
>> [ 1128.123000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
>> [ 1128.123000]  [<b0104ffb>] show_stack_log_lvl+0x8b/0xb0
>> [ 1128.123000]  [<b0105243>] show_registers+0x1c3/0x320
>> [ 1128.123000]  [<b0105525>] die+0x105/0x230
>> [ 1128.123000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
>> [ 1128.123000]  [<b04eae3a>] error_code+0x6a/0x70
>> [ 1128.123000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
>> [ 1128.123000]  [<b0104f62>] show_trace+0x12/0x20
>> [ 1128.123000]  =======================
>> [ 1128.123000] Code: 18 8b 4d 08 8b 45 0c 8b 53 04 ff 51 08 8b 03 39 d8 76 06 89 c3 39 f3 77 e4 8b 4d 08 ba 71 fc 5a b0 8b 45 0c ff 51 0c 85 c0 78 38 <8b> 76 34 85 f6 74 31 8d 76 00 e8 bb d7 00 00 eb b3 89 eb eb af
>> [ 1128.123000] EIP: [<b0104e36>] dump_trace+0x66/0xb0 SS:ESP 0068:b18f6fb8
> 
> Mess.  Someone incorrectly called the IO scheduler under a spinlock (or
> similar), CFQ tried to do a dump_stack(), but the dump_stack() code
> exploded.  Usually this happens when the x86_64 tree contains stacktrace
> improvements, but the unwinder (at least) wasn't present in -mm1.
> 
> How come those addresses are 0xb0......, btw?  You're running a different
> vm split?

I've just got this under mainline too now (0ec54aa8af5e6faa346aa55a1ad15ee6c25bb42d 2007-05-05 22:08:06):

[84567.084000] BUG: scheduling while atomic: pdflush/0xeff84acf/186
[84567.084000] INFO: lockdep is turned off.
[84567.084000] do_IRQ: stack overflow: 440
[84567.084000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[84567.084000]  [<b0104f62>] show_trace+0x12/0x20
[84567.084000]  [<b0105075>] dump_stack+0x15/0x20
[84567.084000]  [<b01069a8>] do_IRQ+0xd8/0xe0
[84567.084000]  [<b0104bd6>] common_interrupt+0x2e/0x34
[84567.084000]  [<b0120a28>] printk+0x18/0x20
[84567.084000]  [<b0140b33>] debug_show_held_locks+0x23/0x30
[84567.084000]  [<b04e7fea>] schedule+0x52a/0x680
[84567.084000]  [<b04e8a0a>] schedule_timeout+0x8a/0x90
[84567.084000]  [<b026c61e>] xlog_state_sync+0x21e/0x260
[84567.084000]  [<b0269274>] _xfs_log_force+0x44/0x70
[84567.084000]  [<b022dd22>] xfs_alloc_search_busy+0xd2/0xe0
[84567.084000]  [<b022d1e6>] xfs_alloc_get_freelist+0xe6/0x100
[84567.084000]  [<b022fb7f>] xfs_alloc_split+0x1f/0x4c0
[84567.084000]  [<b022ec3d>] xfs_alloc_insrec+0x35d/0x3b0
[84567.084000]  [<b02304f9>] xfs_alloc_insert+0x59/0xd0
[84567.084000]  [<b022c847>] xfs_free_ag_extent+0x297/0x640
[84567.084000]  [<b022ce11>] xfs_alloc_fix_freelist+0x1d1/0x4c0
[84567.084000]  [<b022d73b>] xfs_alloc_vextent+0x1eb/0x4b0
[84567.084000]  [<b023d4bb>] xfs_bmap_btalloc+0x3bb/0x8f0
[84567.084000]  [<b023da11>] xfs_bmap_alloc+0x21/0x40
[84567.084000]  [<b02411bf>] xfs_bmapi+0xdbf/0x1450
[84567.084000]  [<b0266b4a>] xfs_iomap_write_allocate+0x2ba/0x520
[84567.084000]  [<b026587b>] xfs_iomap+0x45b/0x470
[84567.084000]  [<b028d85c>] xfs_bmap+0x2c/0x40
[84567.084000]  [<b0284a0c>] xfs_map_blocks+0x3c/0x80
[84567.084000]  [<b0285953>] xfs_page_state_convert+0x2f3/0x670
[84567.084000]  [<b0285d2a>] xfs_vm_writepage+0x5a/0xf0
[84567.084000]  [<b01539a6>] generic_writepages+0x226/0x360
[84567.084000]  [<b0285de4>] xfs_vm_writepages+0x24/0x60
[84567.084000]  [<b0153b0c>] do_writepages+0x2c/0x50
[84567.084000]  [<b01887d9>] __sync_single_inode+0x59/0x1f0
[84567.084000]  [<b01889b4>] __writeback_single_inode+0x44/0x1d0
[84567.084000]  [<b0188d09>] sync_sb_inodes+0x1c9/0x2e0
[84567.084000]  [<b0188eee>] writeback_inodes+0xce/0xe0
[84567.084000]  [<b01535c3>] wb_kupdate+0x73/0xf0
[84567.084000]  [<b015419e>] __pdflush+0xce/0x1a0
[84567.084000]  [<b0154295>] pdflush+0x25/0x30
[84567.084000]  [<b01342b4>] kthread+0x94/0xd0
[84567.084000]  [<b0104d7b>] kernel_thread_helper+0x7/0x1c
[84567.084000]  =======================
[84567.087000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[84567.087000]  [<b0104f62>] do_IRQ: stack overflow: 328
[84567.087000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[84567.087000]  [<b0104f62>] show_trace+0x12/0x20
[84567.087000]  [<b0105075>] dump_stack+0x15/0x20
[84567.087000]  [<b01069a8>] do_IRQ+0xd8/0xe0
[84567.087000]  [<b0104bd6>] common_interrupt+0x2e/0x34
[84567.087000]  [<b0120a28>] printk+0x18/0x20
[84567.087000]  [<b0104f0d>] print_trace_address+0x1d/0x30
[84567.087000]  [<b0104e18>] dump_trace+0x48/0xb0
[84567.087000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[84567.087000]  [<b0104f62>] show_trace+0x12/0x20
[84567.087000]  [<b0105075>] dump_stack+0x15/0x20
[84567.087000]  [<b04e7ffa>] schedule+0x53a/0x680
[84567.087000]  [<b04e8a0a>] schedule_timeout+0x8a/0x90
[84567.087000]  [<b026c61e>] xlog_state_sync+0x21e/0x260
[84567.087000]  [<b0269274>] _xfs_log_force+0x44/0x70
[84567.087000]  [<b022dd22>] xfs_alloc_search_busy+0xd2/0xe0
[84567.087000]  [<b022d1e6>] xfs_alloc_get_freelist+0xe6/0x100
[84567.087000]  [<b022fb7f>] xfs_alloc_split+0x1f/0x4c0
[84567.087000]  [<b022ec3d>] xfs_alloc_insrec+0x35d/0x3b0
[84567.087000]  [<b02304f9>] xfs_alloc_insert+0x59/0xd0
[84567.087000]  [<b022c847>] xfs_free_ag_extent+0x297/0x640
[84567.087000]  [<b022ce11>] xfs_alloc_fix_freelist+0x1d1/0x4c0
[84567.087000]  [<b022d73b>] xfs_alloc_vextent+0x1eb/0x4b0
[84567.087000]  [<b023d4bb>] xfs_bmap_btalloc+0x3bb/0x8f0
[84567.087000]  [<b023da11>] xfs_bmap_alloc+0x21/0x40
[84567.087000]  [<b02411bf>] xfs_bmapi+0xdbf/0x1450
[84567.087000]  [<b0266b4a>] xfs_iomap_write_allocate+0x2ba/0x520
[84567.087000]  [<b026587b>] xfs_iomap+0x45b/0x470
[84567.087000]  [<b028d85c>] xfs_bmap+0x2c/0x40
[84567.087000]  [<b0284a0c>] xfs_map_blocks+0x3c/0x80
[84567.087000]  [<b0285953>] xfs_page_state_convert+0x2f3/0x670
[84567.087000]  [<b0285d2a>] xfs_vm_writepage+0x5a/0xf0
[84567.087000]  [<b01539a6>] generic_writepages+0x226/0x360
[84567.087000]  [<b0285de4>] xfs_vm_writepages+0x24/0x60
[84567.087000]  [<b0153b0c>] do_writepages+0x2c/0x50
[84567.087000]  [<b01887d9>] __sync_single_inode+0x59/0x1f0
[84567.087000]  [<b01889b4>] __writeback_single_inode+0x44/0x1d0
[84567.087000]  [<b0188d09>] sync_sb_inodes+0x1c9/0x2e0
[84567.087000]  [<b0188eee>] writeback_inodes+0xce/0xe0
[84567.087000]  [<b01535c3>] wb_kupdate+0x73/0xf0
[84567.087000]  [<b015419e>] __pdflush+0xce/0x1a0
[84567.087000]  [<b0154295>] pdflush+0x25/0x30
[84567.087000]  [<b01342b4>] kthread+0x94/0xd0
[84567.087000]  [<b0104d7b>] kernel_thread_helper+0x7/0x1c
[84567.087000] BUG: unable to handle kernel paging request at virtual address 00008034
[84567.087000]  printing eip:
[84567.087000] b0104e36
[84567.087000] *pde = 00000000
[84567.087000] Oops: 0000 [#1]
[84567.087000] PREEMPT
[84567.087000] Modules linked in: drbd mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
[84567.087000] CPU:    0
[84567.087000] EIP:    0060:[<b0104e36>]    Not tainted VLI
[84567.087000] EFLAGS: 00010046   (2.6.21-git #197)
[84567.087000] EIP is at dump_trace+0x66/0xb0
[84567.087000] eax: 00000000   ebx: b18f6fe0   ecx: b06323ec   edx: b05afc71
[84567.087000] esi: 00008000   edi: 00008ffd   ebp: b18f6138   esp: b18f6120
[84567.087000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
[84567.087000] Process pdflush (pid: 186, ti=b18f5000 task=eff84ad0 task.ti=b18f6000)
[84567.087000] Stack: b18f6130 b04ea9af 00000001 b05b9937 0000000a b06d656e b18f6158 b0104f3a
[84567.087000]        b06323ec b05b9937 00000000 b06356a8 b18f6160 b18f622a b18f6168 b0104f62
[84567.087000]        b05b9937 b06d656e b18f6178 b0105075 b05afeac b18f6184 b18f61a8 b01069a8
[84567.087000] Call Trace:
[84567.087000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000034
[84567.087000]  printing eip:
[84567.087000] b0104e36
[84567.087000] *pde = 00000000
[84567.087000] Oops: 0000 [#2]
[84567.087000] PREEMPT
[84567.087000] Modules linked in: drbd mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
[84567.087000] CPU:    0
[84567.087000] EIP:    0060:[<b0104e36>]    Not tainted VLI
[84567.087000] EFLAGS: 00010046   (2.6.21-git #197)
[84567.087000] EIP is at dump_trace+0x66/0xb0
[84567.087000] eax: 00000000   ebx: b18f5f60   ecx: b06323ec   edx: b05afc71
[84567.087000] esi: 00000000   edi: 00000ffd   ebp: b18f5f60   esp: b18f5f48
[84567.087000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
[84567.087000] Process pdflush (pid: 186, ti=b18f5000 task=eff84ad0 task.ti=b18f6000)
[84567.087000] Stack: 5b3e303c 36353438 38302e37 b05afcde 00000018 00000000 b18f5f80 b0104f3a
[84567.087000]        b06323ec b05afcde 

Then it just gave up doing anything sane, presumably because of the stack overflow  in do_IRQ:
http://redrum.lp0.eu/tmp/100_4037.jpg
http://redrum.lp0.eu/tmp/100_4038.jpg

-- 
Simon Arlott
