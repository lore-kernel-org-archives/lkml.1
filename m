Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYENUiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYENUiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYENUie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:38:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:35503 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYENUic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=b0n5mxr5pJLszhHc07y5RkI3+CRmV7Y971Y5GK7puCm79hId0rSEyb/9ZpF3Fkeml5Fi0Thk9aF4pVCOFAEb5FDF+cWha3EnsS5RSszwaAVk33++JZ320c0FLvpLyJAH6BnpzZ3VPStYE2qZh3nw2Taws1UVDAIqlD98bWWzxAs=
Date: Thu, 15 May 2008 01:33:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc2-mm1: sloooow mkfs.ext2
Message-ID: <20080514213352.GA6523@martell.zuzino.mipt.ru>
References: <20080514010129.4f672378.akpm@linux-foundation.org> <20080514211600.GA4748@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514211600.GA4748@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 01:16:00AM +0400, Alexey Dobriyan wrote:
> mkfs.ext2 became kick-ass slow:
> 
> + sudo mkfs.ext2 -F 
> mke2fs 1.40.6 (09-Feb-2008)
> Warning: 256-byte inodes not usable on older systems
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> 9773056 inodes, 39072726 blocks
> 1953636 blocks (5.00%) reserved for the super user
> First data block=0
> Maximum filesystem blocks=4294967296
> 1193 block groups
> 32768 blocks per group, 32768 fragments per group
> 8192 inodes per group
> Superblock backups stored on blocks:
> 	...
> 
> Writing inode tables:  193/1193
> 		       ^^^^
> 		       counter moves slowly,
> 		       occasional counting at what seems to be normal
> 		       speed occur.
> 
> 160 GB SATA disk, no partitions.
> According to sysfs, CFQ is in use, the rest is compiled out.
> 2.6.26-rc2 is fine, mkfs takes ~1 min.
> 
> Slowdown is totally reproducible.
> 
> 
> CONFIG_ATA=y
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_AHCI=y
> CONFIG_ATA_SFF=y
> CONFIG_ATA_PIIX=y
> CONFIG_PATA_JMICRON=y
> 
> 
> /sys/block/sdb/queue/iosched/back_seek_max
> 16384
> /sys/block/sdb/queue/iosched/back_seek_penalty
> 2
> /sys/block/sdb/queue/iosched/fifo_expire_async
> 250
> /sys/block/sdb/queue/iosched/fifo_expire_sync
> 120
> /sys/block/sdb/queue/iosched/quantum
> 4
> /sys/block/sdb/queue/iosched/slice_async
> 40
> /sys/block/sdb/queue/iosched/slice_async_rq
> 2
> /sys/block/sdb/queue/iosched/slice_idle
> 10
> /sys/block/sdb/queue/iosched/slice_sync
> 100

Here is where it spends time (seems to be always the same):

mkfs.ext2     D 0000000000000000     0  4760   4759
 ffff81017ce93a58 0000000000000046 0000000000000000 0000000000000282
 ffff81017e14d640 ffffffff8056f4c0 ffff81017e14d880 ffffffff804679a2
 00000000ffffb5c4 000000007ce93a68 0000000000000003 ffffffff8023d504
Call Trace:
 [<ffffffff804679a2>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff8023d504>] ? __mod_timer+0xc4/0x110
 [<ffffffff80465012>] schedule_timeout+0x62/0xe0
 [<ffffffff8023cee0>] ? process_timeout+0x0/0x10
 [<ffffffff80464ef8>] io_schedule_timeout+0x28/0x40
 [<ffffffff8027663a>] congestion_wait+0x8a/0xb0
 [<ffffffff80248720>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8026fe31>] balance_dirty_pages_ratelimited_nr+0x1a1/0x3f0
 [<ffffffff8026915f>] generic_file_buffered_write+0x1ff/0x740
 [<ffffffff80467870>] ? _spin_unlock+0x30/0x60
 [<ffffffff802acafb>] ? mnt_drop_write+0x7b/0x160
 [<ffffffff80269b30>] __generic_file_aio_write_nolock+0x2a0/0x460
 [<ffffffff802548ed>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff80269df7>] generic_file_aio_write_nolock+0x37/0xa0
 [<ffffffff80292be1>] do_sync_write+0xf1/0x130
 [<ffffffff80256485>] ? trace_hardirqs_on_caller+0xd5/0x160
 [<ffffffff80248720>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80256485>] ? trace_hardirqs_on_caller+0xd5/0x160
 [<ffffffff8025651d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8029339a>] vfs_write+0xaa/0xe0
 [<ffffffff80293940>] sys_write+0x50/0x90
 [<ffffffff8020b69b>] system_call_after_swapgs+0x7b/0x80

