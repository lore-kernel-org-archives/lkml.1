Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbZDOIcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbZDOIcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbZDOIcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:32:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:43652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977AbZDOIcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:32:08 -0400
Date: Wed, 15 Apr 2009 10:32:07 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <axboe@kernel.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] brd: fix cacheflushing
Message-ID: <20090415083207.GB7685@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

brd is missing a flush_dcache_page. On 2nd thoughts, perhaps it is the
pagecache's responsibility to flush user virtual aliases (the driver of
course should flush kernel virtual mappings)... but anyway, there
already exists cache flushing for one direction of transfer, so we
should add the other.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 drivers/block/brd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -275,8 +275,10 @@ static int brd_do_bvec(struct brd_device
 	if (rw == READ) {
 		copy_from_brd(mem + off, brd, sector, len);
 		flush_dcache_page(page);
-	} else
+	} else {
+		flush_dcache_page(page);
 		copy_to_brd(brd, mem + off, sector, len);
+	}
 	kunmap_atomic(mem, KM_USER0);
 
 out:
