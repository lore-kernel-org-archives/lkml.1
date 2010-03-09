Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0CIQIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:08:10 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:50869 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab0CIQIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:08:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH v2] NOMMU: implement vmap/vunmap with kmalloc
Date: Tue,  9 Mar 2010 11:11:21 -0500
Message-Id: <1268151081-28307-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1261413866-30634-1-git-send-email-vapier@gentoo.org>
References: <1261413866-30634-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- fix up changelog

 mm/nommu.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index b9b5cce..61a68d5 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -360,14 +360,26 @@ EXPORT_SYMBOL(vmalloc_32_user);
 
 void *vmap(struct page **pages, unsigned int count, unsigned long flags, pgprot_t prot)
 {
-	BUG();
-	return NULL;
+	unsigned int i;
+	void *new_map, *page_data;
+
+	new_map = kmalloc(count << PAGE_SHIFT, GFP_KERNEL);
+	if (!new_map)
+		return NULL;
+
+	for (i = 0; i < count; ++i) {
+		page_data = kmap(pages[i]);
+		memcpy(new_map + (i << PAGE_SHIFT), page_data, PAGE_SIZE);
+		kunmap(page_data);
+	}
+
+	return new_map;
 }
 EXPORT_SYMBOL(vmap);
 
 void vunmap(const void *addr)
 {
-	BUG();
+	kfree(addr);
 }
 EXPORT_SYMBOL(vunmap);
 
-- 
1.7.0.2

