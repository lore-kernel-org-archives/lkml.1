Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYIIQSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYIIQSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYIIQSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:18:23 -0400
Received: from mga05.intel.com ([192.55.52.89]:11186 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754499AbYIIQSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,366,1217833200"; 
   d="scan'208";a="614435874"
Date: Tue, 9 Sep 2008 09:19:03 -0700
From: mark gross <mgross@linux.intel.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: kernel BUG at drivers/pci/intel-iommu.c:1373!
Message-ID: <20080909161903.GA14986@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <1220883964.8537.27.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220883964.8537.27.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 10:26:04AM -0400, Chris Mason wrote:
> Hello everyone,
> 
> I originally hit this with btrfs and assumed I was doing something
> wrong, but it looks like it is a generic problem.  The stack trace at
> the bottom of this email came from the following setup:
> 
> mdadm --create /dev/md0 --level=1 --raid-devices=4 --assume-clean /dev/sd[cdef]
> mkfs.ext4dev /dev/md0 50000000
> mount /dev/md0 /mnt
> synctest -t 100 -F -f -u /mnt
> 
> synctest is an old benchmark from akpm that I dug up to test the btrfs
> fsync code.  google doesn't seem to know much about it anymore, so I've
> tossed it up here:
> 
> http://oss.oracle.com/~mason/synctest/synctest.c
> 
> The important part is that I have a software raid1 volume with 4 drives
> and that I'm hammering on it has hard as I can with synchronous writes
> from 100 procs.
> 
> MD uses bio_clone to make copies of bios for each device in the mirror
> set.  So, using 4 devices means each bio is cloned 3 times, greatly
> increases the chances that I'll send down the same page in different
> bios to different devices.
> 
> Ext4 needs about 10 minutes to trigger on top of MD.  Btrfs needs about
> 30 seconds when it controls the 4 devices itself.
> 
> I've been told this BUG in the io-mmu code comes when someone tries to
> map a page into the iommu that has already been mapped.  It seems like
> that is a natural result of bio_clone, and not an inherent race in the
> code.  But, I've just said everything I know about the iommu code, so my
> guesses don't mean much.

I have a bad feeling about this.  Can you retest booting with a kernel
parrameter "intel_iommu=strict"?

--mgross

> 
> -chris
> 
> kernel BUG at drivers/pci/intel-iommu.c:1373!
> invalid opcode: 0000 [1] SMP
> CPU 5
> Modules linked in: ext4dev jbd2 crc16 netconsole configfs raid1 md_mod loop 3w_9xxx
> Pid: 0, comm: swapper Not tainted 2.6.27-rc5-hgac1744ddb3a6 #78
> RIP: 0010:[<ffffffff803a4ec3>]  [<ffffffff803a4ec3>] domain_page_mapping+0x195/0x1e8
> RSP: 0018:ffff88015fb7faa0  EFLAGS: 00010006
> RAX: 00000000000001d0 RBX: 0000000000000012 RCX: ffff88000000000c
> RDX: 0000000151c08001 RSI: 0000000000000006 RDI: ffff88015b46d3c8
> RBP: ffff88015fb7fb10 R08: 0000000000000001 R09: ffff8801217bf380
> R10: ffff88015a8c9000 R11: 00000000000b77c9 R12: ffff88010b50b000
> R13: ffff88010b50be80 R14: 000000000000000c R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88015fa5ee80(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000004e94d0 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff88015fb78000, task ffff88015fb70590)
> Stack:  0000000000000001 ffff88015b46d3c8 ffff88015b46d380 0000000000107b9a
>  0000000000107b9c 00000000affd0000 0000000000000006 ffff88015b46d3c8
>  00000000affd1000 ffff88015d14d120 00000000affd0000 0000000000002000
> Call Trace:
>  <IRQ>  [<ffffffff803a5bd6>] intel_map_sg+0x1b7/0x255
>  [<ffffffff8048c9e9>] scsi_dma_map+0x4f/0x66
>  [<ffffffffa0000f3e>] twa_scsiop_execute_scsi+0x165/0x3aa [3w_9xxx]
>  [<ffffffff8048664e>] ? scsi_done+0x0/0x21
>  [<ffffffffa0001230>] twa_scsi_queue+0xad/0x109 [3w_9xxx]
>  [<ffffffff80486c9b>] scsi_dispatch_cmd+0x183/0x1d7
>  [<ffffffff8048c6ca>] scsi_request_fn+0x294/0x35e
>  [<ffffffff803813b5>] __blk_run_queue+0x34/0x5b
>  [<ffffffff803813fd>] blk_run_queue+0x21/0x35 
>  [<ffffffff8048aa86>] scsi_run_queue+0x272/0x281
>  [<ffffffff80486742>] ? __scsi_put_command+0x6b/0x74
>  [<ffffffff8048af20>] scsi_next_command+0x36/0x47
>  [<ffffffff8048b197>] scsi_end_request+0x7d/0x8f
>  [<ffffffff8048c0ff>] scsi_io_completion+0x19f/0x3a1
>  [<ffffffff803a5d73>] ? intel_unmap_sg+0xff/0x110
>  [<ffffffff804865fa>] scsi_finish_command+0xa0/0xa9
>  [<ffffffff8048c42d>] scsi_softirq_done+0xd7/0xe0
>  [<ffffffff80381a59>] blk_done_softirq+0x69/0x79
>  [<ffffffff802375e1>] __do_softirq+0x63/0xb1
>  [<ffffffff8020c98c>] call_softirq+0x1c/0x28
>  [<ffffffff8020e398>] do_softirq+0x34/0x74
>  [<ffffffff80237563>] irq_exit+0x3f/0x41
>  [<ffffffff8020dd11>] do_IRQ+0x12e/0x144
>  [<ffffffff8020bc51>] ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff803cd411>] ? acpi_processor_idle+0x312/0x519
>  [<ffffffff803cd40b>] ? acpi_processor_idle+0x30c/0x519
>  [<ffffffff8020a0e6>] ? cpu_idle+0x82/0xb0
>  [<ffffffff805d662d>] ? start_secondary+0x161/0x166
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
