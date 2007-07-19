Return-Path: <linux-kernel-owner+w=401wt.eu-S938319AbXGSN5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938319AbXGSN5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764386AbXGSNsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:51 -0400
Received: from ns1.suse.de ([195.135.220.2]:54536 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937209AbXGSNst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:49 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: andi@lisas.de, ak@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [19/48] i386: add cpu_relax() to cmos_lock()
Message-Id: <20070719134848.C274014E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andreas Mohr <andi@lisas.de>

Add cpu_relax() to cmos_lock() inline function for faster operation on SMT
CPUs and less power consumption on others in case of lock contention (which
probably doesn't happen too often, so admittedly this patch is not too
exciting).

[akpm@linux-foundation.org: Include the header file for cpu_relax()]
Signed-off-by: Andreas Mohr <andi@lisas.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mc146818rtc.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/include/asm-i386/mc146818rtc.h
===================================================================
--- linux.orig/include/asm-i386/mc146818rtc.h
+++ linux/include/asm-i386/mc146818rtc.h
@@ -6,6 +6,7 @@
 
 #include <asm/io.h>
 #include <asm/system.h>
+#include <asm/processor.h>
 #include <linux/mc146818rtc.h>
 
 #ifndef RTC_PORT
@@ -43,8 +44,10 @@ static inline void lock_cmos(unsigned ch
 	unsigned long new;
 	new = ((smp_processor_id()+1) << 8) | reg;
 	for (;;) {
-		if (cmos_lock)
+		if (cmos_lock) {
+			cpu_relax();
 			continue;
+		}
 		if (__cmpxchg(&cmos_lock, 0, new, sizeof(cmos_lock)) == 0)
 			return;
 	}
