Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683Ab0BZALI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:11:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:59593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593Ab0BZALE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:11:04 -0500
Message-ID: <4B87114C.5020503@kernel.org>
Date: Thu, 25 Feb 2010 16:09:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2] x86: set nr_irqs_gsi only in probe_nr_irqs_gsi
References: <4B84E09D.4090600@kernel.org>
In-Reply-To: <4B84E09D.4090600@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -151,11 +151,6 @@ int __init arch_early_irq_init(void)
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
@@ -3857,6 +3852,8 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr = 0;
 
+	nr_irqs_gsi = legacy_pic->nr_legacy_irqs;
+
 	nr = acpi_probe_gsi();
 	if (nr > nr_irqs_gsi) {
 		nr_irqs_gsi = nr;
