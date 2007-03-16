Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXCPIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXCPIxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXCPIvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:43 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34706 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932511AbXCPIvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:22 -0400
Message-ID: <374035060.24367@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085053.642868000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:10 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] readahead: remove noaction/shrink events
Content-Disposition: inline; filename=readahead-remove-noaction-shrink-events.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tear down the following ra_account(NULL, ...) calls:

	ra_account(RA_EVENT_LOOKAHEAD_NOACTION)
	ra_account(RA_EVENT_READAHEAD_SHRINK)

The two events are not as useful and do not have clear meanings.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

---
 mm/readahead.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -87,10 +87,8 @@ enum ra_event {
 	RA_EVENT_READAHEAD_HIT,		/* read-ahead page hit */
 	RA_EVENT_LOOKAHEAD,		/* look-ahead issued */
 	RA_EVENT_LOOKAHEAD_HIT,		/* look-ahead mark hit */
-	RA_EVENT_LOOKAHEAD_NOACTION,	/* look-ahead mark ignored */
 	RA_EVENT_READAHEAD_MMAP,	/* read-ahead for mmap access */
 	RA_EVENT_READAHEAD_EOF,		/* read-ahead reaches EOF */
-	RA_EVENT_READAHEAD_SHRINK,	/* ra_size falls under previous la_size */
 	RA_EVENT_READAHEAD_THRASHING,	/* read-ahead thrashing happened */
 	RA_EVENT_READAHEAD_MUTILATE,	/* read-ahead mutilated by imbalanced aging */
 	RA_EVENT_READAHEAD_RESCUE,	/* read-ahead rescued */
@@ -452,8 +450,6 @@ int force_page_cache_readahead(struct ad
 		nr_to_read -= this_chunk;
 	}
 
-	ra_account(NULL, RA_EVENT_READAHEAD, ret);
-
 	return ret;
 }
 
@@ -496,8 +492,6 @@ int do_page_cache_readahead(struct addre
 
 	ret = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
-	ra_account(NULL, RA_EVENT_READAHEAD, ret);
-
 	return ret;
 }
 
@@ -520,7 +514,6 @@ blockable_page_cache_readahead(struct ad
 
 	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
-	ra_account(NULL, RA_EVENT_READAHEAD, actual);
 	dprintk("blockable-readahead(ino=%lu, ra=%lu+%lu) = %d\n",
 			mapping->host->i_ino, offset, nr_to_read, actual);
 
@@ -1007,7 +1000,6 @@ static int adjust_rala(unsigned long *ra
 	 * if there is a major upsurge of load, or fall of this stream's speed.
 	 */
 	if (*ra_size <= *la_size * 2) {
-		ra_account(NULL, RA_EVENT_READAHEAD_SHRINK, *ra_size);
 		return 0;
 	}
 
@@ -1710,8 +1702,6 @@ page_cache_readahead_adaptive(struct add
 
 	/* No action on look-ahead time? */
 	if (page) {
-		ra_account(ra, RA_EVENT_LOOKAHEAD_NOACTION,
-						ra->readahead_index - offset);
 		return 0;
 	}
 
@@ -1807,10 +1797,8 @@ static const char * const ra_event_name[
 	"readahead_hit",
 	"lookahead",
 	"lookahead_hit",
-	"lookahead_ignore",
 	"readahead_mmap",
 	"readahead_eof",
-	"readahead_shrink",
 	"readahead_thrash",
 	"readahead_mutilt",
 	"readahead_rescue"
@@ -1825,13 +1813,11 @@ static void ra_account(struct file_ra_st
 	if (!readahead_debug_level)
 		return;
 
-	if (e == RA_EVENT_READAHEAD_HIT && pages < 0) {
-		c = ra_class_old(ra);
+	if (pages < 0) {
 		pages = -pages;
-	} else if (ra)
+		c = ra_class_old(ra);
+	} else
 		c = ra_class_new(ra);
-	else
-		c = RA_CLASS_NONE;
 
 	if (!c)
 		c = RA_CLASS_NONE;

--
