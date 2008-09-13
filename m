Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYIMRx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYIMRx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 13:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYIMRxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 13:53:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:16485 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYIMRxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 13:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QOuhwuoBYluis4EQfbxc46CXUXQUEEmpJnlTie9bnGbhPggu7mNfEekTtZQj27Y4mJ
         tBboLAbqtOjzDnPNNtDbmlORW1ZgUqZdqJ+wyYTetro/ZV23nVw/DPfKQNF1wb8S/a4c
         EF5EeP2yxGZsUzYAmrVp+0qCYRisqvnbFhAX0=
Message-ID: <6278d2220809131053p303e839dy5521d5975523fea8@mail.gmail.com>
Date: Sat, 13 Sep 2008 18:53:13 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Ingo Molnar" <mingo@elte.hu>, torvalds@linux-foundation.org
Subject: Re: [2.6.27-rc6, patch] fix SWIOTLB oops...
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com,
       "Jens Axboe" <jens.axboe@oracle.com>, tony.luck@intel.com,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080911222838V.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220809101307h798bb921m3b471f29ce8150ad@mail.gmail.com>
	 <20080911222838V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 2:29 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 10 Sep 2008 21:07:55 +0100
> "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
>
>> With SWIOTLB being enabled and straight-forward page allocation
>> failure [1], the swiotlb_alloc_coherent fall-back path hits an issue
>> [2], resulting in my webcam failing to work.
>>
>> At the time of oops, RDI is clearly a pointer to a structure which has
>> arrived as NULL, leading to the typo in swiotlb_map_single's callsite
>> arguments.
>>
>> Correctly passing the device structure [3] addresses the issue and
>> gets my webcam working again (the allocation failure still occuring).
>>
>> Please apply,
>>   Daniel
>>
>> --- [1]
>>
>> skype: page allocation failure. order:3, mode:0x1
>> Pid: 5895, comm: skype Not tainted 2.6.27-rc6-235c-debug #1
>>
>> Call Trace:
>>  [<ffffffff802b7cf0>] __alloc_pages_internal+0x4a0/0x5d0
>>  [<ffffffff802d5ddd>] alloc_pages_current+0xad/0x110
>>  [<ffffffff802b4ccd>] __get_free_pages+0x1d/0x60
>>  [<ffffffff8046cd39>] swiotlb_alloc_coherent+0x49/0x180
>>  [<ffffffff80212731>] dma_alloc_coherent+0x281/0x310
>>  [<ffffffff805621c0>] hcd_buffer_alloc+0x50/0x90
>>  [<ffffffff805547fd>] usb_buffer_alloc+0x2d/0x40
>>  [<ffffffffa0056763>] uvc_alloc_urb_buffers+0x53/0xf0 [uvcvideo]
>>  [<ffffffffa0056958>] uvc_init_video+0x158/0x3e0 [uvcvideo]
>>  [<ffffffffa0056c17>] uvc_video_enable+0x37/0x80 [uvcvideo]
>>  [<ffffffffa0055853>] uvc_v4l2_do_ioctl+0x723/0x1260 [uvcvideo]
>>  [<ffffffff8026dd61>] ? trace_hardirqs_off_caller+0x21/0xc0
>>  [<ffffffff8026dd61>] ? trace_hardirqs_off_caller+0x21/0xc0
>>  [<ffffffffa0032c9f>] video_usercopy+0x19f/0x390 [videodev]
>>  [<ffffffffa0055130>] ? uvc_v4l2_do_ioctl+0x0/0x1260 [uvcvideo]
>>  [<ffffffff8026d0ce>] ? put_lock_stats+0xe/0x30
>>  [<ffffffffa0054dad>] uvc_v4l2_ioctl+0x4d/0x80 [uvcvideo]
>>  [<ffffffffa0045083>] native_ioctl+0x83/0x90 [compat_ioctl32]
>>  [<ffffffffa004534e>] v4l_compat_ioctl32+0x2be/0x1da4 [compat_ioctl32]
>>  [<ffffffff806aad21>] ? do_page_fault+0x3d1/0xae0
>>  [<ffffffff80270ccd>] ? trace_hardirqs_on+0xd/0x10
>>  [<ffffffff80270c59>] ? trace_hardirqs_on_caller+0x149/0x1b0
>>  [<ffffffff80270ccd>] ? trace_hardirqs_on+0xd/0x10
>>  [<ffffffff80329afa>] compat_sys_ioctl+0x8a/0x3c0
>>  [<ffffffff806a700d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>>  [<ffffffff8022f816>] sysenter_dispatch+0x7/0x2c
>>  [<ffffffff806a6fce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>
>> Mem-Info:
>> Node 0 DMA per-cpu:
>> CPU    0: hi:    0, btch:   1 usd:   0
>> CPU    1: hi:    0, btch:   1 usd:   0
>> Node 0 DMA32 per-cpu:
>> CPU    0: hi:  186, btch:  31 usd:   3
>> CPU    1: hi:  186, btch:  31 usd:   0
>> Node 0 Normal per-cpu:
>> CPU    0: hi:  186, btch:  31 usd:  23
>> CPU    1: hi:  186, btch:  31 usd: 179
>> Active:78545 inactive:48683 dirty:31 writeback:0 unstable:2
>>  free:830202 slab:17516 mapped:17473 pagetables:3496 bounce:0
>> Node 0 DMA free:36kB min:28kB low:32kB high:40kB active:0kB
>> inactive:0kB present:15156kB pages_scanned:0 all_unreclaimable? no
>> lowmem_reserve[]: 0 3207 3956 3956
>> Node 0 DMA32 free:3197192kB min:6512kB low:8140kB high:9768kB
>> active:0kB inactive:0kB present:3284896kB pages_scanned:0
>> all_unreclaimable? no
>> lowmem_reserve[]: 0 0 748 748
>> Node 0 Normal free:123580kB min:1516kB low:1892kB high:2272kB
>> active:314180kB inactive:194732kB present:766464kB pages_scanned:0
>> all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0 0
>> Node 0 DMA: 1*4kB 0*8kB 0*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB
>> 0*1024kB 0*2048kB 0*4096kB = 36kB
>> Node 0 DMA32: 4*4kB 3*8kB 2*16kB 3*32kB 4*64kB 5*128kB 3*256kB 5*512kB
>> 4*1024kB 5*2048kB 776*4096kB = 3197224kB
>> Node 0 Normal: 14*4kB 14*8kB 8*16kB 6*32kB 1*64kB 3*128kB 3*256kB
>> 2*512kB 4*1024kB 1*2048kB 28*4096kB = 123560kB
>> 64847 total pagecache pages
>> 0 pages in swap cache
>> Swap cache stats: add 0, delete 0, find 0/0
>> Free swap  = 502752kB
>> Total swap = 502752kB
>> 1048576 pages RAM
>> 52120 pages reserved
>> 71967 pages shared
>> 143004 pages non-shared
>>
>> --- [2]
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000000000002c8
>> IP: [<ffffffff8046c84c>] map_single+0x1c/0x280
>> PGD 10e54e067 PUD 10e595067 PMD 0
>> Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
>> CPU 0
>> Modules linked in: kvm_intel kvm microcode uvcvideo compat_ioctl32
>> videodev v4l1_compat shpchp pci_hotplug
>> Pid: 5895, comm: skype Not tainted 2.6.27-rc6-235c-debug #1
>> RIP: 0010:[<ffffffff8046c84c>]  [<ffffffff8046c84c>] map_single+0x1c/0x280
>> RSP: 0018:ffff88010e78d988  EFLAGS: 00210296
>> RAX: 0000780000000000 RBX: 0000000000000000 RCX: 0000000000000002
>> RDX: 0000000000005000 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: ffff88010e78d9e8 R08: 0000000000000000 R09: 0000000000000001
>> R10: ffff88010e78d698 R11: 0000000000000001 R12: 0000000000000002
>> R13: 0000000000000000 R14: 0000000000005000 R15: ffff88012f1c9968
>> FS:  0000000000000000(0000) GS:ffffffff80a6cdc0(0063) knlGS:00000000f6355b90
>> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>> CR2: 00000000000002c8 CR3: 000000010e57d000 CR4: 00000000000026e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process skype (pid: 5895, threadinfo ffff88010e78c000, task ffff88012b9cc460)
>> Stack:  0000000200000000 0000000000005000 0000000000000000 0000000000000000
>>  00000000000017b8 0000000000000000 ffff88010e78d9c8 0000000000000000
>>  0000000000000002 0000000000000000 0000000000005000 ffff88012f1c9968
>> Call Trace:
>>  [<ffffffff8046cbb0>] swiotlb_map_single_attrs+0x60/0xf0
>>  [<ffffffff8046cc4c>] swiotlb_map_single+0xc/0x10
>>  [<ffffffff8046cdee>] swiotlb_alloc_coherent+0xfe/0x180
>>  [<ffffffff80212731>] dma_alloc_coherent+0x281/0x310
>>  [<ffffffff805621c0>] hcd_buffer_alloc+0x50/0x90
>>  [<ffffffff805547fd>] usb_buffer_alloc+0x2d/0x40
>>  [<ffffffffa0056763>] uvc_alloc_urb_buffers+0x53/0xf0 [uvcvideo]
>>  [<ffffffffa0056958>] uvc_init_video+0x158/0x3e0 [uvcvideo]
>>  [<ffffffffa0056c17>] uvc_video_enable+0x37/0x80 [uvcvideo]
>>  [<ffffffffa0055853>] uvc_v4l2_do_ioctl+0x723/0x1260 [uvcvideo]
>>  [<ffffffff8026dd61>] ? trace_hardirqs_off_caller+0x21/0xc0
>>  [<ffffffff8026dd61>] ? trace_hardirqs_off_caller+0x21/0xc0
>>  [<ffffffffa0032c9f>] video_usercopy+0x19f/0x390 [videodev]
>>  [<ffffffffa0055130>] ? uvc_v4l2_do_ioctl+0x0/0x1260 [uvcvideo]
>>  [<ffffffff8026d0ce>] ? put_lock_stats+0xe/0x30
>>  [<ffffffffa0054dad>] uvc_v4l2_ioctl+0x4d/0x80 [uvcvideo]
>>  [<ffffffffa0045083>] native_ioctl+0x83/0x90 [compat_ioctl32]
>>  [<ffffffffa004534e>] v4l_compat_ioctl32+0x2be/0x1da4 [compat_ioctl32]
>>  [<ffffffff806aad21>] ? do_page_fault+0x3d1/0xae0
>>  [<ffffffff80270ccd>] ? trace_hardirqs_on+0xd/0x10
>>  [<ffffffff80270c59>] ? trace_hardirqs_on_caller+0x149/0x1b0
>>  [<ffffffff80270ccd>] ? trace_hardirqs_on+0xd/0x10
>>  [<ffffffff80329afa>] compat_sys_ioctl+0x8a/0x3c0
>>  [<ffffffff806a700d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>>  [<ffffffff8022f816>] sysenter_dispatch+0x7/0x2c
>>  [<ffffffff806a6fce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>
>> Code: 45 31 c0 48 89 e5 e8 a4 ff ff ff c9 c3 66 90 55 48 89 e5 41 57
>> 41 56 41 55 41 54 53 48 83 ec 38 48 89 75 b0 48 89 55 a8 89 4d a4 <48>
>> 8b 87 c8 02 00 00 48 85 c0 0f 84 1c 02 00 00 48 8b 58 08 48
>> RIP  [<ffffffff8046c84c>] map_single+0x1c/0x280
>>  RSP <ffff88010e78d988>
>> CR2: 00000000000002c8
>> ---[ end trace 5d15baeeb7025a0e ]---
>>
>> --- [3]
>>
>> ffffffff8046c830 <map_single>:
>> map_single():
>> /store/kernel/linux/lib/swiotlb.c:291
>> ffffffff8046c830:       55                      push   %rbp
>> ffffffff8046c831:       48 89 e5                mov    %rsp,%rbp
>> ffffffff8046c834:       41 57                   push   %r15
>> ffffffff8046c836:       41 56                   push   %r14
>> ffffffff8046c838:       41 55                   push   %r13
>> ffffffff8046c83a:       41 54                   push   %r12
>> ffffffff8046c83c:       53                      push   %rbx
>> ffffffff8046c83d:       48 83 ec 38             sub    $0x38,%rsp
>> ffffffff8046c841:       48 89 75 b0             mov    %rsi,-0x50(%rbp)
>> ffffffff8046c845:       48 89 55 a8             mov    %rdx,-0x58(%rbp)
>> ffffffff8046c849:       89 4d a4                mov    %ecx,-0x5c(%rbp)
>> dma_get_seg_boundary():
>> /store/kernel/linux/include/linux/dma-mapping.h:80
>> ffffffff8046c84c:       48 8b 87 c8 02 00 00    mov    0x2c8(%rdi),%rax <----
>>
>> --- [4]
>>
>> Fix back-off path when memory allocation fails
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>>
>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>> index 977edbd..8826fdf 100644
>> --- a/lib/swiotlb.c
>> +++ b/lib/swiotlb.c
>> @@ -491,7 +491,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>>                * the lowest available address range.
>>                */
>>               dma_addr_t handle;
>> -             handle = swiotlb_map_single(NULL, NULL, size, DMA_FROM_DEVICE);
>> +             handle = swiotlb_map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
>
> I think that it's better to use map_single instead of
> swiotlb_map_single since we always need swiotlb memory here.
>
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0809.1/0043.html

Thanks Fujita; this looks a better way of doing this. I've tested the
three patches you posted and they address the original issue I bumped
into, so seem an appropriate fix for -rc7. Not sure if preceding
comments need tweaking though.

Our work isn't done yet though, since we see unexpected page state [5]
on the release path. Calling the appropriate IOMMU/SWIOTLB release
function [6] corrects this. Verified on x86-64 Intel system with
SWIOTLB in use due to large memory; without this, processes end up
hosed, so I'd say it's -rc7 material.

Thanks,
  Daniel

--- [5]

Bad page state in process 'skype'
page:ffffe20000d52a58 flags:0x0040000000000400
mapping:0000000000000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 4950, comm: skype Not tainted 2.6.27-rc6-235c-debug #6

Call Trace:
 [<ffffffff802b50de>] bad_page+0x7e/0xd0
 [<ffffffff802b74f8>] __free_pages_ok+0x348/0x480
 [<ffffffff806a7ea7>] ? _spin_unlock_irqrestore+0x47/0x80
 [<ffffffff802b7685>] __free_pages+0x35/0x50
 [<ffffffff802b771e>] free_pages+0x7e/0x90
 [<ffffffff80212400>] dma_free_coherent+0x80/0xc0
 [<ffffffff8056211b>] hcd_buffer_free+0x4b/0x90
 [<ffffffff805547b5>] usb_buffer_free+0x25/0x30
 [<ffffffffa005447e>] uvc_uninit_video+0x7e/0xb0 [uvcvideo]
 [<ffffffffa0054c28>] uvc_video_enable+0x48/0x80 [uvcvideo]
 [<ffffffffa0053828>] uvc_v4l2_do_ioctl+0x6f8/0x1260 [uvcvideo]
 [<ffffffff8026dd61>] ? trace_hardirqs_off_caller+0x21/0xc0
 [<ffffffff8026de0d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffffa0030c9f>] video_usercopy+0x19f/0x390 [videodev]
 [<ffffffffa0053130>] ? uvc_v4l2_do_ioctl+0x0/0x1260 [uvcvideo]
 [<ffffffff8026d084>] ? get_lock_stats+0x34/0x70
 [<ffffffff8026d0ce>] ? put_lock_stats+0xe/0x30
 [<ffffffff80274c50>] ? futex_wake+0x100/0x130
 [<ffffffffa0052dad>] uvc_v4l2_ioctl+0x4d/0x80 [uvcvideo]
 [<ffffffffa0043083>] native_ioctl+0x83/0x90 [compat_ioctl32]
 [<ffffffffa004334e>] v4l_compat_ioctl32+0x2be/0x1da4 [compat_ioctl32]
 [<ffffffff8027647b>] ? do_futex+0x9b/0xab0
 [<ffffffff80270ccd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80270c59>] ? trace_hardirqs_on_caller+0x149/0x1b0
 [<ffffffff80270ccd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80329afa>] compat_sys_ioctl+0x8a/0x3c0
 [<ffffffff806a6ffd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8022f816>] sysenter_dispatch+0x7/0x2c
 [<ffffffff806a6fbe>] ? trace_hardirqs_on_thunk+0x3a/0x3f

...followed by dup stack traces with the rest of the pages:

page:ffffe20000d52ac0 flags:0x0040000000000400
mapping:0000000000000000 mapcount:0 count:1
page:ffffe20000d52b28 flags:0x0040000000000400
mapping:0000000000000000 mapcount:0 count:1
page:ffffe20000d52b90 flags:0x0040000000000400
mapping:0000000000000000 mapcount:0 count:1
page:ffffe20000d52bf8 flags:0x0040000000000400
mapping:0000000000000000 mapcount:0 count:1
page:ffffe20000d52c60 flags:0x0040000000000400
mapping:0000000000000000 mapcount:0 count:1
page:ffffe20000d52cc8 flags:0x0040000000000400
mapping:0000000000000000 mapcount:0 count:1
page:ffffe20000d52d30 flags:0x0040000000000400
mapping:0000000000000000 mapcount:0 count:1

--- [6]

Ensure the SWIOTLB/IOMMU buffers aren't incorrectly freed by calling
appropriate release function.
Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 87d4d69..265805c 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -378,7 +378,11 @@ void dma_free_coherent(struct device *dev, size_t size,
 		return;
 	if (ops->unmap_single)
 		ops->unmap_single(dev, bus, size, 0);
-	free_pages((unsigned long)vaddr, order);
+	
+	if (ops->alloc_coherent)
+		ops->free_coherent(dev, size, vaddr, bus);
+	else
+		free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);

-- 
Daniel J Blueman
