Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbYH2XRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbYH2XRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbYH2XQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:16:49 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:54422 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbYH2XQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:16:47 -0400
Date: Fri, 29 Aug 2008 16:16:46 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com
Subject: [PATCH 4/6] VM: Annotate pagealloc
In-Reply-To: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
Message-ID: <alpine.DEB.1.00.0808291616170.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valgrind annotations for valgrind: memory is addressable once it's been
alloced, and unaddressable when it is freed again.  Can't use malloc-like
and free-like because valgrind considers a malloc-like chunk indivisible.

Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
---

Index: linux-2.6.27-rc5/mm/page_alloc.c
===================================================================
--- linux-2.6.27-rc5.orig/mm/page_alloc.c	2008-08-29 14:24:27.000000000 -0700
+++ linux-2.6.27-rc5/mm/page_alloc.c	2008-08-29 14:24:37.000000000 -0700
@@ -46,6 +46,7 @@
  #include <linux/page-isolation.h>
  #include <linux/memcontrol.h>
  #include <linux/debugobjects.h>
+#include <linux/memcheck.h>

  #include <asm/tlbflush.h>
  #include <asm/div64.h>
@@ -1080,6 +1081,7 @@
  		if (!page)
  			goto failed;
  	}
+	VALGRIND_MAKE_MEM_UNDEFINED(page_address(page), PAGE_SIZE << order);

  	__count_zone_vm_events(PGALLOC, zone, 1 << order);
  	zone_statistics(preferred_zone, zone);
@@ -1679,6 +1681,8 @@
  void __free_pages(struct page *page, unsigned int order)
  {
  	if (put_page_testzero(page)) {
+		VALGRIND_MAKE_MEM_NOACCESS(page_address(page),
+						PAGE_SIZE << order);
  		if (order == 0)
  			free_hot_page(page);
  		else
