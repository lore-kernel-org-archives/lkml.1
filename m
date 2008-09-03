Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYICPxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYICPxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYICPx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:53:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:3170 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYICPxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=awzLwvCQKHMizqZU+CMTeRLRgJxLUp5fuAZBNiLoK7IFl7FSEimmGvchgWYRAx0Nxg
         sMOjb6oZop2FFnA/iNIOIdQE/+ERCCfNmPxpwvWOfd75hW2qBPAlGNtR+4vLhfCU1RMi
         gucPlCMI2JgyI5b1C1qJZlX2MaxykfA/fg5Xk=
From: Rui Sousa <rui.p.m.sousa@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATH] Fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
Date: Wed, 3 Sep 2008 17:53:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031753.07292.rui.p.m.sousa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes compilation if CONFIG_TRACE_IRQFLAGS_SUPPORT is ever
disabled (which is currently not allowed by Kconfig). Alternatively
we could just remove the option altogether and the associated code
paths. Since the compilation error has been in the tree for at
least two years and no one noticed it, I guess we don't really have
the need for CONFIG_TRACE_IRQFLAGS_SUPPORT=n.
Boot tested on x86 UP.

Signed-off-by: Rui Sousa <rui.p.m.sousa@gmail.com>

---
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 74bde13..f299351 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -52,10 +52,10 @@
 # define start_critical_timings() do { } while (0)
 #endif
 
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
-
 #include <asm/irqflags.h>
 
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+
 #define local_irq_enable() \
 	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
 #define local_irq_disable() \
@@ -84,21 +84,20 @@
  * The local_irq_*() APIs are equal to the raw_local_irq*()
  * if !TRACE_IRQFLAGS.
  */
-# define raw_local_irq_disable()	local_irq_disable()
-# define raw_local_irq_enable()		local_irq_enable()
-# define raw_local_irq_save(flags)			\
+#define local_irq_disable()		raw_local_irq_disable()
+#define local_irq_enable()		raw_local_irq_enable()
+#define local_irq_save(flags)				\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		local_irq_save(flags);			\
+		raw_local_irq_save(flags);		\
 	} while (0)
-# define raw_local_irq_restore(flags)			\
+# define local_irq_restore(flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		local_irq_restore(flags);		\
+		raw_local_irq_restore(flags);		\
 	} while (0)
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 #define safe_halt()						\
 	do {							\
 		trace_hardirqs_on();				\
@@ -124,6 +123,5 @@
 	typecheck(unsigned long, flags);	\
 	raw_irqs_disabled_flags(flags);		\
 })
-#endif		/* CONFIG_X86 */
 
 #endif
