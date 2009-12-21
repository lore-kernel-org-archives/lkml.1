Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZLUQne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZLUQne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbZLUQna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:43:30 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:34465 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbZLUQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:43:27 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nommu: implement vmap/vunmap with kmalloc
Date: Mon, 21 Dec 2009 11:44:26 -0500
Message-Id: <1261413866-30634-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <8bd0f97a0910052125m4327fef3i47e3b549938802f9@mail.gmail.com>
References: <8bd0f97a0910052125m4327fef3i47e3b549938802f9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git-svn-id: svn://localhost/svn/linux-kernel/trunk@7693 526b6c2d-f592-4532-a319-5dd88ccb003d
---
 mm/nommu.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 8687973..d28ab94 100644
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
1.6.5.4

