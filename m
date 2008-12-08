Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbYLHUZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYLHUZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 15:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYLHUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 15:25:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37023 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbYLHUZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 15:25:36 -0500
Message-ID: <493D82A6.9070104@redhat.com>
Date: Mon, 08 Dec 2008 15:25:10 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
References: <20081129195357.813D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081208205842.53F8.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081208220016.53FB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081208220016.53FB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> +	for (o = order; o < MAX_ORDER; o++) {
> +		if (z->free_area[o].nr_free)
> +			return 1;

Since page breakup and coalescing always manipulates .nr_free,
I wonder if it would make sense to pack the nr_free variables
in their own cache line(s), so we have fewer cache misses when
going through zone_watermark_ok() ?

That would end up looking something like this:

(whitespace mangled because it doesn't make sense to apply
just this thing, anyway)

Index: linux-2.6.28-rc7/include/linux/mmzone.h
===================================================================
--- linux-2.6.28-rc7.orig/include/linux/mmzone.h        2008-12-02 
15:04:33.000000000 -0500
+++ linux-2.6.28-rc7/include/linux/mmzone.h     2008-12-08 
15:24:25.000000000 -0500
@@ -58,7 +58,6 @@ static inline int get_pageblock_migratet

  struct free_area {
         struct list_head        free_list[MIGRATE_TYPES];
-       unsigned long           nr_free;
  };

  struct pglist_data;
@@ -296,6 +295,7 @@ struct zone {
         seqlock_t               span_seqlock;
  #endif
         struct free_area        free_area[MAX_ORDER];
+       struct nr_free          [MAX_ORDER];

  #ifndef CONFIG_SPARSEMEM
         /*


-- 
All rights reversed.
