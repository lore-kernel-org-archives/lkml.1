Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbXHPQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbXHPQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763418AbXHPQZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:25:22 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:51191 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763154AbXHPQZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:25:21 -0400
Date: Thu, 16 Aug 2007 12:24:27 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - Fix previous request size limit fix
Message-ID: <20070816162427.GA8123@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is both 2.6.24 and -stable material ]

The previous patch which limited the number of sectors in a single
request to a COWed device was correct in concept, but the limit was
implemented in the wrong place.

By putting it in ubd_add, it covered the cases where the COWing was
specified on the command line.  However, when the command line only
has the COW file specified, the fact that it's a COW file isn't known
until it's opened, so the limit is missed in these cases.

This patch moves the sector limit from ubd_add to ubd_open_dev.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ubd_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-08-07 13:25:47.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-08-09 13:08:20.000000000 -0400
@@ -612,6 +612,8 @@ static int ubd_open_dev(struct ubd *ubd_
 	ubd_dev->fd = fd;
 
 	if(ubd_dev->cow.file != NULL){
+		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
+
 		err = -ENOMEM;
 		ubd_dev->cow.bitmap = (void *) vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
@@ -712,8 +714,6 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->queue->queuedata = ubd_dev;
 
 	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
-	if(ubd_dev->cow.file != NULL)
-		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
