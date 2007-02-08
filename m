Return-Path: <linux-kernel-owner+w=401wt.eu-S1423306AbXBHUeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423306AbXBHUeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423317AbXBHUeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:34:03 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:36329 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423306AbXBHUeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:34:00 -0500
Date: Thu, 8 Feb 2007 21:32:10 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Jan Glauber <jan.glauber@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] i386/x86_64: smp_call_function locking inconsistency
Message-ID: <20070208203210.GB9798@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On i386/x86_64 smp_call_function_single() takes call_lock with
spin_lock_bh(). To me this would imply that it is legal to call
smp_call_function_single() from softirq context.
It's not since smp_call_function() takes call_lock with just
spin_lock(). We can easily deadlock:

-> [process context]
-> smp_call_function()
-> spin_lock(&call_lock)
-> IRQ -> do_softirq -> tasklet
-> [softirq context]
-> smp_call_function_single()
-> spin_lock_bh(&call_lock)
-> dead

So either all spin_lock_bh's should be converted to spin_lock,
which would limit smp_call_function()/smp_call_function_single()
to process context & irqs enabled.
Or the spin_lock's could be converted to spin_lock_bh which would
make it possible to call these two functions even if in softirq
context. AFAICS this should be safe.

Just stumbled across this since we have the same inconsistency
on s390 and our new iucv driver makes use of smp_call_function
in softirq context.

The patch below converts the spin_lock's in i386/x86_64 to
spin_lock_bh, so it would be consistent with s390.

Patch is _not_ compile tested.

Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/i386/kernel/smp.c   |    8 ++++----
 arch/x86_64/kernel/smp.c |   10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/i386/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/smp.c
+++ linux-2.6/arch/i386/kernel/smp.c
@@ -527,7 +527,7 @@ static struct call_data_struct *call_dat
  * remote CPUs are nearly ready to execute <<func>> or are or have executed.
  *
  * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
+ * hardware interrupt handler.
  */
 int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
 			int wait)
@@ -536,10 +536,10 @@ int smp_call_function (void (*func) (voi
 	int cpus;
 
 	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
+	spin_lock_bh(&call_lock);
 	cpus = num_online_cpus() - 1;
 	if (!cpus) {
-		spin_unlock(&call_lock);
+		spin_unlock_bh(&call_lock);
 		return 0;
 	}
 
@@ -566,7 +566,7 @@ int smp_call_function (void (*func) (voi
 	if (wait)
 		while (atomic_read(&data.finished) != cpus)
 			cpu_relax();
-	spin_unlock(&call_lock);
+	spin_unlock_bh(&call_lock);
 
 	return 0;
 }
Index: linux-2.6/arch/x86_64/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/smp.c
+++ linux-2.6/arch/x86_64/kernel/smp.c
@@ -439,15 +439,15 @@ static void __smp_call_function (void (*
  * remote CPUs are nearly ready to execute func or are or have executed.
  *
  * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
+ * hardware interrupt handler.
  * Actually there are a few legal cases, like panic.
  */
 int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
 			int wait)
 {
-	spin_lock(&call_lock);
+	spin_lock_bh(&call_lock);
 	__smp_call_function(func,info,nonatomic,wait);
-	spin_unlock(&call_lock);
+	spin_unlock_bh(&call_lock);
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
@@ -477,13 +477,13 @@ void smp_send_stop(void)
 	if (reboot_force)
 		return;
 	/* Don't deadlock on the call lock in panic */
-	if (!spin_trylock(&call_lock)) {
+	if (!spin_trylock_bh(&call_lock)) {
 		/* ignore locking because we have panicked anyways */
 		nolock = 1;
 	}
 	__smp_call_function(smp_really_stop_cpu, NULL, 0, 0);
 	if (!nolock)
-		spin_unlock(&call_lock);
+		spin_unlock_bh(&call_lock);
 
 	local_irq_disable();
 	disable_local_APIC();
