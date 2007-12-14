Return-Path: <linux-kernel-owner+w=401wt.eu-S1764236AbXLNBbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764236AbXLNBbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 20:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbXLNBbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 20:31:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbXLNBbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 20:31:13 -0500
Date: Thu, 13 Dec 2007 20:30:41 -0500
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>
Subject: Re: Print taint info in more places.
Message-ID: <20071214013041.GH22304@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>
References: <20071213224927.GA18639@redhat.com> <20071214000350.GK21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214000350.GK21616@stusta.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 01:03:50AM +0100, Adrian Bunk wrote:

 > >  #ifndef HAVE_ARCH_BUG
 > >  #define BUG() do { \
 > > -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
 > > +	printk(KERN_ERR "BUG: failure at %s:%d/%s()! (%s)\n",
 > > +		__FILE__, __LINE__, __FUNCTION__, print_tainted()); \
 > >  	panic("BUG!"); \
 > >  } while (0)
 > >  #endif
 > >...
 > 
 > Note that this only changes a handful of architectures and most likely 
 > not the ones you are interested in.

Hmm, it appears that I was mistaken, and we never did patch x86.
Which leaves me wondering if its worth it or not to  patch BUG()
Anyways, here's the latest rev with the out-of-line changes as
suggested by Andi.

init/main.c may not be the best place for the ool variant. suggestions?

	Dave


diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index d56fedb..e35833a 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
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
@@ -32,13 +37,11 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
+void out_of_line_warnon(char *file, unsigned int line, const char *func);
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
-			__LINE__, __FUNCTION__);			\
-		dump_stack();						\
-	}								\
+	if (unlikely(__ret_warn_on))					\
+		out_of_line_warnon(__FILE__, __LINE__, __FUNCTION__);	\
 	unlikely(__ret_warn_on);					\
 })
 #endif
diff --git a/init/main.c b/init/main.c
index 80b04b6..b1fad76 100644
--- a/init/main.c
+++ b/init/main.c
@@ -855,3 +855,11 @@ static int __init kernel_init(void * unused)
 	init_post();
 	return 0;
 }
+
+void out_of_line_warnon(char *file, unsigned int line, const char *func)
+{
+	printk(KERN_ERR "WARNING: at %s:%d %s() (%s)\n",
+		file, line, func, print_tainted());
+	dump_stack();
+}
+EXPORT_SYMBOL(out_of_line_warnon);
diff --git a/kernel/panic.c b/kernel/panic.c
index 6f6e03e..198fc58 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -173,6 +173,7 @@ const char *print_tainted(void)
 		snprintf(buf, sizeof(buf), "Not tainted");
 	return(buf);
 }
+EXPORT_SYMBOL(print_tainted);
 
 void add_taint(unsigned flag)
 {
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 9c4b025..b7a010a 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -58,9 +58,9 @@ static void spin_bug(spinlock_t *lock, const char *msg)
 
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
@@ -114,9 +114,9 @@ static void __spin_lock_debug(spinlock_t *lock)
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
@@ -159,9 +159,9 @@ static void rwlock_bug(rwlock_t *lock, const char *msg)
 	if (!debug_locks_off())
 		return;
 
-	printk(KERN_EMERG "BUG: rwlock %s on CPU#%d, %s/%d, %p\n",
+	printk(KERN_EMERG "BUG: rwlock %s on CPU#%d, %s/%d, %p (%s)\n",
 		msg, raw_smp_processor_id(), current->comm,
-		task_pid_nr(current), lock);
+		task_pid_nr(current), lock, print_tainted());
 	dump_stack();
 }
 
@@ -184,9 +184,9 @@ static void __read_lock_debug(rwlock_t *lock)
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
@@ -259,9 +259,9 @@ static void __write_lock_debug(rwlock_t *lock)
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b5a58d4..7a0c25d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -221,12 +221,12 @@ static inline int bad_range(struct zone *zone, struct page *page)
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
diff --git a/mm/slab.c b/mm/slab.c
index 2e338a5..e5627f9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1846,8 +1846,8 @@ static void check_poison_obj(struct kmem_cache *cachep, void *objp)
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
@@ -2935,8 +2935,8 @@ static void check_slabp(struct kmem_cache *cachep, struct slab *slabp)
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
diff --git a/mm/slub.c b/mm/slub.c
index 9c1d9f3..e11d58d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -451,7 +451,7 @@ static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 	va_end(args);
 	printk(KERN_ERR "========================================"
 			"=====================================\n");
-	printk(KERN_ERR "BUG %s: %s\n", s->name, buf);
+	printk(KERN_ERR "BUG %s (%s): %s\n", s->name, print_tainted(), buf);
 	printk(KERN_ERR "----------------------------------------"
 			"-------------------------------------\n\n");
 }
-- 
http://www.codemonkey.org.uk
