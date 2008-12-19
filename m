Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbYLSVt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbYLSVt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYLSVtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:49:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:54696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYLSVtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:49:08 -0500
Message-ID: <494C16B2.9000005@kernel.org>
Date: Fri, 19 Dec 2008 13:48:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] sparseirq: fix numa_migrate_irq_desc dependency and comments
References: <20081219235757.6b94d9ef.sfr@canb.auug.org.au> <200812192201.28665.bzolnier@gmail.com> <494C0D28.6040002@kernel.org> <20081219214221.GE2351@elte.hu>
In-Reply-To: <20081219214221.GE2351@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Impact: clean up

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> pointed out config and comments
are not right.

update it depend to NUMA, and fix some comments

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig          |    2 +-
 arch/x86/kernel/io_apic.c |    2 +-
 kernel/irq/numa_migrate.c |   11 +++--------
 3 files changed, 5 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -259,7 +259,7 @@ config SPARSE_IRQ
 
 config NUMA_MIGRATE_IRQ_DESC
 	bool "Move irq desc when changing irq smp_affinity"
-	depends on SPARSE_IRQ && SMP
+	depends on SPARSE_IRQ && NUMA
 	default n
 	help
 	  This enables moving irq_desc to cpu/node that irq will use handled.
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -2519,7 +2519,7 @@ static void irq_complete_move(struct irq
 		if (likely(!cfg->move_desc_pending))
 			return;
 
-		/* domain is not change, but affinity is changed */
+		/* domain has not changed, but affinity did */
 		me = smp_processor_id();
 		if (cpu_isset(me, desc->affinity)) {
 			*descp = desc = move_irq_desc(desc, me);
Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -1,13 +1,8 @@
 /*
- * linux/kernel/irq/handle.c
- *
- * Copyright (C) 1992, 1998-2006 Linus Torvalds, Ingo Molnar
- * Copyright (C) 2005-2006, Thomas Gleixner, Russell King
- *
- * This file contains the core interrupt handling code.
- *
- * Detailed information is available in Documentation/DocBook/genericirq
+ * NUMA irq-desc migration code
  *
+ * Migrate IRQ data structures (irq_desc, chip_data, etc.) over to
+ * the new "home node" of the IRQ.
  */
 
 #include <linux/irq.h>
