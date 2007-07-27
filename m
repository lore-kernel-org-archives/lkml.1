Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbXG0Mqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbXG0Mqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXG0Mq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:46:29 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59817 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbXG0Mq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:46:29 -0400
Date: Fri, 27 Jul 2007 05:44:51 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: mucci@cs.utk.edu, ralf@linux-mips.org, linux-mips@linux-mips.org,
       ak@suse.de, akpm@linux-foundation.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: [PATCH] MIPS: add smp_call_function_single()
Message-ID: <20070727124451.GC9828@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    [MIPS] add smp_call_function_single()
    
    signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
    signed-off-by: Phil Mucci <mucci@cs.utk.edu>

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index be7362b..9e376e2 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -193,6 +193,53 @@ void smp_call_function_interrupt(void)
 	}
 }
 
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int retry,
+			     int wait)
+{
+  struct call_data_struct data;
+  int me = smp_processor_id();
+
+  /*
+     * Can die spectacularly if this CPU isn't yet marked online
+      */
+  BUG_ON(!cpu_online(me));
+  if (cpu == me) {
+    WARN_ON(1);
+    return -EBUSY;
+    }
+
+  /* Can deadlock when called with interrupts disabled */
+  WARN_ON(irqs_disabled());
+
+  data.func = func;
+  data.info = info;
+  atomic_set(&data.started, 0);
+  data.wait = wait;
+  if (wait)
+    atomic_set(&data.finished, 0);
+
+  spin_lock(&smp_call_lock);
+  call_data = &data;
+  mb();
+
+  /* Send a message to the other CPU */
+  core_send_ipi(cpu, SMP_CALL_FUNCTION);
+
+  /* Wait for response */
+  /* FIXME: lock-up detection, backtrace on lock-up */
+  while (atomic_read(&data.started) != 1)
+    barrier();
+
+  if (wait)
+    while (atomic_read(&data.finished) != 1)
+      barrier();
+  call_data = NULL;
+  spin_unlock(&smp_call_lock);
+
+  return 0;
+}
+EXPORT_SYMBOL(smp_call_function_single);
+
 static void stop_this_cpu(void *dummy)
 {
 	/*
diff --git a/include/asm-mips/smp.h b/include/asm-mips/smp.h
index 13aef6a..5acbf38 100644
--- a/include/asm-mips/smp.h
+++ b/include/asm-mips/smp.h
@@ -102,6 +102,8 @@ static inline void smp_send_reschedule(int cpu)
 	core_send_ipi(cpu, SMP_RESCHEDULE_YOURSELF);
 }
 
+extern int smp_call_function_single(int cpuid, void (*func) (void *info),
+				void *info, int retry, int wait);
 extern asmlinkage void smp_call_function_interrupt(void);
 
 #endif /* CONFIG_SMP */
