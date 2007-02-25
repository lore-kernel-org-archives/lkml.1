Return-Path: <linux-kernel-owner+w=401wt.eu-S932322AbXBYUGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbXBYUGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932684AbXBYUGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:06:24 -0500
Received: from mail.screens.ru ([213.234.233.54]:36233 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322AbXBYUGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:06:23 -0500
Date: Sun, 25 Feb 2007 23:06:21 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] adapt page_lock_anon_vma() to PREEMPT_RCU
Message-ID: <20070225200621.GA2259@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

page_lock_anon_vma() uses spin_lock() to block RCU. This doesn't work with
PREEMPT_RCU, we have to do rcu_read_lock() explicitely. Otherwise, it is
theoretically possible that slab returns anon_vma's memory to the system
before we do spin_unlock(&anon_vma->lock).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- WQ/mm/rmap.c~	2007-02-18 22:56:49.000000000 +0300
+++ WQ/mm/rmap.c	2007-02-25 22:43:00.000000000 +0300
@@ -183,7 +183,7 @@ void __init anon_vma_init(void)
  */
 static struct anon_vma *page_lock_anon_vma(struct page *page)
 {
-	struct anon_vma *anon_vma = NULL;
+	struct anon_vma *anon_vma;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -195,9 +195,16 @@ static struct anon_vma *page_lock_anon_v
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	spin_lock(&anon_vma->lock);
+	return anon_vma;
 out:
 	rcu_read_unlock();
-	return anon_vma;
+	return NULL;
+}
+
+static void page_unlock_anon_vma(struct anon_vma *anon_vma)
+{
+	spin_unlock(&anon_vma->lock);
+	rcu_read_unlock();
 }
 
 /*
@@ -333,7 +340,8 @@ static int page_referenced_anon(struct p
 		if (!mapcount)
 			break;
 	}
-	spin_unlock(&anon_vma->lock);
+
+	page_unlock_anon_vma(anon_vma);
 	return referenced;
 }
 
@@ -809,7 +817,8 @@ static int try_to_unmap_anon(struct page
 				!page_mapped(page))
 			break;
 	}
-	spin_unlock(&anon_vma->lock);
+
+	page_unlock_anon_vma(anon_vma);
 	return ret;
 }
 

