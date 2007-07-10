Return-Path: <linux-kernel-owner+w=401wt.eu-S1764679AbXGKAdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764679AbXGKAdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbXGKAdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:33:43 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38259 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759738AbXGKAdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:33:42 -0400
Date: Tue, 10 Jul 2007 12:49:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - limit requests on COW devices to 32 sectors
Message-ID: <20070710164902.GA7820@c2.user-mode-linux.org>
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
