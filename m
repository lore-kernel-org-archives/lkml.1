Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbZAHUiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbZAHUiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZAHUiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:38:11 -0500
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:1568 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbZAHUiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:38:10 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 15:38:09 EST
From: David Daney <ddaney@caviumnetworks.com>
To: rusty@rustcorp.com.au, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] cpumask fallout: Initialize irq_default_affinity earlier.
Date: Thu,  8 Jan 2009 12:21:21 -0800
Message-Id: <1231446081-8448-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.6
X-OriginalArrivalTime: 08 Jan 2009 20:21:26.0317 (UTC) FILETIME=[AE9805D0:01C971CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the initialization of irq_default_affinity to early_irq_init as
core_initcall is too late.

irq_default_affinity can be used in init_IRQ and potentially timer and
SMP init as well.  All of these happen before core_initcall.  Moving
the initialization to early_irq_init ensures that it is initialized
before it is used.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---

Only tested on my mips/cavium_octeon port that (if the benevolent
spirits are willing) will be pushed up from Ralf's linux-mips.org tree
in the very near future.  Also the tested configuration is without
CONFIG_SPARSE_IRQ, so that was not tested, but it should be safe as it
is the same code.

 kernel/irq/handle.c    |    8 ++++++++
 kernel/irq/internals.h |    4 ++++
 kernel/irq/manage.c    |    4 +---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index c20db0b..54802ca 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -134,6 +134,10 @@ int __init early_irq_init(void)
 	int legacy_count;
 	int i;
 
+#ifdef CONFIG_SMP
+	init_irq_default_affinity();
+#endif
+
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 
@@ -219,6 +223,10 @@ int __init early_irq_init(void)
 	int count;
 	int i;
 
+#ifdef CONFIG_SMP
+	init_irq_default_affinity();
+#endif
+
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index e6d0a43..066ff94 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -32,6 +32,10 @@ static inline void unregister_handler_proc(unsigned int irq,
 
 extern int irq_select_affinity_usr(unsigned int irq);
 
+#ifdef CONFIG_SMP
+extern void init_irq_default_affinity(void);
+#endif
+
 /*
  * Debugging printout:
  */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index cd0cd8d..2f87aae 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -18,13 +18,11 @@
 #ifdef CONFIG_SMP
 cpumask_var_t irq_default_affinity;
 
-static int init_irq_default_affinity(void)
+void __init init_irq_default_affinity(void)
 {
 	alloc_cpumask_var(&irq_default_affinity, GFP_KERNEL);
 	cpumask_setall(irq_default_affinity);
-	return 0;
 }
-core_initcall(init_irq_default_affinity);
 
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
-- 
1.5.6.6

