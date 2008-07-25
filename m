Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYGYJSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYGYJSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYGYJSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:18:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:13081 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbYGYJSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=o3qTGt8K0jl/0akDe+8lbNLDchTugPQvEljLgobPa1DvOeN/ZDx/F+a0cZqtQFUdqN
         0Y0lcFipIQirUtOENk0qVguxfd1mwWSf42Q4/NqH8lo9sbfwZe0hHD1KrT8YjDWbp+5+
         pTU9A5i2l+y1WXOgMs5R1sJ+S1VMk5UKHdP4E=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: add setup_ioapic_ids for numaq in x86_quirks
Date: Fri, 25 Jul 2008 02:14:28 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807250214.28786.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_32.c |    5 ++---
 arch/x86/kernel/numaq_32.c   |    7 +++++++
 include/asm-x86/setup.h      |    1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -46,6 +46,7 @@
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
+#include <asm/setup.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
@@ -1739,10 +1740,8 @@ static void __init setup_ioapic_ids_from
 	unsigned char old_id;
 	unsigned long flags;
 
-#ifdef CONFIG_X86_NUMAQ
-	if (found_numaq)
+	if (x86_quirks->setup_ioapic_ids && x86_quirks->setup_ioapic_ids())
 		return;
-#endif
 
 	/*
 	 * Don't check I/O APIC IDs for xAPIC systems.  They have
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -229,6 +229,12 @@ static void __init smp_read_mpc_oem(stru
 	}
 }
 
+static int __init numaq_setup_ioapic_ids(void)
+{
+	/* so can skip it */
+	return 1;
+}
+
 static struct x86_quirks numaq_x86_quirks __initdata = {
 	.arch_pre_time_init	= numaq_pre_time_init,
 	.arch_time_init		= NULL,
@@ -243,6 +249,7 @@ static struct x86_quirks numaq_x86_quirk
 	.mpc_oem_bus_info	= mpc_oem_bus_info,
 	.mpc_oem_pci_bus	= mpc_oem_pci_bus,
 	.smp_read_mpc_oem	= smp_read_mpc_oem,
+	.setup_ioapic_ids	= numaq_setup_ioapic_ids,
 };
 
 void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -38,6 +38,7 @@ struct x86_quirks {
 	void (*mpc_oem_pci_bus)(struct mpc_config_bus *m);
 	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
                                     unsigned short oemsize);
+	int (*setup_ioapic_ids)(void);
 };
 
 extern struct x86_quirks *x86_quirks;
