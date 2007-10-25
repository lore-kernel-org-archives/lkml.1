Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbXJYTgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbXJYTgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXJYTfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:35:51 -0400
Received: from ozlabs.org ([203.10.76.45]:51456 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbXJYTfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:35:51 -0400
Date: Thu, 25 Oct 2007 14:32:26 -0500
From: Anton Blanchard <anton@samba.org>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Initialise scatter/gather list in ata_sg_setup
Message-ID: <20071025193226.GA20459@kryten>
References: <20071025192959.GA5827@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025192959.GA5827@kryten>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(Sorry the subject was incorrect)...

After turning on DEBUG_SG I hit a fail:

kernel BUG at include/linux/scatterlist.h:50!

	ata_qc_issue
	ata_scsi_translate
	ipr_queuecommand
	scsi_dispatch_cmd
	scsi_request_fn
	elv_insert
	blk_execute_rq_nowait
	blk_execute_rq
	sg_io
	scsi_cmd_ioctl
	cdrom_ioctl
	sr_block_ioctl
	blkdev_driver_ioctl
	blkdev_ioctl
	block_ioctl
	do_ioctl
	vfs_ioctl
	sys_ioctl
	sg_ioctl_trans

It looks like ata_sg_setup is working on an uninitialised sg table. Call
sg_init_table to initialise it before use.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Jens this is against your sg branch. This fixes the fail but Id
appreciate a confirmation that it's the right fix :)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b5f7c59..4de41bb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4689,6 +4689,7 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 		 * data in this function or read data in ata_sg_clean.
 		 */
 		offset = lsg->offset + lsg->length - qc->pad_len;
+		sg_init_table(psg, 1);
 		sg_set_page(psg, nth_page(sg_page(lsg), offset >> PAGE_SHIFT),
 				qc->pad_len, offset_in_page(offset));
 
