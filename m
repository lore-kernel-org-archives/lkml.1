Return-Path: <linux-kernel-owner+w=401wt.eu-S969773AbXG3WbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969773AbXG3WbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940003AbXG3WaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:30:10 -0400
Received: from static-72-72-73-123.bstnma.east.verizon.net ([72.72.73.123]:27259
	"EHLO mail.sicortex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940117AbXG3WaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:30:08 -0400
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 18:30:08 EDT
From: pwatkins@sicortex.com
To: eranian@hpl.hp.com, heiko.carstens@de.ibm.com
Cc: pwatkins@sicortex.com, mucci@cs.utk.edu, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, ak@suse.de,
       akpm@linux-foundation.org, tony.luck@intel.com, avi@qumranet.com
Subject: Re: [PATCH] MIPS: Add smp_call_function_single()
Date: Mon, 30 Jul 2007 18:01:29 -0400
Message-Id: <11858328891389-git-send-email-pwatkins@sicortex.com>
X-Mailer: git-send-email 1.4.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about this to handle the "call yourself" semantic?

In the other archs, there is more factoring of smp call code, and more care in
the use of get_cpu(). That can be a follow-up MIPS patch.

Signed-off-by: Peter Watkins <pwatkins@sicortex.com>

---
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 67edfa7..33712ff 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -203,6 +203,61 @@ void smp_call_function_interrupt(void)
 	}
 }
 
+int smp_call_function_single (int cpu, void (*func) (void *info), void *info, int retry,
+			      int wait)
+{
+	struct call_data_struct data;
+	int me;
+
+	/*
+	 * Can die spectacularly if this CPU isn't yet marked online
+	 */
+	if (!cpu_online(cpu))
+		return 0;
+
+	me = get_cpu();
+	BUG_ON(!cpu_online(me));
+
+	if (cpu == me) {
+		local_irq_disable()
+		func(info);
+		local_irq_enable();
+		put_cpu();
+		return 0;
+	}
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	spin_lock(&smp_call_lock);
+	call_data = &data;
+	smp_mb();
+
+	/* Send a message to the other CPU */
+	core_send_ipi(cpu, SMP_CALL_FUNCTION);
+
+	/* Wait for response */
+	/* FIXME: lock-up detection, backtrace on lock-up */
+	while (atomic_read(&data.started) != 1)
+		barrier();
+
+	if (wait)
+		while (atomic_read(&data.finished) != 1)
+			barrier();
+	call_data = NULL;
+	spin_unlock(&smp_call_lock);
+
+	put_cpu();
+	return 0;
+}
+
 static void stop_this_cpu(void *dummy)
 {
 	/*
