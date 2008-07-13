Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYGMVvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYGMVvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYGMVvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:51:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:40556 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbYGMVvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=NeQwvXG82hIC/MKRV1g1rMT8X0p+RBYVvPFap3KE5eb96HHYQVrnQMHNFSYt7CeMOt
         Os3yRQ4N2Q7Q6aiI0P8gDKCguViznXCVhZdPM9r8cz/zaIROndxqVFAuKQUOz/jRZYj3
         yBOd9F1Qrbr3gsyF599dHoPYkxsIsLoLRPqJ0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: make 64bit hpet_set_mapping to use ioremap too v2
Date: Sun, 13 Jul 2008 14:50:56 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807121432.45759.yhlu.kernel@gmail.com> <200807131432.37642.yhlu.kernel@gmail.com>
In-Reply-To: <200807131432.37642.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131450.57286.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


need to apply after
	[PATCH] x86: get x86_phys_bits early

keep the one for VSYSCALL_HPET

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/hpet.c      |   20 ++++----------------
 include/asm-x86/fixmap_64.h |    1 -
 2 files changed, 4 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -36,26 +36,15 @@ static inline void hpet_writel(unsigned
 }
 
 #ifdef CONFIG_X86_64
-
 #include <asm/pgtable.h>
-
-static inline void hpet_set_mapping(void)
-{
-	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
-	hpet_virt_address = (void __iomem *)fix_to_virt(FIX_HPET_BASE);
-}
-
-static inline void hpet_clear_mapping(void)
-{
-	hpet_virt_address = NULL;
-}
-
-#else
+#endif
 
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+#ifdef CONFIG_X86_64
+	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+#endif
 }
 
 static inline void hpet_clear_mapping(void)
@@ -63,7 +52,6 @@ static inline void hpet_clear_mapping(vo
 	iounmap(hpet_virt_address);
 	hpet_virt_address = NULL;
 }
-#endif
 
 /*
  * HPET command line enable / disable
Index: linux-2.6/include/asm-x86/fixmap_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/fixmap_64.h
+++ linux-2.6/include/asm-x86/fixmap_64.h
@@ -40,7 +40,6 @@ enum fixed_addresses {
 	VSYSCALL_HPET,
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
-	FIX_HPET_BASE,
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
