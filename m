Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYKHMwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYKHMwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYKHMws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:52:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40221 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbYKHMwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:52:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH -next] Hibernate: Do not oops on resume if image data are incorrect
Date: Sat, 8 Nov 2008 13:57:42 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811081357.42925.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Please add this patch to the suspend branch.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Hibernate: Do not oops on resume if image data are incorrect

During resume from hibernation using the userland interface image
data are being passed from the used space process to the kernel.
These data need not be valid, but currently the kernel sometimes
oopses if it gets invalid image data, which is wrong.  Make the
kernel return error codes to the user space in such cases.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
---
 kernel/power/snapshot.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -529,6 +529,14 @@ static int memory_bm_test_bit(struct mem
 	return test_bit(bit, addr);
 }
 
+static bool memory_bm_pfn_present(struct memory_bitmap *bm, unsigned long pfn)
+{
+	void *addr;
+	unsigned int bit;
+
+	return !memory_bm_find_bit(bm, pfn, &addr, &bit);
+}
+
 /**
  *	memory_bm_next_pfn - find the pfn that corresponds to the next set bit
  *	in the bitmap @bm.  If the pfn cannot be found, BM_END_OF_MAP is
@@ -1466,9 +1474,7 @@ load_header(struct swsusp_info *info)
  *	unpack_orig_pfns - for each element of @buf[] (1 page at a time) set
  *	the corresponding bit in the memory bitmap @bm
  */
-
-static inline void
-unpack_orig_pfns(unsigned long *buf, struct memory_bitmap *bm)
+static int unpack_orig_pfns(unsigned long *buf, struct memory_bitmap *bm)
 {
 	int j;
 
@@ -1476,8 +1482,13 @@ unpack_orig_pfns(unsigned long *buf, str
 		if (unlikely(buf[j] == BM_END_OF_MAP))
 			break;
 
-		memory_bm_set_bit(bm, buf[j]);
+		if (memory_bm_pfn_present(bm, buf[j]))
+			memory_bm_set_bit(bm, buf[j]);
+		else
+			return -EFAULT;
 	}
+
+	return 0;
 }
 
 /* List of "safe" pages that may be used to store data loaded from the suspend
@@ -1615,7 +1626,7 @@ get_highmem_page_buffer(struct page *pag
 	pbe = chain_alloc(ca, sizeof(struct highmem_pbe));
 	if (!pbe) {
 		swsusp_free();
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	pbe->orig_page = page;
 	if (safe_highmem_pages > 0) {
@@ -1684,7 +1695,7 @@ prepare_highmem_image(struct memory_bitm
 static inline void *
 get_highmem_page_buffer(struct page *page, struct chain_allocator *ca)
 {
-	return NULL;
+	return ERR_PTR(-EINVAL);
 }
 
 static inline void copy_last_highmem_page(void) {}
@@ -1795,8 +1806,13 @@ prepare_image(struct memory_bitmap *new_
 static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 {
 	struct pbe *pbe;
-	struct page *page = pfn_to_page(memory_bm_next_pfn(bm));
+	struct page *page;
+	unsigned long pfn = memory_bm_next_pfn(bm);
 
+	if (pfn == BM_END_OF_MAP)
+		return ERR_PTR(-EFAULT);
+
+	page = pfn_to_page(pfn);
 	if (PageHighMem(page))
 		return get_highmem_page_buffer(page, ca);
 
@@ -1812,7 +1828,7 @@ static void *get_buffer(struct memory_bi
 	pbe = chain_alloc(ca, sizeof(struct pbe));
 	if (!pbe) {
 		swsusp_free();
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	pbe->orig_address = page_address(page);
 	pbe->address = safe_pages_list;
@@ -1875,7 +1891,10 @@ int snapshot_write_next(struct snapshot_
 				return error;
 
 		} else if (handle->prev <= nr_meta_pages) {
-			unpack_orig_pfns(buffer, &copy_bm);
+			error = unpack_orig_pfns(buffer, &copy_bm);
+			if (error)
+				return error;
+
 			if (handle->prev == nr_meta_pages) {
 				error = prepare_image(&orig_bm, &copy_bm);
 				if (error)
@@ -1886,12 +1905,14 @@ int snapshot_write_next(struct snapshot_
 				restore_pblist = NULL;
 				handle->buffer = get_buffer(&orig_bm, &ca);
 				handle->sync_read = 0;
-				if (!handle->buffer)
-					return -ENOMEM;
+				if (IS_ERR(handle->buffer))
+					return PTR_ERR(handle->buffer);
 			}
 		} else {
 			copy_last_highmem_page();
 			handle->buffer = get_buffer(&orig_bm, &ca);
+			if (IS_ERR(handle->buffer))
+				return PTR_ERR(handle->buffer);
 			if (handle->buffer != buffer)
 				handle->sync_read = 0;
 		}
