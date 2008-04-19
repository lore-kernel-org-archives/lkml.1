Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYDSV6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYDSV6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYDSV63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:58:29 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:61899 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbYDSV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:58:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0FAAIICkhMROPA/2dsb2JhbACBYKhS
Date: Sat, 19 Apr 2008 17:58:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Check for breakpoint in text_poke to eliminate bug_on
Message-ID: <20080419215826.GC2831@Krystal>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi> <20080413230552.33ca587a@daedalus.pq.iki.fi> <20080414065713.GB16163@elte.hu> <20080419184137.79957a07@daedalus.pq.iki.fi> <20080419161956.GA24685@Krystal> <20080420000657.20ba6b4b@daedalus.pq.iki.fi> <20080420005208.12ad32fd@daedalus.pq.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080420005208.12ad32fd@daedalus.pq.iki.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:55:13 up 50 days, 18:06,  4 users,  load average: 0.74, 0.40,
	0.32
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Paalanen (pq@iki.fi) wrote:
> On Sun, 20 Apr 2008 00:06:57 +0300
> Pekka Paalanen <pq@iki.fi> wrote:
> 
> > Mathieu,
> > 
> > thank you for the quick reply. Your patch did not apply on sched-devel/latest
> > so I made the changes by hand, resulting patch here. The change was in the
> > context lines, which made `patch' fail, e.g. __FUNCTION__ -> __func__.
> > Now my enter_uniprocessor(), that disables all but the first cpu, works fine.
> > 
> > My next quest is, why attempting to re-enable the cpus makes the whole
> > machine reboot after a short hang.
> 
> Uhh, I don't have the faintest idea why this happens or how to debug it.
> 
> A simple
> echo 0 > /sys/devices/system/cpu/cpu1/online
> echo 1 > /sys/devices/system/cpu/cpu1/online
> 
> produces the following kernel log (netconsole) and then after a couple
> second hang the machine reboots:
> 
> [   84.678357] console [netcon0] enabled
> [   84.679568] netconsole: network logging started
> [  232.812335] CPU 1 is now offline
> [  232.812678] lockdep: fixing up alternatives.
> [  232.813051] SMP alternatives: switching to UP code
> [  268.447582] lockdep: fixing up alternatives.
> [  268.447903] SMP alternatives: switching to SMP code
> [  268.459462] Booting processor 1/1 ip 6000
> 
> My kernel is sched-devel/latest git tree with Desnoyers' patch, and my
> patches that touch only arch/x86/mm/mmio-mod.c.
> The machine is Thinkpad T61 with:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
> stepping	: 10
> cpu MHz		: 2001.000
> cache size	: 4096 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est
> tm2 ssse3 cx16 xtpr lahf_lm ida
> bogomips	: 3997.03
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> processor	: 1
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
> stepping	: 10
> cpu MHz		: 2001.000
> cache size	: 4096 KB
> physical id	: 0
> siblings	: 2
> core id		: 1
> cpu cores	: 2
> apicid		: 1
> initial apicid	: 1
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est
> tm2 ssse3 cx16 xtpr lahf_lm ida
> bogomips	: 3991.26
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> Any help would be appreciated.
> 
> 
> Thanks.

This patch should bring more consistency checks to text_poke, can you
give it a try ?

Hm, actually, I think it contains the fix you are looking for.

kernel_text_address -> core_kernel_text will probably make everything go
smoothly.

Mathieu


Check for breakpoint in text_poke to eliminate bug_on

It's ok to modify an instruction non-atomically (multiple memory accesses to a
large and/or non aligned instruction) *if and only if* we have inserted a
breakpoint at the beginning of the instruction.

Also change kernel_text_address (bogus) check to core_kernel_text.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/alternative.c |   49 ++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

Index: linux-2.6-sched-devel/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/alternative.c	2008-04-16 17:17:59.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/alternative.c	2008-04-16 17:19:53.000000000 -0400
@@ -15,6 +15,7 @@
 #include <asm/io.h>
 
 #define MAX_PATCH_LEN (255-1)
+#define BREAKPOINT_INSTRUCTION	0xcc
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
@@ -505,37 +506,45 @@ void *text_poke_early(void *addr, const 
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
  * page.
+ *
+ * It's ok to modify an instruction non-atomically (multiple memory accesses to
+ * a large and/or non aligned instruction) *if and only if* we have inserted a
+ * breakpoint at the beginning of the instruction and we are modifying the rest
+ * of the instruction.
  */
 void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
 	int nr_pages = 2;
+	struct page *pages[2];
+	int i;
 
-	BUG_ON(len > sizeof(long));
-	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
-		- ((long)addr & ~(sizeof(long) - 1)));
-	if (kernel_text_address((unsigned long)addr)) {
-		struct page *pages[2] = { virt_to_page(addr),
-			virt_to_page(addr + PAGE_SIZE) };
-		if (!pages[1])
-			nr_pages = 1;
-		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-		BUG_ON(!vaddr);
-		local_irq_save(flags);
-		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-		local_irq_restore(flags);
-		vunmap(vaddr);
+	if (*((uint8_t *)addr - 1) != BREAKPOINT_INSTRUCTION) {
+		BUG_ON(len > sizeof(long));
+		BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
+			- ((long)addr & ~(sizeof(long) - 1)));
+	}
+	if (!core_kernel_text((unsigned long)addr)) {
+		pages[0] = vmalloc_to_page(addr);
+		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
 	} else {
-		/*
-		 * modules are in vmalloc'ed memory, always writable.
-		 */
-		local_irq_save(flags);
-		memcpy(addr, opcode, len);
-		local_irq_restore(flags);
+		pages[0] = virt_to_page(addr);
+		pages[1] = virt_to_page(addr + PAGE_SIZE);
 	}
+	BUG_ON(!pages[0]);
+	if (!pages[1])
+		nr_pages = 1;
+	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	BUG_ON(!vaddr);
+	local_irq_save(flags);
+	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
+	local_irq_restore(flags);
+	vunmap(vaddr);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
+	for (i = 0; i < len; i++)
+		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
 	return addr;
 }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
