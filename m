Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbXF1NkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbXF1NkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbXF1NkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:40:00 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:42943 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbXF1Nj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:39:59 -0400
Date: Thu, 28 Jun 2007 15:39:56 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch -mm] s390: rename CPU_IDLE to S390_CPU_IDLE
Message-ID: <20070628133956.GC4343@osiris.boeblingen.de.ibm.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

sched-cfs-v2.6.22-git-v18.patch introduces CPU_IDLE in sched.h.
This conflict with the already existing define in
include/asm-s390/processor.h
Just rename the s390 defines, since they will go away as soon as
we support CONFIG_NO_HZ instead of our own CONFIG_NO_IDLE_HZ.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/process.c   |    6 +++---
 arch/s390/kernel/time.c      |    4 ++--
 arch/s390/kernel/vtime.c     |    4 ++--
 include/asm-s390/processor.h |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6.22-rc6-mm1/arch/s390/kernel/process.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/s390/kernel/process.c
+++ linux-2.6.22-rc6-mm1/arch/s390/kernel/process.c
@@ -93,8 +93,8 @@ void do_monitor_call(struct pt_regs *reg
 	/* disable monitor call class 0 */
 	__ctl_clear_bit(8, 15);
 
-	atomic_notifier_call_chain(&idle_chain, CPU_NOT_IDLE,
-			    (void *)(long) smp_processor_id());
+	atomic_notifier_call_chain(&idle_chain, S390_CPU_NOT_IDLE,
+				   (void *)(long) smp_processor_id());
 }
 
 extern void s390_handle_mcck(void);
@@ -115,7 +115,7 @@ static void default_idle(void)
 	}
 
 	rc = atomic_notifier_call_chain(&idle_chain,
-			CPU_IDLE, (void *)(long) cpu);
+					S390_CPU_IDLE, (void *)(long) cpu);
 	if (rc != NOTIFY_OK && rc != NOTIFY_DONE)
 		BUG();
 	if (rc != NOTIFY_OK) {
Index: linux-2.6.22-rc6-mm1/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/s390/kernel/time.c
+++ linux-2.6.22-rc6-mm1/arch/s390/kernel/time.c
@@ -226,10 +226,10 @@ static int nohz_idle_notify(struct notif
 			    unsigned long action, void *hcpu)
 {
 	switch (action) {
-	case CPU_IDLE:
+	case S390_CPU_IDLE:
 		stop_hz_timer();
 		break;
-	case CPU_NOT_IDLE:
+	case S390_CPU_NOT_IDLE:
 		start_hz_timer();
 		break;
 	}
Index: linux-2.6.22-rc6-mm1/arch/s390/kernel/vtime.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/s390/kernel/vtime.c
+++ linux-2.6.22-rc6-mm1/arch/s390/kernel/vtime.c
@@ -545,10 +545,10 @@ static int vtimer_idle_notify(struct not
 			      unsigned long action, void *hcpu)
 {
 	switch (action) {
-	case CPU_IDLE:
+	case S390_CPU_IDLE:
 		stop_cpu_timer();
 		break;
-	case CPU_NOT_IDLE:
+	case S390_CPU_NOT_IDLE:
 		start_cpu_timer();
 		break;
 	}
Index: linux-2.6.22-rc6-mm1/include/asm-s390/processor.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/asm-s390/processor.h
+++ linux-2.6.22-rc6-mm1/include/asm-s390/processor.h
@@ -357,8 +357,8 @@ extern void (*s390_base_ext_handler_fn)(
 /*
  * CPU idle notifier chain.
  */
-#define CPU_IDLE	0
-#define CPU_NOT_IDLE	1
+#define S390_CPU_IDLE		0
+#define S390_CPU_NOT_IDLE	1
 
 struct notifier_block;
 int register_idle_notifier(struct notifier_block *nb);
