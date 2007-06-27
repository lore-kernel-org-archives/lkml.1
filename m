Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXF0C4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXF0C4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXF0Cz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:55:59 -0400
Received: from va-65-40-217-47.sta.embarqhsd.net ([65.40.217.47]:21470 "EHLO
	CVAEX1.VERTICAL.COM" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753945AbXF0Cz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:55:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: scheduling while atomic and DEBUG_SPINLOCK_SLEEP
Date: Tue, 26 Jun 2007 22:55:57 -0400
Message-ID: <4DD3AF7ECBBC43409BA36508938D01851B0E7E@CVAEX1.VERTICAL.COM>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: scheduling while atomic and DEBUG_SPINLOCK_SLEEP
Thread-Index: Ace4ZqyF2icOW991S2Owfln8fM3BBg==
From: "Jon Ringle" <JRingle@vertical.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am sometimes getting the following "scheduling while atomic" dump:

[42949427.370000] scheduling while atomic: sh/0x00000002/144
[42949427.380000] [<c0030370>] (dump_stack+0x0/0x14) from [<c029a868>]
(schedule+0x628/0x6c8)
[42949427.390000] [<c029a240>] (schedule+0x0/0x6c8) from [<c029c92c>]
(__down_read+0xc4/0x128)
[42949427.400000] [<c029c868>] (__down_read+0x0/0x128) from [<c00335a4>]
(do_page_fault+0x84/0x214)
[42949427.400000]  r5 = 00000017  r4 = C02F6168
[42949427.410000] [<c0033520>] (do_page_fault+0x0/0x214) from
[<c0033870>] (do_DataAbort+0x3c/0xa4)
[42949427.420000] [<c0033834>] (do_DataAbort+0x0/0xa4) from [<c002a800>]
(__dabt_svc+0x40/0x60)
[42949427.430000]  r8 = 00000093  r7 = C0186920  r6 = E5903048  r5 =
CF21FD14
[42949427.430000]  r4 = FFFFFFFF
[42949427.440000] [<c0034990>] (do_alignment_ldrstr+0x0/0x130) from
[<c0034fac>] (do_alignment+0x238/0x34c)
[42949427.450000]  r4 = CF21E000
[42949427.450000] [<c0034d74>] (do_alignment+0x0/0x34c) from
[<c0033870>] (do_DataAbort+0x3c/0xa4)
[42949427.460000] [<c0033834>] (do_DataAbort+0x0/0xa4) from [<c002a800>]
(__dabt_svc+0x40/0x60)
[42949427.470000]  r8 = CFD51F34  r7 = 80000000  r6 = 00000001  r5 =
CF21FE58
[42949427.470000]  r4 = FFFFFFFF
[42949427.480000] [<c0186900>] (get_index+0x0/0x5c) from [<c0186bd0>]
(prio_tree_insert+0xac/0x28c)
[42949427.490000] [<c0186b24>] (prio_tree_insert+0x0/0x28c) from
[<c00762f8>] (vma_prio_tree_insert+0x28/0x40)
[42949427.500000] [<c00762d0>] (vma_prio_tree_insert+0x0/0x40) from
[<c007b80c>] (vma_link+0xe0/0x1d4)
[42949427.500000]  r5 = CFC4F90C  r4 = CF21E000
[42949427.510000] [<c007b72c>] (vma_link+0x0/0x1d4) from [<c007cfe8>]
(do_mmap_pgoff+0x390/0x760)
[42949427.520000]  r7 = CFC374E0  r6 = 00001000  r5 = 4005E000  r4 =
CFC4F90C
[42949427.520000] [<c007cc58>] (do_mmap_pgoff+0x0/0x760) from
[<c002f64c>] (old_mmap+0x108/0x130)
[42949427.530000] [<c002f544>] (old_mmap+0x0/0x130) from [<c002aca0>]
(ret_fast_syscall+0x0/0x2c)

So, I think I need to try to figure out why the preempt_count is 2. I
enabled CONFIG_DEBUG_SPINLOCK_SLEEP thinking that it would give me more
information about this problem. I got two different hits with this
turned on.

The first dump is coming from Intel's ixp400eth driver:

[42949391.910000] Debug: sleeping function called from invalid context
at include/asm/semaphore.h:69
[42949391.910000] in_atomic():1, irqs_disabled():128
[42949391.910000] [<c00303bc>] (dump_stack+0x0/0x14) from [<c003f6f0>]
(__might_sleep+0xe8/0x114)
[42949391.910000] [<c003f608>] (__might_sleep+0x0/0x114) from
[<bf003a20>] (ixOsalMutexLock+0x190/0x1d8 [ixp400eth])
[42949391.910000]  r5 = BF0A3D84  r4 = CFC2D2C0
[42949391.910000] [<bf003890>] (ixOsalMutexLock+0x0/0x1d8 [ixp400eth])
from [<bf00bc40>] (ixEthAccPortMulticastAddressLeaveAll+0x38/0x60
[ixp400eth])
[42949391.910000]  r8 = FFFFFF9D  r7 = BF09ED88  r6 = C43F5260  r5 =
CFD36000
[42949391.910000]  r4 = 00000000
[42949391.910000] [<bf00bc08>]
(ixEthAccPortMulticastAddressLeaveAll+0x0/0x60 [ixp400eth]) from
[<bf001734>] (dev_set_multicast_list+0x68/0x214 [ixp400eth])
[42949391.910000]  r4 = C43F5000
[42949391.910000] [<bf0016cc>] (dev_set_multicast_list+0x0/0x214
[ixp400eth]) from [<c01ea834>] (__dev_mc_upload+0x3c/0x40)
[42949391.910000]  r7 = 00000000  r6 = 00001002  r5 = 00000000  r4 =
CFD36000
[42949391.910000] [<c01ea7f8>] (__dev_mc_upload+0x0/0x40) from
[<c01ea868>] (dev_mc_upload+0x30/0x44)
[42949391.910000] [<c01ea838>] (dev_mc_upload+0x0/0x44) from
[<c01e551c>] (dev_open+0x70/0xcc)
[42949391.910000]  r4 = C43F5000
[42949391.910000] [<c01e54ac>] (dev_open+0x0/0xcc) from [<c01e6f68>]
(dev_change_flags+0x68/0x138)
[42949391.910000]  r5 = 00001043  r4 = C43F5000
[42949391.910000] [<c01e6f00>] (dev_change_flags+0x0/0x138) from
[<c0231454>] (devinet_ioctl+0x64c/0x72c)
[42949391.910000]  r7 = CFA09760  r6 = CFD36000  r5 = BEFA8D2C  r4 =
CFB99D40
[42949391.910000] [<c0230e08>] (devinet_ioctl+0x0/0x72c) from
[<c0232760>] (inet_ioctl+0x1b0/0x1d4)
[42949391.910000] [<c02325b0>] (inet_ioctl+0x0/0x1d4) from [<c01dac0c>]
(sock_ioctl+0x184/0x2f0)
[42949391.910000] [<c01daa88>] (sock_ioctl+0x0/0x2f0) from [<c00a2e4c>]
(do_ioctl+0x84/0xa0)
[42949391.910000]  r8 = C002AE44  r7 = BEFA8D2C  r6 = 00008914  r5 =
FFFFFFE7
[42949391.910000]  r4 = C43F1800
[42949391.910000] [<c00a2dc8>] (do_ioctl+0x0/0xa0) from [<c00a2efc>]
(vfs_ioctl+0x94/0x314)
[42949391.910000]  r7 = 00000000  r6 = BEFA8D2C  r5 = 00000003  r4 =
C43F1800
[42949391.910000] [<c00a2e68>] (vfs_ioctl+0x0/0x314) from [<c00a31bc>]
(sys_ioctl+0x40/0x64)
[42949391.910000]  r8 = C002AE44  r7 = 00000036  r6 = 00008914  r5 =
FFFFFFF7
[42949391.910000]  r4 = C43F1800
[42949391.910000] [<c00a317c>] (sys_ioctl+0x0/0x64) from [<c002aca0>]
(ret_fast_syscall+0x0/0x2c)
[42949391.910000]  r6 = 00000000  r5 = BEFA8E1C  r4 = BEFA8D2C

And the other one is from one of our own kernel modules:

[42949490.890000] Debug: sleeping function called from invalid context
at mm/slab.c:2729
[42949490.890000] in_atomic():0, irqs_disabled():128
[42949490.890000] [<c00303bc>] (dump_stack+0x0/0x14) from [<c003f6f0>]
(__might_sleep+0xe8/0x114)
[42949490.890000] [<c003f608>] (__might_sleep+0x0/0x114) from
[<c00897f4>] (kmem_cache_alloc+0x74/0x84)
[42949490.890000]  r5 = 000000D0  r4 = CFFFE0C0
[42949490.890000] [<c0089780>] (kmem_cache_alloc+0x0/0x84) from
[<c002c418>] (request_irq+0x80/0xdc)
[42949490.890000]  r6 = 00000000  r5 = 00000007  r4 = 00000000
[42949490.890000] [<c002c398>] (request_irq+0x0/0xdc) from [<bf11b524>]
(VbusHookInterrupt+0x2c/0x68 [dstdrv])
[42949490.890000] [<bf11b4f8>] (VbusHookInterrupt+0x0/0x68 [dstdrv])
from [<bf11b62c>] (VbusRegisterISR+0xcc/0xfc [dstdrv])
[42949490.890000]  r4 = 20000013
[42949490.890000] [<bf11b560>] (VbusRegisterISR+0x0/0xfc [dstdrv]) from
[<bf119520>] (kEPIsrIoctl+0xac4/0xe30 [dstdrv])
[42949490.890000]  r8 = D085C009  r7 = CFB9B1E0  r6 = 00000002  r5 =
D086C000
[42949490.890000]  r4 = 00000001
[42949490.890000] [<bf118a5c>] (kEPIsrIoctl+0x0/0xe30 [dstdrv]) from
[<bf11af90>] (vert_dst_ioctl+0x8c/0xd8 [dstdrv])
[42949490.890000] [<bf11af04>] (vert_dst_ioctl+0x0/0xd8 [dstdrv]) from
[<c00a2e34>] (do_ioctl+0x6c/0xa0)
[42949490.890000]  r4 = CF2D42C0
[42949490.890000] [<c00a2dc8>] (do_ioctl+0x0/0xa0) from [<c00a2efc>]
(vfs_ioctl+0x94/0x314)
[42949490.890000]  r7 = 00000000  r6 = 00000002  r5 = 00000010  r4 =
CF2D42C0
[42949490.890000] [<c00a2e68>] (vfs_ioctl+0x0/0x314) from [<c00a31bc>]
(sys_ioctl+0x40/0x64)
[42949490.890000]  r8 = C002AE44  r7 = 00000036  r6 = 00006401  r5 =
FFFFFFF7
[42949490.890000]  r4 = CF2D42C0
[42949490.890000] [<c00a317c>] (sys_ioctl+0x0/0x64) from [<c002aca0>]
(ret_fast_syscall+0x0/0x2c)
[42949490.890000]  r6 = BE3FFC78  r5 = BCDFFE20  r4 = 000603B8

Out of these two, the first one that is showing "in_atomic():1" seems
more likely to me to be a potential cause of the "scheduling while
atomic" dump.

Does this logic seem reasonable? Are there other debugging techniques I
can use to narrow down the cause for the "scheduling while atomic"?

Thanks,

Jon

