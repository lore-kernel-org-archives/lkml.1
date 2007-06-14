Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbXFNU3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbXFNU3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbXFNU2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:28:23 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59747 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbXFNU2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:28:20 -0400
Date: Thu, 14 Jun 2007 22:28:19 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Corey Minyard <minyard@acm.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] i386: add cpu_relax() to cmos_lock()
Message-ID: <20070614202819.GA14777@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060612183743.GA28610@rhlx01.fht-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpu_relax() to cmos_lock() inline function
for faster operation on SMT CPUs and less power consumption
on others in case of lock contention (which probably doesn't
happen too often, so admittedly this patch is not too exciting).

This is a small followup to my cpu_relax() patch series last year.

A different, possibly more readable and efficient way to write this loop
would be something like:

	while ((cmos_lock) ||
           (__cmpxchg(&cmos_lock, 0, new, sizeof(cmos_lock)))) {
		cpu_relax();
	}

Compiled and runtime-tested on linux-2.6.22-rc4-mm2, Athlon.

Signed-off-by: Andreas Mohr <andi@lisas.de>


--- linux-2.6.22-rc4-mm2.orig/include/asm-i386/mc146818rtc.h	2007-06-10 22:00:53.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/asm-i386/mc146818rtc.h	2007-06-09 21:40:21.000000000 +0200
@@ -43,8 +43,10 @@
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

