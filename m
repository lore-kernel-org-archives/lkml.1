Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZDJFEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZDJFEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZDJFEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:04:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:49153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZDJFEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:04:13 -0400
Subject: Re: [PATCH] firmware: speed up request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Ira Snyder <iws@ovro.caltech.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1239304137.2974.29.camel@macbook.infradead.org>
References: <20090128180446.GB31107@ovro.caltech.edu>
	 <E1LSFhF-0002OC-00.arvidjaar-mail-ru@mx5.mail.ru>
	 <20090128194534.457d58cd@lxorguk.ukuu.org.uk>
	 <20090128203421.GC31107@ovro.caltech.edu>
	 <1239304137.2974.29.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 22:03:59 -0700
Message-Id: <1239339839.712.18.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than calling vmalloc() repeatedly to grow the firmware image as
we receive data from userspace, just allocate and fill individual pages.
Then vmap() the whole lot in one go when we're done.

A quick test with a 337KiB iwlagn firmware shows the time taken for
request_firmware() going from ~32ms to ~5ms after I apply this patch.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

--- 
Various failure modes and corner cases, including firmware_data_read(),
are still untested.

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d3a59c6..90cb7c2 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -17,7 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
-
+#include <linux/highmem.h>
 #include <linux/firmware.h>
 #include "base.h"
 
@@ -45,7 +45,10 @@ struct firmware_priv {
 	struct bin_attribute attr_data;
 	struct firmware *fw;
 	unsigned long status;
-	int alloc_size;
+	struct page **pages;
+	int nr_pages;
+	int page_array_size;
+	const char *vdata;
 	struct timer_list timeout;
 };
 
@@ -141,6 +144,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 {
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	int loading = simple_strtol(buf, NULL, 10);
+	int i;
 
 	switch (loading) {
 	case 1:
@@ -151,13 +155,30 @@ static ssize_t firmware_loading_store(struct device *dev,
 		}
 		vfree(fw_priv->fw->data);
 		fw_priv->fw->data = NULL;
+		for (i = 0; i < fw_priv->nr_pages; i++)
+			__free_page(fw_priv->pages[i]);
+		kfree(fw_priv->pages);
+		fw_priv->pages = NULL;
+		fw_priv->page_array_size = 0;
+		fw_priv->nr_pages = 0;
 		fw_priv->fw->size = 0;
-		fw_priv->alloc_size = 0;
 		set_bit(FW_STATUS_LOADING, &fw_priv->status);
 		mutex_unlock(&fw_lock);
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
+			vfree(fw_priv->fw->data);
+			fw_priv->fw->data = vmap(fw_priv->pages,
+						 fw_priv->nr_pages,
+						 0, PAGE_KERNEL_RO);
+			if (!fw_priv->fw->data) {
+				dev_err(dev, "%s: vmap() failed\n", __func__);
+				goto err;
+			}
+			/* Pages will be freed by vfree() */
+			fw_priv->pages = NULL;
+			fw_priv->page_array_size = 0;
+			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
 			clear_bit(FW_STATUS_LOADING, &fw_priv->status);
 			break;
@@ -167,6 +188,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		dev_err(dev, "%s: unexpected value (%d)\n", __func__, loading);
 		/* fallthrough */
 	case -1:
+	err:
 		fw_load_abort(fw_priv);
 		break;
 	}
@@ -191,8 +213,28 @@ firmware_data_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 		ret_count = -ENODEV;
 		goto out;
 	}
-	ret_count = memory_read_from_buffer(buffer, count, &offset,
-						fw->data, fw->size);
+	if (offset > fw->size)
+		return 0;
+	if (count > fw->size - offset)
+		count = fw->size - offset;
+
+	ret_count = count;
+
+	while (count) {
+		void *page_data;
+		int page_nr = offset >> PAGE_SHIFT;
+		int page_ofs = offset & (PAGE_SIZE-1);
+		int page_cnt = min(PAGE_SIZE - page_ofs, count);
+
+		page_data = kmap(fw_priv->pages[page_nr]);
+
+		memcpy(buffer, page_data + page_ofs, page_cnt);
+
+		kunmap(page_data);
+		buffer += page_cnt;
+		offset += page_cnt;
+		count -= page_cnt;
+	}
 out:
 	mutex_unlock(&fw_lock);
 	return ret_count;
@@ -201,27 +243,39 @@ out:
 static int
 fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 {
-	u8 *new_data;
-	int new_size = fw_priv->alloc_size;
+	int pages_needed = ALIGN(min_size, PAGE_SIZE) >> PAGE_SHIFT;
+
+	/* If the array of pages is too small, grow it... */
+	if (fw_priv->page_array_size < pages_needed) {
+		int new_array_size = max(pages_needed,
+					 fw_priv->page_array_size * 2);
+		struct page **new_pages;
+
+		new_pages = kmalloc(new_array_size * sizeof(void *),
+				    GFP_KERNEL);
+		if (!new_pages) {
+			fw_load_abort(fw_priv);
+			return -ENOMEM;
+		}
+		memcpy(new_pages, fw_priv->pages,
+		       fw_priv->page_array_size * sizeof(void *));
+		memset(&new_pages[fw_priv->page_array_size], 0, sizeof(void *) *
+		       (new_array_size - fw_priv->page_array_size));
+		kfree(fw_priv->pages);
+		fw_priv->pages = new_pages;
+		fw_priv->page_array_size = new_array_size;
+	}
 
-	if (min_size <= fw_priv->alloc_size)
-		return 0;
+	while (fw_priv->nr_pages < pages_needed) {
+		fw_priv->pages[fw_priv->nr_pages] =
+			alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
 
-	new_size = ALIGN(min_size, PAGE_SIZE);
-	new_data = vmalloc(new_size);
-	if (!new_data) {
-		printk(KERN_ERR "%s: unable to alloc buffer\n", __func__);
-		/* Make sure that we don't keep incomplete data */
-		fw_load_abort(fw_priv);
-		return -ENOMEM;
-	}
-	fw_priv->alloc_size = new_size;
-	if (fw_priv->fw->data) {
-		memcpy(new_data, fw_priv->fw->data, fw_priv->fw->size);
-		vfree(fw_priv->fw->data);
+		if (!fw_priv->pages[fw_priv->nr_pages]) {
+			fw_load_abort(fw_priv);
+			return -ENOMEM;
+		}
+		fw_priv->nr_pages++;
 	}
-	fw_priv->fw->data = new_data;
-	BUG_ON(min_size > fw_priv->alloc_size);
 	return 0;
 }
 
@@ -258,10 +312,25 @@ firmware_data_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 	if (retval)
 		goto out;
 
-	memcpy((u8 *)fw->data + offset, buffer, count);
-
-	fw->size = max_t(size_t, offset + count, fw->size);
 	retval = count;
+
+	while (count) {
+		void *page_data;
+		int page_nr = offset >> PAGE_SHIFT;
+		int page_ofs = offset & (PAGE_SIZE - 1);
+		int page_cnt = min(PAGE_SIZE - page_ofs, count);
+
+		page_data = kmap(fw_priv->pages[page_nr]);
+
+		memcpy(page_data + page_ofs, buffer, page_cnt);
+
+		kunmap(page_data);
+		buffer += page_cnt;
+		offset += page_cnt;
+		count -= page_cnt;
+	}
+
+	fw->size = max_t(size_t, offset, fw->size);
 out:
 	mutex_unlock(&fw_lock);
 	return retval;
@@ -277,7 +346,11 @@ static struct bin_attribute firmware_attr_data_tmpl = {
 static void fw_dev_release(struct device *dev)
 {
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	int i;
 
+	for (i = 0; i < fw_priv->nr_pages; i++)
+		__free_page(fw_priv->pages[i]);
+	kfree(fw_priv->pages);
 	kfree(fw_priv);
 	kfree(dev);
 



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

