Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbXFLNHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbXFLNHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbXFLNH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:07:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54301 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbXFLNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:07:25 -0400
Message-Id: <20070612121916.533503225@chello.nl>
References: <20070612121351.448814658@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 12 Jun 2007 14:13:52 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/4] lockdep: variuos fixes
Content-Disposition: inline; filename=lockdep_fixups.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - update the copyright notices
 - use the default hash function
 - fix a thinko in a BUILD_BUG_ON
 - add a WARN_ON to spot inconsitent naming
 - fix a termination issue in /proc/lock_stat

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |    3 ++-
 kernel/lockdep.c        |   20 +++++++++++---------
 kernel/lockdep_proc.c   |    6 +++++-
 3 files changed, 18 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -5,7 +5,8 @@
  *
  * Started by Ingo Molnar:
  *
- *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
  * this code maps all the lock dependencies as they occur in a live kernel
  * and will warn about the following classes of locking bugs:
@@ -37,6 +38,7 @@
 #include <linux/debug_locks.h>
 #include <linux/irqflags.h>
 #include <linux/utsname.h>
+#include <linux/hash.h>
 
 #include <asm/sections.h>
 
@@ -238,8 +240,7 @@ LIST_HEAD(all_lock_classes);
  */
 #define CLASSHASH_BITS		(MAX_LOCKDEP_KEYS_BITS - 1)
 #define CLASSHASH_SIZE		(1UL << CLASSHASH_BITS)
-#define CLASSHASH_MASK		(CLASSHASH_SIZE - 1)
-#define __classhashfn(key)	((((unsigned long)key >> CLASSHASH_BITS) + (unsigned long)key) & CLASSHASH_MASK)
+#define __classhashfn(key)	hash_long((unsigned long)key, CLASSHASH_BITS)
 #define classhashentry(key)	(classhash_table + __classhashfn((key)))
 
 static struct list_head classhash_table[CLASSHASH_SIZE];
@@ -250,9 +251,7 @@ static struct list_head classhash_table[
  */
 #define CHAINHASH_BITS		(MAX_LOCKDEP_CHAINS_BITS-1)
 #define CHAINHASH_SIZE		(1UL << CHAINHASH_BITS)
-#define CHAINHASH_MASK		(CHAINHASH_SIZE - 1)
-#define __chainhashfn(chain) \
-		(((chain >> CHAINHASH_BITS) + chain) & CHAINHASH_MASK)
+#define __chainhashfn(chain)	hash_long(chain, CHAINHASH_BITS)
 #define chainhashentry(chain)	(chainhash_table + __chainhashfn((chain)))
 
 static struct list_head chainhash_table[CHAINHASH_SIZE];
@@ -680,7 +679,7 @@ look_up_lock_class(struct lockdep_map *l
 	 * (or spin_lock_init()) call - which acts as the key. For static
 	 * locks we use the lock object itself as the key.
 	 */
-	BUILD_BUG_ON(sizeof(struct lock_class_key) > sizeof(struct lock_class));
+	BUILD_BUG_ON(sizeof(struct lock_class_key) > sizeof(struct lockdep_map));
 
 	key = lock->key->subkeys + subclass;
 
@@ -690,9 +689,12 @@ look_up_lock_class(struct lockdep_map *l
 	 * We can walk the hash lockfree, because the hash only
 	 * grows, and we are careful when adding entries to the end:
 	 */
-	list_for_each_entry(class, hash_head, hash_entry)
-		if (class->key == key)
+	list_for_each_entry(class, hash_head, hash_entry) {
+		if (class->key == key) {
+			WARN_ON_ONCE(class->name != lock->name);
 			return class;
+		}
+	}
 
 	return NULL;
 }
Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -1,7 +1,8 @@
 /*
  * Runtime locking correctness validator
  *
- *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
  * see Documentation/lockdep-design.txt for more details.
  */
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -5,7 +5,8 @@
  *
  * Started by Ingo Molnar:
  *
- *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
  * Code for /proc/lockdep and /proc/lockdep_stats:
  *
@@ -498,6 +499,9 @@ static void *ls_start(struct seq_file *m
 	if (data->iter == data->stats)
 		seq_header(m);
 
+	if (data->iter == data->iter_end)
+		data->iter = NULL;
+
 	return data->iter;
 }
 

-- 

