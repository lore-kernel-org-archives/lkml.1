Return-Path: <linux-kernel-owner+w=401wt.eu-S1764912AbXHKTC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764912AbXHKTC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762580AbXHKS6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:25 -0400
Received: from 1wt.eu ([62.212.114.60]:1559 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762447AbXHKS6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:22 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184845.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:09 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Olaf Kirch <olaf.kirch@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 17/28] dm crypt: fix avoid cloned bio ref after free
Content-Disposition: inline; filename=0017-dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not access the bio after generic_make_request

We should never access a bio after generic_make_request - there's no guarantee
it still exists.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/dm-crypt.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index bffaf1c..28831a9 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -655,9 +655,12 @@ static void process_write(struct crypt_io *io)
 
 		generic_make_request(clone);
 
+		/* Do not reference clone after this - it
+		 * may be gone already. */
+
 		/* out of memory -> run queues */
 		if (remaining)
-			congestion_wait(bio_data_dir(clone), HZ/100);
+			congestion_wait(WRITE, HZ/100);
 	}
 }
 
-- 
1.5.2.4

-- 
