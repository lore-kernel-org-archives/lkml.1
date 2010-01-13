Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573Ab0AMOyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0AMOyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464Ab0AMOyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:54:51 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53201 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0AMOyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:54:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uqInvK+9yplRH/eBdpn/rY9kqeIdzd56+mbtER9/aRwzu/k4ofgiyUApFQV1VIPR+J
         Kra+NpgJ1zW6VNzwHxH/U6gfOB77HWgZJ7voUzb/gt0pA/dU8l4Y/z8kEAdjMAnIdwmU
         bWkN8bZTwEL4kteWR58OCoL36tdNXdnqTeeNI=
MIME-Version: 1.0
Date: Wed, 13 Jan 2010 22:54:50 +0800
Message-ID: <3a3680031001130654q1928df60pde0e3706ea2461c@mail.gmail.com>
Subject: [PATCH 3/3] mm: remove function free_hot_page
From: Li Hong <lihong.hi@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now fuction 'free_hot_page' is just a wrap of ' free_hot_cold_page' with
parameter 'cold = 0'. After adding a clear comment for 'free_hot_cold_page', it
is reasonable to remove a level of call.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 mm/page_alloc.c |    8 ++------
 mm/swap.c       |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 175dd36..c88e03d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1073,6 +1073,7 @@ void mark_free_pages(struct zone *zone)

 /*
  * Free a 0-order page
+ * cold == 1 ? free a cold page : free a hot page
  */
 static void free_hot_cold_page(struct page *page, int cold)
 {
@@ -1135,11 +1136,6 @@ out:
        put_cpu();
 }

-void free_hot_page(struct page *page)
-{
-       free_hot_cold_page(page, 0);
-}
-
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
@@ -2014,7 +2010,7 @@ void __free_pages(struct page *page, unsigned int order)
 {
        if (put_page_testzero(page)) {
                if (order == 0)
-                       free_hot_page(page);
+                       free_hot_cold_page(page, 0);
                else
                        __free_pages_ok(page, order);
        }
diff --git a/mm/swap.c b/mm/swap.c
index 308e57d..9036b89 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -55,7 +55,7 @@ static void __page_cache_release(struct page *page)
                del_page_from_lru(zone, page);
                spin_unlock_irqrestore(&zone->lru_lock, flags);
        }
-       free_hot_page(page);
+       free_hot_cold_page(page, 0);
 }

 static void put_compound_page(struct page *page)
-- 
1.6.3.3
