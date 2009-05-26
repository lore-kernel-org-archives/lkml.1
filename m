Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbZEZXUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbZEZXUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758995AbZEZXSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53163 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209AbZEZXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:31 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/17] x86: MCE: Remove machine check handler idle notify on 64bit
Date: Wed, 27 May 2009 01:18:06 +0200
Message-Id: <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

i386 has no idle notifiers, but the 64bit machine check
code uses them to wake up mcelog from a fatal machine check
exception.

For corrected machine checks found by the poller or
threshold interrupts going through an idle notifier is not needed
because the wake_up can is just done directly and doesn't
need the idle notifier. It is only needed for logging
exceptions.

To be honest I never liked the idle notifier even though I signed
off on it. On closer investigation the code actually turned out
to be nearly. Right now machine check exceptions on x86 are always
unrecoverable (lead to panic due to PCC), which means we never execute
the idle notifier path.

The only exception is the somewhat weird tolerant==3 case, which
ignores PCC. I'll fix this in a future patch in a much cleaner way.

So remove the "mcelog wakeup through idle notifier" code
from 64bit.

This allows to compile the 64bit machine check handler on 32bit
which doesn't have idle notifiers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68c3329..60acee3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -555,29 +555,6 @@ int mce_notify_user(void)
 	return 0;
 }
 
-/* see if the idle task needs to notify userspace: */
-static int
-mce_idle_callback(struct notifier_block *nfb, unsigned long action,
-		  void *unused)
-{
-	/* IDLE_END should be safe - interrupts are back on */
-	if (action == IDLE_END && test_thread_flag(TIF_MCE_NOTIFY))
-		mce_notify_user();
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block mce_idle_notifier = {
-	.notifier_call		= mce_idle_callback,
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
-- 
1.6.0.2

