Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZIJU1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZIJU1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZIJU1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:27:46 -0400
Received: from ns1.coraid.com ([12.51.113.4]:35423 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752973AbZIJU1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:27:46 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 10 Sep 2009 16:27:12 -0400
To: ecashin@coraid.com, jens.axboe@oracle.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, apw@canonical.com, bonbons@linux-vserver.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <6b358a82605cc6a12b76538a8f020667@coraid.com>
In-Reply-To: <178912f8877bbbbbd5aa5cd4a082f8a9@coraid.com>
References: <20090908193540.GB18599@kernel.dk>
	<60772f633c524ba873f569966fccd6ce@coraid.com>
	<20090909180804.3e62331a@lxorguk.ukuu.org.uk>
	<30b7855d211ab5b6bef6fe2cd9b76295@coraid.com>
	<20090909205835.GK18599@kernel.dk>
	<810bbe1723b0a205f9b5018a5ddaa722@coraid.com>
	<20090910074820.GS18599@kernel.dk>
	<84f18127dcdb4762bf9dc6796846087f@coraid.com>
	<20090910195021.GW18599@kernel.dk>
	<aa669085856b88bee82d150efe84b682@coraid.com>
	<178912f8877bbbbbd5aa5cd4a082f8a9@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aoe: end barrier bios with EOPNOTSUPP

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
 drivers/block/aoe/aoeblk.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 2307a27..22efb33 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -172,6 +172,9 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
 		BUG();
 		bio_endio(bio, -ENXIO);
 		return 0;
+	} else if (bio_barrier(bio)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
 	} else if (bio->bi_io_vec == NULL) {
 		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
 		BUG();
-- 
1.5.6.5


-- 
  Ed Cashin <ecashin@coraid.com>
  http://noserose.net/e/
  http://www.coraid.com/
