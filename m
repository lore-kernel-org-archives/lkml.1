Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbXJDKCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbXJDKCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 06:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbXJDKCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 06:02:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46461 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbXJDKC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:02:29 -0400
Message-ID: <4704BA1F.4070408@oracle.com>
Date: Thu, 04 Oct 2007 15:32:07 +0530
From: gurudas pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at arch/i386/mm/highmem.c:15!  on 2.6.23-rc8/rc9
References: <47048A0C.4020608@oracle.com> <200710040053.19570.nickpiggin@yahoo.com.au> <200710040139.04201.nickpiggin@yahoo.com.au>
In-Reply-To: <200710040139.04201.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>> While running Oracle database test on x86/6GB RAM machine panics with
>>> following messages.
>> Hi,
>>
>> Hmm, seems like something in sys_remap_file_pages might have broken.
>> It's a bit hard to work out from the backtrace, though.
>>
>> Is it possible you can strace to find the arguments for the
>> remap_file_pages that goes wrong?
> 
> Ahh, I think it's just underflowing the preempt count somewhere, which
> is leading highmem.c:15 to just *think* it is in an interrupt.
> 
> But you aren't running a preemptible kernel, which makes it unusual...
> it would have to be coming from interrupt code (or just random corruption).
> Still, preempt debugging should catch those cases as well.
> 
> So, can you disregard my last message, and instead compile a kernel
> with CONFIG_PREEMPT and CONFIG_DEBUG_PREEMPT, and see what
> messages come up?
With CONFIG_PREEMPT and CONFIG_DEBUG_PREEMPT set I got following 
messages on rc9.


BUG: using smp_processor_id() in preemptible [00000001] code: oracle/3631
caller is kunmap_atomic+0xb/0x82
  [<c04ec241>] debug_smp_processor_id+0xa1/0xb4
  [<c0420dd0>] kunmap_atomic+0xb/0x82
  [<c045fae3>] __do_fault+0x55/0x35b
  [<c04623e8>] handle_mm_fault+0x4d0/0x909
  [<c0460624>] follow_page+0x1d9/0x228
  [<c0462a71>] get_user_pages+0x250/0x332
  [<c0462bce>] make_pages_present+0x7b/0x90
  [<c045f06a>] sys_remap_file_pages+0x2de/0x330
  [<c0404f0e>] syscall_call+0x7/0xb
  [<c0620000>] ioctl_standard_call+0x209/0x2ce
  =======================
WARNING: at kernel/sched.c:3389 sub_preempt_count()
  [<c0420e2f>] kunmap_atomic+0x6a/0x82
  [<c045fae3>] __do_fault+0x55/0x35b
  [<c04623e8>] handle_mm_fault+0x4d0/0x909
  [<c0460624>] follow_page+0x1d9/0x228
  [<c0462a71>] get_user_pages+0x250/0x332
  [<c0462bce>] make_pages_present+0x7b/0x90
  [<c045f06a>] sys_remap_file_pages+0x2de/0x330
  [<c0404f0e>] syscall_call+0x7/0xb
  [<c0620000>] ioctl_standard_call+0x209/0x2ce
  =======================
------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:70!
invalid opcode: 0000 [#1]
PREEMPT SMP
Modules linked in: netconsole autofs4 hidp nfs lockd nfs_acl rfcomm 
l2cap bluetooth sunrpc ipv6 dm_mirror dm_mod video output sbs battery ac 
parport_pc lp parport scb2_flash mtd chipreg sg floppy i2c_piix4 
i2c_core tg3 e1000 button ide_cd serio_raw cdrom aic7xxx 
scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
CPU:    1
EIP:    0060:[<c0420e21>]    Not tainted VLI
EFLAGS: 00010206   (2.6.23-rc9-debug #2)
EIP is at kunmap_atomic+0x5c/0x82
eax: fff8f000   ebx: 0000000f   ecx: 0000002a   edx: 00070000
esi: fffaa000   edi: 97322000   ebp: 000490b1   esp: f672ce1c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process oracle (pid: 3617, ti=f672c000 task=f7587320 task.ti=f672c000)
Stack: 00000003 c341038c c045fae3 c401c080 97322000 f7893b1c f77f85c0 
01000000
        00000000 c341038c 000013d6 00000000 c3410380 00000040 000490b1 
00000003
        000490b1 97322000 00000000 f672ce78 fffaa910 c341038c 00000040 
000490b1
Call Trace:
  [<c045fae3>] __do_fault+0x55/0x35b
  [<c04623e8>] handle_mm_fault+0x4d0/0x909
  [<c0460624>] follow_page+0x1d9/0x228
  [<c0462a71>] get_user_pages+0x250/0x332
  [<c0462bce>] make_pages_present+0x7b/0x90
  [<c045f06a>] sys_remap_file_pages+0x2de/0x330
  [<c0404f0e>] syscall_call+0x7/0xb
  [<c0620000>] ioctl_standard_call+0x209/0x2ce
  =======================
Code: 00 00 00 29 d0 c7 00 00 00 00 00 c7 40 04 00 00 00 00 0f 01 3e eb 
18 81 fe ff ff ff bf 77 04 0f 0b eb fe 3b 35 8c 89 7d c0 72 04 <0f> 0b 
eb fe b8 01 00 00 00 e8 4d 51 00 00 89 e0 25 00 f0 ff ff
EIP: [<c0420e21>] kunmap_atomic+0x5c/0x82 SS:ESP 0068:f672ce1c



Thanks,
-Guru
