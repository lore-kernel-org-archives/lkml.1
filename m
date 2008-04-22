Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbYDVOAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbYDVOAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933812AbYDVOAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:00:20 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57406 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933809AbYDVOAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:00:18 -0400
Date: Tue, 22 Apr 2008 23:00:17 +0900 (JST)
Message-Id: <20080422.230017.69986283.taka@valinux.co.jp>
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 10/10] I/O context inheritance
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The floppy driver will allocate a bio on its stack, so its iocontext
should be set here.

This code hasn't been tested yet.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/drivers/block/floppy.c	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/drivers/block/floppy.c	2008-04-22 21:33:40.000000000 +0900
@@ -3845,12 +3845,14 @@ static int __floppy_read_block_0(struct 
 	init_completion(&complete);
 	bio.bi_private = &complete;
 	bio.bi_end_io = floppy_rb0_complete;
+	bio.bi_io_context = get_io_context(GFP_NOIO, -1);
 
 	submit_bio(READ, &bio);
 	generic_unplug_device(bdev_get_queue(bdev));
 	process_fd_request();
 	wait_for_completion(&complete);
 
+	put_io_context(bio.bi_io_context);
 	__free_page(page);
 
 	return 0;
