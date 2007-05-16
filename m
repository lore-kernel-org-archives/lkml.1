Return-Path: <linux-kernel-owner+w=401wt.eu-S1763417AbXEPWuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763417AbXEPWuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759662AbXEPWsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:48:38 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50147 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758471AbXEPWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:48:33 -0400
Message-ID: <379355695.83536@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070516224818.246719596@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 17 May 2007 06:47:53 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 1/9] readahead: introduce PG_readahead
Content-Disposition: inline; filename=mm-introduce-pg_readahead.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new page flag: PG_readahead.

It acts as a look-ahead mark, which tells the page reader:
Hey, it's time to invoke the read-ahead logic.  For the sake of I/O pipelining,
don't wait until it runs out of cached pages!

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

 include/linux/page-flags.h |    5 +++++
 mm/page_alloc.c            |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.22-rc1-mm1.orig/include/linux/page-flags.h
+++ linux-2.6.22-rc1-mm1/include/linux/page-flags.h
@@ -92,6 +92,7 @@
 #define PG_lazyfree		20	/* MADV_FREE potential throwaway */
 
 #define PG_booked		21	/* Has blocks reserved on-disk */
+#define PG_readahead		22	/* Reminder to do async read-ahead */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
@@ -206,6 +207,10 @@ static inline void SetPageUptodate(struc
 #define SetPageBooked(page)	set_bit(PG_booked, &(page)->flags)
 #define ClearPageBooked(page)	clear_bit(PG_booked, &(page)->flags)
 
+#define PageReadahead(page)	test_bit(PG_readahead, &(page)->flags)
+#define SetPageReadahead(page)	set_bit(PG_readahead, &(page)->flags)
+#define ClearPageReadahead(page) clear_bit(PG_readahead, &(page)->flags)
+
 #define PageReclaim(page)	test_bit(PG_reclaim, &(page)->flags)
 #define SetPageReclaim(page)	set_bit(PG_reclaim, &(page)->flags)
 #define ClearPageReclaim(page)	clear_bit(PG_reclaim, &(page)->flags)
--- linux-2.6.22-rc1-mm1.orig/mm/page_alloc.c
+++ linux-2.6.22-rc1-mm1/mm/page_alloc.c
@@ -659,7 +659,7 @@ static int prep_new_page(struct page *pa
 	if (PageReserved(page))
 		return 1;
 
-	page->flags &= ~(1 << PG_uptodate | 1 << PG_error |
+	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
 			1 << PG_referenced | 1 << PG_arch_1 |
 			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);

--
