Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYGMVdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYGMVdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbYGMVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:33:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:30421 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbYGMVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=VXYOEBxoOQXPLpKkLjKQQFZEdMQrDP9CxDp4yzrUmgmsXT0N125pUoLpGhbSw20Wy3
         K95oQZggInQ0hVAsoPC1SyfCaa996r/CJGhKuH1OXBQmx4GsKlqzCUkP/HtXjGA9R/k3
         8o8xiI8ikniz4Dh9LhORZTgPaS3HEIRoz+/2U=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: make 64bit hpet_set_mapping to use ioremap too
Date: Sun, 13 Jul 2008 14:32:37 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807121432.45759.yhlu.kernel@gmail.com>
In-Reply-To: <200807121432.45759.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131432.37642.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


need to apply after
	[PATCH] x86: get x86_phys_bits early

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ea230ec..bfef53c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -35,24 +35,6 @@ static inline void hpet_writel(unsigned long d, unsigned long a)
 	writel(d, hpet_virt_address + a);
 }
 
-#ifdef CONFIG_X86_64
-
-#include <asm/pgtable.h>
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
-
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
@@ -63,7 +45,6 @@ static inline void hpet_clear_mapping(void)
 	iounmap(hpet_virt_address);
 	hpet_virt_address = NULL;
 }
-#endif
 
 /*
  * HPET command line enable / disable
