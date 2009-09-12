Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZILUth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZILUth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 16:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZILUtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 16:49:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:32447 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbZILUtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 16:49:35 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH v3 2/2] ARM: copy_page.S: take into account the size of the cache line
Date: Sat, 12 Sep 2009 23:48:31 +0300
Message-Id: <baf6bd8717f0e68da27d3c72c4e7e67cf656196b.1252788311.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name>
References: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name>
In-Reply-To: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name>
References: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimized version of copy_page() was written with assumption that cache
line size is 32 bytes. On Cortex-A8 cache line size is 64 bytes.

This patch tries to generalize copy_page() to work with any cache line
size if cache line size is multiple of 16 and page size is multiple of
two cache line size.

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

V3:
  - fix typo

V2:
  - include <asm/cache.h>
  - remove unnecessary parens and fix style

Signed-off-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/arm/lib/copy_page.S |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/lib/copy_page.S b/arch/arm/lib/copy_page.S
index 6ae04db..6ee2f67 100644
--- a/arch/arm/lib/copy_page.S
+++ b/arch/arm/lib/copy_page.S
@@ -12,8 +12,9 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
+#include <asm/cache.h>
 
-#define COPY_COUNT (PAGE_SZ/64 PLD( -1 ))
+#define COPY_COUNT (PAGE_SZ / (2 * L1_CACHE_BYTES) PLD( -1 ))
 
 		.text
 		.align	5
@@ -26,17 +27,16 @@
 ENTRY(copy_page)
 		stmfd	sp!, {r4, lr}			@	2
 	PLD(	pld	[r1, #0]		)
-	PLD(	pld	[r1, #32]		)
+	PLD(	pld	[r1, #L1_CACHE_BYTES]		)
 		mov	r2, #COPY_COUNT			@	1
 		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
-1:	PLD(	pld	[r1, #64]		)
-	PLD(	pld	[r1, #96]		)
-2:		stmia	r0!, {r3, r4, ip, lr}		@	4
-		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
-		stmia	r0!, {r3, r4, ip, lr}		@	4
-		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
+1:	PLD(	pld	[r1, #2 * L1_CACHE_BYTES])
+	PLD(	pld	[r1, #3 * L1_CACHE_BYTES])
+2:
+	.rept	(2 * L1_CACHE_BYTES / 16 - 1)
 		stmia	r0!, {r3, r4, ip, lr}		@	4
 		ldmia	r1!, {r3, r4, ip, lr}		@	4
+	.endr
 		subs	r2, r2, #1			@	1
 		stmia	r0!, {r3, r4, ip, lr}		@	4
 		ldmgtia	r1!, {r3, r4, ip, lr}		@	4
-- 
1.6.4.2

