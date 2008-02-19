Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbYBSOqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbYBSOqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbYBSOpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:45:18 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:60351 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYBSOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:45:09 -0500
Message-Id: <20080219144503.680430685@de.ibm.com>
References: <20080219144047.587547541@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 15:40:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/13] Make sure enabled wait psw is loaded in default_idle.
Content-Disposition: inline; filename=004-idle.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

If both NO_IDLE_HZ and VIRT_TIMER are disabled default_idle won't load
an enabled wait psw and busy loop instead. This is because the
idle_chain is empty and the return value of atomic_notifier_call_chain
will be NOTIFY_DONE, which causes default_idle to return instead of
loading an enabled wait psw.
Fix this by calling __atomic_notifier_call_chain instead and add proper
return value handling.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/process.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: quilt-2.6/arch/s390/kernel/process.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/process.c
+++ quilt-2.6/arch/s390/kernel/process.c
@@ -114,24 +114,27 @@ extern void s390_handle_mcck(void);
 static void default_idle(void)
 {
 	int cpu, rc;
+	int nr_calls = 0;
+	void *hcpu;
 #ifdef CONFIG_SMP
 	struct s390_idle_data *idle;
 #endif
 
 	/* CPU is going idle. */
 	cpu = smp_processor_id();
-
+	hcpu = (void *)(long)cpu;
 	local_irq_disable();
 	if (need_resched()) {
 		local_irq_enable();
 		return;
 	}
 
-	rc = atomic_notifier_call_chain(&idle_chain,
-					S390_CPU_IDLE, (void *)(long) cpu);
-	if (rc != NOTIFY_OK && rc != NOTIFY_DONE)
-		BUG();
-	if (rc != NOTIFY_OK) {
+	rc = __atomic_notifier_call_chain(&idle_chain, S390_CPU_IDLE, hcpu, -1,
+					  &nr_calls);
+	if (rc == NOTIFY_BAD) {
+		nr_calls--;
+		__atomic_notifier_call_chain(&idle_chain, S390_CPU_NOT_IDLE,
+					     hcpu, nr_calls, NULL);
 		local_irq_enable();
 		return;
 	}

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

