Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0BXITH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:19:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:45916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab0BXITF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:19:05 -0500
Message-ID: <4B84E09D.4090600@kernel.org>
Date: Wed, 24 Feb 2010 00:17:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: set nr_irqs_gsi only in probe_nr_irqs_gsi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't clear that in arch_early_irq_init

probe_nr_irqs_gsi is always called when ioapic is selected in config.

so even for mrst, print out from probe_nr_irqs_gsi report correct
nr_irqs_gsi

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -151,10 +151,12 @@ int __init arch_early_irq_init(void)
 	int node;
 	int i;
 
-	if (!legacy_pic->nr_legacy_irqs) {
-		nr_irqs_gsi = 0;
+	/*
+	 * in case, io apic is not detected
+	 * then setup_IO_APIC() is not called
+	 */
+	if (!legacy_pic->nr_legacy_irqs)
 		io_apic_irqs = ~0UL;
-	}
 
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
@@ -3857,6 +3859,8 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr = 0;
 
+	nr_irqs_gsi = legacy_pic->nr_legacy_irqs;
+
 	nr = acpi_probe_gsi();
 	if (nr > nr_irqs_gsi) {
 		nr_irqs_gsi = nr;
