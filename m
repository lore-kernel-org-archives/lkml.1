Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXGQVaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXGQVaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbXGQV3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:29:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49267 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038AbXGQV3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:29:48 -0400
Date: Tue, 17 Jul 2007 22:29:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] smp_call_function_single() should be a macro on UP
Message-ID: <20070717212946.GP21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

... or we end up with header include order problems from hell.
E.g. on m68k this is 100% fatal - local_irq_enable() there
wants preempt_count(), which wants task_struct fields, which
we won't have when we are in smp.h pulled from sched.h.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 8039dac..259a13c 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -7,7 +7,6 @@
  */
 
 #include <linux/errno.h>
-#include <asm/system.h>
 
 extern void cpu_idle(void);
 
@@ -100,15 +99,14 @@ static inline int up_smp_call_function(void)
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
-static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
-					   void *info, int retry, int wait)
-{
-	WARN_ON(cpuid != 0);
-	local_irq_disable();
-	func(info);
-	local_irq_enable();
-	return 0;
-}
+#define smp_call_function_single(cpuid, func, info, retry, wait) \
+({ \
+	WARN_ON(cpuid != 0);	\
+	local_irq_disable();	\
+	(func)(info);		\
+	local_irq_enable();	\
+	0;			\
+})
 
 #endif /* !SMP */
 
