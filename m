Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbZDGPM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbZDGPM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZDGPHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48847 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbZDGPHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:52 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [9/28] x86: MCE: Remove machine check handler idle notify on 64bit
Message-Id: <20090407150750.652F71D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For corrected machine checks found by the poller or
threshold interrupts going through an idle notifier is not needed
because the wake_up can is just done directly and doesn't
need the idle notifier. It is only needed for logging
exceptions.

The code going through the idle notifier is also
fairly ugly and intrusive to the rest of the kernel.

To be honest I never liked the idle notifier even though I signed
off on it. On closer investigation the code actually turned out
to be nearly. Right now machine check exceptions on x86 are always
unrecoverable (lead to panic due to PCC), which means we never execute
the idle notifier path in the normal case.

The only exception is the somewhat weird tolerant==3 case, which
ignores PCC. I'll fix this in a followup patch in a much cleaner way.

So remove the "mcelog wakeup through idle notifier" code
from 64bit.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   22 ----------------------
 1 file changed, 22 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:13.000000000 +0200
@@ -521,28 +521,6 @@
 	return 0;
 }
 
-/* see if the idle task needs to notify userspace */
-static int
-mce_idle_callback(struct notifier_block *nfb, unsigned long action, void *junk)
-{
-	/* IDLE_END should be safe - interrupts are back on */
-	if (action == IDLE_END && test_thread_flag(TIF_MCE_NOTIFY))
-		mce_notify_user();
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block mce_idle_notifier = {
-	.notifier_call = mce_idle_callback,
-};
-
-static __init int periodic_mcheck_init(void)
-{
-       idle_notifier_register(&mce_idle_notifier);
-       return 0;
-}
-__initcall(periodic_mcheck_init);
-
 /*
  * Initialize Machine Checks for a CPU.
  */
