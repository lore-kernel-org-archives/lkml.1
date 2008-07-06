Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYGFPqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYGFPqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbYGFPqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:46:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:41457 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbYGFPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=a/AKzRadeXlpQg0m+XjHSek3bb7kvADejuJTY8fzEkvqy2xijeFWB3m98tg60VmQVL
         trCXVM2GZGn4rehcuZH2niJPj/UlLAslDu4WxQdKkJNGy7JZcnGFqgpKslrDYGI+ND81
         5Xv2pHMpMJykSZKU0h/ptDiGbaIbJxE9g3OMs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 14/23] make section names compatible with -ffunction-sections -fdata-sections: parisc
Date: Sun, 6 Jul 2008 17:46:02 +0200
User-Agent: KMail/1.8.2
Cc: Russell King <rmk@arm.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
References: <200807020239.11410.vda.linux@googlemail.com>
In-Reply-To: <200807020239.11410.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807061746.02517.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes parisc architecture.

Updated version - does not try to rename sections
which really are expected to be produced by gcc - .text.sys_exit etc.

James please ACK/NAK.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/parisc/kernel/head.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/parisc/kernel/head.S	Wed Jul  2 00:45:45 2008
@@ -345,7 +345,7 @@
 ENDPROC(stext)
 
 #ifndef CONFIG_64BIT
-	.section .data.read_mostly
+	.section .read_mostly.data
 
 	.align	4
 	.export	$global$,data
--- 0.org/arch/parisc/kernel/init_task.c	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/parisc/kernel/init_task.c	Wed Jul  2 00:46:55 2008
@@ -49,7 +49,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((aligned(128))) __attribute__((__section__(".data.init_task"))) =
+	__attribute__((aligned(128))) __attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 #if PT_NLEVELS == 3
@@ -58,11 +58,11 @@
  * guarantee that global objects will be laid out in memory in the same order 
  * as the order of declaration, so put these in different sections and use
  * the linker script to order them. */
-pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".data.vm0.pmd"), aligned(PAGE_SIZE)));
+pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".vm0.pmd.data"), aligned(PAGE_SIZE)));
 #endif
 
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".data.vm0.pgd"), aligned(PAGE_SIZE)));
-pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".data.vm0.pte"), aligned(PAGE_SIZE)));
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".vm0.pgd.data"), aligned(PAGE_SIZE)));
+pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".vm0.pte.data"), aligned(PAGE_SIZE)));
 
 /*
  * Initial task structure.
--- 0.org/arch/parisc/kernel/vmlinux.lds.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/parisc/kernel/vmlinux.lds.S	Wed Jul  2 01:02:35 2008
@@ -95,8 +95,8 @@
 
 	/* rarely changed data like cpu maps */
 	. = ALIGN(16);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.read_mostly.data : {
+		*(.read_mostly.data)
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
@@ -107,14 +107,14 @@
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 
 	/* PA-RISC locks requires 16-byte alignment */
 	. = ALIGN(16);
-	.data.lock_aligned : {
-		*(.data.lock_aligned)
+	.lock_aligned.data : {
+		*(.lock_aligned.data)
 	}
 
 	/* nosave data is really only used for software suspend...it's here
@@ -123,7 +123,7 @@
 	. = ALIGN(PAGE_SIZE);
 	__nosave_begin = .;
 	.data_nosave : {
-		*(.data.nosave)
+		*(.nosave.data)
 	}
 	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
@@ -135,10 +135,10 @@
 	__bss_start = .;
 	/* page table entries need to be PAGE_SIZE aligned */
 	. = ALIGN(PAGE_SIZE);
-	.data.vmpages : {
-		*(.data.vm0.pmd)
-		*(.data.vm0.pgd)
-		*(.data.vm0.pte)
+	.data.vmpages : { /* TODO: rename .vmpages.data? */
+		*(.vm0.pmd.data)
+		*(.vm0.pgd.data)
+		*(.vm0.pte.data)
 	}
 	.bss : {
 		*(.bss)
@@ -150,8 +150,8 @@
 	/* assembler code expects init_task to be 16k aligned */
 	. = ALIGN(16384);
 	/* init_task */
-	.data.init_task : {
-		*(.data.init_task)
+	.init_task.data : {
+		*(.init_task.data)
 	}
 
 #ifdef CONFIG_64BIT
--- 0.org/include/asm-parisc/cache.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-parisc/cache.h	Wed Jul  2 00:45:45 2008
@@ -28,7 +28,7 @@
 
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 void parisc_cache_init(void);	/* initializes cache-flushing */
 void disable_sr_hashing_asm(int); /* low level support for above */
--- 0.org/include/asm-parisc/system.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-parisc/system.h	Wed Jul  2 00:46:14 2008
@@ -174,7 +174,7 @@
 })
 
 #ifdef CONFIG_SMP
-# define __lock_aligned __attribute__((__section__(".data.lock_aligned")))
+# define __lock_aligned __attribute__((__section__(".lock_aligned.data")))
 #endif
 
 #define arch_align_stack(x) (x)
