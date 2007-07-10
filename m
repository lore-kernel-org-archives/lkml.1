Return-Path: <linux-kernel-owner+w=401wt.eu-S1764156AbXGJVLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764156AbXGJVLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758489AbXGJVLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:11:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52222 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641AbXGJVLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:11:38 -0400
Date: Tue, 10 Jul 2007 23:11:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Dittmer <jdi@l4x.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sched: rename idle_type/SCHED_IDLE
Message-ID: <20070710211133.GA4724@elte.hu>
References: <200707092059.l69Kx1kb026264@hera.kernel.org> <46938363.2000007@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46938363.2000007@l4x.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Dittmer <jdi@l4x.org> wrote:

> This broke s390:

the patch below should fix this.

	Ingo

--------------------->
Subject: [patch] s390: rename CPU_IDLE to S390_CPU_IDLE
From: Heiko Carstens <heiko.carstens@de.ibm.com>

CFS introduces CPU_IDLE in sched.h. This conflicts with the already
existing define in include/asm-s390/processor.h.

Just rename the s390 defines, since they will go away as soon as
we support CONFIG_NO_HZ instead of our own CONFIG_NO_IDLE_HZ.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/s390/kernel/process.c   |    6 +++---
 arch/s390/kernel/time.c      |    4 ++--
 arch/s390/kernel/vtime.c     |    4 ++--
 include/asm-s390/processor.h |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

Index: linux/arch/s390/kernel/process.c
===================================================================
--- linux.orig/arch/s390/kernel/process.c
+++ linux/arch/s390/kernel/process.c
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
Index: linux/arch/s390/kernel/time.c
===================================================================
--- linux.orig/arch/s390/kernel/time.c
+++ linux/arch/s390/kernel/time.c
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
Index: linux/arch/s390/kernel/vtime.c
===================================================================
--- linux.orig/arch/s390/kernel/vtime.c
+++ linux/arch/s390/kernel/vtime.c
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
Index: linux/include/asm-s390/processor.h
===================================================================
--- linux.orig/include/asm-s390/processor.h
+++ linux/include/asm-s390/processor.h
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
