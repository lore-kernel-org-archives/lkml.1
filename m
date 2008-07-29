Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYG2Hxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYG2Hxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYG2Hxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:53:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:9493 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYG2Hxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=X09Clq3rpOvJfljdqOoErE31aloO6Lz3AF/r8zSkPWHNjqhr4Fe+QuaHLQ1c2aD2f1
         dRb3vAui54GeeL9y9w1FrNH4Pznrh9UOTMhD2t7CQysi1Vp+0XByvYUKVWa3XYzA+eJ3
         vm60pTCbaDOWIoN/fyaaBqroypyJJt8Y/OecA=
Date: Tue, 29 Jul 2008 15:54:41 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       yhlu.kernel@gmail.com, x86@kernel.org, linux-mm@kvack.org
Subject: [PATCH V2] i386 : vmalloc size fix
Message-ID: <20080729075441.GA3075@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 based on the ported version of ingo, changes:
remove unused VMALLOC_RESERVE macro in page_32.h

--
Booting kernel with vmalloc=[any size<=16m] will oops on my pc (i386/1G memory).

BUG_ON in arch/x86/mm/init_32.c triggered:
BUG_ON((unsigned long)high_memory > VMALLOC_START);

It's due to the vm area hole.

In include/asm-x86/pgtable_32.h:
#define VMALLOC_OFFSET	(8 * 1024 * 1024)
#define VMALLOC_START	(((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
			 & ~(VMALLOC_OFFSET - 1))

There's several related point:
1. MAXMEM :
 (-__PAGE_OFFSET - __VMALLOC_RESERVE).
The space after VMALLOC_END is included as well, I set it to
(VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)

2. VMALLOC_OFFSET is not considered in __VMALLOC_RESERVE
fixed by adding VMALLOC_OFFSET to it.

3. VMALLOC_START :
 (((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) & ~(VMALLOC_OFFSET - 1))
So it's not always 8M, bigger than 8M possible.
I set it to ((unsigned long)high_memory + VMALLOC_OFFSET)

4. the VMALLOC_RESERVE is an unused macro, so remove it here.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

arch/x86/mm/pgtable_32.c     |    3 ++-
include/asm-x86/page_32.h    |    3 ---
include/asm-x86/pgtable_32.h |    5 +++--
3 files changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/mm/pgtable_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pgtable_32.c	2008-07-29 14:43:02.000000000 +0800
+++ linux-2.6/arch/x86/mm/pgtable_32.c	2008-07-29 14:44:43.000000000 +0800
@@ -123,7 +123,8 @@
 	if (!arg)
 		return -EINVAL;
 
-	__VMALLOC_RESERVE = memparse(arg, &arg);
+	/* Add VMALLOC_OFFSET to the parsed value due to vm area guard hole*/
+	__VMALLOC_RESERVE = memparse(arg, &arg) + VMALLOC_OFFSET;
 	return 0;
 }
 early_param("vmalloc", parse_vmalloc);
Index: linux-2.6/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_32.h	2008-07-29 14:44:13.000000000 +0800
+++ linux-2.6/include/asm-x86/page_32.h	2008-07-29 14:45:15.000000000 +0800
@@ -89,9 +89,6 @@
 extern unsigned int __VMALLOC_RESERVE;
 extern int sysctl_legacy_va_layout;
 
-#define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
-#define MAXMEM			(-__PAGE_OFFSET - __VMALLOC_RESERVE)
-
 extern void find_low_pfn_range(void);
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
Index: linux-2.6/include/asm-x86/pgtable_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable_32.h	2008-07-29 14:43:02.000000000 +0800
+++ linux-2.6/include/asm-x86/pgtable_32.h	2008-07-29 14:44:43.000000000 +0800
@@ -56,8 +56,7 @@
  * area for the same reason. ;)
  */
 #define VMALLOC_OFFSET	(8 * 1024 * 1024)
-#define VMALLOC_START	(((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
-			 & ~(VMALLOC_OFFSET - 1))
+#define VMALLOC_START	((unsigned long)high_memory + VMALLOC_OFFSET)
 #ifdef CONFIG_X86_PAE
 #define LAST_PKMAP 512
 #else
@@ -73,6 +72,8 @@
 # define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
 #endif
 
+#define MAXMEM	(VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)
+
 /*
  * Define this if things work differently on an i386 and an i486:
  * it will (on an i486) warn about kernel memory accesses that are
