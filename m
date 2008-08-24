Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYHXRuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYHXRuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHXRt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:49:58 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:42202 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYHXRt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=PyVwz1DeEvJ8/CUJ9HWzplMhOLcxZsKa0xFW8zrsD2gycPqZfGLrqhabUDv9D35m7W
         f9yF2aIIp4E7JCk5SJwov4iuoGGW+tPw24WhsXrJLhhLiQymLIDB5q3q6a32ySJAiu8M
         FR2ZXKh5ns6P/VeAT2sJfOHJkrOyf6vP3b1z8=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH] kmemtrace: SLUB hooks for caller-tracking functions.
Date: Sun, 24 Aug 2008 20:49:35 +0300
Message-Id: <1219600175-5253-1-git-send-email-eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kmemtrace hooks for __kmalloc_track_caller() and
__kmalloc_node_track_caller(). Currently, they set the call site pointer
to the value recieved as a parameter. (This could change if we implement
stack trace exporting in kmemtrace.)

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 mm/slub.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 06755e2..e79b814 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3254,6 +3254,7 @@ static struct notifier_block __cpuinitdata slab_notifier = {
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large(size, gfpflags);
@@ -3263,13 +3264,21 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, gfpflags, -1, caller);
+	ret = slab_alloc(s, gfpflags, -1, caller);
+
+	/* Honor the call site pointer we recieved. */
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
+			     (unsigned long) caller, ret,
+			     size, s->size, gfpflags);
+
+	return ret;
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 					int node, void *caller)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large_node(size, gfpflags, node);
@@ -3279,7 +3288,14 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, gfpflags, node, caller);
+	ret = slab_alloc(s, gfpflags, node, caller);
+
+	/* Honor the call site pointer we recieved. */
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+				  (unsigned long) caller, ret,
+				  size, s->size, gfpflags, node);
+
+	return ret;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
-- 
1.5.6.1

