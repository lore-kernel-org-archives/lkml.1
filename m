Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYKOT1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYKOT1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 14:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYKOT1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 14:27:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:56372 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYKOT1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 14:27:03 -0500
Date: Sat, 15 Nov 2008 11:27:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: htejun@gmail.com, akpm@linux-foundation.org, jens.axboe@oracle.com
Subject: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081115112751.1d38c072@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From fd5530ac75a919a20bf7951e90a2b12323e9c0a0 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 15 Nov 2008 11:23:58 -0800
Subject: [PATCH] Fix kunmap() argument in sg_miter_stop

kunmap() takes as argument the struct page that orginally got kmap()'d,
however the sg_miter_stop() function passed it the kernel virtual address
instead, resulting in "kernel BUG at arch/x86/mm/highmem_32.c:115!"

This is moderately popular on kerneloops.org, mostly in interaction with the MMC layer.

Reported-by: kerneloops.org
CC: htejun@gmail.com
CC: stable@kernel.org

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 lib/scatterlist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 8d2688f..b7b449d 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -395,7 +395,7 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 			WARN_ON(!irqs_disabled());
 			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
 		} else
-			kunmap(miter->addr);
+			kunmap(miter->page);
 
 		miter->page = NULL;
 		miter->addr = NULL;
-- 
1.6.0.3


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
