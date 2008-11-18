Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbYKRIzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbYKRIzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYKRIyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:54:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbYKRIyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:54:22 -0500
Message-ID: <492281FE.4000301@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 16:51:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, David Miller <davem@davemloft.net>,
       Dave Airlie <airlied@gmail.com>, Paul Menage <menage@google.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH V2 2/4] mm: introduce kvfree_atomic()
References: <492162E4.9080902@cn.fujitsu.com> <20081117131440.GB29931@cmpxchg.org>
In-Reply-To: <20081117131440.GB29931@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fdtable and sysipc use vfree() in RCU callback. this patch
introduce vfree_atomic() for them.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ff89388..aa7b5ca 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -280,6 +280,7 @@ static inline int is_vmalloc_addr(const void *x)
 
 void *kvmalloc(unsigned long size, gfp_t flags);
 void kvfree(void *ptr);
+void kvfree_atomic(void *ptr);
 
 static inline struct page *compound_head(struct page *page)
 {
diff --git a/mm/util.c b/mm/util.c
index 66d1a12..ed2d317 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -197,6 +197,15 @@ void kvfree(void *ptr)
 }
 EXPORT_SYMBOL(kvfree);
 
+void kvfree_atomic(void *ptr)
+{
+	if (is_vmalloc_addr(ptr))
+		vfree_atomic(ptr);
+	else
+		kfree(ptr);
+}
+EXPORT_SYMBOL(kvfree_atomic);
+
 #ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {

