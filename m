Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0CIJMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:12:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:35101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab0CIJM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:12:27 -0500
Message-ID: <4B9610E5.4080805@kernel.org>
Date: Tue, 09 Mar 2010 18:12:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] percpu,lockdep: implement and use is_static_percpu_address()
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>            <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost> <4B95EE4C.3020606@kernel.org>
In-Reply-To: <4B95EE4C.3020606@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 09:12:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep has custom code to check whether a pointer belongs to static
percpu area which is somewhat broken.  Implement proper
is_static_percpu_address() in percpu and replace the custom code.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
This wasn't the cause this time but I'll queue the fix in percpu tree
anyway.

Thanks.

 include/linux/percpu.h |    7 +++++++
 kernel/lockdep.c       |   15 ++-------------
 mm/percpu.c            |   26 ++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a93e5bf..1eca064 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -137,6 +137,7 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
 extern void __percpu *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void __percpu *__pdata);
+extern bool is_static_percpu_address(unsigned long addr);
 extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
@@ -163,6 +164,12 @@ static inline void free_percpu(void __percpu *p)
 	kfree(p);
 }
 
+/* can't distinguish from other static vars, always false */
+static inline bool is_static_percpu_address(unsigned long addr)
+{
+	return false;
+}
+
 static inline phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
 	return __pa(addr);
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0c30d04..4206f6f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -582,9 +582,6 @@ static int static_obj(void *obj)
 	unsigned long start = (unsigned long) &_stext,
 		      end   = (unsigned long) &_end,
 		      addr  = (unsigned long) obj;
-#ifdef CONFIG_SMP
-	int i;
-#endif
 
 	/*
 	 * static variable?
@@ -595,19 +592,11 @@ static int static_obj(void *obj)
 	if (arch_is_kernel_data(addr))
 		return 1;
 
-#ifdef CONFIG_SMP
 	/*
 	 * percpu var?
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
+	if (is_static_percpu_address(addr))
+		return 1;
 
 	/*
 	 * module var?
diff --git a/mm/percpu.c b/mm/percpu.c
index 768419d..ae4d058 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1304,6 +1304,32 @@ void free_percpu(void __percpu *ptr)
 EXPORT_SYMBOL_GPL(free_percpu);
 
 /**
+ * is_static_percpu_address - test whether address is from static percpu area
+ * @addr: address to test
+ *
+ * Test whether @addr belongs to static percpu area.  Module static
+ * percpu areas allocated via __alloc_reserved_percpu() is not
+ * considered.  Use is_module_address() for those.
+ *
+ * RETURNS:
+ * %true if @addr is from static percpu area, %false otherwise.
+ */
+bool is_static_percpu_address(unsigned long addr)
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
-- 
1.6.4.2

