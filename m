Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYKQINS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYKQINS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYKQING
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:13:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43448 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYKQINF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:13:05 -0500
Date: Mon, 17 Nov 2008 09:11:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081117081117.GD26778@kernel.dk>
References: <20081115112751.1d38c072@infradead.org> <Pine.LNX.4.64.0811152003360.1618@blonde.site> <20081115123916.0d83a89e@infradead.org> <491FACC3.1050202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491FACC3.1050202@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16 2008, Tejun Heo wrote:
> Arjan van de Ven wrote:
> > From 979d181d6199f639ba78c5eadf85857f6a9f3f89 Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sat, 15 Nov 2008 11:23:58 -0800
> > Subject: [PATCH] Fix kunmap() argument in sg_miter_stop
> > 
> > kunmap() takes as argument the struct page that orginally got kmap()'d,
> > however the sg_miter_stop() function passed it the kernel virtual address
> > instead, resulting in weird stuff.
> > 
> > Somehow I ended up fixing this bug by accident while looking for a bug
> > in the same area.
> > 
> > Reported-by: kerneloops.org
> > CC: htejun@gmail.com
> > 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> Argh... talk about confusing interfaces.  Thanks a lot.

It IS indeed a crap interface, I can't even count on fingers and toes
the times that people did either kunmap() on the address or
kunmap_atomic() on the page. It's virtually there in the first version
of any patch that does kmaps.

It would be REALLY nice if we could catch this at compile time instead
especially when highmem. How about something like this? It'll at least
throw a

lib/scatterlist.c: In function ?sg_miter_stop?:
lib/scatterlist.c:398: warning: comparison of distinct pointer types
lacks a cast

warning to notify of the problem up front.

The more typical error is passing the page into kunmap_atomic(), though.
That one is a bit more tricky, since you can pass in char/void/whatever
pointers. We could mandate that a void * should always be used, then we
could do the same trick there.

Just throwing this out there for comment, I really think we should be
doing something about this finally.

diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
index bf9276b..4b6f197 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -58,10 +58,10 @@ extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
 
 void *kmap(struct page *page);
-void kunmap(struct page *page);
+void __kunmap(struct page *page);
 void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
 void *kmap_atomic(struct page *page, enum km_type type);
-void kunmap_atomic(void *kvaddr, enum km_type type);
+void __kunmap_atomic(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 struct page *kmap_atomic_to_page(void *ptr);
 
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index bcc079c..09d2254 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -9,7 +9,7 @@ void *kmap(struct page *page)
 	return kmap_high(page);
 }
 
-void kunmap(struct page *page)
+void __kunmap(struct page *page)
 {
 	if (in_interrupt())
 		BUG();
@@ -91,7 +91,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 	return (void *)vaddr;
 }
 
-void *kmap_atomic(struct page *page, enum km_type type)
+void *__kmap_atomic(struct page *page, enum km_type type)
 {
 	return kmap_atomic_prot(page, type, kmap_prot);
 }
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 7dcbc82..f07ab8f 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -42,7 +42,7 @@ static inline void *kmap(struct page *page)
 	return page_address(page);
 }
 
-#define kunmap(page) do { (void) (page); } while (0)
+#define __kunmap(page) do { (void) (page); } while (0)
 
 #include <asm/kmap_types.h>
 
@@ -53,7 +53,7 @@ static inline void *kmap_atomic(struct page *page, enum km_type idx)
 }
 #define kmap_atomic_prot(page, idx, prot)	kmap_atomic(page, idx)
 
-#define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
+#define __kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 
@@ -62,6 +62,20 @@ static inline void *kmap_atomic(struct page *page, enum km_type idx)
 
 #endif /* CONFIG_HIGHMEM */
 
+#define kunmap(p)			\
+	do {				\
+		struct page *__p;	\
+		(void) (&__p == &(p));	\
+		__kunmap(p);		\
+	} while (0)
+
+#define kunmap_atomic(a, t)		\
+	do {				\
+		void *__p;		\
+		(void) (&__p == &(a));	\
+		__kunmap_atomic(a, t);	\
+	} while (0)
+
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
@@ -163,7 +177,7 @@ static inline void __deprecated memclear_highpage_flush(struct page *page,
 static inline void copy_user_highpage(struct page *to, struct page *from,
 	unsigned long vaddr, struct vm_area_struct *vma)
 {
-	char *vfrom, *vto;
+	void *vfrom, *vto;
 
 	vfrom = kmap_atomic(from, KM_USER0);
 	vto = kmap_atomic(to, KM_USER1);
@@ -176,7 +190,7 @@ static inline void copy_user_highpage(struct page *to, struct page *from,
 
 static inline void copy_highpage(struct page *to, struct page *from)
 {
-	char *vfrom, *vto;
+	void *vfrom, *vto;
 
 	vfrom = kmap_atomic(from, KM_USER0);
 	vto = kmap_atomic(to, KM_USER1);

-- 
Jens Axboe

