Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbXENJYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbXENJYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbXENJY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:24:26 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:5595 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbXENJYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:24:25 -0400
Date: Mon, 14 May 2007 11:23:17 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       randy.dunlap@oracle.com, paulus@samba.org, benh@kernel.crashing.org,
       David Miller <davem@davemloft.net>
Subject: [patch] Let smp_call_function_single return -EBUSY.
Message-ID: <20070514092317.GB8968@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

All architectures that have an implementation of smp_call_function_single
let it return -EBUSY if it is asked to execute func on the current cpu.
Therefore the UP version must always return -EBUSY.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

This of course raises another question: it is not clear in which context
the smp_call_function* functions are supposed to be called. Should it be
with preemption disabled or is preemption enabled allowed as well?
If calling with preemption enabled is allowed then the powerpc implementation
is broken, since smp_processor_id() as well as num_online_cpus() may change
while they are accessed.

 include/linux/smp.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/smp.h
===================================================================
--- linux-2.6.orig/include/linux/smp.h
+++ linux-2.6/include/linux/smp.h
@@ -99,11 +99,9 @@ static inline void smp_send_reschedule(i
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
 static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
-				void *info, int retry, int wait)
+					   void *info, int retry, int wait)
 {
-	/* Disable interrupts here? */
-	func(info);
-	return 0;
+	return -EBUSY;
 }
 
 #endif /* !SMP */
