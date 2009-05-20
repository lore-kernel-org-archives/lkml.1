Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZETHpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZETHpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZETHpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:45:42 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57943 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZETHpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:45:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Date: Wed, 20 May 2009 00:45:16 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: don't allocate dummy page for wrong madt/mptable
In-reply-to: <4A1393CD.7080604@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <4A13B50C.5080201@sun.com>
References: <4A1393CD.7080604@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in io_apic_init_mapping, if nr_ioapics > 0, we don't need to check
smp_found_config further.

also don't need to allocate dummy pages if we got wrong mptable/madt.
like bad ioapic address. because skip_ioapic_setup already guard that
later.

[ Impact: save 4k when bad mptable/madt or skip_ioapic_setup ]

Sign-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |   48 +++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1887,7 +1887,9 @@ __apicdebuginit(int) print_all_ICs(void)
 		return 0;
 
 	print_all_local_APICs();
-	print_IO_APIC();
+
+	if (!skip_ioapic_setup && nr_ioapics)
+		print_IO_APIC();
 
 	return 0;
 }
@@ -3828,6 +3830,9 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr = 0;
 
+	if (skip_ioapic_setup)
+		return;
+
 	nr = acpi_probe_gsi();
 	if (nr > nr_irqs_gsi) {
 		nr_irqs_gsi = nr;
@@ -4139,29 +4144,26 @@ void __init ioapic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	ioapic_res = ioapic_setup_resources();
+	if (nr_ioapics < 1 || skip_ioapic_setup)
+		return;
+
 	for (i = 0; i < nr_ioapics; i++) {
-		if (smp_found_config) {
-			ioapic_phys = mp_ioapics[i].apicaddr;
-#ifdef CONFIG_X86_32
-			if (!ioapic_phys) {
-				printk(KERN_ERR
-				       "WARNING: bogus zero IO-APIC "
-				       "address found in MPTABLE, "
-				       "disabling IO/APIC support!\n");
-				smp_found_config = 0;
-				skip_ioapic_setup = 1;
-				goto fake_ioapic_page;
-			}
-#endif
-		} else {
-#ifdef CONFIG_X86_32
-fake_ioapic_page:
-#endif
-			ioapic_phys = (unsigned long)
-				alloc_bootmem_pages(PAGE_SIZE);
-			ioapic_phys = __pa(ioapic_phys);
+		ioapic_phys = mp_ioapics[i].apicaddr;
+		if (!ioapic_phys) {
+			printk(KERN_ERR
+			       "WARNING: bogus zero IO-APIC "
+			       "address found in MPTABLE or MADT, "
+			       "disabling IO/APIC support!\n");
+			smp_found_config = 0;
+			skip_ioapic_setup = 1;
+			return;
 		}
+	}
+
+	ioapic_res = ioapic_setup_resources();
+	for (i = 0; i < nr_ioapics; i++) {
+		ioapic_phys = mp_ioapics[i].apicaddr;
+
 		/*
 		 * when acpi ioapic is used, mp_register_ioapic() map
 		 * ioapic_phys already
@@ -4187,7 +4189,7 @@ static int __init ioapic_insert_resource
 	struct resource *r = ioapic_resources;
 
 	if (!r) {
-		if (nr_ioapics > 0) {
+		if (nr_ioapics > 0 && !skip_ioapic_setup) {
 			printk(KERN_ERR
 				"IO APIC resources couldn't be allocated.\n");
 			return -1;
