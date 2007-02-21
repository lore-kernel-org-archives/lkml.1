Return-Path: <linux-kernel-owner+w=401wt.eu-S1161200AbXBUKCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161200AbXBUKCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161211AbXBUKCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:02:00 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:48251 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161189AbXBUKBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:01:42 -0500
Date: Wed, 21 Feb 2007 11:01:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] etr: Add barrier() to etr_sync_cpu_start().
Message-ID: <20070221100142.GF13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] etr: Add barrier() to etr_sync_cpu_start().

Force reading of *in_sync in while loop. Loops where the content that
is checked for is changed by a different cpu always should have some
sort of barrier() semantics.
Otherwise this might lead to very subtle bugs.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/time.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/kernel/time.c linux-2.6-patched/arch/s390/kernel/time.c
--- linux-2.6/arch/s390/kernel/time.c	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/time.c	2007-02-21 10:47:28.000000000 +0100
@@ -747,6 +747,7 @@ static void etr_adjust_time(unsigned lon
 	}
 }
 
+#ifdef CONFIG_SMP
 static void etr_sync_cpu_start(void *dummy)
 {
 	int *in_sync = dummy;
@@ -758,8 +759,14 @@ static void etr_sync_cpu_start(void *dum
 	 * __udelay will stop the cpu on an enabled wait psw until the
 	 * TOD is running again.
 	 */
-	while (*in_sync == 0)
+	while (*in_sync == 0) {
 		__udelay(1);
+		/*
+		 * A different cpu changes *in_sync. Therefore use
+		 * barrier() to force memory access.
+		 */
+		barrier();
+	}
 	if (*in_sync != 1)
 		/* Didn't work. Clear per-cpu in sync bit again. */
 		etr_disable_sync_clock(NULL);
@@ -773,6 +780,7 @@ static void etr_sync_cpu_start(void *dum
 static void etr_sync_cpu_end(void *dummy)
 {
 }
+#endif /* CONFIG_SMP */
 
 /*
  * Sync the TOD clock using the port refered to by aibp. This port
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

