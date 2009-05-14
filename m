Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZENQTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZENQTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZENQTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:19:11 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34138 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbZENQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LqvWCFbFU9l2NCUAe8ru8lQA6SCZ/Lh7w5qx/IwaoJAS42qOpl9J9VPMYq/iS66LRm
         2M10B8UVidlBUuWioojcBQ5S9HoerVPaPqw+C24empy7NZNXdY8izEtRrtAYFT9qWM9Y
         dvJCekT1dQZQ1IbngW4mgiNR/aDOnIunoPGnQ=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Introduce check_readable_bytes()
Date: Thu, 14 May 2009 18:19:00 +0200
Message-Id: <1242317939-15392-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This routine acts almost as fault_in_pages_readable(), but returns
accessible amount of bytes instead of plain OK/FAIL, so callers
may know how many data can be proceeded without GPF.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 include/linux/pagemap.h |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 34da523..f931308 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -439,6 +439,41 @@ static inline int fault_in_pages_readable(const char __user *uaddr, int size)
 	return ret;
 }
 
+/*
+ * check_readable_bytes - check if given amount of bytes can be read
+ * at given address.
+ * @uaddr: address to check
+ * @size: size to check
+ *
+ * Returns 0 when @size is 0, -EFAULT when @uaddr points to
+ * unaccessible region, or count of accessible bytes.
+ */
+static inline int check_readable_bytes(const char __user *uaddr, int size)
+{
+	volatile char c;
+	int ret = 0;
+	long page_begin = (unsigned long)uaddr & PAGE_MASK;
+	long page_end = ((unsigned long)uaddr + size) & PAGE_MASK;
+	long ptr = page_begin;
+
+	if (unlikely(size == 0))
+		goto out;
+
+	while (!ret && ptr <= page_end) {
+		ret = __get_user(c, (const char __user*)ptr);
+		if (!ret)
+			ptr += PAGE_SIZE;
+	}
+
+	if (likely(!ret))
+		ret = size;
+	else
+		ret = (ptr == page_begin) ?
+			-EFAULT : (const char __user *)ptr - uaddr;
+out:
+	return ret;
+}
+
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
-- 
1.6.2.2


