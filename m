Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529Ab0A0QLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0A0QLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150Ab0A0QLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:11:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554Ab0A0QLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:11:53 -0500
Date: Wed, 27 Jan 2010 08:09:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Roman Jarosz <kedgedev@gmail.com>,
       A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
In-Reply-To: <1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
Message-ID: <alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain> <1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Chris Wilson wrote:
> 
> v2: Pass gfp into page mapping.

Ahh, you did need the whole complexity of ->readpage?

Ok, in that case, can you test if this works for you?

It adds a 'read_cache_page_gfp()' function, which is a simplified form of 
read_cache_page() (no need to pass in filler/data, it uses the default 
values, like read_mapping_page() does), but allows setting gfp explicitly.

Untested, but if you test it and it works for you, then I think it's a 
reasonable addition. There might be other cases where some users prefer 
certain flags.

The actual new function is just a single line, the real patch is changing 
(and splitting up) the helper functions a bit so that all the variations 
on read_cache_page_*() can all be trivial.

		Linus

---
 include/linux/pagemap.h |    2 +
 mm/filemap.c            |  100 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 70 insertions(+), 32 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ed5d750..3c62ed4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -253,6 +253,8 @@ extern struct page * read_cache_page_async(struct address_space *mapping,
 extern struct page * read_cache_page(struct address_space *mapping,
 				pgoff_t index, filler_t *filler,
 				void *data);
+extern struct page * read_cache_page_gfp(struct address_space *mapping,
+				pgoff_t index, gfp_t gfp_mask);
 extern int read_cache_pages(struct address_space *mapping,
 		struct list_head *pages, filler_t *filler, void *data);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 96ac6b0..e373692 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1634,14 +1634,15 @@ EXPORT_SYMBOL(generic_file_readonly_mmap);
 static struct page *__read_cache_page(struct address_space *mapping,
 				pgoff_t index,
 				int (*filler)(void *,struct page*),
-				void *data)
+				void *data,
+				gfp_t gfp)
 {
 	struct page *page;
 	int err;
 repeat:
 	page = find_get_page(mapping, index);
 	if (!page) {
-		page = page_cache_alloc_cold(mapping);
+		page = __page_cache_alloc(gfp | __GFP_COLD);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
 		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
@@ -1661,31 +1662,18 @@ repeat:
 	return page;
 }
 
-/**
- * read_cache_page_async - read into page cache, fill it if needed
- * @mapping:	the page's address_space
- * @index:	the page index
- * @filler:	function to perform the read
- * @data:	destination for read data
- *
- * Same as read_cache_page, but don't wait for page to become unlocked
- * after submitting it to the filler.
- *
- * Read into the page cache. If a page already exists, and PageUptodate() is
- * not set, try to fill the page but don't wait for it to become unlocked.
- *
- * If the page does not get brought uptodate, return -EIO.
- */
-struct page *read_cache_page_async(struct address_space *mapping,
+static struct page *do_read_cache_page(struct address_space *mapping,
 				pgoff_t index,
 				int (*filler)(void *,struct page*),
-				void *data)
+				void *data,
+				gfp_t gfp)
+
 {
 	struct page *page;
 	int err;
 
 retry:
-	page = __read_cache_page(mapping, index, filler, data);
+	page = __read_cache_page(mapping, index, filler, data, gfp);
 	if (IS_ERR(page))
 		return page;
 	if (PageUptodate(page))
@@ -1710,8 +1698,67 @@ out:
 	mark_page_accessed(page);
 	return page;
 }
+
+/**
+ * read_cache_page_async - read into page cache, fill it if needed
+ * @mapping:	the page's address_space
+ * @index:	the page index
+ * @filler:	function to perform the read
+ * @data:	destination for read data
+ *
+ * Same as read_cache_page, but don't wait for page to become unlocked
+ * after submitting it to the filler.
+ *
+ * Read into the page cache. If a page already exists, and PageUptodate() is
+ * not set, try to fill the page but don't wait for it to become unlocked.
+ *
+ * If the page does not get brought uptodate, return -EIO.
+ */
+struct page *read_cache_page_async(struct address_space *mapping,
+				pgoff_t index,
+				int (*filler)(void *,struct page*),
+				void *data)
+{
+	return do_read_cache_page(mapping, index, filler, data, mapping_gfp_mask(mapping));
+}
 EXPORT_SYMBOL(read_cache_page_async);
 
+static struct page *wait_on_page_read(struct page *page)
+{
+	if (!IS_ERR(page)) {
+		wait_on_page_locked(page);
+		if (!PageUptodate(page)) {
+			page_cache_release(page);
+			page = ERR_PTR(-EIO);
+		}
+	}
+	return page;
+}
+
+/**
+ * read_cache_page_gfp - read into page cache, using specified page allocation flags.
+ * @mapping:	the page's address_space
+ * @index:	the page index
+ * @gfp:	the page allocator flags to use if allocating
+ *
+ * This is the same as "read_mapping_page(mapping, index, NULL)", but with
+ * any new page allocations done using the specified allocation flags. Note
+ * that the Radix tree operations will still use GFP_KERNEL, so you can't
+ * expect to do this atomically or anything like that - but you can pass in
+ * other page requirements.
+ *
+ * If the page does not get brought uptodate, return -EIO.
+ */
+struct page *read_cache_page_gfp(struct address_space *mapping,
+				pgoff_t index,
+				gfp_t gfp)
+{
+	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
+
+	return wait_on_page_read(do_read_cache_page(mapping, index, filler, NULL, gfp));
+}
+EXPORT_SYMBOL(read_cache_page_gfp);
+
 /**
  * read_cache_page - read into page cache, fill it if needed
  * @mapping:	the page's address_space
@@ -1729,18 +1776,7 @@ struct page *read_cache_page(struct address_space *mapping,
 				int (*filler)(void *,struct page*),
 				void *data)
 {
-	struct page *page;
-
-	page = read_cache_page_async(mapping, index, filler, data);
-	if (IS_ERR(page))
-		goto out;
-	wait_on_page_locked(page);
-	if (!PageUptodate(page)) {
-		page_cache_release(page);
-		page = ERR_PTR(-EIO);
-	}
- out:
-	return page;
+	return wait_on_page_read(read_cache_page_async(mapping, index, filler, data));
 }
 EXPORT_SYMBOL(read_cache_page);
 
