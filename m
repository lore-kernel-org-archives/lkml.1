Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0CDKMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:12:10 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51074 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab0CDKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:10:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 04 Mar 2010 02:08:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/12] x86: set nr_irqs_gsi only in probe_nr_irqs_gsi
In-reply-to: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1267697339-5491-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't clear that in arch_early_irq_init

probe_nr_irqs_gsi is always called when ioapic is selected in config.

so even for mrst, print out from probe_nr_irqs_gsi is report correct
nr_irqs_gsi

-v2: remove io_apic_irqs assignement, setup_IO_APIC will do that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a0fd171..83430a7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -153,11 +153,6 @@ int __init arch_early_irq_init(void)
 	int node;
 	int i;
 
-	if (!legacy_pic->nr_legacy_irqs) {
-		nr_irqs_gsi = 0;
-		io_apic_irqs = ~0UL;
-	}
-
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
 	node= cpu_to_node(boot_cpu_id);
@@ -3887,6 +3882,8 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr = 0;
 
+	nr_irqs_gsi = legacy_pic->nr_legacy_irqs;
+
 	nr = acpi_probe_gsi();
 	if (nr > nr_irqs_gsi) {
 		nr_irqs_gsi = nr;
-- 
1.6.4.2

