Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbYESPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbYESPrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760539AbYESPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:47:06 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41287 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760221AbYESPrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:47:04 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: mp_bus_id_to_pci_bus is not needed
Date: Mon, 19 May 2008 19:47:09 +0400
Message-ID: <20080519154709.15071.79793.stgit@thinkpad>
In-Reply-To: <20080519154656.15071.96979.stgit@thinkpad>
References: <20080519154656.15071.96979.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/io_apic_32.c |    2 +-
 arch/x86/kernel/io_apic_64.c |    2 +-
 arch/x86/kernel/mpparse.c    |   10 ----------
 include/asm-x86/mpspec.h     |    2 --
 4 files changed, 2 insertions(+), 14 deletions(-)


diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 3037aa4..01dfe7c 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -864,7 +864,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 
 	apic_printk(APIC_DEBUG, "querying PCI -> IRQ mapping bus:%d, "
 		"slot:%d, pin:%d.\n", bus, slot, pin);
-	if (mp_bus_id_to_pci_bus[bus] == -1) {
+	if (test_bit(bus, mp_bus_not_pci)) {
 		printk(KERN_WARNING "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
 		return -1;
 	}
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 416154d..e7f7ea7 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -520,7 +520,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 
 	apic_printk(APIC_DEBUG, "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
 		bus, slot, pin);
-	if (mp_bus_id_to_pci_bus[bus] == -1) {
+	if (test_bit(bus, mp_bus_not_pci)) {
 		apic_printk(APIC_VERBOSE, "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
 		return -1;
 	}
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d67cd76..83dfd66 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -41,13 +41,6 @@ int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
 
 DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
-int mp_bus_id_to_pci_bus[MAX_MP_BUSSES] = {[0 ... MAX_MP_BUSSES - 1] = -1 };
-
-static int mp_current_pci_id;
-
-/*
- * Intel MP BIOS table parsing routines:
- */
 
 /*
  * Checksum an MP configuration block.
@@ -101,7 +94,6 @@ static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
 static void __init MP_bus_info(struct mpc_config_bus *m)
 {
 	char str[7];
-
 	memcpy(str, m->mpc_bustype, 6);
 	str[6] = 0;
 
@@ -130,8 +122,6 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 		mpc_oem_pci_bus(m, translation_table[mpc_record]);
 #endif
 		clear_bit(m->mpc_busid, mp_bus_not_pci);
-		mp_bus_id_to_pci_bus[m->mpc_busid] = mp_current_pci_id;
-		mp_current_pci_id++;
 #if defined(CONFIG_EISA) || defined (CONFIG_MCA)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_PCI;
 	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index 57a991b..b785ddd 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -32,8 +32,6 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
-extern int mp_bus_id_to_pci_bus[MAX_MP_BUSSES];
-
 extern unsigned int boot_cpu_physical_apicid;
 extern int smp_found_config;
 extern int mpc_default_type;

