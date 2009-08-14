Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbZHNUNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbZHNUNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbZHNUNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:13:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44783 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbZHNUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:13:51 -0400
Date: Fri, 14 Aug 2009 22:13:11 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nicolas Pitre <nico@marvell.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>,
       MinChan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -rt] Fix kmap_high_get()
Message-ID: <20090814201311.GA453@pengutronix.de>
References: <1249810600-21946-3-git-send-email-u.kleine-koenig@pengutronix.de> <1250199243-18677-1-git-send-email-u.kleine-koenig@pengutronix.de> <1250258573.5241.1581.camel@twins> <alpine.LFD.2.00.0908141152290.10633@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0908141152290.10633@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 14, 2009 at 11:58:59AM -0400, Nicolas Pitre wrote:
> On Fri, 14 Aug 2009, Peter Zijlstra wrote:
> 
> > As to the patch, its not quite right.
... on irc Peter and me agreed it's not that wrong :-)  Anyhow, I merged
the two patches to get the benefits from both.  See below.

> > From what I understand kmap_high_get() is used to pin a page's kmap iff
> > it has one, whereas the result of your patch seems to be that it'll
> > actually create one if its not found.
> 
> I don't have enough context to review this patch, but your understanding 
> of the kmap_high_get() purpose is right.
The patch with all it's dependencies based on -rc6 is available on

	git://git.pengutronix.de/git/ukl/linux-2.6.git kmap-testing

Niko:  Your review would be very welcome because neither Peter nor me
have a machine with highmem.

Best regards
Uwe

>From fafb2e9964cd01535a61f20a45093ba053169f06 Mon Sep 17 00:00:00 2001
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Date: Fri, 14 Aug 2009 21:45:55 +0200
Subject: [PATCH] Fix kmap_high_get() as kmap locking is gone
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

This has the pros of both Peter's and my patch:

- It obsoletes ARCH_NEEDS_KMAP_HIGH_GET without introducing a big
  overhead for the archs not having defined that symbol.
- no code duplication between kmap_high_get and kmap_high
- a nice kmap_high_put function that does the same as kunmap_high
  without accounting
- no compiler warning about mismatched declarations

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Nicolas Pitre <nico@marvell.com>
Cc: MinChan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/include/asm/highmem.h |    3 +-
 arch/arm/mm/dma-mapping.c      |    2 +-
 mm/highmem.c                   |   98 +++++++++++++++++-----------------------
 3 files changed, 43 insertions(+), 60 deletions(-)

diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
index 7f36d00..2082ed8 100644
--- a/arch/arm/include/asm/highmem.h
+++ b/arch/arm/include/asm/highmem.h
@@ -15,10 +15,9 @@
 
 extern pte_t *pkmap_page_table;
 
-#define ARCH_NEEDS_KMAP_HIGH_GET
-
 extern void *kmap_high(struct page *page);
 extern void *kmap_high_get(struct page *page);
+extern void kmap_high_put(struct page *page);
 extern void kunmap_high(struct page *page);
 
 extern void *kmap(struct page *page);
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 510c179..d71aff9 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -551,7 +551,7 @@ static void dma_cache_maint_contiguous(struct page *page, unsigned long offset,
 		if (vaddr) {
 			vaddr += offset;
 			inner_op(vaddr, vaddr + size);
-			kunmap_high(page);
+			kmap_high_put(page);
 		}
 	}
 
diff --git a/mm/highmem.c b/mm/highmem.c
index 4aa9eea..1043938 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -75,26 +75,6 @@ pte_t * pkmap_page_table;
 
 static DECLARE_WAIT_QUEUE_HEAD(pkmap_wait);
 
-
-/*
- * Most architectures have no use for kmap_high_get(), so let's abstract
- * the disabling of IRQ out of the locking in that case to save on a
- * potential useless overhead.
- */
-#ifdef ARCH_NEEDS_KMAP_HIGH_GET
-#define lock_kmap()             spin_lock_irq(&kmap_lock)
-#define unlock_kmap()           spin_unlock_irq(&kmap_lock)
-#define lock_kmap_any(flags)    spin_lock_irqsave(&kmap_lock, flags)
-#define unlock_kmap_any(flags)  spin_unlock_irqrestore(&kmap_lock, flags)
-#else
-#define lock_kmap()             spin_lock(&kmap_lock)
-#define unlock_kmap()           spin_unlock(&kmap_lock)
-#define lock_kmap_any(flags)    \
-		do { spin_lock(&kmap_lock); (void)(flags); } while (0)
-#define unlock_kmap_any(flags)  \
-		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
-#endif
-
 /*
  * Try to free a given kmap slot.
  *
@@ -313,22 +293,32 @@ static void kunmap_account(void)
 	wake_up(&pkmap_wait);
 }
 
-void *kmap_high(struct page *page)
+/**
+ * kmap_high_get - pin a highmem page into memory
+ * @page: &struct page to pin
+ *
+ * Returns the page's current virtual memory address, or NULL if no mapping
+ * exists.  When and only when a non null address is returned then a
+ * matching call to kmap_high_put() is necessary.
+ *
+ * This can be called from any context.
+ */
+void *kmap_high_get(struct page *page)
 {
 	unsigned long vaddr;
 
-
-	kmap_account();
 again:
 	vaddr = (unsigned long)page_address(page);
 	if (vaddr) {
 		atomic_t *counter = &pkmap_count[PKMAP_NR(vaddr)];
 		if (atomic_inc_not_zero(counter)) {
 			/*
-			 * atomic_inc_not_zero implies a (memory) barrier on success
-			 * so page address will be reloaded.
+			 * atomic_inc_not_zero implies a (memory) barrier on
+			 * success, so page address will be reloaded.
 			 */
-			unsigned long vaddr2 = (unsigned long)page_address(page);
+			unsigned long vaddr2 =
+				(unsigned long)page_address(page);
+
 			if (likely(vaddr == vaddr2))
 				return (void *)vaddr;
 
@@ -345,46 +335,40 @@ again:
 		}
 	}
 
+	return NULL;
+}
+EXPORT_SYMBOL(kmap_high_get);
+
+void kmap_high_put(struct page *page)
+{
+	unsigned long vaddr = (unsigned long)page_address(page);
+
+	BUG_ON(!vaddr);
+	pkmap_put(&pkmap_count[PKMAP_NR(vaddr)]);
+}
+EXPORT_SYMBOL(kmap_high_put);
+
+void *kmap_high(struct page *page)
+{
+	unsigned long vaddr;
+
+	kmap_account();
+again:
+	vaddr = (unsigned long)kmap_high_get(page);
+	if (vaddr)
+		return (void *)vaddr;
+
 	vaddr = pkmap_insert(page);
 	if (!vaddr)
 		goto again;
 
 	return (void *)vaddr;
 }
-
 EXPORT_SYMBOL(kmap_high);
 
-#ifdef ARCH_NEEDS_KMAP_HIGH_GET
-/**
- * kmap_high_get - pin a highmem page into memory
- * @page: &struct page to pin
- *
- * Returns the page's current virtual memory address, or NULL if no mapping
- * exists.  When and only when a non null address is returned then a
- * matching call to kunmap_high() is necessary.
- *
- * This can be called from any context.
- */
-void *kmap_high_get(struct page *page)
-{
-	unsigned long vaddr, flags;
-
-	lock_kmap_any(flags);
-	vaddr = (unsigned long)page_address(page);
-	if (vaddr) {
-		BUG_ON(atomic_read(&pkmap_count[PKMAP_NR(vaddr)]) < 1);
-		atomic_add(1, pkmap_count[PKMAP_NR(vaddr)]);
-	}
-	unlock_kmap_any(flags);
-	return (void*) vaddr;
-}
-#endif
-
- void kunmap_high(struct page *page)
+void kunmap_high(struct page *page)
 {
-	unsigned long vaddr = (unsigned long)page_address(page);
-	BUG_ON(!vaddr);
-	pkmap_put(&pkmap_count[PKMAP_NR(vaddr)]);
+	kmap_high_put(page);
 	kunmap_account();
 }
 
-- 
1.6.3.3



-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
