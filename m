Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab0CJJ7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:59:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:47617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab0CJJ7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:59:11 -0500
Message-ID: <4B976D22.1070404@kernel.org>
Date: Wed, 10 Mar 2010 18:57:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] percpu,module: implement and use is_kernel/module_percpu_address()
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>	 <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost>	 <4B95EE4C.3020606@kernel.org>  <4B9610E5.4080805@kernel.org> <1268133942.4162.2.camel@twins> <4B963441.40000@kernel.org> <4B976CBA.3070305@kernel.org>
In-Reply-To: <4B976CBA.3070305@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 09:57:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep has custom code to check whether a pointer belongs to static
percpu area which is somewhat broken.  Implement proper
is_kernel/module_percpu_address() and replace the custom code.

On UP, percpu variables are regular static variables and can't be
distinguished from them.  Always return %false on UP.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
I went for is_kernel/module_percpu_address() so that the tests are
orthogonal.  Tested on SMP and UP.  If no one objects, I'll put this
into percpu#for-linus for a while and push it to Linus.

Thanks.

 include/linux/module.h |    1 +
 include/linux/percpu.h |    7 +++++++
 kernel/lockdep.c       |   21 +++++----------------
 kernel/module.c        |   38 ++++++++++++++++++++++++++++++++++++++
 mm/percpu.c            |   26 ++++++++++++++++++++++++++
 5 files changed, 77 insertions(+), 16 deletions(-)

Index: work/include/linux/module.h
===================================================================
--- work.orig/include/linux/module.h
+++ work/include/linux/module.h
@@ -394,6 +394,7 @@ static inline int module_is_live(struct
 struct module *__module_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
+bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
 
 static inline int within_module_core(unsigned long addr, struct module *mod)
Index: work/include/linux/percpu.h
===================================================================
--- work.orig/include/linux/percpu.h
+++ work/include/linux/percpu.h
@@ -137,6 +137,7 @@ extern int __init pcpu_page_first_chunk(
 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
 extern void __percpu *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void __percpu *__pdata);
+extern bool is_kernel_percpu_address(unsigned long addr);
 extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
@@ -163,6 +164,12 @@ static inline void free_percpu(void __pe
 	kfree(p);
 }
 
+/* can't distinguish from other static vars, always false */
+static inline bool is_kernel_percpu_address(unsigned long addr)
+{
+	return false;
+}
+
 static inline phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
 	return __pa(addr);
Index: work/kernel/lockdep.c
===================================================================
--- work.orig/kernel/lockdep.c
+++ work/kernel/lockdep.c
@@ -582,9 +582,6 @@ static int static_obj(void *obj)
 	unsigned long start = (unsigned long) &_stext,
 		      end   = (unsigned long) &_end,
 		      addr  = (unsigned long) obj;
-#ifdef CONFIG_SMP
-	int i;
-#endif
 
 	/*
 	 * static variable?
@@ -595,24 +592,16 @@ static int static_obj(void *obj)
 	if (arch_is_kernel_data(addr))
 		return 1;
 
-#ifdef CONFIG_SMP
 	/*
-	 * percpu var?
+	 * in-kernel percpu var?
 	 */
-	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
-					+ per_cpu_offset(i);
-
-		if ((addr >= start) && (addr < end))
-			return 1;
-	}
-#endif
+	if (is_kernel_percpu_address(addr))
+		return 1;
 
 	/*
-	 * module var?
+	 * module static or percpu var?
 	 */
-	return is_module_address(addr);
+	return is_module_address(addr) || is_module_percpu_address(addr);
 }
 
 /*
Index: work/kernel/module.c
===================================================================
--- work.orig/kernel/module.c
+++ work/kernel/module.c
@@ -415,6 +415,40 @@ static void percpu_modcopy(struct module
 		memcpy(per_cpu_ptr(mod->percpu, cpu), from, size);
 }
 
+/**
+ * is_module_percpu_address - test whether address is from module static percpu
+ * @addr: address to test
+ *
+ * Test whether @addr belongs to module static percpu area.
+ *
+ * RETURNS:
+ * %true if @addr is from module static percpu area
+ */
+bool is_module_percpu_address(unsigned long addr)
+{
+	struct module *mod;
+	unsigned int cpu;
+
+	preempt_disable();
+
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if (!mod->percpu_size)
+			continue;
+		for_each_possible_cpu(cpu) {
+			void *start = per_cpu_ptr(mod->percpu, cpu);
+
+			if ((void *)addr >= start &&
+			    (void *)addr < start + mod->percpu_size) {
+				preempt_enable();
+				return true;
+			}
+		}
+	}
+
+	preempt_enable();
+	return false;
+}
+
 #else /* ... !CONFIG_SMP */
 
 static inline void __percpu *mod_percpu(struct module *mod)
@@ -441,6 +475,10 @@ static inline void percpu_modcopy(struct
 	/* pcpusec should be 0, and size of that section should be 0. */
 	BUG_ON(size != 0);
 }
+bool is_module_percpu_address(unsigned long addr)
+{
+	return false;
+}
 
 #endif /* CONFIG_SMP */
 
Index: work/mm/percpu.c
===================================================================
--- work.orig/mm/percpu.c
+++ work/mm/percpu.c
@@ -1304,6 +1304,32 @@ void free_percpu(void __percpu *ptr)
 EXPORT_SYMBOL_GPL(free_percpu);
 
 /**
+ * is_kernel_percpu_address - test whether address is from static percpu area
+ * @addr: address to test
+ *
+ * Test whether @addr belongs to in-kernel static percpu area.  Module
+ * static percpu areas are not considered.  For those, use
+ * is_module_percpu_address().
+ *
+ * RETURNS:
+ * %true if @addr is from in-kernel static percpu area, %false otherwise.
+ */
+bool is_kernel_percpu_address(unsigned long addr)
+{
+	const size_t static_size = __per_cpu_end - __per_cpu_start;
+	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu) {
+		void *start = per_cpu_ptr(base, cpu);
+
+		if ((void *)addr >= start && (void *)addr < start + static_size)
+			return true;
+        }
+	return false;
+}
+
+/**
  * per_cpu_ptr_to_phys - convert translated percpu address to physical address
  * @addr: the address to be converted to physical address
  *
