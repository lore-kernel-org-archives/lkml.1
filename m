Return-Path: <linux-kernel-owner+w=401wt.eu-S1763872AbZAHW45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763872AbZAHW45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761001AbZAHW42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:56:28 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:39316 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbZAHW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:56:26 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: rusty@rustcorp.com.au, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, travis@sgi.com,
       David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 2/2] cpumask fallout: Initialize irq_default_affinity earlier (v2).
Date: Thu,  8 Jan 2009 14:55:45 -0800
Message-Id: <1231455345-29453-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <496683D0.6000509@caviumnetworks.com>
References: <496683D0.6000509@caviumnetworks.com>
X-OriginalArrivalTime: 08 Jan 2009 22:55:49.0635 (UTC) FILETIME=[3FF62D30:01C971E4]
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
 kernel/irq/handle.c |   12 ++++++++++++
 kernel/irq/manage.c |    8 --------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index c20db0b..a9fbb01 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -39,6 +39,14 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 	ack_bad_irq(irq);
 }
 
+static inline void __init init_irq_default_affinity(void)
+{
+#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
+	alloc_bootmem_cpumask_var(&irq_default_affinity);
+	cpumask_setall(irq_default_affinity);
+#endif
+}
+
 /*
  * Linux has a controller-independent interrupt architecture.
  * Every controller has a 'controller-template', that is used
@@ -134,6 +142,8 @@ int __init early_irq_init(void)
 	int legacy_count;
 	int i;
 
+	init_irq_default_affinity();
+
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 
@@ -219,6 +229,8 @@ int __init early_irq_init(void)
 	int count;
 	int i;
 
+	init_irq_default_affinity();
+
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 618a64f..291f036 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -18,14 +18,6 @@
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 cpumask_var_t irq_default_affinity;
 
-static int init_irq_default_affinity(void)
-{
-	alloc_cpumask_var(&irq_default_affinity, GFP_KERNEL);
-	cpumask_setall(irq_default_affinity);
-	return 0;
-}
-core_initcall(init_irq_default_affinity);
-
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
-- 
1.5.6.6

