Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbXLGO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbXLGO7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXLGO6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:58:51 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53805 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924AbXLGO6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:58:49 -0500
Date: Fri, 7 Dec 2007 23:56:44 +0900
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       muli@il.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 6/6] kill __clear_bit_string and find_next_zero_string
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
References: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071207235728V.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kills unused __clear_bit_string and find_next_zero_string (they
were used by only gart and calgary IOMMUs).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/lib/Makefile_64    |    2 +-
 arch/x86/lib/bitstr_64.c    |   28 ----------------------------
 include/asm-x86/bitops_64.h |   16 ----------------
 3 files changed, 1 insertions(+), 45 deletions(-)
 delete mode 100644 arch/x86/lib/bitstr_64.c

diff --git a/arch/x86/lib/Makefile_64 b/arch/x86/lib/Makefile_64
index bbabad3..1b72bda 100644
--- a/arch/x86/lib/Makefile_64
+++ b/arch/x86/lib/Makefile_64
@@ -9,5 +9,5 @@ obj-$(CONFIG_SMP)	+= msr-on-cpu.o
 
 lib-y := csum-partial_64.o csum-copy_64.o csum-wrappers_64.o delay_64.o \
 	usercopy_64.o getuser_64.o putuser_64.o  \
-	thunk_64.o clear_page_64.o copy_page_64.o bitstr_64.o bitops_64.o
+	thunk_64.o clear_page_64.o copy_page_64.o bitops_64.o
 lib-y += memcpy_64.o memmove_64.o memset_64.o copy_user_64.o rwlock_64.o copy_user_nocache_64.o
diff --git a/arch/x86/lib/bitstr_64.c b/arch/x86/lib/bitstr_64.c
deleted file mode 100644
index 7445caf..0000000
--- a/arch/x86/lib/bitstr_64.c
+++ /dev/null
@@ -1,28 +0,0 @@
-#include <linux/module.h>
-#include <linux/bitops.h>
-
-/* Find string of zero bits in a bitmap */ 
-unsigned long 
-find_next_zero_string(unsigned long *bitmap, long start, long nbits, int len)
-{ 
-	unsigned long n, end, i; 	
-
- again:
-	n = find_next_zero_bit(bitmap, nbits, start);
-	if (n == -1) 
-		return -1;
-	
-	/* could test bitsliced, but it's hardly worth it */
-	end = n+len;
-	if (end > nbits)
-		return -1; 
-	for (i = n+1; i < end; i++) { 
-		if (test_bit(i, bitmap)) {  
-			start = i+1; 
-			goto again; 
-		} 
-	}
-	return n;
-}
-
-EXPORT_SYMBOL(find_next_zero_string);
diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
index 48adbf5..aaf1519 100644
--- a/include/asm-x86/bitops_64.h
+++ b/include/asm-x86/bitops_64.h
@@ -37,12 +37,6 @@ static inline long __scanbit(unsigned long val, unsigned long max)
   ((off)+(__scanbit(~(((*(unsigned long *)addr)) >> (off)),(size)-(off)))) : \
 	find_next_zero_bit(addr,size,off)))
 
-/* 
- * Find string of zero bits in a bitmap. -1 when not found.
- */ 
-extern unsigned long 
-find_next_zero_string(unsigned long *bitmap, long start, long nbits, int len);
-
 static inline void set_bit_string(unsigned long *bitmap, unsigned long i, 
 				  int len) 
 { 
@@ -53,16 +47,6 @@ static inline void set_bit_string(unsigned long *bitmap, unsigned long i,
 	}
 } 
 
-static inline void __clear_bit_string(unsigned long *bitmap, unsigned long i, 
-				    int len) 
-{ 
-	unsigned long end = i + len; 
-	while (i < end) {
-		__clear_bit(i, bitmap); 
-		i++;
-	}
-} 
-
 /**
  * ffz - find first zero in word.
  * @word: The word to search
-- 
1.5.3.4

