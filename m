Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYEOHhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYEOHhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYEOHh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:37:28 -0400
Received: from smtp25.orange.fr ([193.252.22.22]:4511 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbYEOHh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:37:27 -0400
X-ME-UUID: 20080515073725920.166FA1C00085@mwinf2517.orange.fr
Message-ID: <482BE82C.4010004@cosmosbay.com>
Date: Thu, 15 May 2008 09:37:16 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] percpu: Introduce DEFINE_PER_CPU_PAGE_ALIGNED()
Content-Type: multipart/mixed;
 boundary="------------040206030809000502010508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040206030809000502010508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While examining  percpu section on i386 I found we were wasting about 
8000 bytes
because of two large holes :

c05dd000 D __per_cpu_start
c05dd000 D per_cpu__current_task
c05dd004 D per_cpu__cpu_number
c05dd008 D per_cpu__irq_regs
c05dd00c D per_cpu__x86_cpu_to_apicid
c05dd010 d per_cpu__cpu_devices
c05dd044 D per_cpu__cyc2ns
*HOLE* of 4Kbytes
c05de000 d per_cpu__cpuid4_info
c05de004 d per_cpu__cache_kobject
c05de008 d per_cpu__index_kobject
*HOLE* of 4Kbytes
c05df000 D per_cpu__gdt_page
c05e0000 d per_cpu__next_check
c05e0008 d per_cpu__thermal_throttle_count

This is because gdt_page is a percpu variable, defined with a page 
alignement,
and linker is doing its job, two times because of .o nesting in the 
build process,
mixing variables with quite different alignment requirements.

I introduced a new macro DEFINE_PER_CPU_PAGE_ALIGNED() to avoid
wasting this space. All page aligned variables (only one at this time) 
are put in
a separate subsection .data.percpu.page_aligned.

# size -A vmlinux.old vmlinux | grep percpu
.data.percpu                22272   3227373568
.data.percpu                30336   3227373568

Thats 8064 bytes saved for each CPU (plus one for the .data.percpu 
storage itself)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------040206030809000502010508
Content-Type: text/plain;
 name="percpu_page_aligned.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="percpu_page_aligned.patch"

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d0463a9..b2f54fa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -21,7 +21,7 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index ce5ed08..0f7c29a 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -189,6 +189,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
+	*(.data.percpu.page_aligned)
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..69e5c11 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -348,6 +348,7 @@
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 4cdd393..b4d7fdb 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -15,19 +15,28 @@
 
 #ifdef MODULE
 #define SHARED_ALIGNED_SECTION ".data.percpu"
+#define PAGE_ALIGNED_SECTION   ".data.percpu"
 #else
 #define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
+#define PAGE_ALIGNED_SECTION   ".data.percpu.page_aligned"
 #endif
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
 	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
+	__attribute__((__section__(PAGE_ALIGNED_SECTION)))		\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 #else
 #define DEFINE_PER_CPU(type, name)					\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DEFINE_PER_CPU(type, name)
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
 	DEFINE_PER_CPU(type, name)
 #endif
 

--------------040206030809000502010508--


