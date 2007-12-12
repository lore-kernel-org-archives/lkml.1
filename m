Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbXLLPjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbXLLPjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbXLLPiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:38:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757756AbXLLPiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:38:50 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 03/19] change gdt acessor macro name
Date: Wed, 12 Dec 2007 10:53:48 -0200
Message-Id: <11974640653022-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197464057242-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the name of x86_64 macro used to access the per-cpu
gdt. It is now equal to the i386 version, which will allow code to be shared.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/setup64.c     |    2 +-
 arch/x86/kernel/suspend_64.c  |    2 +-
 arch/x86/kernel/vsyscall_64.c |    2 +-
 include/asm-x86/desc_64.h     |   10 +++++-----
 4 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/setup64.c
+++ linux-2.6-x86/arch/x86/kernel/setup64.c
@@ -228,7 +228,7 @@ void __cpuinit cpu_init (void)
 	 * and set up the GDT descriptor:
 	 */
 	if (cpu)
- 		memcpy(cpu_gdt(cpu), cpu_gdt_table, GDT_SIZE);
+		memcpy(get_cpu_gdt_table(cpu), cpu_gdt_table, GDT_SIZE);
 
 	cpu_gdt_descr[cpu].size = GDT_SIZE;
 	load_gdt((const struct desc_ptr *)&cpu_gdt_descr[cpu]);
Index: linux-2.6-x86/arch/x86/kernel/suspend_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/suspend_64.c
+++ linux-2.6-x86/arch/x86/kernel/suspend_64.c
@@ -118,7 +118,7 @@ void fix_processor_context(void)
 
 	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
 
-	cpu_gdt(cpu)[GDT_ENTRY_TSS].type = 9;
+	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
 
 	syscall_init();                         /* This sets MSR_*STAR and related */
 	load_TR_desc();				/* This does ltr */
Index: linux-2.6-x86/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/vsyscall_64.c
+++ linux-2.6-x86/arch/x86/kernel/vsyscall_64.c
@@ -297,7 +297,7 @@ static void __cpuinit vsyscall_set_cpu(i
 	/* Store cpu number in limit so that it can be loaded quickly
 	   in user space in vgetcpu.
 	   12 bits for the CPU and 8 bits for the node. */
-	d = (unsigned long *)(cpu_gdt(cpu) + GDT_ENTRY_PER_CPU);
+	d = (unsigned long *)(get_cpu_gdt_table(cpu) + GDT_ENTRY_PER_CPU);
 	*d = 0x0f40000000000ULL;
 	*d |= cpu;
 	*d |= (node & 0xf) << 12;
Index: linux-2.6-x86/include/asm-x86/desc_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_64.h
+++ linux-2.6-x86/include/asm-x86/desc_64.h
@@ -48,7 +48,7 @@ static inline void write_ldt_entry(struc
 }
 
 /* the cpu gdt accessor */
-#define cpu_gdt(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
+#define get_cpu_gdt_table(x) ((struct desc_struct *)cpu_gdt_descr[x].address)
 
 static inline void load_gdt(const struct desc_ptr *ptr)
 {
@@ -141,15 +141,15 @@ static inline void set_tss_desc(unsigned
 	 * -1? seg base+limit should be pointing to the address of the
 	 * last valid byte
 	 */
-	set_tssldt_descriptor(&cpu_gdt(cpu)[GDT_ENTRY_TSS],
+	set_tssldt_descriptor(&get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS],
 		(unsigned long)addr, DESC_TSS,
 		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1);
 }
 
 static inline void set_ldt_desc(unsigned cpu, void *addr, int size)
 {
-	set_tssldt_descriptor(&cpu_gdt(cpu)[GDT_ENTRY_LDT], (unsigned long)addr,
-			      DESC_LDT, size * 8 - 1);
+	set_tssldt_descriptor(&get_cpu_gdt_table(cpu)[GDT_ENTRY_LDT],
+			     (unsigned long)addr, DESC_LDT, size * 8 - 1);
 }
 
 #define LDT_entry_a(info) \
@@ -183,7 +183,7 @@ static inline void set_ldt_desc(unsigned
 static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 {
 	unsigned int i;
-	u64 *gdt = (u64 *)(cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN);
+	u64 *gdt = (u64 *)(get_cpu_gdt_table(cpu) + GDT_ENTRY_TLS_MIN);
 
 	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
 		gdt[i] = t->tls_array[i];
