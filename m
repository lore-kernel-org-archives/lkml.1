Return-Path: <linux-kernel-owner+w=401wt.eu-S1761859AbZBYK1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859AbZBYK1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbZBYK1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:27:00 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:56711 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbZBYK07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:26:59 -0500
X-BigFish: VPS3(z34a4jzzzzzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KFMACM-01-2G5-01
Date: Wed, 25 Feb 2009 11:26:18 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] x86: memtest: reuse test patterns when memtest
	parameter exceeds number of available patterns
Message-ID: <20090225102618.GQ6298@alberich.amd.com>
References: <20090225102337.GP6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090225102337.GP6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Feb 2009 10:26:46.0252 (UTC) FILETIME=[8F722AC0:01C99733]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix unexpected behaviour when pattern number is out of range

Current implementation provides 4 patterns for memtest. The code doesn't
check whether the memtest parameter value exceeds the maximum pattern number.

Instead the memtest code pretends to test with non-existing patterns, e.g.
when booting with memtest=10 I've observed the following

  ...
  early_memtest: pattern num 10
  0000001000 - 0000006000 pattern 0
  ...
  0000001000 - 0000006000 pattern 1
  ...
  0000001000 - 0000006000 pattern 2
  ...
  0000001000 - 0000006000 pattern 3
  ...
  0000001000 - 0000006000 pattern 4
  ...
  0000001000 - 0000006000 pattern 5
  ...
  0000001000 - 0000006000 pattern 6
  ...
  0000001000 - 0000006000 pattern 7
  ...
  0000001000 - 0000006000 pattern 8
  ...
  0000001000 - 0000006000 pattern 9
  ...

But in fact Linux didn't test anything for patterns > 4 as the default
case in memtest() is to leave the function.

I suggest to use the memtest parameter as the number of tests to be
performed and to re-iterate over all existing patterns.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 9cab18b..00b8bdc 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -9,6 +9,8 @@
 
 #include <asm/e820.h>
 
+#define _MAX_MEM_PATTERNS 4
+
 static void __init memtest(unsigned long start_phys, unsigned long size,
 				 unsigned pattern)
 {
@@ -21,6 +23,8 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 	unsigned long count;
 	unsigned long incr;
 
+	pattern = pattern % _MAX_MEM_PATTERNS;
+
 	switch (pattern) {
 	case 0:
 		val = 0UL;
@@ -110,8 +114,9 @@ void __init early_memtest(unsigned long start, unsigned long end)
 				t_size = end - t_start;
 
 			printk(KERN_CONT "\n  %010llx - %010llx pattern %d",
-				(unsigned long long)t_start,
-				(unsigned long long)t_start + t_size, pattern);
+			       (unsigned long long)t_start,
+			       (unsigned long long)t_start + t_size,
+			       pattern % _MAX_MEM_PATTERNS);
 
 			memtest(t_start, t_size, pattern);
 
-- 
1.6.1.3



