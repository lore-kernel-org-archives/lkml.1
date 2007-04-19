Return-Path: <linux-kernel-owner+w=401wt.eu-S1766859AbXDSQgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766859AbXDSQgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766866AbXDSQft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:35:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48161 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766858AbXDSQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:20 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070419163520.11948.15503.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 3/8] Flushing and zeroing higher order page cache pages
Date: Thu, 19 Apr 2007 09:35:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/linux/pagemap.h |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: linux-2.6.21-rc7/include/linux/pagemap.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/pagemap.h	2007-04-18 22:08:36.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/pagemap.h	2007-04-18 22:09:13.000000000 -0700
@@ -210,6 +210,33 @@ static inline void wait_on_page_writebac
 
 extern void end_page_writeback(struct page *page);
 
+/* Support for clearing higher order pages */
+static inline void clear_mapping_page(struct address_space *a,
+						struct page *page)
+{
+	int nr_pages = 1 << a->order;
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		clear_highpage(page + i);
+}
+
+/*
+ * Support for flushing higher order pages.
+ *
+ * A bit stupid: On many platforms flushing the first page
+ * will flush any TLB starting there
+ */
+static inline void flush_mapping_page(struct address_space *a,
+						struct page *page)
+{
+	int nr_pages = 1 << a->order;
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		flush_dcache_page(page + i);
+}
+
 /*
  * Fault a userspace page into pagetables.  Return non-zero on a fault.
  *
