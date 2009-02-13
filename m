Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbZBMPEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbZBMPEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZBMPEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:04:45 -0500
Received: from wa4ehsobe001.messaging.microsoft.com ([216.32.181.11]:39309
	"EHLO WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752010AbZBMPEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:04:44 -0500
X-BigFish: VPS5(z34a4jzzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KF0EID-02-IWS-01
Date: Fri, 13 Feb 2009 15:49:18 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] x86: memtest: reuse test patterns when memtest
	parameter exceeds number of available patterns
Message-ID: <20090213144918.GA13000@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090213144600.GA6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Feb 2009 14:49:28.0627 (UTC) FILETIME=[4598B830:01C98DEA]
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
1.6.1.2



