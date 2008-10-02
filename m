Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYJBVoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYJBVoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYJBVoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:44:04 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:61220 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361AbYJBVoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:44:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAEPd5EhMQWq+/2dsb2JhbACBZ7xPgWo
Date: Thu, 2 Oct 2008 17:43:59 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       mbligh@google.com, Jiaying Zhang <jiayingz@google.com>
Subject: [TEST] LTTng relay-alloc cache tests
Message-ID: <20081002214359.GA24693@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:38:25 up 120 days,  2:18, 10 users,  load average: 0.26, 0.36,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With these tests, I come to the surprising conclusion that it is faster
to keep the buffer pages as write-back than to set them to
write-combined or uncached. I would have thought that keeping the
cachelines free for kernel or userspace cache lines would have improved
performance, but for some reason it doesn't.

Doing these tests under a webserver-like workload would however be
interesting. Feel free to play with this. :-)

Mathieu


LTTng trace buffer memory cache behavior comparison
Tracing in flight recorder mode with default size buffers
LTTng 0.31, kernel 2.6.27-rc8
Dual quad-core x86_64 with 16GB ram

** tbench (MB/s) **

tracing disabled :         1862.24

tracing flight recorder default buffer size :
cache WB :                  942.72
cache WC (write-combined) : 755.94
uncached :                  780.03


** kernel compilation **

make clean
sync
sync
echo 3 > /proc/sys/vm/drop_caches
time make -j10
[timing 1, cache cold]
make clean
make -j10
[timing 2, cache hot]


Tracing disabled :

[timing 1, cache cold]
real    1m24.729s
user    7m22.952s
sys     0m48.943s

[timing 2, cache hot]
real    1m10.639s
user    7m25.864s
sys     0m49.235s


cache WB :

[timing 1, cache cold]
real    1m33.408s
user    7m27.852s
sys     1m47.623s

[timing 2, cache hot]
real    1m20.429s
user    7m30.668s
sys     1m46.895s


cache WC (write-combined) :

[timing 1, cache cold]
real    1m38.971s
user    7m27.800s
sys     2m18.241s

[timing 2, cache hot]
real    1m25.200s
user    7m30.040s
sys     2m18.201s

uncached :

[timing 1, cache cold]
real    1m37.237s
user    7m28.352s
sys     2m13.312s

[timing 2, cache hot]
real    1m24.303s
user    7m29.420s
sys     2m14.756s

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 ltt/ltt-relay-alloc.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

Index: linux-2.6-lttng/ltt/ltt-relay-alloc.c
===================================================================
--- linux-2.6-lttng.orig/ltt/ltt-relay-alloc.c	2008-10-02 17:02:42.000000000 -0400
+++ linux-2.6-lttng/ltt/ltt-relay-alloc.c	2008-10-02 17:07:48.000000000 -0400
@@ -26,6 +26,38 @@
 static DEFINE_MUTEX(relay_channels_mutex);
 static LIST_HEAD(relay_channels);
 
+#ifdef CONFIG_X86
+#include <asm/cacheflush.h>
+#include <asm/pat.h>
+
+/*
+ * TODO : create an abstraction in arch/x86
+ * Use write-combined pages if PAT is supported. Else, use uncached pages to
+ * make sure we don't evince really useful cachelines.
+ */
+static int arch_buffer_page_attr_set(struct page *page, int numpages)
+{
+	return set_memory_wc((unsigned long)page_address(page), numpages);
+	//return set_memory_uc((unsigned long)page_address(page), numpages);
+}
+
+static int arch_buffer_page_attr_clear(struct page *page, int numpages)
+{
+	return set_memory_wb((unsigned long)page_address(page), numpages);
+}
+#else
+static int arch_buffer_page_attr_set(struct page *page)
+{
+	return 0;
+}
+
+static int arch_buffer_page_attr_clear(struct page *page)
+{
+	return 0;
+}
+#endif
+
+
 /**
  *	relay_alloc_buf - allocate a channel buffer
  *	@buf: the buffer struct
@@ -35,6 +67,7 @@ static int relay_alloc_buf(struct rchan_
 {
 	unsigned int i, n_pages;
 	struct buf_page *buf_page, *n;
+	int ret;
 
 	*size = PAGE_ALIGN(*size);
 	n_pages = *size >> PAGE_SHIFT;
@@ -56,6 +89,8 @@ static int relay_alloc_buf(struct rchan_
 		buf_page->offset = (size_t)i << PAGE_SHIFT;
 		buf_page->buf = buf;
 		set_page_private(buf_page->page, (unsigned long)buf_page);
+		ret = arch_buffer_page_attr_set(buf_page->page, 1);
+		WARN_ON(ret);
 		if (i == 0) {
 			buf->wpage = buf_page;
 			buf->hpage[0] = buf_page;
@@ -69,6 +104,8 @@ static int relay_alloc_buf(struct rchan_
 depopulate:
 	list_for_each_entry_safe(buf_page, n, &buf->pages, list) {
 		list_del_init(&buf_page->list);
+		ret = arch_buffer_page_attr_clear(buf_page->page, 1);
+		WARN_ON(ret);
 		__free_page(buf_page->page);
 		kfree(buf_page);
 	}
@@ -123,9 +160,12 @@ static void relay_destroy_buf(struct rch
 {
 	struct rchan *chan = buf->chan;
 	struct buf_page *buf_page, *n;
+	int ret;
 
 	list_for_each_entry_safe(buf_page, n, &buf->pages, list) {
 		list_del_init(&buf_page->list);
+		ret = arch_buffer_page_attr_clear(buf_page->page, 1);
+		WARN_ON(ret);
 		__free_page(buf_page->page);
 		kfree(buf_page);
 	}

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
