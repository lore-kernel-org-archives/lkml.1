Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZAVRsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZAVRsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbZAVRn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbZAVRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:51 -0500
Message-Id: <20090122174053.859726452@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:18 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 17/19] lockdep: simplify get_user_chars()
Content-Disposition: inline; filename=lockdep-get_usage_chars.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there's too much repetition of code..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   65 ++++++++++++++++++++-----------------------------------
 1 file changed, 24 insertions(+), 41 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -467,54 +467,37 @@ const char * __get_key_name(struct lockd
 	return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
 }
 
-void
-get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3,
-					char *c4, char *c5, char *c6)
+static inline unsigned long lock_flag(enum lock_usage_bit bit)
 {
-	*c1 = '.', *c2 = '.', *c3 = '.', *c4 = '.', *c5 = '.', *c6 = '.';
-
-	if (class->usage_mask & LOCKF_USED_IN_HARDIRQ)
-		*c1 = '+';
-	else
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ)
-			*c1 = '-';
+	return 1UL << bit;
+}
 
-	if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ)
-		*c2 = '+';
-	else
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ)
-			*c2 = '-';
+static char get_usage_char(struct lock_class *class, enum lock_usage_bit bit)
+{
+	char c = '.';
 
-	if (class->usage_mask & LOCKF_ENABLED_HARDIRQ_READ)
-		*c3 = '-';
-	if (class->usage_mask & LOCKF_USED_IN_HARDIRQ_READ) {
-		*c3 = '+';
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ_READ)
-			*c3 = '?';
-	}
-
-	if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ_READ)
-		*c4 = '-';
-	if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ_READ) {
-		*c4 = '+';
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ_READ)
-			*c4 = '?';
+	if (class->usage_mask & lock_flag(bit + 2))
+		c = '+';
+	if (class->usage_mask & lock_flag(bit)) {
+		c = '-';
+		if (class->usage_mask & lock_flag(bit + 2))
+			c = '?';
 	}
 
-	if (class->usage_mask & LOCKF_USED_IN_RECLAIM_FS)
-		*c5 = '+';
-	else
-		if (class->usage_mask & LOCKF_ENABLED_RECLAIM_FS)
-			*c5 = '-';
+	return c;
+}
 
-	if (class->usage_mask & LOCKF_ENABLED_RECLAIM_FS_READ)
-		*c6 = '-';
-	if (class->usage_mask & LOCKF_USED_IN_RECLAIM_FS_READ) {
-		*c6 = '+';
-		if (class->usage_mask & LOCKF_ENABLED_RECLAIM_FS_READ)
-			*c6 = '?';
-	}
+void
+get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3,
+					char *c4, char *c5, char *c6)
+{
+	*c1 = get_usage_char(class, LOCK_USED_IN_HARDIRQ);
+	*c2 = get_usage_char(class, LOCK_USED_IN_SOFTITQ);
+	*c3 = get_usage_char(class, LOCK_USED_IN_HARDIRQ_READ);
+	*c4 = get_usage_char(class, LOCK_USED_IN_SOFTITQ_READ);
 
+	*c5 = get_usage_char(class, LOCK_USED_IN_RECLAIM_FS);
+	*c6 = get_usage_char(class, LOCK_USED_IN_RECLAIM_FS_READ);
 }
 
 static void print_lock_name(struct lock_class *class)

-- 

