Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbZGIQY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbZGIQY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760309AbZGIQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:24:49 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54709 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbZGIQYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:24:49 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>
Subject: [PATCH] ARM: copy_page.S: take into account the size of the cache line
Date: Thu,  9 Jul 2009 19:23:25 +0300
Message-Id: <1247156605-16245-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Optimized version of copy_page() was written with assumption that cache
line size is 32 bytes. On Cortex-A8 cache line size is 64 bytes.

This patch tries to generalize copy_page() to work with any cache line
size if cache line size is multiple of 16 and page size is multiple of
two cache line size.

Unfortunately, kernel doesn't provide a macros with correct cache size.
L1_CACHE_SHIFT is 5 on any ARM. So we have to define macros for this
propose by ourself.

After this optimization we've got ~25% speedup on OMAP3(tested in
userspace).

There is test for kernelspace which trigger copy-on-write after fork():

 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>

 #define BUF_SIZE (10000*4096)
 #define NFORK 200

 int main(int argc, char **argv)
 {
         char *buf = malloc(BUF_SIZE);
         int i;

         memset(buf, 0, BUF_SIZE);

         for(i = 0; i < NFORK; i++) {
                 if (fork()) {
                         wait(NULL);
                 } else {
                         int j;

                         for(j = 0; j < BUF_SIZE; j+= 4096)
                                 buf[j] = (j & 0xFF) + 1;
                         break;
                 }
         }

         free(buf);
         return 0;
 }

Before optimization this test takes ~66 seconds, after optimization
takes ~56 seconds.

Signed-off-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/arm/lib/copy_page.S |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm/lib/copy_page.S b/arch/arm/lib/copy_page.S
index 6ae04db..3bd1b9c 100644
--- a/arch/arm/lib/copy_page.S
+++ b/arch/arm/lib/copy_page.S
@@ -13,7 +13,13 @@
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 
-#define COPY_COUNT (PAGE_SZ/64 PLD( -1 ))
+#if CONFIG_ARCH_OMAP3
+#define CACHE_LINE_SZ 64
+#else
+#define CACHE_LINE_SZ 32
+#endif
+
+#define COPY_COUNT (PAGE_SZ/(2 * CACHE_LINE_SZ) PLD( -1 ))
 
 		.text
 		.align	5
@@ -26,17 +32,16 @@
 ENTRY(copy_page)
 		stmfd	sp!, {r4, lr}			@	2
 	PLD(	pld	[r1, #0]		)
-	PLD(	pld	[r1, #32]		)
+	PLD(	pld	[r1, #CACHE_LINE_SZ]		)
 		mov	r2, #COPY_COUNT			@	1
 		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
-1:	PLD(	pld	[r1, #64]		)
-	PLD(	pld	[r1, #96]		)
-2:		stmia	r0!, {r3, r4, ip, lr}		@	4
-		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
-		stmia	r0!, {r3, r4, ip, lr}		@	4
-		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
+1:	PLD(	pld	[r1, #(2*CACHE_LINE_SZ)])
+	PLD(	pld	[r1, #(3*CACHE_LINE_SZ)])
+2:
+	.rept	(2 * (CACHE_LINE_SZ) / 16 - 1)
 		stmia	r0!, {r3, r4, ip, lr}		@	4
 		ldmia	r1!, {r3, r4, ip, lr}		@	4
+	.endr
 		subs	r2, r2, #1			@	1
 		stmia	r0!, {r3, r4, ip, lr}		@	4
 		ldmgtia	r1!, {r3, r4, ip, lr}		@	4
-- 
1.6.3.3

