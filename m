Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYAAQ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYAAQ6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYAAQ5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:57:51 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:55051 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbYAAQ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:57:50 -0500
Message-ID: <477A7099.3010603@cosmosbay.com>
Date: Tue, 01 Jan 2008 17:55:53 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: [PATCH] X86 : Introduce DEFINE_PER_CPU_PAGE_ALIGNED() macro for x86
 arch to shrink percpu section
Content-Type: multipart/mixed;
 boundary="------------070104090300070509050009"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 01 Jan 2008 17:56:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070104090300070509050009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ingo

Here is a patch against linux-2.6-x86 git

Thank you

[PATCH] X86 : Introduce DEFINE_PER_CPU_PAGE_ALIGNED() macro for x86 arch to 
shrink percpu section

While examining holes in percpu section I found this :

c0659008 D per_cpu__cpu_number
c065900c D per_cpu__irq_regs
<BIG HOLE of about 4000 bytes>
c065a000 D per_cpu__gdt_page
c065b000 d per_cpu__next_check

This is because gdt_page is a percpu variable, defined with
a page alignement, and linker is doing its job.

I introduced a new macro DEFINE_PER_CPU_PAGE_ALIGNED() to avoid
wasting this space. All page aligned variables are put in a separate
subsection .data.percpu.page_aligned

This macro is defined for x86/generic architectures only
but could be added to other arches if needed.

Before patch :

# size -A vmlinux | grep percpu
.data.percpu                26144   3227328512

After patch :

# size -A vmlinux | grep percpu
.data.percpu                22048   3227328512


Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

  arch/x86/kernel/cpu/common.c      |    2 +-
  arch/x86/kernel/vmlinux_32.lds.S  |    1 +
  include/asm-generic/percpu.h      |    4 ++++
  include/asm-generic/vmlinux.lds.h |    1 +
  include/asm-x86/percpu_32.h       |    4 ++++
  include/asm-x86/percpu_64.h       |    4 ++++
  6 files changed, 15 insertions(+), 1 deletion(-)


--------------070104090300070509050009
Content-Type: text/plain;
 name="percpu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="percpu.patch"

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2fcf20..a262d4c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -21,7 +21,7 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
 	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { 0x0000ffff, 0x00cffa00 },
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 7d72cce..b579e8b 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -182,6 +182,7 @@ SECTIONS
   . = ALIGN(4096);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
+	*(.data.percpu.page_aligned)
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index d85172e..6c89cda 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -14,6 +14,10 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name) \
+    __attribute__((__section__(".data.percpu.page_aligned"))) \
+    __typeof__(type) per_cpu__##name
+
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
     __attribute__((__section__(".data.percpu.shared_aligned"))) \
     __typeof__(type) per_cpu__##name				\
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9f584cc..68aaf68 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -259,6 +259,7 @@
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
diff --git a/include/asm-x86/percpu_32.h b/include/asm-x86/percpu_32.h
index a7ebd43..a515897 100644
--- a/include/asm-x86/percpu_32.h
+++ b/include/asm-x86/percpu_32.h
@@ -54,6 +54,10 @@ extern unsigned long __per_cpu_offset[];
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name) \
+    __attribute__((__section__(".data.percpu.page_aligned"))) \
+    __typeof__(type) per_cpu__##name
+
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
     __attribute__((__section__(".data.percpu.shared_aligned"))) \
     __typeof__(type) per_cpu__##name				\
diff --git a/include/asm-x86/percpu_64.h b/include/asm-x86/percpu_64.h
index 5abd482..9949008 100644
--- a/include/asm-x86/percpu_64.h
+++ b/include/asm-x86/percpu_64.h
@@ -20,6 +20,10 @@
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name) \
+    __attribute__((__section__(".data.percpu.page_aligned"))) \
+	__typeof__(type) per_cpu__##name
+
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
     __attribute__((__section__(".data.percpu.shared_aligned"))) \
     __typeof__(type) per_cpu__##name				\

--------------070104090300070509050009--
