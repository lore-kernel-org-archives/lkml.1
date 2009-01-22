Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbZAVRs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbZAVRs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbZAVRn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbZAVRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:51 -0500
Message-Id: <20090122174053.912199330@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:19 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 18/19] lockdep: get_user_chars() redo
Content-Disposition: inline; filename=lockdep-get_usage_chars2.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic, states independent, get_user_chars().

XXX: update documentation, usage string order changed

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c           |   26 +++++++++++++-------------
 kernel/lockdep_internals.h |    7 ++++---
 kernel/lockdep_proc.c      |    6 +++---
 3 files changed, 20 insertions(+), 19 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -487,25 +487,25 @@ static char get_usage_char(struct lock_c
 	return c;
 }
 
-void
-get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3,
-					char *c4, char *c5, char *c6)
-{
-	*c1 = get_usage_char(class, LOCK_USED_IN_HARDIRQ);
-	*c2 = get_usage_char(class, LOCK_USED_IN_SOFTITQ);
-	*c3 = get_usage_char(class, LOCK_USED_IN_HARDIRQ_READ);
-	*c4 = get_usage_char(class, LOCK_USED_IN_SOFTITQ_READ);
+void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
+{
+	int i = 0;
+
+#define LOCKDEP_STATE(__STATE) 						\
+	usage[i++] = get_usage_char(class, LOCK_USED_IN_##__STATE);	\
+	usage[i++] = get_usage_char(class, LOCK_USED_IN_##__STATE##_READ);
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 
-	*c5 = get_usage_char(class, LOCK_USED_IN_RECLAIM_FS);
-	*c6 = get_usage_char(class, LOCK_USED_IN_RECLAIM_FS_READ);
+	usage[i] = '\0';
 }
 
 static void print_lock_name(struct lock_class *class)
 {
-	char str[KSYM_NAME_LEN], c1, c2, c3, c4, c5, c6;
+	char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
 	const char *name;
 
-	get_usage_chars(class, &c1, &c2, &c3, &c4, &c5, &c6);
+	get_usage_chars(class, usage);
 
 	name = class->name;
 	if (!name) {
@@ -518,7 +518,7 @@ static void print_lock_name(struct lock_
 		if (class->subclass)
 			printk("/%d", class->subclass);
 	}
-	printk("){%c%c%c%c%c%c}", c1, c2, c3, c4, c5, c6);
+	printk("){%s}", usage);
 }
 
 static void print_lockdep_cache(struct lockdep_map *lock)
Index: linux-2.6/kernel/lockdep_internals.h
===================================================================
--- linux-2.6.orig/kernel/lockdep_internals.h
+++ linux-2.6/kernel/lockdep_internals.h
@@ -70,9 +70,10 @@ enum {
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
 
-extern void
-get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3,
-					char *c4, char *c5, char *c6);
+#define LOCK_USAGE_CHARS (1+LOCK_USAGE_STATES/2)
+
+extern void get_usage_chars(struct lock_class *class,
+			    char usage[LOCK_USAGE_CHARS]);
 
 extern const char * __get_key_name(struct lockdep_subclass_key *key, char *str);
 
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -84,7 +84,7 @@ static int l_show(struct seq_file *m, vo
 {
 	struct lock_class *class = v;
 	struct lock_list *entry;
-	char c1, c2, c3, c4, c5, c6;
+	char usage[LOCK_USAGE_CHARS];
 
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(m, "all lock classes:\n");
@@ -100,8 +100,8 @@ static int l_show(struct seq_file *m, vo
 	seq_printf(m, " BD:%5ld", lockdep_count_backward_deps(class));
 #endif
 
-	get_usage_chars(class, &c1, &c2, &c3, &c4, &c5, &c6);
-	seq_printf(m, " %c%c%c%c%c%c", c1, c2, c3, c4, c5, c6);
+	get_usage_chars(class, usage);
+	seq_printf(m, " %s", usage);
 
 	seq_printf(m, ": ");
 	print_name(m, class);

-- 

