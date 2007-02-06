Return-Path: <linux-kernel-owner+w=401wt.eu-S965484AbXBFVKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965484AbXBFVKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965481AbXBFVKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:10:08 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:2426 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965483AbXBFVKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:10:06 -0500
Date: Tue, 6 Feb 2007 22:10:06 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Add/extend WARN_ONs in smp_call_function & smp_call_function_on.
Message-ID: <20070206211006.GB30335@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Add/extend WARN_ONs in smp_call_function & smp_call_function_on.

Let smp_call_function & smp_call_function_on complain if called with
interrupts disabled or called from a wrong context.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/smp.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/smp.c linux-2.6-patched/arch/s390/kernel/smp.c
--- linux-2.6/arch/s390/kernel/smp.c	2007-02-06 21:43:03.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/smp.c	2007-02-06 21:43:35.000000000 +0100
@@ -57,7 +57,7 @@ static void smp_ext_bitcall(int, ec_bit_
 static void smp_ext_bitcall_others(ec_bit_sig);
 
 /*
-5B * Structure and data for smp_call_function(). This is designed to minimise
+ * Structure and data for smp_call_function(). This is designed to minimise
  * static memory requirements. It also looks cleaner.
  */
 static DEFINE_SPINLOCK(call_lock);
@@ -113,8 +113,8 @@ int smp_call_function (void (*func) (voi
 	if (cpus <= 0)
 		return 0;
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	/* Can deadlock when interrupts are disabled or if in wrong context */
+	WARN_ON(irqs_disabled() || in_interrupt());
 
 	data.func = func;
 	data.info = info;
@@ -159,6 +159,9 @@ int smp_call_function_on(void (*func) (v
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	/* Can deadlock when interrupts are disabled or if in wrong context */
+	WARN_ON(irqs_disabled() || in_irq());
+
 	/* disable preemption for local function call */
 	curr_cpu = get_cpu();
 
