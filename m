Return-Path: <linux-kernel-owner+w=401wt.eu-S1763351AbZE1OW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763351AbZE1OW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbZE1OWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:22:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33019 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZE1OWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:22:46 -0400
Message-ID: <4A1E9D0B.4090402@gmail.com>
Date: Thu, 28 May 2009 17:17:47 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2009 14:17:49.0522 (UTC) FILETIME=[149A4B20:01C9DF9F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Here's the 9th version of the writeback patches. Changes since v8:
> 
> - Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
>   issue.
> - Get rid of the explicit wait queues, we can just use wake_up_process()
>   since it's just for that one task.
> - Add separate "sync_supers" thread that makes sure that the dirty
>   super blocks get written. We cannot safely do this from bdi_forker_task(),
>   as that risks deadlocking on ->s_umount. Artem, I implemented this
>   by doing the wake ups from a timer so that it would be easier for you
>   to just deactivate the timer when there are no super blocks.

Thanks. 

I've just tried to test UBIFS with your patches (writeback-v9)
and got lots of these warnings:
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:679 __mark_inode_dirty+0x1b6/0x212()
Hardware name: HP xw6600 Workstation
Modules linked in: deflate zlib_deflate lzo lzo_decompress lzo_compress ubifs crc16 ubi nandsim nand nand_ids nand_ecc mtd cpufreq_ondemand acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support tg3 libphy wmi mptsas mptscsih mptbase scsi_transport_sas [last unloaded: microcode]
Pid: 2210, comm: integck Tainted: G        W  2.6.30-rc7-block-2.6 #1
Call Trace:
 [<ffffffff810ecf78>] ? __mark_inode_dirty+0x1b6/0x212
 [<ffffffff8103ffe2>] warn_slowpath_common+0x77/0xa4
 [<ffffffff8104001e>] warn_slowpath_null+0xf/0x11
 [<ffffffff810ecf78>] __mark_inode_dirty+0x1b6/0x212
 [<ffffffff810a4faa>] __set_page_dirty_nobuffers+0xf5/0x105
 [<ffffffffa00c4399>] ubifs_write_end+0x1a9/0x236 [ubifs]
 [<ffffffff8109c7c1>] ? pagefault_enable+0x28/0x33
 [<ffffffff8109cc8f>] ? iov_iter_copy_from_user_atomic+0xfb/0x10a
 [<ffffffff8109e2da>] generic_file_buffered_write+0x18c/0x2d9
 [<ffffffff8109e828>] __generic_file_aio_write_nolock+0x261/0x295
 [<ffffffff8109f09f>] generic_file_aio_write+0x69/0xc5
 [<ffffffffa00c39d6>] ubifs_aio_write+0x14c/0x19e [ubifs]
 [<ffffffff810d1a89>] do_sync_write+0xe7/0x12d
 [<ffffffff812f51c5>] ? __mutex_lock_common+0x36f/0x419
 [<ffffffff812f5218>] ? __mutex_lock_common+0x3c2/0x419
 [<ffffffff81054bd4>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff812f4cae>] ? __mutex_unlock_slowpath+0x10d/0x13c
 [<ffffffff8106211f>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff812f4ccb>] ? __mutex_unlock_slowpath+0x12a/0x13c
 [<ffffffff811578d0>] ? security_file_permission+0x11/0x13
 [<ffffffff810d24ae>] vfs_write+0xab/0x105
 [<ffffffff810d25cc>] sys_write+0x47/0x70
 [<ffffffff8100bc2b>] system_call_fastpath+0x16/0x1b
---[ end trace 7205fe43ac3aa184 ]---

And then eventually my test failed. It yells at this code:

if (bdi_cap_writeback_dirty(bdi) &&
    !test_bit(BDI_registered, &bdi->state)) {
        WARN_ON(1);
    printk("bdi-%s not registered\n", bdi->name);
}

UBIFS is flash file-system. It works on top of MTD devices,
not block devices. Well, to be correct, it works on top of
UBI volumes, which sit on top of MTD devices, which represent
raw flash.

UBIFS needs write-back, but it does not need a full BDI
device. So we used-to have a fake BDI device. Also, UBIFS
wants to disable read-ahead. We do not need anything else
from the block sub-system.

I guess the reason for the complaint is that UBIFS does
not call 'bdi_register()' or 'bdi_register_dev()'. The
question is - should it? 'bdi_register()' a block device,
but we do not have one.

Suggestions?

Artem.
