Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbXE3PYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbXE3PYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbXE3PYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:24:12 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:47032 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbXE3PYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:24:10 -0400
Message-ID: <465D9804.9040904@openvz.org>
Date: Wed, 30 May 2007 19:28:04 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH 2/8] Add container pointer on struct page
References: <465D9739.8070209@openvz.org>
In-Reply-To: <465D9739.8070209@openvz.org>
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

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff -upr linux-2.6.22-rc2-mm1.orig/include/linux/mm.h linux-2.6.22-rc2-mm1-0/include/linux/mm.h
--- linux-2.6.22-rc2-mm1.orig/include/linux/mm.h	2007-05-30 12:32:35.000000000 +0400
+++ linux-2.6.22-rc2-mm1-0/include/linux/mm.h	2007-05-30 16:13:09.000000000 +0400
@@ -250,6 +250,12 @@ struct vm_operations_struct {
 struct mmu_gather;
 struct inode;
 
+#ifdef CONFIG_RSS_CONTAINER
+#define page_container(page)	(page->rss_container)
+#else
+#define page_container(page)	(NULL)
+#endif
+
 #define page_private(page)		((page)->private)
 #define set_page_private(page, v)	((page)->private = (v))
 
diff -upr linux-2.6.22-rc2-mm1.orig/include/linux/mm_types.h linux-2.6.22-rc2-mm1-0/include/linux/mm_types.h
--- linux-2.6.22-rc2-mm1.orig/include/linux/mm_types.h	2007-05-30 12:32:35.000000000 +0400
+++ linux-2.6.22-rc2-mm1-0/include/linux/mm_types.h	2007-05-30 16:13:09.000000000 +0400
@@ -83,6 +83,9 @@ struct page {
 	unsigned int gfp_mask;
 	unsigned long trace[8];
 #endif
+#ifdef CONFIG_RSS_CONTAINER
+	struct page_container *rss_container;
+#endif
 };
 
 #endif /* _LINUX_MM_TYPES_H */

