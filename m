Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab0CLJpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:45:34 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34343 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab0CLJpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:45:31 -0500
X-IronPort-AV: E=Sophos;i="4.49,625,1262581200"; 
   d="scan'208";a="87802816"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       x86@kernel.org
Subject: [PATCH] x86: irq_desc->chip_data is always correct whether or not SPARSE_IRQ is enabled.
Date: Fri, 12 Mar 2010 09:45:16 +0000
Message-Id: <1268387116-30522-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1268387091.10129.5973.camel@zakaz.uk.xensource.com>
References: <1268387091.10129.5973.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 12 Mar 2010 09:45:30.0314 (UTC) FILETIME=[C0A502A0:01CAC1C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_early_irq_init ensures that in the non-SPARSE_IRQ case that
chip_data is only set for irq < NR_IRQS which means that the
SPARSE_IRQ version of irq_cfg behaves exactly the same as the
non-SPARSE_IRQ version when SPARSE_IRQ is disabled.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/apic/io_apic.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 12e5cf4..afe81d6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -178,7 +178,6 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-#ifdef CONFIG_SPARSE_IRQ
 struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	struct irq_cfg *cfg = NULL;
@@ -191,6 +190,8 @@ struct irq_cfg *irq_cfg(unsigned int irq)
 	return cfg;
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+
 static struct irq_cfg *get_one_free_irq_cfg(int node)
 {
 	struct irq_cfg *cfg;
@@ -331,16 +332,10 @@ void x86_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 /* end for move_irq_desc */
 
 #else
-struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
-}
-
 int x86_init_chip_data(struct irq_desc *desc, int node)
 {
 	return 0;
 }
-
 #endif
 
 struct io_apic {
-- 
1.5.6.5

