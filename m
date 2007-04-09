Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbXDIMiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbXDIMiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXDIMiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:38:07 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:33553 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbXDIMiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:38:05 -0400
Message-ID: <461A3483.10402@sw.ru>
Date: Mon, 09 Apr 2007 16:41:39 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
CC: devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@google.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 2/8] Add container pointer on struct page
References: <461A3010.90403@sw.ru>
In-Reply-To: <461A3010.90403@sw.ru>
Content-Type: multipart/mixed;
 boundary="------------020306010801040802000602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020306010801040802000602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Each page is supposed to have an owner - the container
that touched the page first. The owner stays alive during
the page lifetime even if the task that touched the page
dies or moves to another container.

This ownership is the forerunner for the "fair" page sharing
accounting, in which page has as may owners as it is really
used by.

--------------020306010801040802000602
Content-Type: text/plain;
 name="diff-rss-container-on-page"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-rss-container-on-page"

diff -upr linux-2.6.20.orig/include/linux/mm.h linux-2.6.20-2/include/linux/mm.h
--- linux-2.6.20.orig/include/linux/mm.h	2007-03-06 19:09:50.000000000 +0300
+++ linux-2.6.20-2/include/linux/mm.h	2007-04-09 11:26:06.000000000 +0400
@@ -220,6 +220,12 @@ struct vm_operations_struct {
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
 
diff -upr linux-2.6.20.orig/include/linux/mm_types.h linux-2.6.20-2/include/linux/mm_types.h
--- linux-2.6.20.orig/include/linux/mm_types.h	2007-03-06 19:09:50.000000000 +0300
+++ linux-2.6.20-2/include/linux/mm_types.h	2007-04-09 11:26:06.000000000 +0400
@@ -62,6 +62,9 @@ struct page {
 	void *virtual;			/* Kernel virtual address (NULL if
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
+#ifdef CONFIG_RSS_CONTAINER
+	struct page_container *rss_container;
+#endif
 };
 
 #endif /* _LINUX_MM_TYPES_H */


--------------020306010801040802000602--
