Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbXFDNZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbXFDNZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbXFDNZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:25:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:36721 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbXFDNZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:25:07 -0400
Message-ID: <466413C3.5020303@openvz.org>
Date: Mon, 04 Jun 2007 17:29:39 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 2/8] Add container pointer on struct page
References: <466412C5.1060104@openvz.org>
In-Reply-To: <466412C5.1060104@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Each page is supposed to have an owner - the container
that touched the page first. The owner stays alive during
the page lifetime even if the task that touched the page
dies or moves to another container.

This ownership is the forerunner for the "fair" page sharing
accounting, in which page has as may owners as it is really
used by.

Page ownership getter/setter are done as static inline function.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff -upr linux-2.6.22-rc2-mm1.orig/include/linux/mm.h linux-2.6.22-rc2-mm1-2/include/linux/mm.h
--- linux-2.6.22-rc2-mm1.orig/include/linux/mm.h	2007-05-30 12:32:35.000000000 +0400
+++ linux-2.6.22-rc2-mm1-2/include/linux/mm.h	2007-06-01 16:35:15.000000000 +0400
@@ -249,6 +249,30 @@ struct vm_operations_struct {
 
 struct mmu_gather;
 struct inode;
+struct page_container;
+
+#ifdef CONFIG_RSS_CONTAINER
+static inline struct page_container *page_container(struct page *pg)
+{
+	return pg->rss_container;
+}
+
+static inline void set_page_container(struct page *pg,
+		struct page_container *container)
+{
+	pg->rss_container = container;
+}
+#else
+static inline struct page_container *page_container(struct page *pg)
+{
+	return NULL;
+}
+
+static inline void set_page_container(struct page *pg,
+		struct page_container *container)
+{
+}
+#endif
 
 #define page_private(page)		((page)->private)
 #define set_page_private(page, v)	((page)->private = (v))
diff -upr linux-2.6.22-rc2-mm1.orig/include/linux/mm_types.h linux-2.6.22-rc2-mm1-2/include/linux/mm_types.h
--- linux-2.6.22-rc2-mm1.orig/include/linux/mm_types.h	2007-05-30 12:32:35.000000000 +0400
+++ linux-2.6.22-rc2-mm1-2/include/linux/mm_types.h	2007-06-01 16:35:13.000000000 +0400
@@ -83,6 +83,9 @@ struct page {
 	unsigned int gfp_mask;
 	unsigned long trace[8];
 #endif
+#ifdef CONFIG_RSS_CONTAINER
+	struct page_container *rss_container;
+#endif
 };
 
 #endif /* _LINUX_MM_TYPES_H */

