Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYGMF6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYGMF6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 01:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYGMF5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 01:57:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:22724 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYGMF5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 01:57:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=kxLOUf59KK0++qIksPwln+gbnftqQ7sGS+ZCmBH8fHd1XLqKSXGtT5urx/qFPtvdcC
         joBkK/jMqV7ka5Uu6pgDbRYuj2x5DBe6Dre8jJ1rowHbQy1NFo7XdB7bwfjIQKbdijda
         Duh/Tks27lH1zjgL18vrqsDrJPQJSEKPuZDH4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: remove end_user_pfn
Date: Sat, 12 Jul 2008 22:57:07 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807122257.07454.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


e820 map already get updated, so don't need to keep that anymore

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1049,11 +1049,6 @@ u64 __init early_reserve_e820(u64 startt
 #endif
 
 /*
- * Last pfn which the user wants to use.
- */
-unsigned long __initdata end_user_pfn = MAX_ARCH_PFN;
-
-/*
  * Find the highest page frame number we have available
  */
 static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
@@ -1085,8 +1080,6 @@ static unsigned long __init e820_end_pfn
 
 	if (last_pfn > max_arch_pfn)
 		last_pfn = max_arch_pfn;
-	if (last_pfn > end_user_pfn)
-		last_pfn = end_user_pfn;
 
 	printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",
 			 last_pfn, max_arch_pfn);
@@ -1131,12 +1124,6 @@ int __init e820_find_active_region(const
 	if (*ei_endpfn > last_pfn)
 		*ei_endpfn = last_pfn;
 
-	/* Obey end_user_pfn to save on memmap */
-	if (*ei_startpfn >= end_user_pfn)
-		return 0;
-	if (*ei_endpfn > end_user_pfn)
-		*ei_endpfn = end_user_pfn;
-
 	return 1;
 }
 
@@ -1201,7 +1188,6 @@ static int __init parse_memopt(char *p)
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
-	end_user_pfn = mem_size>>PAGE_SHIFT;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
@@ -1245,10 +1231,9 @@ static int __init parse_memmap_opt(char
 	} else if (*p == '$') {
 		start_at = memparse(p+1, &p);
 		e820_add_region(start_at, mem_size, E820_RESERVED);
-	} else {
-		end_user_pfn = (mem_size >> PAGE_SHIFT);
+	} else
 		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
-	}
+
 	return *p == '\0' ? 0 : -EINVAL;
 }
 early_param("memmap", parse_memmap_opt);
