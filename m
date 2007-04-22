Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXDVJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXDVJQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965576AbXDVJQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:16:41 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:36742 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965564AbXDVJQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=oUN6G0AEc1V3XkxGCap8CwqXskFyAqm91/YUd8gwaWIdhWc8RCs0IzAUsEjBGcn2i554Bti3TBzn4F2byMzPw3+c42ycWQp1AnSV37t/OOGdrQ61XcrG+7CKNTXeB1/veM5iHvGu7oCF5q5pVIaUHeC74hqF9JFE9/97vuJSCkY=
Date: Sun, 22 Apr 2007 18:11:08 +0900
To: Andi Kleen <andi@firstfloor.org>,
       Scott Porter <scott@opengridcomputing.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] fault injection: fix failslab with CONFIG_NUMA
Message-ID: <20070422091108.GB4246@APFDCB5C>
Mail-Followup-To: Akinobu Mita <Akinobu.Mita@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Scott Porter <scott@opengridcomputing.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>
References: <1177095354.25165.48.camel@scott-desktop.site> <1177192363.25165.101.camel@scott-desktop.site> <20070421221033.GA30496@one.firstfloor.org> <20070422070603.GA30662@APFDCB5C> <20070422090930.GA4246@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422090930.GA4246@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
From: Akinobu Mita <akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently failslab injects failures into ____cache_alloc().
But with enabling CONFIG_NUMA it's not enough to let actual
slab allocator functions (kmalloc, kmem_cache_alloc, ...) return NULL.

This patch moves fault injection hook inside of __cache_alloc() and
__cache_alloc_node(). These are lower call path than ____cache_alloc()
and enable to inject faulures to slab allocators with CONFIG_NUMA.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 mm/slab.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: 2.6-git/mm/slab.c
===================================================================
--- 2.6-git.orig/mm/slab.c
+++ 2.6-git/mm/slab.c
@@ -3142,7 +3142,7 @@ static int __init failslab_debugfs(void)
 	struct dentry *dir;
 	int err;
 
-       	err = init_fault_attr_dentries(&failslab.attr, "failslab");
+	err = init_fault_attr_dentries(&failslab.attr, "failslab");
 	if (err)
 		return err;
 	dir = failslab.attr.dentries.dir;
@@ -3180,9 +3180,6 @@ static inline void *____cache_alloc(stru
 
 	check_irq_off();
 
-	if (should_failslab(cachep, flags))
-		return NULL;
-
 	ac = cpu_cache_get(cachep);
 	if (likely(ac->avail)) {
 		STATS_INC_ALLOCHIT(cachep);
@@ -3374,6 +3371,9 @@ __cache_alloc_node(struct kmem_cache *ca
 	unsigned long save_flags;
 	void *ptr;
 
+	if (should_failslab(cachep, flags))
+		return NULL;
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
@@ -3444,6 +3444,9 @@ __cache_alloc(struct kmem_cache *cachep,
 	unsigned long save_flags;
 	void *objp;
 
+	if (should_failslab(cachep, flags))
+		return NULL;
+
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 	objp = __do_cache_alloc(cachep, flags);
