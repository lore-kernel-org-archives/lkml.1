Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbYGAWdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbYGAWdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYGAWde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:33:34 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:8662 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYGAWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=JGompEekO2oHF47xYdzn/Qc+QITpyb1VmuCKvcmyftg+8yCBHLYyFAUVP9WGKGTtVd
         N4arsN2uq0oMv2w8RBA7NB9v9EJEXwCTkQHyb12KqgTpoOSAZdPhfy+ezkxVbTIoerlR
         9/GKQRTJ7HUx8eCwwVSo1lwXfFu8z/WkxQlgU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/23] make section names compatible with -ffunction-sections -fdata-sections
Date: Wed, 2 Jul 2008 02:33:48 +0200
User-Agent: KMail/1.8.2
Cc: Russell King <rmk@arm.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200807020233.48646.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, folks,

I am unsure how to synchronize propagation of these patches
across all architectures.

Andrew, how this can be done without causing lots of pain
for arch maintainers? Please advise.

The purpose of these patches is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".

Newer gcc and binutils can do dead code and data removal
at link time. It is achieved using combination of
-ffunction-sections -fdata-sections options for gcc and
--gc-sections for ld.

Theory of operation:

-ffunction-sections instructs gcc to place each function
(including static ones) in it's own section named .text.function_name
instead of placing all functions in one big .text section.

At link time, ld normally coalesce all such sections into one
output section .text again. It is achieved by having *(.text.*) spec
along with *(.text) spec in built-in linker scripts.

If ld is invoked with --gc-sections, it tracks references, starting
from entry point and marks all input sections which are reachable
from there. Then it discards all input sections which are not marked.

This isn't buying much if you have one big .text section per .o module,
because even one referenced function will pull in entire section.
You need -ffunction-sections in order to split .text into per-function
sections and make --gc-sections much more useful.

-fdata-sections is analogous: it places each global or static variable
into .data.variable_name, .rodata.variable_name or .bss.variable_name.

If we ever want to use described mechanism, we need to adapt
existing code for new section names. Basically, we need to stop using
section names of the form
.text.xxxx
.data.xxxx
.rodata.xxxx
.bss.xxxx
in the kernel - otherwise section placement done by kernel's
custom linker scripts produces broken vmlinux and vdso images.

The following patches fix section names, one per architecture.

The patch in _this_ mail fixes generic part.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/Documentation/mutex-design.txt	Wed Jul  2 00:40:39 2008
+++ 1.fixname/Documentation/mutex-design.txt	Wed Jul  2 00:44:40 2008
@@ -66,14 +66,14 @@
 
     c0377ccb <mutex_lock>:
     c0377ccb:       f0 ff 08                lock decl (%eax)
-    c0377cce:       78 0e                   js     c0377cde <.text.lock.mutex>
+    c0377cce:       78 0e                   js     c0377cde <.lock.mutex.text>
     c0377cd0:       c3                      ret
 
    the unlocking fastpath is equally tight:
 
     c0377cd1 <mutex_unlock>:
     c0377cd1:       f0 ff 00                lock incl (%eax)
-    c0377cd4:       7e 0f                   jle    c0377ce5 <.text.lock.mutex+0x7>
+    c0377cd4:       7e 0f                   jle    c0377ce5 <.lock.mutex.text+0x7>
     c0377cd6:       c3                      ret
 
  - 'struct mutex' semantics are well-defined and are enforced if
--- 0.org/include/asm-generic/vmlinux.lds.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-generic/vmlinux.lds.h	Wed Jul  2 00:54:09 2008
@@ -41,7 +41,7 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
-	*(.data.init.refok)						\
+	*(.init.refok.data)						\
 	*(.ref.data)							\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
@@ -206,8 +206,8 @@
 		ALIGN_FUNCTION();					\
 		*(.text)						\
 		*(.ref.text)						\
-		*(.text.init.refok)					\
-		*(.exit.text.refok)					\
+		*(.init.refok.text)					\
+		*(.exit.refok.text)					\
 	DEV_KEEP(init.text)						\
 	DEV_KEEP(exit.text)						\
 	CPU_KEEP(init.text)						\
@@ -347,8 +347,8 @@
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
-	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
-		*(.data.percpu)						\
-		*(.data.percpu.shared_aligned)				\
+	.percpu.data  : AT(ADDR(.percpu.data) - LOAD_OFFSET) {		\
+		*(.percpu.data)						\
+		*(.percpu.shared_aligned.data)				\
 	}								\
 	__per_cpu_end = .;
--- 0.org/include/linux/cache.h	Wed Jul  2 00:40:51 2008
+++ 1.fixname/include/linux/cache.h	Wed Jul  2 00:45:51 2008
@@ -31,7 +31,7 @@
 #ifndef __cacheline_aligned
 #define __cacheline_aligned					\
   __attribute__((__aligned__(SMP_CACHE_BYTES),			\
-		 __section__(".data.cacheline_aligned")))
+		 __section__(".cacheline_aligned.data")))
 #endif /* __cacheline_aligned */
 
 #ifndef __cacheline_aligned_in_smp
--- 0.org/include/linux/init.h	Wed Jul  2 00:40:51 2008
+++ 1.fixname/include/linux/init.h	Wed Jul  2 00:54:13 2008
@@ -62,9 +62,9 @@
 
 /* backward compatibility note
  *  A few places hardcode the old section names:
- *  .text.init.refok
- *  .data.init.refok
- *  .exit.text.refok
+ *  .init.refok.text
+ *  .init.refok.data
+ *  .exit.refok.text
  *  They should be converted to use the defines from this file
  */
 
@@ -299,7 +299,7 @@
 #endif
 
 /* Data marked not to be saved by software suspend */
-#define __nosavedata __section(.data.nosave)
+#define __nosavedata __section(.nosave.data)
 
 /* This means "can be init if no module support, otherwise module load
    may call it." */
--- 0.org/include/linux/percpu.h	Wed Jul  2 00:40:51 2008
+++ 1.fixname/include/linux/percpu.h	Wed Jul  2 00:45:39 2008
@@ -10,13 +10,13 @@
 
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU(type, name)					\
-	__attribute__((__section__(".data.percpu")))			\
+	__attribute__((__section__(".percpu.data")))			\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
 #ifdef MODULE
-#define SHARED_ALIGNED_SECTION ".data.percpu"
+#define SHARED_ALIGNED_SECTION ".percpu.data"
 #else
-#define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
+#define SHARED_ALIGNED_SECTION ".percpu.shared_aligned.data"
 #endif
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
--- 0.org/include/linux/spinlock.h	Wed Jul  2 00:40:51 2008
+++ 1.fixname/include/linux/spinlock.h	Wed Jul  2 00:44:40 2008
@@ -59,7 +59,7 @@
 /*
  * Must define these before including other files, inline functions need them
  */
-#define LOCK_SECTION_NAME ".text.lock."KBUILD_BASENAME
+#define LOCK_SECTION_NAME ".lock.text."KBUILD_BASENAME
 
 #define LOCK_SECTION_START(extra)               \
         ".subsection 1\n\t"                     \
--- 0.org/kernel/module.c	Wed Jul  2 00:40:51 2008
+++ 1.fixname/kernel/module.c	Wed Jul  2 00:45:39 2008
@@ -433,7 +433,7 @@
 				 Elf_Shdr *sechdrs,
 				 const char *secstrings)
 {
-	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
+	return find_sec(hdr, sechdrs, secstrings, ".percpu.data");
 }
 
 static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
--- 0.org/scripts/mod/modpost.c	Wed Jul  2 00:40:54 2008
+++ 1.fixname/scripts/mod/modpost.c	Wed Jul  2 00:54:21 2008
@@ -794,9 +794,9 @@
 /* sections that may refer to an init/exit section with no warning */
 static const char *initref_sections[] =
 {
-	".text.init.refok*",
-	".exit.text.refok*",
-	".data.init.refok*",
+	".init.refok.text*",
+	".exit.refok.text*",
+	".init.refok.data*",
 	NULL
 };
 
@@ -915,7 +915,7 @@
  * Pattern 0:
  *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
  *   The pattern is identified by:
- *   fromsec = .text.init.refok* | .data.init.refok*
+ *   fromsec = .init.refok.text* | .init.refok.data*
  *
  * Pattern 1:
  *   If a module parameter is declared __initdata and permissions=0
@@ -939,8 +939,8 @@
  *           *probe_one, *_console, *_timer
  *
  * Pattern 3:
- *   Whitelist all refereces from .text.head to .init.data
- *   Whitelist all refereces from .text.head to .init.text
+ *   Whitelist all refereces from .head.text to .init.data
+ *   Whitelist all refereces from .head.text to .init.text
  *
  * Pattern 4:
  *   Some symbols belong to init section but still it is ok to reference
