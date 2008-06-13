Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbYFMJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbYFMJAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbYFMJAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:00:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:51150 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbYFMJAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=Elgb5iYCJb+MNESneK5dJveLOQZ8vAybEnYQ68slGx7x316sNw+9mVW8M4URYSjWgt
         OxBhGEss+NfFZmOuCIYkP2qGkona5yEBgMwQIIvEpkJtX1FkhAf79ehQfT30SdBunDLk
         lVqqlci4qr+PPUIIn5O97iOXbKu37gFWq5hKk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: clean up reserve_bootmem_generic
Date: Fri, 13 Jun 2008 02:00:56 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806130200.56822.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. add reserve_bootmem_generic for 32bit
2. change len to unsigned long
3. make early_res_to_bootmem to use it

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -635,7 +635,7 @@ void __init early_res_to_bootmem(u64 sta
 			continue;
 		printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
 			final_start, final_end - 1, r->name);
-		reserve_bootmem(final_start, final_end - final_start,
+		reserve_bootmem_generic(final_start, final_end - final_start,
 				BOOTMEM_DEFAULT);
 	}
 }
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -859,10 +859,11 @@ static int __init smp_scan_config(unsign
 
 			if (!reserve)
 				return 1;
-#ifdef CONFIG_X86_32
-			reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE,
+			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
 					BOOTMEM_DEFAULT);
 			if (mpf->mpf_physptr) {
+				unsigned long size = PAGE_SIZE;
+#ifdef CONFIG_X86_32
 				/*
 				 * We cannot access to MPC table to compute
 				 * table size yet, as only few megabytes from
@@ -872,22 +873,15 @@ static int __init smp_scan_config(unsign
 				 * PAGE_SIZE from mpg->mpf_physptr yields BUG()
 				 * in reserve_bootmem.
 				 */
-				unsigned long size = PAGE_SIZE;
 				unsigned long end = max_low_pfn * PAGE_SIZE;
 				if (mpf->mpf_physptr + size > end)
 					size = end - mpf->mpf_physptr;
-				reserve_bootmem(mpf->mpf_physptr, size,
+#endif
+				reserve_bootmem_generic(mpf->mpf_physptr, size,
 						BOOTMEM_DEFAULT);
 			}
 
-#else
-			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
-				BOOTMEM_DEFAULT);
-			if (mpf->mpf_physptr)
-				reserve_bootmem_generic(mpf->mpf_physptr,
-					PAGE_SIZE, BOOTMEM_DEFAULT);
-#endif
-		return 1;
+			return 1;
 		}
 		bp += 4;
 		length -= 16;
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -781,3 +781,9 @@ void free_initrd_mem(unsigned long start
 	free_init_pages("initrd memory", start, end);
 }
 #endif
+
+int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
+				   int flags)
+{
+	return reserve_bootmem(phys, len, flags);
+}
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -827,7 +827,8 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-int __init reserve_bootmem_generic(unsigned long phys, unsigned len, int flags)
+int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
+				   int flags)
 {
 #ifdef CONFIG_NUMA
 	int nid, next_nid;
Index: linux-2.6/include/asm-x86/proto.h
===================================================================
--- linux-2.6.orig/include/asm-x86/proto.h
+++ linux-2.6/include/asm-x86/proto.h
@@ -14,8 +14,6 @@ extern void ia32_syscall(void);
 extern void ia32_cstar_target(void);
 extern void ia32_sysenter_target(void);
 
-extern int reserve_bootmem_generic(unsigned long phys, unsigned len, int flags);
-
 extern void syscall32_cpu_init(void);
 
 extern void check_efer(void);
Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -84,6 +84,8 @@ extern int reserve_bootmem(unsigned long
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
+extern int reserve_bootmem_generic(unsigned long addr, unsigned long size,
+				   int flags);
 extern unsigned long free_all_bootmem(void);
 extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern void *__alloc_bootmem_node(pg_data_t *pgdat,
