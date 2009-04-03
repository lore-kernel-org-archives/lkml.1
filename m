Return-Path: <linux-kernel-owner+w=401wt.eu-S1763391AbZDCKkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763391AbZDCKkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764031AbZDCKiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:38:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:42982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763870AbZDCKiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:38:18 -0400
Date: Fri, 3 Apr 2009 10:37:29 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237971957.30175.18.camel@penberg-laptop>
References: <1237971957.30175.18.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace-v2] kmemtrace: trace kfree() calls with NULL or zero-length objects
Message-ID: <tip-2121db74ba0fd2259f0e2265511684fadda9ac49@git.kernel.org>
Git-Commit-ID: 2121db74ba0fd2259f0e2265511684fadda9ac49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:37:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2121db74ba0fd2259f0e2265511684fadda9ac49
Gitweb:     http://git.kernel.org/tip/2121db74ba0fd2259f0e2265511684fadda9ac49
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Wed, 25 Mar 2009 11:05:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:23:10 +0200

kmemtrace: trace kfree() calls with NULL or zero-length objects

Impact: also output kfree(NULL) entries

This patch moves the trace_kfree() calls before the ZERO_OR_NULL_PTR
check so that we can trace call-sites that call kfree() with NULL many
times which might be an indication of a bug.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <1237971957.30175.18.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
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
index 0000358..a2d4ab3 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -514,6 +514,8 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
+	trace_kfree(_RET_IP_, block);
+
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 
@@ -524,8 +526,6 @@ void kfree(const void *block)
 		slob_free(m, *m + align);
 	} else
 		put_page(&sp->page);
-
-	trace_kfree(_RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slub.c b/mm/slub.c
index a98078b..7ab54ec 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2792,6 +2792,8 @@ void kfree(const void *x)
 	struct page *page;
 	void *object = (void *)x;
 
+	trace_kfree(_RET_IP_, x);
+
 	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
@@ -2802,8 +2804,6 @@ void kfree(const void *x)
 		return;
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
-
-	trace_kfree(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
