Return-Path: <linux-kernel-owner+w=401wt.eu-S1751787AbZL3FRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbZL3FRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZL3FRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:17:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:49090 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZL3FRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:17:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227701939"
Date: Wed, 30 Dec 2009 13:17:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [RFC][PATCH 1/2] readahead: replace ra->mmap_miss with ra->flags
Message-ID: <20091230051747.GA26364@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230051540.GA16308@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a readahead flags field and embed the existing mmap_miss in it
(to save space).

It will be possible to lose the flags in race conditions, however the
impact should be limited.

CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/fs.h |   30 +++++++++++++++++++++++++++++-
 mm/filemap.c       |    7 ++-----
 2 files changed, 31 insertions(+), 6 deletions(-)

--- linux.orig/include/linux/fs.h	2009-12-30 11:07:04.000000000 +0800
+++ linux/include/linux/fs.h	2009-12-30 12:59:28.000000000 +0800
@@ -889,10 +889,38 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
+	unsigned int flags;
 	loff_t prev_pos;		/* Cache last read() position */
 };
 
+/* low 16 bits: cache miss stat for mmap accesses */
+#define	RA_FLAG_MMAP_MISS		0x0000ffff
+
+/*
+ * Don't do flags++ directly to avoid possible overflow:
+ * the ra fields can be accessed concurrently in a racy way.
+ */
+static inline unsigned int ra_mmap_miss_inc(struct file_ra_state *ra)
+{
+	unsigned int miss = ra->flags & RA_FLAG_MMAP_MISS;
+
+	if (miss < RA_FLAG_MMAP_MISS) {
+		miss++;
+		ra->flags = miss | (ra->flags &~ RA_FLAG_MMAP_MISS);
+	}
+	return miss;
+}
+
+static inline void ra_mmap_miss_dec(struct file_ra_state *ra)
+{
+	unsigned int miss = ra->flags & RA_FLAG_MMAP_MISS;
+
+	if (miss) {
+		miss--;
+		ra->flags = miss | (ra->flags &~ RA_FLAG_MMAP_MISS);
+	}
+}
+
 /*
  * Check if @index falls in the readahead windows.
  */
--- linux.orig/mm/filemap.c	2009-12-30 11:07:04.000000000 +0800
+++ linux/mm/filemap.c	2009-12-30 11:07:22.000000000 +0800
@@ -1418,14 +1418,12 @@ static void do_sync_mmap_readahead(struc
 		return;
 	}
 
-	if (ra->mmap_miss < INT_MAX)
-		ra->mmap_miss++;
 
 	/*
 	 * Do we miss much more than hit in this file? If so,
 	 * stop bothering with read-ahead. It will only hurt.
 	 */
-	if (ra->mmap_miss > MMAP_LOTSAMISS)
+	if (ra_mmap_miss_inc(ra) > MMAP_LOTSAMISS)
 		return;
 
 	/*
@@ -1455,8 +1453,7 @@ static void do_async_mmap_readahead(stru
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
 		return;
-	if (ra->mmap_miss > 0)
-		ra->mmap_miss--;
+	ra_mmap_miss_dec(ra);
 	if (PageReadahead(page))
 		page_cache_async_readahead(mapping, ra, file,
 					   page, offset, ra->ra_pages);
