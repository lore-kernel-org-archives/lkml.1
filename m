Return-Path: <linux-kernel-owner+w=401wt.eu-S1765464AbXGSKCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765464AbXGSKCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758634AbXGSJzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:33050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbXGSJzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:03 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [14/58] x86_64: Add on_cpu_single
Message-Id: <20070719095458.DB13914E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Call a function on a target CPU but do the right thing when 
we're already on that CPU. That's the main difference from smp_call_function_single
which does the wrong thing in this case (erroring out)

Another advantage is that it is also defined for the UP case, avoiding
some ifdefs.

I also dropped retry (which never did anything) and wait (because the on
current cpu case will always wait)
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/smp.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

Index: linux/include/linux/smp.h
===================================================================
--- linux.orig/include/linux/smp.h
+++ linux/include/linux/smp.h
@@ -138,4 +138,26 @@ static inline void smp_send_reschedule(i
 
 void smp_setup_processor_id(void);
 
+#ifdef CONFIG_SMP
+/* Similar to smp_call_function_single, but DTRT when we're already
+   on the right CPU. */
+static inline void on_cpu_single(int cpu, void (*func)(void *), void *info)
+{
+	int me = get_cpu();
+	if (cpu == me) {
+		func(info);
+		put_cpu();
+	} else {
+		put_cpu();
+		/* wait is forced on because the me==cpu case above will always wait */
+		smp_call_function_single(cpu, func, info, 0, 1);
+	}
+}
+#else
+static inline void on_cpu_single(int cpu, void (*func)(void *), void *info)
+{
+	func(info);
+}
+#endif
+
 #endif /* __LINUX_SMP_H */
