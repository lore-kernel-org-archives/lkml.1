Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZCRMuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZCRMuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbZCRMs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:48:58 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:48431 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbZCRMs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:48:56 -0400
Message-Id: <20090318124845.801638079@de.ibm.com>
References: <20090318124829.637003183@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 18 Mar 2009 13:48:33 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 4/6] Dont check for pfn_valid() in uaccess_pt.c
Content-Disposition: inline; filename=004-valid.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

pfn_valid() actually checks for a valid struct page and not for a
valid pfn. Using xip mappings w/o struct pages, this will result in
-EFAULT returned by the (page table walk) user copy functions,
even though there is valid memory. Those user copy functions don't
need a struct page, so this patch just removes the pfn_valid() check.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/lib/uaccess_pt.c |   18 ------------------
 1 file changed, 18 deletions(-)

Index: quilt-2.6/arch/s390/lib/uaccess_pt.c
===================================================================
--- quilt-2.6.orig/arch/s390/lib/uaccess_pt.c
+++ quilt-2.6/arch/s390/lib/uaccess_pt.c
@@ -119,8 +119,6 @@ retry:
 			goto fault;
 
 		pfn = pte_pfn(*pte);
-		if (!pfn_valid(pfn))
-			goto out;
 
 		offset = uaddr & (PAGE_SIZE - 1);
 		size = min(n - done, PAGE_SIZE - offset);
@@ -135,7 +133,6 @@ retry:
 		done += size;
 		uaddr += size;
 	} while (done < n);
-out:
 	spin_unlock(&mm->page_table_lock);
 	return n - done;
 fault:
@@ -163,9 +160,6 @@ retry:
 		goto fault;
 
 	pfn = pte_pfn(*pte);
-	if (!pfn_valid(pfn))
-		goto out;
-
 	ret = (pfn << PAGE_SHIFT) + (uaddr & (PAGE_SIZE - 1));
 out:
 	return ret;
@@ -244,11 +238,6 @@ retry:
 			goto fault;
 
 		pfn = pte_pfn(*pte);
-		if (!pfn_valid(pfn)) {
-			done = -1;
-			goto out;
-		}
-
 		offset = uaddr & (PAGE_SIZE-1);
 		addr = (char *)(pfn << PAGE_SHIFT) + offset;
 		len = min(count - done, PAGE_SIZE - offset);
@@ -256,7 +245,6 @@ retry:
 		done += len_str;
 		uaddr += len_str;
 	} while ((len_str == len) && (done < count));
-out:
 	spin_unlock(&mm->page_table_lock);
 	return done + 1;
 fault:
@@ -325,12 +313,7 @@ retry:
 		}
 
 		pfn_from = pte_pfn(*pte_from);
-		if (!pfn_valid(pfn_from))
-			goto out;
 		pfn_to = pte_pfn(*pte_to);
-		if (!pfn_valid(pfn_to))
-			goto out;
-
 		offset_from = uaddr_from & (PAGE_SIZE-1);
 		offset_to = uaddr_from & (PAGE_SIZE-1);
 		offset_max = max(offset_from, offset_to);
@@ -342,7 +325,6 @@ retry:
 		uaddr_from += size;
 		uaddr_to += size;
 	} while (done < n);
-out:
 	spin_unlock(&mm->page_table_lock);
 	return n - done;
 fault:

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

