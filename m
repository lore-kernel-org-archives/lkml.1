Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbZHIQCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbZHIQCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 12:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZHIQCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 12:02:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZHIQCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 12:02:03 -0400
Date: Sun, 9 Aug 2009 18:01:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090809160146.GA25826@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Alok Kataria (1):
      x86: Fix VMI && stack protector

Ozan Çağlayan (1):
      x86: Add quirk to make Apple MacBookPro5,1 use reboot=pci

Roel Kluin (1):
      x86: fix buffer overflow in efi_init()

Yinghai Lu (1):
      x86: Fix MSI-X initialization by using online_mask for x2apic target_cpus


 arch/x86/kernel/apic/x2apic_cluster.c |    8 +++++---
 arch/x86/kernel/apic/x2apic_phys.c    |    8 +++++---
 arch/x86/kernel/efi.c                 |    2 +-
 arch/x86/kernel/reboot.c              |   10 +++++++++-
 arch/x86/kernel/vmi_32.c              |    2 +-
 5 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 2ed4e2b..a5371ec 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -17,11 +17,13 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled();
 }
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
+/*
+ * need to use more than cpu 0, because we need more vectors when
+ * MSI-X are used.
+ */
 static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 0b631c6..a8989aa 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -27,11 +27,13 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		return 0;
 }
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
+/*
+ * need to use more than cpu 0, because we need more vectors when
+ * MSI-X are used.
+ */
 static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 19ccf6d..fe26ba3 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -354,7 +354,7 @@ void __init efi_init(void)
 	 */
 	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
 	if (c16) {
-		for (i = 0; i < sizeof(vendor) && *c16; ++i)
+		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 834c9da..9eb8976 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -405,7 +405,7 @@ EXPORT_SYMBOL(machine_real_restart);
 #endif /* CONFIG_X86_32 */
 
 /*
- * Apple MacBook5,2 (2009 MacBook) needs reboot=p
+ * Some Apple MacBook and MacBookPro's needs reboot=p to be able to reboot
  */
 static int __init set_pci_reboot(const struct dmi_system_id *d)
 {
@@ -426,6 +426,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,2"),
 		},
 	},
+	{	/* Handle problems with rebooting on Apple MacBookPro5,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBookPro5,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,1"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index b263423..95a7289 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -441,7 +441,7 @@ vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 	ap.ds = __USER_DS;
 	ap.es = __USER_DS;
 	ap.fs = __KERNEL_PERCPU;
-	ap.gs = 0;
+	ap.gs = __KERNEL_STACK_CANARY;
 
 	ap.eflags = 0;
 
