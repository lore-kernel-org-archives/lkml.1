Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZCYJGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZCYJGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZCYJGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:06:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57638 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZCYJGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:06:00 -0400
Subject: [PATCH] kmemtrace: trace kfree() calls with NULL or zero-length
	objects
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, eduard.munteanu@linux360.ro,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Mar 2009 11:05:57 +0200
Message-Id: <1237971957.30175.18.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: improve tracing

This patch moves the trace_kfree() calls before the ZERO_OR_NULL_PTR
check so that we can trace call-sites that call kfree() with NULL many
times which might be an indication of a bug.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Eduard, does this require some changes in the user-space tools?

 mm/slab.c |    4 ++--
 mm/slob.c |    4 ++--
 mm/slub.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index fa00fd6..b584002 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3773,6 +3773,8 @@ void kfree(const void *objp)
 	struct kmem_cache *c;
 	unsigned long flags;
 
+	trace_kfree(_RET_IP_, objp);
+
 	if (unlikely(ZERO_OR_NULL_PTR(objp)))
 		return;
 	local_irq_save(flags);
@@ -3782,8 +3784,6 @@ void kfree(const void *objp)
 	debug_check_no_obj_freed(objp, obj_size(c));
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
-
-	trace_kfree(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slob.c b/mm/slob.c
index 2ccd31d..5bd7ecc 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -503,6 +503,8 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
+	trace_kfree(_RET_IP_, block);
+
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 
@@ -513,8 +515,6 @@ void kfree(const void *block)
 		slob_free(m, *m + align);
 	} else
 		put_page(&sp->page);
-
-	trace_kfree(_RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slub.c b/mm/slub.c
index c3a905b..988ef33 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2791,6 +2791,8 @@ void kfree(const void *x)
 	struct page *page;
 	void *object = (void *)x;
 
+	trace_kfree(_RET_IP_, x);
+
 	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
@@ -2801,8 +2803,6 @@ void kfree(const void *x)
 		return;
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
-
-	trace_kfree(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
-- 
1.5.4.3



