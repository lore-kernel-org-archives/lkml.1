Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZEYFeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZEYFeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZEYFdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:33:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36821 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbZEYFdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:33:51 -0400
Date: Mon, 25 May 2009 15:33:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       raz ben yehuda <raziebe@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: linux-next: md tree build failure
Message-Id: <20090525153346.758483fc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

drivers/md/raid0.c: In function 'create_strip_zones':
drivers/md/raid0.c:243: error: 'struct request_queue' has no member named 'hardsect_size'

Caused by commit e1defc4ff0cf57aca6c5e3ff99fa503f5943c1f1 ("block: Do
away with the notion of hardsect_size") from the block tree interacting
with commit 131e4477401ae76a9cbe8539e4b7819e04cfba36 ("md: raid0: chunk
size check in raid0_run") from the md tree.

I applied the following patch.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b8a0747..0bf275d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -240,7 +240,7 @@ static int create_strip_zones(mddev_t *mddev)
 	 * now since we have the hard sector sizes, we can make sure
 	 * chunk size is a multiple of that sector size
 	 */
-	if (mddev->chunk_size % mddev->queue->hardsect_size) {
+	if (mddev->chunk_size % queue_logical_block_size(mddev->queue)) {
 		printk(KERN_ERR "%s chunk_size of %d not valid\n",
 		       mdname(mddev),
 		       mddev->chunk_size);
