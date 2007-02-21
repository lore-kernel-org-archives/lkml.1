Return-Path: <linux-kernel-owner+w=401wt.eu-S1161211AbXBUKCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161211AbXBUKCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161179AbXBUKCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:02:44 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:62564 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161211AbXBUKCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:02:04 -0500
Date: Wed, 21 Feb 2007 11:02:05 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: holzheu@de.ibm.com
Subject: [S390] New get_cpu_id() inline assembly
Message-ID: <20070221100205.GG13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

[S390] New get_cpu_id() inline assembly

Replace two stidp inline assemblies with one global implementation.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c     |    2 +-
 arch/s390/kernel/setup.c     |    2 +-
 include/asm-s390/processor.h |    5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/early.c linux-2.6-patched/arch/s390/kernel/early.c
--- linux-2.6/arch/s390/kernel/early.c	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/early.c	2007-02-21 10:47:29.000000000 +0100
@@ -129,7 +129,7 @@ static noinline __init void detect_machi
 {
 	struct cpuinfo_S390 *cpuinfo = &S390_lowcore.cpu_data;
 
-	asm volatile("stidp %0" : "=m" (S390_lowcore.cpu_data.cpu_id));
+	get_cpu_id(&S390_lowcore.cpu_data.cpu_id);
 
 	/* Running under z/VM ? */
 	if (cpuinfo->cpu_id.version == 0xff)
diff -urpN linux-2.6/arch/s390/kernel/setup.c linux-2.6-patched/arch/s390/kernel/setup.c
--- linux-2.6/arch/s390/kernel/setup.c	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/setup.c	2007-02-21 10:47:29.000000000 +0100
@@ -106,7 +106,7 @@ void __devinit cpu_init (void)
         /*
          * Store processor id in lowcore (used e.g. in timer_interrupt)
          */
-	asm volatile("stidp %0": "=m" (S390_lowcore.cpu_data.cpu_id));
+	get_cpu_id(&S390_lowcore.cpu_data.cpu_id);
         S390_lowcore.cpu_data.cpu_addr = addr;
 
         /*
diff -urpN linux-2.6/include/asm-s390/processor.h linux-2.6-patched/include/asm-s390/processor.h
--- linux-2.6/include/asm-s390/processor.h	2007-02-21 10:47:14.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/processor.h	2007-02-21 10:47:29.000000000 +0100
@@ -36,6 +36,11 @@ typedef struct
         unsigned int unused  : 16;
 } __attribute__ ((packed)) cpuid_t;
 
+static inline void get_cpu_id(cpuid_t *ptr)
+{
+	asm volatile("stidp 0(%1)" : "=m" (*ptr) : "a" (ptr));
+}
+
 struct cpuinfo_S390
 {
         cpuid_t  cpu_id;
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

