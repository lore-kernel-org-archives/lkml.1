Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab0CJLGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:06:08 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:22222 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0CJLFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:05:43 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 06:05:41 EST
X-IronPort-AV: E=Sophos;i="4.49,613,1262581200"; 
   d="scan'208";a="87456559"
From: ijc@hellion.org.uk
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       x86@kernel.org
Subject: [PATCH] x86: irq_desc->chip_data is always correct whether or not SPARSE_IRQ is enabled.
Date: Wed, 10 Mar 2010 10:55:59 +0000
Message-Id: <1268218559-26784-3-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 10 Mar 2010 10:56:12.0082 (UTC) FILETIME=[4C1BF120:01CAC040]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

arch_early_irq_init ensures that in the non-SPARSE_IRQ case that
chip_data is only set for irq < NR_IRQS.

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
index 74d5d96..64a93c8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -178,7 +178,6 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-#ifdef CONFIG_SPARSE_IRQ
 struct ioapic_irq_cfg *ioapic_irq_cfg(unsigned int irq)
 {
 	struct ioapic_irq_cfg *cfg = NULL;
@@ -191,6 +190,8 @@ struct ioapic_irq_cfg *ioapic_irq_cfg(unsigned int irq)
 	return cfg;
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+
 static struct ioapic_irq_cfg *get_one_free_irq_cfg(int node)
 {
 	struct ioapic_irq_cfg *cfg;
@@ -333,16 +334,10 @@ void ioapic_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 /* end for move_irq_desc */
 
 #else
-struct ioapic_irq_cfg *ioapic_irq_cfg(unsigned int irq)
-{
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
-}
-
 int ioapic_init_chip_data(struct irq_desc *desc, int node)
 {
 	return 0;
 }
-
 #endif
 
 struct io_apic {
-- 
1.5.6.5

