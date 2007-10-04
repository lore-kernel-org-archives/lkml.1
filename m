Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXJDEDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXJDEDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXJDEAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53765 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732AbXJDEAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:05 -0400
Message-Id: <20071004040004.708466159@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:48 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ak@suse.de,
       travis@sgi.com
Subject: [13/18] x86_64: Allow fallback for the stack
Content-Disposition: inline; filename=vcompound_x86_64_stack_fallback
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra has recently demonstrated that we can have order 1 allocation
failures under memory pressure with small memory configurations. The
x86_64 stack has a size of 8k and thus requires a order 1 allocation.

This patch adds a virtual fallback capability for the stack. The system may
continue even in extreme situations and we may be able to increase the stack
size if necessary (see next patch).

Cc: ak@suse.de
Cc: travis@sgi.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86_64/thread_info.h |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/thread_info.h	2007-10-03 14:49:48.000000000 -0700
+++ linux-2.6/include/asm-x86_64/thread_info.h	2007-10-03 14:51:00.000000000 -0700
@@ -74,20 +74,14 @@ static inline struct thread_info *stack_
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-    ({								\
-	struct thread_info *ret;				\
-								\
-	ret = ((struct thread_info *) __get_free_pages(GFP_KERNEL,THREAD_ORDER)); \
-	if (ret)						\
-		memset(ret, 0, THREAD_SIZE);			\
-	ret;							\
-    })
+#define THREAD_FLAGS (GFP_VFALLBACK | __GFP_ZERO)
 #else
-#define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(GFP_KERNEL,THREAD_ORDER))
+#define THREAD_FLAGS GFP_VFALLBACK
 #endif
 
+#define alloc_thread_info(tsk) \
+	((struct thread_info *) __get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+
 #define free_thread_info(ti) free_pages((unsigned long) (ti), THREAD_ORDER)
 
 #else /* !__ASSEMBLY__ */

-- 
