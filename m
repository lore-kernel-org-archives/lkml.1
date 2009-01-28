Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZA1OEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZA1OEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZA1N5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbZA1N5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:32 -0500
Message-Id: <20090128135459.332648902@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:12 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 20/21] lockdep: get_user_chars() redo
Content-Disposition: inline; filename=lockdep-get_usage_chars2.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic, states independent, get_user_chars().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/lockdep-design.txt |   30 +++++++++++++++++-------------
 kernel/lockdep.c                 |   26 +++++++++++++-------------
 kernel/lockdep_internals.h       |    7 ++++---
 kernel/lockdep_proc.c            |    6 +++---
 4 files changed, 37 insertions(+), 32 deletions(-)

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
Index: linux-2.6/Documentation/lockdep-design.txt
===================================================================
--- linux-2.6.orig/Documentation/lockdep-design.txt
+++ linux-2.6/Documentation/lockdep-design.txt
@@ -27,33 +27,37 @@ lock-class.
 State
 -----
 
-The validator tracks lock-class usage history into 5 separate state bits:
+The validator tracks lock-class usage history into 4n + 1 separate state bits:
 
-- 'ever held in hardirq context'                    [ == hardirq-safe   ]
-- 'ever held in softirq context'                    [ == softirq-safe   ]
-- 'ever held with hardirqs enabled'                 [ == hardirq-unsafe ]
-- 'ever held with softirqs and hardirqs enabled'    [ == softirq-unsafe ]
+- 'ever held in STATE context'
+- 'ever head as readlock in STATE context'
+- 'ever head with STATE enabled'
+- 'ever head as readlock with STATE enabled'
+
+Where STATE can be either one of (kernel/lockdep_states.h)
+ - hardirq
+ - softirq
+ - reclaim_fs
 
 - 'ever used'                                       [ == !unused        ]
 
-When locking rules are violated, these 4 state bits are presented in the
-locking error messages, inside curlies.  A contrived example:
+When locking rules are violated, these state bits are presented in the
+locking error messages, inside curlies. A contrived example:
 
    modprobe/2287 is trying to acquire lock:
-    (&sio_locks[i].lock){--..}, at: [<c02867fd>] mutex_lock+0x21/0x24
+    (&sio_locks[i].lock){-.-...}, at: [<c02867fd>] mutex_lock+0x21/0x24
 
    but task is already holding lock:
-    (&sio_locks[i].lock){--..}, at: [<c02867fd>] mutex_lock+0x21/0x24
+    (&sio_locks[i].lock){-.-...}, at: [<c02867fd>] mutex_lock+0x21/0x24
 
 
-The bit position indicates hardirq, softirq, hardirq-read,
-softirq-read respectively, and the character displayed in each
-indicates:
+The bit position indicates STATE, STATE-read, for each of the states listed
+above, and the character displayed in each indicates:
 
    '.'  acquired while irqs disabled
    '+'  acquired in irq context
    '-'  acquired with irqs enabled
-   '?' read acquired in irq context with irqs enabled.
+   '?'  acquired in irq context with irqs enabled.
 
 Unused mutexes cannot be part of the cause of an error.
 

-- 

