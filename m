Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZIIQrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZIIQrC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZIIQrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:47:01 -0400
Received: from ns1.ata-over-ethernet.org ([12.51.113.4]:32776 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752712AbZIIQrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:47:00 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 9 Sep 2009 12:45:17 -0400
To: ecashin@coraid.com, jens.axboe@oracle.com, akpm@linux-foundation.org,
       apw@canonical.com, bonbons@linux-vserver.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <60772f633c524ba873f569966fccd6ce@coraid.com>
In-Reply-To: <20090908193540.GB18599@kernel.dk>
References: <200909021955.n82JtkrI032267@imap1.linux-foundation.org>
	<20090903063539.GH12579@kernel.dk>
	<2339aa04a4e8fb440a52624273728352@coraid.com>
	<20090904183525.GB18599@kernel.dk>
	<f48e25c99e41e375f2ddd85989cd39e1@coraid.com>
	<20090905051735.GH18599@kernel.dk>
	<366469f19c41e0150028b886f6859019@coraid.com>
	<20090908193540.GB18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugzilla.kernel.org/show_bug.cgi?id=13942

Bruno Premont noticed that aoe throws a BUG during umount of an XFS in
2.6.31:

[ 5259.349897] aoe: bi_io_vec is NULL
[ 5259.349940] ------------[ cut here ]------------
[ 5259.349958] kernel BUG at /usr/src/linux-2.6/drivers/block/aoe/aoeblk.c:177!
[ 5259.349990] invalid opcode: 0000 [#1]

The bio in question is a barrier.  Jens Axboe suggested that such bios
need to be recognized and ended with -EOPNOTSUPP by any driver that
provides its own ->make_request_fn handler and does not handle
barriers.

In testing the changes below eliminate the BUG.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
After this patch has been reviewed I plan to add this patch to
the aoe quilt tree for linux-next.

 drivers/block/aoe/aoeblk.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 2307a27..d6806fb 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -172,6 +172,9 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
 		BUG();
 		bio_endio(bio, -ENXIO);
 		return 0;
+	} else if (bio_barrier(bio)) {
+                bio_endio(bio, -EOPNOTSUPP);
+                return 0;
 	} else if (bio->bi_io_vec == NULL) {
 		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
 		BUG();
-- 
1.5.6.5


-- 
  Ed Cashin
  http://noserose.net/e/
  http://www.coraid.com/
