Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYKQM37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYKQM37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYKQM3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:29:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56703 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbYKQM3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:29:48 -0500
Message-ID: <492162E4.9080902@cn.fujitsu.com>
Date: Mon, 17 Nov 2008 20:26:12 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, Dave Airlie <airlied@gmail.com>,
       Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 1/1] mm: introduce kvmalloc()/kvfree()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For some reason, we use alternative malloc.
1) we want NUMA spreading and reliable allocation.
2) we use kmalloc(), but we want vmalloc() rarely when required
   memory is very large.
......

there are N copied of such codes in the kernel, it's pure code duplication.
this patch provides two helper functions do such alternative malloc/free,
and duplication codes will be cleanup.

changed from v1:

1) name them kvmalloc()/kvfree() instead of simple_malloc()/simple_free()
2) implement them in mm/util.c
   Since vmalloc()/vfree() is potentially a very expensive operation,
   we should make kvmalloc()/kvfree() uninlined. No need to try to
   save 3 or 4 cpu cycles. This will save icache at least.
3) add gfp_t flags parameter.

changelog of v1:

some subsystem needs vmalloc() when required memory is large.
but current kernel has not APIs for this requirement.
this patch introduces simple_malloc() and simple_free().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ffee2f7..ff89388 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -278,6 +278,9 @@ static inline int is_vmalloc_addr(const void *x)
 #endif
 }
 
+void *kvmalloc(unsigned long size, gfp_t flags);
+void kvfree(void *ptr);
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
diff --git a/mm/util.c b/mm/util.c
index cb00b74..66d1a12 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -5,6 +5,8 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <asm/uaccess.h>
+#include <linux/interrupt.h>
+#include <linux/vmalloc.h>
 
 /**
  * kstrdup - allocate space for and copy an existing string
@@ -163,6 +165,38 @@ char *strndup_user(const char __user *s, long n)
 }
 EXPORT_SYMBOL(strndup_user);
 
+/**
+ * kvmalloc - allocate memory by kmalloc() or vmalloc()
+ *
+ * if @size <= PAGE_SIZE, memory is allocated by kmalloc(),
+ * otherwise by vmalloc().
+ *
+ * NOTICE: Generally, you should use kmalloc() or vmalloc() directly.
+ * kvmalloc() is provided for some special condition.
+ */
+void *kvmalloc(unsigned long size, gfp_t flags)
+{
+	if (size <= PAGE_SIZE)
+		return kmalloc(size, flags & ~__GFP_HIGH);
+	else
+		return __vmalloc(size, flags | __GFP_HIGHMEM, PAGE_KERNEL);
+}
+EXPORT_SYMBOL(kvmalloc);
+
+/**
+ * kvfree - free the memory by kfree(), or vfree() if it is vmalloc addr
+ */
+void kvfree(void *ptr)
+{
+	BUG_ON(in_interrupt());
+
+	if (is_vmalloc_addr(ptr))
+		vfree(ptr);
+	else
+		kfree(ptr);
+}
+EXPORT_SYMBOL(kvfree);
+
 #ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {


