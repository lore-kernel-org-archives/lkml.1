Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbZBMPIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbZBMPIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZBMPIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:08:14 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:13751 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753132AbZBMPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:08:14 -0500
X-BigFish: VPS3(zzzzzzz32i6bh43j)
X-WSS-ID: 0KF0ENZ-02-J1P-01
Date: Fri, 13 Feb 2009 15:52:41 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] x86: memtest: cleanup memtest function
Message-ID: <20090213145241.GC13000@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090213144600.GA6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Feb 2009 14:52:51.0535 (UTC) FILETIME=[BE8A05F0:01C98DEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code cleanup

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index a8a6c51..82321d9 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -21,6 +21,15 @@ static unsigned long patterns[] = {
 #endif
 };
 
+static void reserve_bad_mem(unsigned long pattern, unsigned long start_bad,
+			    unsigned long end_bad)
+{
+	printk(KERN_CONT "\n  %016lx bad mem addr "
+	       "%010lx - %010lx reserved",
+	       pattern, start_bad, end_bad);
+	reserve_early(start_bad, end_bad, "BAD RAM");
+}
+
 static void __init memtest(unsigned long start_phys, unsigned long size,
 			   unsigned long pattern)
 {
@@ -42,25 +51,18 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 	for (i = 0; i < count; i++)
 		start[i] = pattern;
 	for (i = 0; i < count; i++, start++, start_phys_aligned += incr) {
-		if (*start != pattern) {
-			if (start_phys_aligned == last_bad + incr) {
-				last_bad += incr;
-			} else {
-				if (start_bad) {
-					printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
-					       pattern, start_bad,
-					       last_bad + incr);
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
-		printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
-		       pattern, start_bad, last_bad + incr);
-		reserve_early(start_bad, last_bad + incr, "BAD RAM");
-	}
+	if (start_bad)
+		reserve_bad_mem(pattern, start_bad, last_bad + incr);
 }
 
 /* default is disabled */
-- 
1.6.1.2



