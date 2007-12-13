Return-Path: <linux-kernel-owner+w=401wt.eu-S934363AbXLMWtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363AbXLMWtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761990AbXLMWta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:49:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbXLMWt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:49:29 -0500
Date: Thu, 13 Dec 2007 17:49:27 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Print taint info in more places.
Message-ID: <20071213224927.GA18639@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've found in the past that various bug reports have had minimal
information, just a few printk's rather than a complete oops,
and it's taken several round-trips with the bug reporter before
we've discovered they had some proprietary module loaded.

The patches below adds dumping of the tainted state to some
extra parts of the kernel that report 'bad things' happening.
These patches have been in the Fedora kernel for some time now,
and have proved useful often.

Signed-off-by: Dave Jones <davej@redhat.com>


--- linux-2.6/include/asm-generic/bug.h~	2007-02-12 16:18:21.000000000 -0500
+++ linux-2.6/include/asm-generic/bug.h	2007-02-12 16:19:57.000000000 -0500
@@ -3,6 +3,10 @@
 
 #include <linux/compiler.h>
 
+#ifndef __ASSEMBLY__
+extern const char *print_tainted(void);
+#endif
+
 #ifdef CONFIG_BUG
 
 #ifdef CONFIG_GENERIC_BUG
@@ -22,7 +26,8 @@ struct bug_entry {
 
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
-	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
+	printk(KERN_ERR "BUG: failure at %s:%d/%s()! (%s)\n",
+		__FILE__, __LINE__, __FUNCTION__, print_tainted()); \
 	panic("BUG!"); \
 } while (0)
 #endif
@@ -39,8 +39,9 @@ struct bug_entry {
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
 	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
-			__LINE__, __FUNCTION__);			\
+		printk(KERN_ERR "WARNING: at %s:%d %s() (%s)\n",	\
+			 __FILE__, __LINE__, __FUNCTION__,		\
+			 print_tainted());				\
 		dump_stack();						\
 	}								\
 	unlikely(__ret_warn_on);					\
diff -urNp --exclude-from=/home/davej/.exclude linux-1740/kernel/panic.c linux-2000/kernel/panic.c
--- linux-1740/kernel/panic.c
+++ linux-2000/kernel/panic.c
@@ -151,6 +151,7 @@ const char *print_tainted(void)
 		snprintf(buf, sizeof(buf), "Not tainted");
 	return(buf);
 }
+EXPORT_SYMBOL(print_tainted);
 
 void add_taint(unsigned flag)
 {
--- linux-2.6/mm/page_alloc.c~	2006-01-07 20:48:33.000000000 -0500
+++ linux-2.6/mm/page_alloc.c	2006-01-07 20:49:24.000000000 -0500
@@ -137,12 +137,12 @@ static inline int bad_range(struct zone 
 static void bad_page(struct page *page)
 {
 	printk(KERN_EMERG "Bad page state in process '%s'\n"
-		KERN_EMERG "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n"
+		KERN_EMERG "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d (%s)\n"
 		KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
 		KERN_EMERG "Backtrace:\n",
 		current->comm, page, (int)(2*sizeof(unsigned long)),
 		(unsigned long)page->flags, page->mapping,
-		page_mapcount(page), page_count(page));
+		page_mapcount(page), page_count(page), print_tainted());
 	dump_stack();
 	page->flags &= ~(1 << PG_lru	|
 			1 << PG_private |
--- linux-2.6/mm/slab.c~	2007-05-27 22:57:44.000000000 -0400
+++ linux-2.6/mm/slab.c	2007-05-27 22:58:08.000000000 -0400
@@ -1816,8 +1816,8 @@ static void check_poison_obj(struct kmem
 			/* Print header */
 			if (lines == 0) {
 				printk(KERN_ERR
-					"Slab corruption: %s start=%p, len=%d\n",
-					cachep->name, realobj, size);
+					"Slab corruption (%s): %s start=%p, len=%d\n",
+					print_tainted(), cachep->name, realobj, size);
 				print_objinfo(cachep, objp, 0);
 			}
 			/* Hexdump the affected line */
@@ -2924,8 +2924,8 @@ static void check_slabp(struct kmem_cach
 	if (entries != cachep->num - slabp->inuse) {
 bad:
 		printk(KERN_ERR "slab: Internal list corruption detected in "
-				"cache '%s'(%d), slabp %p(%d). Hexdump:\n",
-			cachep->name, cachep->num, slabp, slabp->inuse);
+				"cache '%s'(%d), slabp %p(%d). Tainted(%s). Hexdump:\n",
+			cachep->name, cachep->num, slabp, slabp->inuse, print_tainted());
 		for (i = 0;
 		     i < sizeof(*slabp) + cachep->num * sizeof(kmem_bufctl_t);
 		     i++) {
--- linux-2.6/mm/slub.c~	2007-07-20 14:15:05.000000000 -0400
+++ linux-2.6/mm/slub.c	2007-07-20 14:17:37.000000000 -0400
@@ -450,7 +450,7 @@ static void slab_bug(struct kmem_cache *
 	va_end(args);
 	printk(KERN_ERR "========================================"
 			"=====================================\n");
-	printk(KERN_ERR "BUG %s: %s\n", s->name, buf);
+	printk(KERN_ERR "BUG %s (%s): %s\n", s->name, print_tainted(), buf);
 	printk(KERN_ERR "----------------------------------------"
 			"-------------------------------------\n\n");
 }
--- linux-2.6/lib/spinlock_debug.c~	2007-10-22 01:15:04.000000000 -0400
+++ linux-2.6/lib/spinlock_debug.c	2007-10-22 01:17:03.000000000 -0400
@@ -58,9 +58,9 @@ static void spin_bug(spinlock_t *lock, c
 
 	if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT)
 		owner = lock->owner;
-	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
+	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d (%s)\n",
 		msg, raw_smp_processor_id(),
-		current->comm, task_pid_nr(current));
+		current->comm, task_pid_nr(current), print_tainted());
 	printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
 		lock, lock->magic,
@@ -114,9 +114,9 @@ static void __spin_lock_debug(spinlock_t
 		if (print_once) {
 			print_once = 0;
 			printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
-					"%s/%d, %p\n",
+					"%s/%d, %p (%s)\n",
 				raw_smp_processor_id(), current->comm,
-				task_pid_nr(current), lock);
+				task_pid_nr(current), lock, print_tainted());
 			dump_stack();
 #ifdef CONFIG_SMP
 			trigger_all_cpu_backtrace();
@@ -159,9 +159,9 @@ static void rwlock_bug(rwlock_t *lock, c
 	if (!debug_locks_off())
 		return;
 
-	printk(KERN_EMERG "BUG: rwlock %s on CPU#%d, %s/%d, %p\n",
+	printk(KERN_EMERG "BUG: rwlock %s on CPU#%d, %s/%d, %p (%s)\n",
 		msg, raw_smp_processor_id(), current->comm,
-		task_pid_nr(current), lock);
+		task_pid_nr(current), lock, print_tainted());
 	dump_stack();
 }
 
@@ -177,9 +177,9 @@ static void __read_lock_debug(rwlock_t *
 		if (print_once) {
 			print_once = 0;
 			printk(KERN_EMERG "BUG: read-lock lockup on CPU#%d, "
-					"%s/%d, %p\n",
+					"%s/%d, %p (%s)\n",
 				raw_smp_processor_id(), current->comm,
-				current->pid, lock);
+				current->pid, lock, print_tainted());
 			dump_stack();
 		}
 	}
@@ -250,9 +250,9 @@ static void __write_lock_debug(rwlock_t 
 		if (print_once) {
 			print_once = 0;
 			printk(KERN_EMERG "BUG: write-lock lockup on CPU#%d, "
-					"%s/%d, %p\n",
+					"%s/%d, %p (%s)\n",
 				raw_smp_processor_id(), current->comm,
-				current->pid, lock);
+				current->pid, lock, print_tainted());
 			dump_stack();
 		}
 	}
-- 
http://www.codemonkey.org.uk
