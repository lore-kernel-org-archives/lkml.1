Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbYA2OCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbYA2OCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbYA2OCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:02:03 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:43507 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbYA2OCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:organization:to:subject:date:user-agent:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=eY9n8agzXM8Z1NvB5zVxU8H2DAXIiovCSoNJJAWm+f8Td6XtuUEL+yOMh4aF4UhkegbjuzD/rIq3mvmH6KALNPqAUoyjuvyVQElvQ894+B2Y3s51BSdjMQqsMhnrg6B34LDNd0Pyd5l6RP5cjHjWbxW3s5hFRezRoSWVw2M5M3U=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
Organization: NJU
To: k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org
Subject: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
Date: Tue, 29 Jan 2008 22:01:45 +0800
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200801292201.45718.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Build environment: debian sid, gcc-4.2.3, i386.

The bug is in lately git-pull from 

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

And it can be reproduced very easily on a machine with normal cdroms.
It halts booting and I grabbed the bug output with an serial console.

Code around the bug is:

    /*
     * If DRQ is clear, the command has completed.
     */
    if ((stat & DRQ_STAT) == 0) {
        spin_lock_irqsave(&ide_lock, flags);
        if (__blk_end_request(rq, 0, 0))
            BUG();    // Here comes the bug !
        HWGROUP(drive)->rq = NULL;
        spin_unlock_irqrestore(&ide_lock, flags);

        return ide_stopped;
    }

[    6.964356] kernel BUG at drivers/ide/ide-cd.c:1726!
[    6.964435] invalid opcode: 0000 [#1] PREEMPT SMP
[    6.964435] Modules linked in:
[    6.964435]
[    6.964435] Pid: 1138, comm: scsi_id Not tainted (2.6.24-g8561b089 #19)
[    6.964435] EIP: 0060:[<c03edf9c>] EFLAGS: 00010002 CPU: 0
[    6.964435] EIP is at cdrom_newpc_intr+0x2bc/0x2c0
[    6.964435] EAX: 00000001 EBX: 00000002 ECX: 00000001 EDX: 00000001
[    6.964435] ESI: 00000003 EDI: cf0144d8 EBP: c07a3c58 ESP: cf2b59a8
[    6.964435]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    6.964435] Process scsi_id (pid: 1138, ti=cf2b4000 task=cf8856b0 task.ti=cf2b4000)
[    6.964435] Stack: 00000202 00000002 c0778e80 c0133b57 0000009e 00000000 cf009c00 00000050
[    6.964435]        0000000f c07a3c00 cf009c00 c07a3c58 c03df2c9 00000000 00000000 00000000
[    6.964435]        00000000 00000000 00000202 c03edce0 cfbcbb60 00000000 00000000 0000000f
[    6.964435] Call Trace:
[    6.964435]  [<c0133b57>] lock_timer_base+0x27/0x60
[    6.964435]  [<c03df2c9>] ide_intr+0xa9/0x200
[    6.964435]  [<c03edce0>] cdrom_newpc_intr+0x0/0x2c0
[    6.964435]  [<c01503d5>] handle_IRQ_event+0x25/0x50
[    6.964435]  [<c01517d9>] handle_edge_irq+0xb9/0x120
[    6.964435]  [<c010687b>] do_IRQ+0x3b/0x70
[    6.964435]  [<c0104df3>] common_interrupt+0x23/0x28
[    6.964435]  [<c03dfa88>] ide_outsw+0x8/0x10
[    6.964435]  [<c03e0ae4>] ata_output_data+0x84/0x90
[    6.964435]  [<c03dfe07>] atapi_output_bytes+0x27/0x60
[    6.964435]  [<c03ee2f8>] cdrom_transfer_packet_command+0x98/0x110
[    6.964435]  [<c03eafb0>] cdrom_timer_expiry+0x0/0x60
[    6.964435]  [<c03ecd8b>] cdrom_start_packet_command+0x10b/0x130
[    6.964435]  [<c03ee370>] cdrom_do_newpc_cont+0x0/0x30
[    6.964435]  [<c03deb96>] ide_do_request+0x426/0x990
[    6.964435]  [<c0133ee7>] del_timer+0x57/0x70
[    6.964435]  [<c0321ae6>] blk_remove_plug+0x26/0x60
[    6.964435]  [<c031db95>] elv_drain_elevator+0x15/0x60
[    6.964435]  [<c031e6d8>] elv_insert+0xd8/0x170
[    6.964435]  [<c0321ba4>] blk_execute_rq_nowait+0x54/0xa0
[    6.964435]  [<c0321c70>] blk_execute_rq+0x80/0xf0
[    6.964435]  [<c0320a10>] blk_end_sync_rq+0x0/0x30
[    6.964435]  [<c019b563>] bio_add_pc_page+0x23/0x30
[    6.964435]  [<c0320c06>] blk_rq_bio_prep+0x96/0xb0
[    6.964435]  [<c0320f0c>] blk_rq_append_bio+0x1c/0x70
[    6.964435]  [<c03210f2>] blk_rq_map_user+0x122/0x1a0
[    6.964435]  [<c032577e>] sg_io+0x1be/0x320
[    6.964435]  [<c0325bdc>] scsi_cmd_ioctl+0x2fc/0x430
[    6.964435]  [<c03ec9a0>] idecd_revalidate_disk+0x10/0x20
[    6.964435]  [<c01794d9>] get_super+0x99/0xa0
[    6.964435]  [<c019c329>] __invalidate_device+0x39/0x50
[    6.964435]  [<c047d0b7>] cdrom_ioctl+0x37/0xe20
[    6.964435]  [<c01886c6>] __d_lookup+0x146/0x160
[    6.964435]  [<c03eb6ed>] idecd_ioctl+0x17d/0x190
[    6.964435]  [<c01804bf>] __link_path_walk+0xa1f/0xd50
[    6.964435]  [<c032366d>] blkdev_driver_ioctl+0x6d/0x80
[    6.964435]  [<c032390e>] blkdev_ioctl+0x28e/0x810
[    6.964435]  [<c032bd9f>] kobject_get+0xf/0x20
[    6.964435]  [<c0324169>] get_disk+0x29/0xa0
[    6.964435]  [<c03241e7>] exact_lock+0x7/0x10
[    6.964435]  [<c03b33b8>] kobj_lookup+0x148/0x160
[    6.964435]  [<c019cb47>] do_open+0xb7/0x290
[    6.964435]  [<c019cf50>] blkdev_open+0x0/0x70
[    6.964435]  [<c019cf80>] blkdev_open+0x30/0x70
[    6.964435]  [<c01757ed>] __dentry_open+0x16d/0x1f0
[    6.964435]  [<c0175925>] nameidata_to_filp+0x35/0x40
[    6.964435]  [<c017597b>] do_filp_open+0x4b/0x60
[    6.964435]  [<c017a5c2>] sys_readlinkat+0x32/0x90
[    6.964435]  [<c019c218>] block_ioctl+0x18/0x20
[    6.964435]  [<c019c200>] block_ioctl+0x0/0x20
[    6.964435]  [<c0182cfb>] do_ioctl+0x2b/0x90
[    6.964435]  [<c0182f7e>] vfs_ioctl+0x21e/0x2a0
[    6.964435]  [<c018303d>] sys_ioctl+0x3d/0x70
[    6.964435]  [<c010444a>] syscall_call+0x7/0xb
[    6.964435]  =======================
[    6.964435] Code: 04 00 00 89 44 24 0c e9 b4 fe ff ff b8 00 71 70 c0 e8 49 a5 18 00 31 c9 31 d2 89 c3 89 f8 e8 ac 27 f3 ff 85 c0 0f 84 5c fe ff ff <0f> 0b eb fe 83 ec 38 31 d2 89 7c 24 30 89 c7 89 5c 24 28 8d 4c
[    6.964435] EIP: [<c03edf9c>] cdrom_newpc_intr+0x2bc/0x2c0 SS:ESP 0068:cf2b59a8
[    6.964435] Kernel panic - not syncing: Fatal exception in interrupt

-- 
Best Regards,

Nai
