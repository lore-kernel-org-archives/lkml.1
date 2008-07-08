Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbYGHRC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbYGHRC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbYGHQ6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:58:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:38002 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbYGHQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:58:20 -0400
Date: Tue, 8 Jul 2008 09:53:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 14/17] Use WARN() in lib/
Message-ID: <20080708095343.1a9a0123@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use WARN instead of printk+WARN_ON in /lib 

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.
In addition, one of the if() clauses collapes into the WARN() entirely
now.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>---
 lib/debugobjects.c   |   15 +++++----------
 lib/iomap.c          |    3 +--
 lib/kobject_uevent.c |    6 ++----
 lib/plist.c          |   13 +++++++------
 4 files changed, 15 insertions(+), 22 deletions(-)

Index: linux.trees.git/lib/debugobjects.c
===================================================================
--- linux.trees.git.orig/lib/debugobjects.c
+++ linux.trees.git/lib/debugobjects.c
@@ -205,9 +205,8 @@ static void debug_print_object(struct de
 
 	if (limit < 5 && obj->descr != descr_test) {
 		limit++;
-		printk(KERN_ERR "ODEBUG: %s %s object type: %s\n", msg,
+		WARN(1, KERN_ERR "ODEBUG: %s %s object type: %s\n", msg,
 		       obj_states[obj->state], obj->descr->name);
-		WARN_ON(1);
 	}
 	debug_objects_warnings++;
 }
@@ -735,26 +734,22 @@ check_results(void *addr, enum debug_obj
 
 	obj = lookup_object(addr, db);
 	if (!obj && state != ODEBUG_STATE_NONE) {
-		printk(KERN_ERR "ODEBUG: selftest object not found\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "ODEBUG: selftest object not found\n");
 		goto out;
 	}
 	if (obj && obj->state != state) {
-		printk(KERN_ERR "ODEBUG: selftest wrong state: %d != %d\n",
+		WARN(1, KERN_ERR "ODEBUG: selftest wrong state: %d != %d\n",
 		       obj->state, state);
-		WARN_ON(1);
 		goto out;
 	}
 	if (fixups != debug_objects_fixups) {
-		printk(KERN_ERR "ODEBUG: selftest fixups failed %d != %d\n",
+		WARN(1, KERN_ERR "ODEBUG: selftest fixups failed %d != %d\n",
 		       fixups, debug_objects_fixups);
-		WARN_ON(1);
 		goto out;
 	}
 	if (warnings != debug_objects_warnings) {
-		printk(KERN_ERR "ODEBUG: selftest warnings failed %d != %d\n",
+		WARN(1, KERN_ERR "ODEBUG: selftest warnings failed %d != %d\n",
 		       warnings, debug_objects_warnings);
-		WARN_ON(1);
 		goto out;
 	}
 	res = 0;
Index: linux.trees.git/lib/iomap.c
===================================================================
--- linux.trees.git.orig/lib/iomap.c
+++ linux.trees.git/lib/iomap.c
@@ -40,8 +40,7 @@ static void bad_io_access(unsigned long 
 	static int count = 10;
 	if (count) {
 		count--;
-		printk(KERN_ERR "Bad IO access at port %#lx (%s)\n", port, access);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Bad IO access at port %#lx (%s)\n", port, access);
 	}
 }
 
Index: linux.trees.git/lib/kobject_uevent.c
===================================================================
--- linux.trees.git.orig/lib/kobject_uevent.c
+++ linux.trees.git/lib/kobject_uevent.c
@@ -285,8 +285,7 @@ int add_uevent_var(struct kobj_uevent_en
 	int len;
 
 	if (env->envp_idx >= ARRAY_SIZE(env->envp)) {
-		printk(KERN_ERR "add_uevent_var: too many keys\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "add_uevent_var: too many keys\n");
 		return -ENOMEM;
 	}
 
@@ -297,8 +296,7 @@ int add_uevent_var(struct kobj_uevent_en
 	va_end(args);
 
 	if (len >= (sizeof(env->buf) - env->buflen)) {
-		printk(KERN_ERR "add_uevent_var: buffer size too small\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "add_uevent_var: buffer size too small\n");
 		return -ENOMEM;
 	}
 
Index: linux.trees.git/lib/plist.c
===================================================================
--- linux.trees.git.orig/lib/plist.c
+++ linux.trees.git/lib/plist.c
@@ -31,12 +31,13 @@
 static void plist_check_prev_next(struct list_head *t, struct list_head *p,
 				  struct list_head *n)
 {
-	if (n->prev != p || p->next != n) {
-		printk("top: %p, n: %p, p: %p\n", t, t->next, t->prev);
-		printk("prev: %p, n: %p, p: %p\n", p, p->next, p->prev);
-		printk("next: %p, n: %p, p: %p\n", n, n->next, n->prev);
-		WARN_ON(1);
-	}
+	WARN(n->prev != p || p->next != n,
+			"top: %p, n: %p, p: %p\n"
+			"prev: %p, n: %p, p: %p\n"
+			"next: %p, n: %p, p: %p\n",
+			 t, t->next, t->prev,
+			p, p->next, p->prev,
+			n, n->next, n->prev);
 }
 
 static void plist_check_list(struct list_head *top)
