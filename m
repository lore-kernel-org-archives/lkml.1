Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZEDF1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZEDF1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 01:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZEDF1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 01:27:14 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:64085 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZEDF1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 01:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aYvYs+Zp1ixdbH/s8rXFmfbEwyuy8W0+TSfmNHf0QoeQK5Hg09tGhRDl09HZfrN6dL
         RZxbEzVdH0NUCfFep+cJIveTIOB22T1HF/C1pBRogC0Jjnc7pno2FRluEHgV4/0QiwV4
         EP9rlSFxuE0wiW93pGMPuw+6/LHbZbKgQ51t8=
MIME-Version: 1.0
In-Reply-To: <20090428184431Z.fujita.tomonori@lab.ntt.co.jp>
References: <egHshlwQQFE.A.8CD.mpE9JB@chimera>
	 <20090428172845R.fujita.tomonori@lab.ntt.co.jp>
	 <db2b43030904280218v61fded68rc585ce9c58ba1cce@mail.gmail.com>
	 <20090428184431Z.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 4 May 2009 10:27:11 +0500
Message-ID: <db2b43030905032227u73a41ec3wa511efcef6a22169@mail.gmail.com>
Subject: Re: [Bug #13001] PCI-DMA: Out of IOMMU space
From: =?UTF-8?B?0JTQsNC90LjQu9CwINCW0YPQutC+0YbQutC40Lk=?= 
	<optimusgd@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       grundler@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/28 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Tue, 28 Apr 2009 14:18:57 +0500
> **UNKNOWN CHARSET** <optimusgd@gmail.com> wrote:
>
>> No, it is regression. I can reproduce that without allowdac and any
>> other unnecessary boot options.
>
> Hmm, in the bug repport, you said that you can't reproduce the problem:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=13001#c15
>
> I can't find your comment like, "I can reproduce that without
> allowdac".

I was under a misapprehension. Later discussion was been in linux-pci
mailing list
http://markmail.org/message/pbng73ojpllln5fl

>
>> In later discussion Grant Grundler ask
>> me apply patch that show 32 bit dma devices in my system. Results I
>> attached to bugreport. Looks like only one 32 bit dma device in my
>> system is ata controller, sata-nv.
>
> Hmm, looks like http://bugzilla.kernel.org/attachment.cgi?id=20895
> said that pata_amd and sata_nv use 32bit dma mask.
>
>
>> I can stable reproduce IOMMU out of space when I write data to sata
>> drive.
>
> Ok, let's figure out what's wrong.
>
> First, can you test v2.6.30-rc3 with the following patch?
>
> http://www.kernel.org/pub/linux/kernel/people/tomo/misc/gart-debug.diff
>
>
> Note that please enable CONFIG_DMA_API_DEBUG, CONFIG_IOMMU_DEBUG, and
> CONFIG_IOMMU_LEAK and see if you can reproduce the problem (of course,
> don't use any kernel option).
>
> When the kernel is out of IOMMU space, it prints some useful
> information.
>

I can't reproduce bug in 2.6.30-rc3. I read and wrote ~ 100gb data
from and to sata drive. Dmesg has two warnings during boot,

------------[ cut here ]------------
WARNING: at lib/dma-debug.c:607 check_unmap+0x542/0x610()
Hardware name: HP xw9400 Workstation
3w-9xxx 0001:45:00.0: DMA-API: device driver tries to free DMA memory
it has not allocated [device address=0x0000000000000000] [size=36
bytes]
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.30-rc3-git7 #1
Call Trace:
 <IRQ>  [<ffffffff8023ce2a>] ? warn_slowpath+0xea/0x160
 [<ffffffff802589ae>] ? sched_clock_cpu+0x6e/0x240
 [<ffffffff802370a2>] ? scheduler_tick+0xc2/0x220
 [<ffffffff80259f4b>] ? getnstimeofday+0x5b/0xe0
 [<ffffffff80256b30>] ? ktime_get_ts+0x30/0x60
 [<ffffffff80256b6c>] ? ktime_get+0xc/0x50
 [<ffffffff8021d828>] ? lapic_next_event+0x18/0x20
 [<ffffffff8025e1d6>] ? tick_dev_program_event+0x36/0xb0
 [<ffffffff8021e29c>] ? smp_apic_timer_interrupt+0x6c/0xa0
 [<ffffffff8020bf83>] ? apic_timer_interrupt+0x13/0x20
 [<ffffffff8023db13>] ? vprintk+0x2d3/0x420
 [<ffffffff803f0b12>] ? check_unmap+0x542/0x610
 [<ffffffff803f0d0e>] ? debug_dma_unmap_sg+0xde/0x180
 [<ffffffff8046c0fb>] ? scsi_dma_unmap+0x6b/0xa0
 [<ffffffff80472559>] ? twa_interrupt+0x3e9/0x6a0
 [<ffffffff80256f2d>] ? __hrtimer_start_range_ns+0x12d/0x2b0
 [<ffffffff8026b3b9>] ? handle_IRQ_event+0x59/0x130
 [<ffffffff8026d4e1>] ? handle_edge_irq+0xc1/0x160
 [<ffffffff8020e377>] ? handle_irq+0x17/0x20
 [<ffffffff8020dae5>] ? do_IRQ+0x65/0xf0
 [<ffffffff8020be13>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80213182>] ? default_idle+0x42/0x50
 [<ffffffff802131c4>] ? c1e_idle+0x34/0x100
 [<ffffffff802581d9>] ? __atomic_notifier_call_chain+0x19/0x50
 [<ffffffff8020a09a>] ? cpu_idle+0x5a/0xc0
---[ end trace eedd91b655a6fdac ]---

and

------------[ cut here ]------------
WARNING: at fs/namei.c:1251 lookup_one_len+0xe9/0x100()
Hardware name: HP xw9400 Workstation
Modules linked in: fuse nfs auth_rpcgss lockd sunrpc scsi_wait_scan
usbhid ohci_hcd usb_storage usb_libusual ehci_hcd usbcore
Pid: 2807, comm: mount Tainted: G        W  2.6.30-rc3-git7 #1
Call Trace:
 [<ffffffff8023ce2a>] ? warn_slowpath+0xea/0x160
 [<ffffffff80564ac6>] ? printk+0x4e/0x58
 [<ffffffff8032d8ba>] ? prepare_error_buf+0x51a/0x610
 [<ffffffff802a0afe>] ? new_slab+0x1ee/0x330
 [<ffffffff8032da91>] ? reiserfs_info+0x71/0xa0
 [<ffffffff802b3bb9>] ? lookup_one_len+0xe9/0x100
 [<ffffffff8033e8bd>] ? reiserfs_xattr_init+0x3d/0xb0
 [<ffffffff8032c2b3>] ? reiserfs_fill_super+0x663/0xb50
 [<ffffffff803dfad2>] ? kobject_get+0x12/0x20
 [<ffffffff80457864>] ? get_device+0x14/0x20
 [<ffffffff805676b2>] ? __down_write_nested+0xb2/0xc0
 [<ffffffff802a37e5>] ? kmem_cache_alloc+0x65/0xa0
 [<ffffffff802ac922>] ? sget+0x3c2/0x410
 [<ffffffff802acc94>] ? get_sb_bdev+0x174/0x1a0
 [<ffffffff8032bc50>] ? reiserfs_fill_super+0x0/0xb50
 [<ffffffff802ab726>] ? vfs_kern_mount+0x56/0xd0
 [<ffffffff802ab803>] ? do_kern_mount+0x53/0x120
 [<ffffffff802c450a>] ? do_mount+0x2ba/0x8c0
 [<ffffffff80568f88>] ? bad_gs+0xc34/0x1e0c
 [<ffffffff802c4bdd>] ? sys_mount+0xcd/0x100
 [<ffffffff8020b4eb>] ? system_call_fastpath+0x16/0x1b
---[ end trace eedd91b655a6fdae ]---

So I hope that bug is gone.

-- 
С уважением Данила Жукоцкий, системный администратор ЗАО "Роснефтегазмаш"
