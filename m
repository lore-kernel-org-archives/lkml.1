Return-Path: <linux-kernel-owner+w=401wt.eu-S1763928AbXGYLTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763928AbXGYLTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbXGYLTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:19:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:45873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415AbXGYLTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:19:23 -0400
Date: Wed, 25 Jul 2007 13:19:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, airlied@gmail.com,
       magnade@gmail.com
Subject: [patch] agp: don't lock pages
Message-ID: <20070725111922.GF29011@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does this patch solve the X problem? Does anyone see anything wrong
with it or know why agp was locking the pages?

--
AGP should not need to lock pages. They are not protecting any race
because there is no lock_page calls, only SetPageLocked.

This is causing hangs with d00806b183152af6d24f46f0c33f14162ca1262a.

Signed-off-by: Nick Piggin <npiggin@suse.de>

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index d535c40..3db4f40 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1170,7 +1170,6 @@ void *agp_generic_alloc_page(struct agp_
 	map_page_into_agp(page);
 
 	get_page(page);
-	SetPageLocked(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
 	return page_address(page);
 }
@@ -1187,7 +1186,6 @@ void agp_generic_destroy_page(void *addr
 	page = virt_to_page(addr);
 	unmap_page_from_agp(page);
 	put_page(page);
-	unlock_page(page);
 	free_page((unsigned long)addr);
 	atomic_dec(&agp_bridge->current_memory_agp);
 }
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index a124060..2f319f4 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -213,7 +213,6 @@ static void *i8xx_alloc_pages(void)
 	}
 	global_flush_tlb();
 	get_page(page);
-	SetPageLocked(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
 	return page_address(page);
 }
@@ -229,7 +228,6 @@ static void i8xx_destroy_pages(void *add
 	change_page_attr(page, 4, PAGE_KERNEL);
 	global_flush_tlb();
 	put_page(page);
-	unlock_page(page);
 	__free_pages(page, 2);
 	atomic_dec(&agp_bridge->current_memory_agp);
 }
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index cda608c..98cf8ab 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -51,7 +51,6 @@ static void *sgi_tioca_alloc_page(struct
 		return NULL;
 
 	get_page(page);
-	SetPageLocked(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
 	return page_address(page);
 }
