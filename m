Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbZBYK3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbZBYK3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761505AbZBYK2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:28:51 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:62947 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762155AbZBYK2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:28:50 -0500
X-BigFish: VPS1(zzzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KFMAFL-02-5JF-01
Date: Wed, 25 Feb 2009 11:28:07 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] x86: memtest: cleanup memtest function
Message-ID: <20090225102807.GS6298@alberich.amd.com>
References: <20090225102337.GP6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090225102337.GP6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Feb 2009 10:28:34.0785 (UTC) FILETIME=[D022FD10:01C99733]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: code cleanup

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 827f940..01a72d6 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -16,6 +16,15 @@ static u64 patterns[] __initdata = {
 	0xaaaaaaaaaaaaaaaaULL,
 };
 
+static void __init reserve_bad_mem(u64 pattern, unsigned long start_bad,
+			    unsigned long end_bad)
+{
+	printk(KERN_CONT "\n  %016llx bad mem addr "
+	       "%010lx - %010lx reserved",
+	       (unsigned long long) pattern, start_bad, end_bad);
+	reserve_early(start_bad, end_bad, "BAD RAM");
+}
+
 static void __init memtest(unsigned long start_phys, unsigned long size,
 			   u64 pattern)
 {
@@ -37,26 +46,18 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 	for (i = 0; i < count; i++)
 		start[i] = pattern;
 	for (i = 0; i < count; i++, start++, start_phys_aligned += incr) {
-		if (*start != pattern) {
-			if (start_phys_aligned == last_bad + incr) {
-				last_bad += incr;
-			} else {
-				if (start_bad) {
-					printk(KERN_CONT "\n  %016llx bad mem addr %010lx - %010lx reserved",
-					       (unsigned long long) pattern,
-					       start_bad, last_bad + incr);
-					reserve_early(start_bad, last_bad + incr, "BAD RAM");
-				}
-				start_bad = last_bad = start_phys_aligned;
-			}
+		if (*start == pattern)
+			continue;
+		if (start_phys_aligned == last_bad + incr) {
+			last_bad += incr;
+			continue;
 		}
+		if (start_bad)
+			reserve_bad_mem(pattern, start_bad, last_bad + incr);
+		start_bad = last_bad = start_phys_aligned;
 	}
-	if (start_bad) {
-		printk(KERN_CONT "\n  %016llx bad mem addr %010lx - %010lx reserved",
-		       (unsigned long long) pattern, start_bad,
-		       last_bad + incr);
-		reserve_early(start_bad, last_bad + incr, "BAD RAM");
-	}
+	if (start_bad)
+		reserve_bad_mem(pattern, start_bad, last_bad + incr);
 }
 
 /* default is disabled */
-- 
1.6.1.3



