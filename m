Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbXGMOjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbXGMOjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935593AbXGMOiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:38:20 -0400
Received: from [198.99.130.12] ([198.99.130.12]:50721 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbXGMOiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:38:18 -0400
Date: Fri, 13 Jul 2007 10:37:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Nix <nix@esperi.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/3] UML - Limit request size on COWed devices
Message-ID: <20070713143755.GA6244@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

COWed devices can't handle more than 32 (64 on x86_64) sectors in one
request due to the size of the bitmap being carried around in the
io_thread_req.

Enforce that by telling the block layer not to put too many sectors in
requests to COWed devices.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ubd_kern.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.17/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.17.orig/arch/um/drivers/ubd_kern.c	2007-07-09 08:53:09.000000000 -0400
+++ linux-2.6.17/arch/um/drivers/ubd_kern.c	2007-07-09 18:08:33.000000000 -0400
@@ -712,6 +712,8 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->queue->queuedata = ubd_dev;
 
 	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
+	if(ubd_dev->cow.file != NULL)
+		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
