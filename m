Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbXIAO1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbXIAO1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 10:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXIAO10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 10:27:26 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54719 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbXIAO1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 10:27:23 -0400
Date: Sat, 1 Sep 2007 10:27:19 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       Greg KH <greg@kroah.com>, len.brown@intel.com,
       linux-ide@vger.kernel.org, dz@debian.org, minyard@acm.org,
       j.w.r.degoede@hhs.nl, lm-sensors@lm-sensors.org, rlove@rlove.org,
       bzolnier@gmail.com, dmitry.torokhov@gmail.com, mzxreary@0pointer.de,
       stelian@popies.net, ibm-acpi@hmh.eng.br, ambx1@neo.rr.com,
       gimli@dark-green.com
Subject: [PATCH] drivers/firmware: const-ify DMI API and internals
Message-ID: <20070901142719.GA31990@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 457b6eb3bf3341d2e143518a0bb99ffbb8d754c4
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Sep 1 10:16:45 2007 -0400

    drivers/firmware: const-ify DMI API and internals
    
    Three main sets of changes:
    
    1) dmi_get_system_info() return value should have been marked const,
       since callers should not be changing that data.
    
    2) const-ify DMI internals, since DMI firmware tables should,
       whenever possible, be marked const to ensure we never ever write to
       that data area.
    
    3) const-ify DMI API, to enable marking tables const where possible
       in low-level drivers.
    
    And if we're really lucky, this might enable some additional
    optimizations on the part of the compiler.
    
    The bulk of the changes are #2 and #3, which are interrelated.  #1 could
    have been a separate patch, but it was so small compared to the others,
    it was easier to roll it into this changeset.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 arch/i386/kernel/apm.c                      |   18 ++++----
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 -
 arch/i386/kernel/reboot.c                   |    2 
 arch/i386/mach-generic/bigsmp.c             |    4 -
 arch/i386/pci/common.c                      |    4 -
 arch/i386/pci/irq.c                         |    4 -
 drivers/acpi/osl.c                          |    2 
 drivers/acpi/processor_idle.c               |    2 
 drivers/acpi/sleep/main.c                   |    2 
 drivers/acpi/thermal.c                      |    8 +--
 drivers/ata/ata_piix.c                      |    4 -
 drivers/ata/pata_ali.c                      |    2 
 drivers/ata/pata_cs5530.c                   |    2 
 drivers/ata/pata_via.c                      |    2 
 drivers/char/i8k.c                          |    4 -
 drivers/char/ipmi/ipmi_si_intf.c            |    9 ++--
 drivers/firmware/dmi_scan.c                 |   57 +++++++++++++++-------------
 drivers/hwmon/abituguru.c                   |    2 
 drivers/hwmon/applesmc.c                    |    2 
 drivers/hwmon/hdaps.c                       |    4 -
 drivers/ide/pci/alim15x3.c                  |    2 
 drivers/ide/pci/via82cxxx.c                 |    2 
 drivers/input/misc/wistron_btns.c           |    2 
 drivers/input/mouse/lifebook.c              |    6 +-
 drivers/input/mouse/synaptics.c             |    2 
 drivers/misc/msi-laptop.c                   |    2 
 drivers/misc/sony-laptop.c                  |    4 -
 drivers/misc/thinkpad_acpi.c                |    2 
 drivers/pnp/pnpbios/core.c                  |    2 
 drivers/usb/host/uhci-hcd.c                 |    2 
 drivers/video/imacfb.c                      |    2 
 include/linux/dmi.h                         |   22 +++++-----
 32 files changed, 97 insertions(+), 91 deletions(-)

457b6eb3bf3341d2e143518a0bb99ffbb8d754c4
diff --git a/arch/i386/kernel/apm.c b/arch/i386/kernel/apm.c
index f02a8ac..32f2365 100644
--- a/arch/i386/kernel/apm.c
+++ b/arch/i386/kernel/apm.c
@@ -1869,7 +1869,7 @@ static struct miscdevice apm_device = {
 
 
 /* Simple "print if true" callback */
-static int __init print_if_true(struct dmi_system_id *d)
+static int __init print_if_true(const struct dmi_system_id *d)
 {
 	printk("%s\n", d->ident);
 	return 0;
@@ -1879,14 +1879,14 @@ static int __init print_if_true(struct dmi_system_id *d)
  * Some Bioses enable the PS/2 mouse (touchpad) at resume, even if it was
  * disabled before the suspend. Linux used to get terribly confused by that.
  */
-static int __init broken_ps2_resume(struct dmi_system_id *d)
+static int __init broken_ps2_resume(const struct dmi_system_id *d)
 {
 	printk(KERN_INFO "%s machine detected. Mousepad Resume Bug workaround hopefully not needed.\n", d->ident);
 	return 0;
 }
 
 /* Some bioses have a broken protected mode poweroff and need to use realmode */
-static int __init set_realmode_power_off(struct dmi_system_id *d)
+static int __init set_realmode_power_off(const struct dmi_system_id *d)
 {
 	if (apm_info.realmode_power_off == 0) {
 		apm_info.realmode_power_off = 1;
@@ -1896,7 +1896,7 @@ static int __init set_realmode_power_off(struct dmi_system_id *d)
 }
 
 /* Some laptops require interrupts to be enabled during APM calls */
-static int __init set_apm_ints(struct dmi_system_id *d)
+static int __init set_apm_ints(const struct dmi_system_id *d)
 {
 	if (apm_info.allow_ints == 0) {
 		apm_info.allow_ints = 1;
@@ -1906,7 +1906,7 @@ static int __init set_apm_ints(struct dmi_system_id *d)
 }
 
 /* Some APM bioses corrupt memory or just plain do not work */
-static int __init apm_is_horked(struct dmi_system_id *d)
+static int __init apm_is_horked(const struct dmi_system_id *d)
 {
 	if (apm_info.disabled == 0) {
 		apm_info.disabled = 1;
@@ -1915,7 +1915,7 @@ static int __init apm_is_horked(struct dmi_system_id *d)
 	return 0;
 }
 
-static int __init apm_is_horked_d850md(struct dmi_system_id *d)
+static int __init apm_is_horked_d850md(const struct dmi_system_id *d)
 {
 	if (apm_info.disabled == 0) {
 		apm_info.disabled = 1;
@@ -1927,7 +1927,7 @@ static int __init apm_is_horked_d850md(struct dmi_system_id *d)
 }
 
 /* Some APM bioses hang on APM idle calls */
-static int __init apm_likes_to_melt(struct dmi_system_id *d)
+static int __init apm_likes_to_melt(const struct dmi_system_id *d)
 {
 	if (apm_info.forbid_idle == 0) {
 		apm_info.forbid_idle = 1;
@@ -1951,7 +1951,7 @@ static int __init apm_likes_to_melt(struct dmi_system_id *d)
  *	Phoenix A04  08/24/2000 is known bad (Dell Inspiron 5000e)
  *	Phoenix A07  09/29/2000 is known good (Dell Inspiron 5000)
  */
-static int __init broken_apm_power(struct dmi_system_id *d)
+static int __init broken_apm_power(const struct dmi_system_id *d)
 {
 	apm_info.get_power_status_broken = 1;
 	printk(KERN_WARNING "BIOS strings suggest APM bugs, disabling power status reporting.\n");
@@ -1962,7 +1962,7 @@ static int __init broken_apm_power(struct dmi_system_id *d)
  * This bios swaps the APM minute reporting bytes over (Many sony laptops
  * have this problem).
  */
-static int __init swab_apm_power_in_minutes(struct dmi_system_id *d)
+static int __init swab_apm_power_in_minutes(const struct dmi_system_id *d)
 {
 	apm_info.get_power_status_swabinminutes = 1;
 	printk(KERN_WARNING "BIOS strings suggest APM reports battery life in minutes and wrong byte order.\n");
diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
index 705e13a..b6434a7 100644
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -533,13 +533,13 @@ static int __init acpi_cpufreq_early_init(void)
  */
 static int bios_with_sw_any_bug;
 
-static int sw_any_bug_found(struct dmi_system_id *d)
+static int sw_any_bug_found(const struct dmi_system_id *d)
 {
 	bios_with_sw_any_bug = 1;
 	return 0;
 }
 
-static struct dmi_system_id sw_any_bug_dmi_table[] = {
+static const struct dmi_system_id sw_any_bug_dmi_table[] = {
 	{
 		.callback = sw_any_bug_found,
 		.ident = "Supermicro Server X6DLP",
diff --git a/arch/i386/kernel/reboot.c b/arch/i386/kernel/reboot.c
index 0d79624..b37ed22 100644
--- a/arch/i386/kernel/reboot.c
+++ b/arch/i386/kernel/reboot.c
@@ -79,7 +79,7 @@ __setup("reboot=", reboot_setup);
 /*
  * Some machines require the "reboot=b"  commandline option, this quirk makes that automatic.
  */
-static int __init set_bios_reboot(struct dmi_system_id *d)
+static int __init set_bios_reboot(const struct dmi_system_id *d)
 {
 	if (!reboot_thru_bios) {
 		reboot_thru_bios = 1;
diff --git a/arch/i386/mach-generic/bigsmp.c b/arch/i386/mach-generic/bigsmp.c
index 58a477b..292a225 100644
--- a/arch/i386/mach-generic/bigsmp.c
+++ b/arch/i386/mach-generic/bigsmp.c
@@ -21,7 +21,7 @@
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
 
-static int hp_ht_bigsmp(struct dmi_system_id *d)
+static int hp_ht_bigsmp(const struct dmi_system_id *d)
 {
 #ifdef CONFIG_X86_GENERICARCH
 	printk(KERN_NOTICE "%s detected: force use of apic=bigsmp\n", d->ident);
@@ -31,7 +31,7 @@ static int hp_ht_bigsmp(struct dmi_system_id *d)
 }
 
 
-static struct dmi_system_id bigsmp_dmi_table[] = {
+static const struct dmi_system_id bigsmp_dmi_table[] = {
 	{ hp_ht_bigsmp, "HP ProLiant DL760 G2", {
 		DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
 		DMI_MATCH(DMI_BIOS_VERSION, "P44-"),
diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index ebc6f3c..07d5223 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -123,7 +123,7 @@ void __devinit  pcibios_fixup_bus(struct pci_bus *b)
  * on the kernel command line (which was parsed earlier).
  */
 
-static int __devinit set_bf_sort(struct dmi_system_id *d)
+static int __devinit set_bf_sort(const struct dmi_system_id *d)
 {
 	if (pci_bf_sort == pci_bf_sort_default) {
 		pci_bf_sort = pci_dmi_bf;
@@ -136,7 +136,7 @@ static int __devinit set_bf_sort(struct dmi_system_id *d)
  * Enable renumbering of PCI bus# ranges to reach all PCI busses (Cardbus)
  */
 #ifdef __i386__
-static int __devinit assign_all_busses(struct dmi_system_id *d)
+static int __devinit assign_all_busses(const struct dmi_system_id *d)
 {
 	pci_probe |= PCI_ASSIGN_ALL_BUSSES;
 	printk(KERN_INFO "%s detected: enabling PCI bus# renumbering"
diff --git a/arch/i386/pci/irq.c b/arch/i386/pci/irq.c
index 665db06..3eee103 100644
--- a/arch/i386/pci/irq.c
+++ b/arch/i386/pci/irq.c
@@ -1009,7 +1009,7 @@ static void __init pcibios_fixup_irqs(void)
  * Work around broken HP Pavilion Notebooks which assign USB to
  * IRQ 9 even though it is actually wired to IRQ 11
  */
-static int __init fix_broken_hp_bios_irq9(struct dmi_system_id *d)
+static int __init fix_broken_hp_bios_irq9(const struct dmi_system_id *d)
 {
 	if (!broken_hp_bios_irq9) {
 		broken_hp_bios_irq9 = 1;
@@ -1022,7 +1022,7 @@ static int __init fix_broken_hp_bios_irq9(struct dmi_system_id *d)
  * Work around broken Acer TravelMate 360 Notebooks which assign
  * Cardbus to IRQ 11 even though it is actually wired to IRQ 10
  */
-static int __init fix_acer_tm360_irqrouting(struct dmi_system_id *d)
+static int __init fix_acer_tm360_irqrouting(const struct dmi_system_id *d)
 {
 	if (!acer_tm360_irqrouting) {
 		acer_tm360_irqrouting = 1;
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 12c09fa..352cf81 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1214,7 +1214,7 @@ acpi_os_validate_address (
 }
 
 #ifdef CONFIG_DMI
-static int dmi_osi_linux(struct dmi_system_id *d)
+static int dmi_osi_linux(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: enabling _OSI(Linux)\n", d->ident);
 	enable_osi_linux(1);
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d9b8af7..fde7b22 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -92,7 +92,7 @@ module_param(bm_history, uint, 0644);
  *
  * To skip this limit, boot/load with a large max_cstate limit.
  */
-static int set_max_cstate(struct dmi_system_id *id)
+static int set_max_cstate(const struct dmi_system_id *id)
 {
 	if (max_cstate > ACPI_PROCESSOR_MAX_POWER)
 		return 0;
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index c52ade8..68825d9 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -189,7 +189,7 @@ static struct pm_ops acpi_pm_ops = {
  * Toshiba fails to preserve interrupts over S1, reinitialization
  * of 8259 is needed after S1 resume.
  */
-static int __init init_ints_after_s1(struct dmi_system_id *d)
+static int __init init_ints_after_s1(const struct dmi_system_id *d)
 {
 	printk(KERN_WARNING "%s with broken S1 detected.\n", d->ident);
 	init_8259A_after_S1 = 1;
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index bc6d586..ad898e1 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1360,7 +1360,7 @@ static int acpi_thermal_resume(struct acpi_device *device)
 }
 
 #ifdef CONFIG_DMI
-static int thermal_act(struct dmi_system_id *d) {
+static int thermal_act(const struct dmi_system_id *d) {
 
 	if (act == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
@@ -1369,14 +1369,14 @@ static int thermal_act(struct dmi_system_id *d) {
 	}
 	return 0;
 }
-static int thermal_nocrt(struct dmi_system_id *d) {
+static int thermal_nocrt(const struct dmi_system_id *d) {
 
 	printk(KERN_NOTICE "ACPI: %s detected: "
 		"disabling all critical thermal trip point actions.\n", d->ident);
 	nocrt = 1;
 	return 0;
 }
-static int thermal_tzp(struct dmi_system_id *d) {
+static int thermal_tzp(const struct dmi_system_id *d) {
 
 	if (tzp == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
@@ -1385,7 +1385,7 @@ static int thermal_tzp(struct dmi_system_id *d) {
 	}
 	return 0;
 }
-static int thermal_psv(struct dmi_system_id *d) {
+static int thermal_psv(const struct dmi_system_id *d) {
 
 	if (psv == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e40c94f..a0861e7 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -919,7 +919,7 @@ static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 #ifdef CONFIG_PM
 static int piix_broken_suspend(void)
 {
-	static struct dmi_system_id sysids[] = {
+	static const struct dmi_system_id sysids[] = {
 		{
 			.ident = "TECRA M5",
 			.matches = {
@@ -1175,7 +1175,7 @@ static void __devinit piix_init_sata_map(struct pci_dev *pdev,
 
 static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
 {
-	static struct dmi_system_id sysids[] = {
+	static const struct dmi_system_id sysids[] = {
 		{
 			/* Clevo M570U sets IOCFG bit 18 if the cdrom
 			 * isn't used to boot the system which
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 94e5edc..e3ab690 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -40,7 +40,7 @@
  *	Cable special cases
  */
 
-static struct dmi_system_id cable_dmi_table[] = {
+static const struct dmi_system_id cable_dmi_table[] = {
 	{
 		.ident = "HP Pavilion N5430",
 		.matches = {
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index c6066aa..eaaea84 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -214,7 +214,7 @@ static struct ata_port_operations cs5530_port_ops = {
 	.port_start	= ata_port_start,
 };
 
-static struct dmi_system_id palmax_dmi_table[] = {
+static const struct dmi_system_id palmax_dmi_table[] = {
 	{
 		.ident = "Palmax PD1100",
 		.matches = {
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index ea18e33..8e7cd0b 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -128,7 +128,7 @@ static const struct via_isa_bridge {
  *	Cable special cases
  */
 
-static struct dmi_system_id cable_dmi_table[] = {
+static const struct dmi_system_id cable_dmi_table[] = {
 	{
 		.ident = "Acer Ferrari 3400",
 		.matches = {
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 0289705..cd40641 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -98,9 +98,9 @@ struct smm_regs {
 	unsigned int edi __attribute__ ((packed));
 };
 
-static inline char *i8k_get_dmi_data(int field)
+static inline const char *i8k_get_dmi_data(int field)
 {
-	char *dmi_data = dmi_get_system_info(field);
+	const char *dmi_data = dmi_get_system_info(field);
 
 	return dmi_data && *dmi_data ? dmi_data : "?";
 }
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 9b07f78..046f456 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1965,10 +1965,10 @@ struct dmi_ipmi_data
 	u8              slave_addr;
 };
 
-static int __devinit decode_dmi(struct dmi_header *dm,
+static int __devinit decode_dmi(const struct dmi_header *dm,
 				struct dmi_ipmi_data *dmi)
 {
-	u8              *data = (u8 *)dm;
+	const u8	*data = (const u8 *)dm;
 	unsigned long  	base_addr;
 	u8		reg_spacing;
 	u8              len = dm->length;
@@ -2091,13 +2091,14 @@ static __devinit void try_init_dmi(struct dmi_ipmi_data *ipmi_data)
 
 static void __devinit dmi_find_bmc(void)
 {
-	struct dmi_device    *dev = NULL;
+	const struct dmi_device *dev = NULL;
 	struct dmi_ipmi_data data;
 	int                  rv;
 
 	while ((dev = dmi_find_device(DMI_DEV_TYPE_IPMI, NULL, dev))) {
 		memset(&data, 0, sizeof(data));
-		rv = decode_dmi((struct dmi_header *) dev->device_data, &data);
+		rv = decode_dmi((const struct dmi_header *) dev->device_data,
+				&data);
 		if (!rv)
 			try_init_dmi(&data);
 	}
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index f7318b3..0cdadea 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -8,9 +8,9 @@
 #include <linux/slab.h>
 #include <asm/dmi.h>
 
-static char * __init dmi_string(struct dmi_header *dm, u8 s)
+static char * __init dmi_string(const struct dmi_header *dm, u8 s)
 {
-	u8 *bp = ((u8 *) dm) + dm->length;
+	const u8 *bp = ((u8 *) dm) + dm->length;
 	char *str = "";
 
 	if (s) {
@@ -37,7 +37,7 @@ static char * __init dmi_string(struct dmi_header *dm, u8 s)
  *	pointing to completely the wrong place for example
  */
 static int __init dmi_table(u32 base, int len, int num,
-			    void (*decode)(struct dmi_header *))
+			    void (*decode)(const struct dmi_header *))
 {
 	u8 *buf, *data;
 	int i = 0;
@@ -53,7 +53,8 @@ static int __init dmi_table(u32 base, int len, int num,
 	 *	OR we run off the end of the table (also happens)
 	 */
 	while ((i < num) && (data - buf + sizeof(struct dmi_header)) <= len) {
-		struct dmi_header *dm = (struct dmi_header *)data;
+		const struct dmi_header *dm = (const struct dmi_header *)data;
+
 		/*
 		 *  We want to know the total length (formated area and strings)
 		 *  before decoding to make sure we won't run off the table in
@@ -71,7 +72,7 @@ static int __init dmi_table(u32 base, int len, int num,
 	return 0;
 }
 
-static int __init dmi_checksum(u8 *buf)
+static int __init dmi_checksum(const u8 *buf)
 {
 	u8 sum = 0;
 	int a;
@@ -89,9 +90,10 @@ int dmi_available;
 /*
  *	Save a DMI string
  */
-static void __init dmi_save_ident(struct dmi_header *dm, int slot, int string)
+static void __init dmi_save_ident(const struct dmi_header *dm, int slot, int string)
 {
-	char *p, *d = (char*) dm;
+	const char *d = (const char*) dm;
+	char *p;
 
 	if (dmi_ident[slot])
 		return;
@@ -103,9 +105,9 @@ static void __init dmi_save_ident(struct dmi_header *dm, int slot, int string)
 	dmi_ident[slot] = p;
 }
 
-static void __init dmi_save_uuid(struct dmi_header *dm, int slot, int index)
+static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int index)
 {
-	u8 *d = (u8*) dm + index;
+	const u8 *d = (u8*) dm + index;
 	char *s;
 	int is_ff = 1, is_00 = 1, i;
 
@@ -132,9 +134,9 @@ static void __init dmi_save_uuid(struct dmi_header *dm, int slot, int index)
         dmi_ident[slot] = s;
 }
 
-static void __init dmi_save_type(struct dmi_header *dm, int slot, int index)
+static void __init dmi_save_type(const struct dmi_header *dm, int slot, int index)
 {
-	u8 *d = (u8*) dm + index;
+	const u8 *d = (u8*) dm + index;
 	char *s;
 
 	if (dmi_ident[slot])
@@ -148,13 +150,13 @@ static void __init dmi_save_type(struct dmi_header *dm, int slot, int index)
 	dmi_ident[slot] = s;
 }
 
-static void __init dmi_save_devices(struct dmi_header *dm)
+static void __init dmi_save_devices(const struct dmi_header *dm)
 {
 	int i, count = (dm->length - sizeof(struct dmi_header)) / 2;
 	struct dmi_device *dev;
 
 	for (i = 0; i < count; i++) {
-		char *d = (char *)(dm + 1) + (i * 2);
+		const char *d = (char *)(dm + 1) + (i * 2);
 
 		/* Skip disabled device */
 		if ((*d & 0x80) == 0)
@@ -173,7 +175,7 @@ static void __init dmi_save_devices(struct dmi_header *dm)
 	}
 }
 
-static void __init dmi_save_oem_strings_devices(struct dmi_header *dm)
+static void __init dmi_save_oem_strings_devices(const struct dmi_header *dm)
 {
 	int i, count = *(u8 *)(dm + 1);
 	struct dmi_device *dev;
@@ -194,7 +196,7 @@ static void __init dmi_save_oem_strings_devices(struct dmi_header *dm)
 	}
 }
 
-static void __init dmi_save_ipmi_device(struct dmi_header *dm)
+static void __init dmi_save_ipmi_device(const struct dmi_header *dm)
 {
 	struct dmi_device *dev;
 	void * data;
@@ -225,7 +227,7 @@ static void __init dmi_save_ipmi_device(struct dmi_header *dm)
  *	and machine entries. For 2.5 we should pull the smbus controller info
  *	out of here.
  */
-static void __init dmi_decode(struct dmi_header *dm)
+static void __init dmi_decode(const struct dmi_header *dm)
 {
 	switch(dm->type) {
 	case 0:		/* BIOS Information */
@@ -265,9 +267,10 @@ static void __init dmi_decode(struct dmi_header *dm)
 	}
 }
 
-static int __init dmi_present(char __iomem *p)
+static int __init dmi_present(const char __iomem *p)
 {
 	u8 buf[15];
+
 	memcpy_fromio(buf, p, 15);
 	if ((memcmp(buf, "_DMI_", 5) == 0) && dmi_checksum(buf)) {
 		u16 num = (buf[13] << 8) | buf[12];
@@ -348,10 +351,10 @@ void __init dmi_scan_machine(void)
  *	returns non zero or we hit the end. Callback function is called for
  *	each successful match. Returns the number of matches.
  */
-int dmi_check_system(struct dmi_system_id *list)
+int dmi_check_system(const struct dmi_system_id *list)
 {
 	int i, count = 0;
-	struct dmi_system_id *d = list;
+	const struct dmi_system_id *d = list;
 
 	while (d->ident) {
 		for (i = 0; i < ARRAY_SIZE(d->matches); i++) {
@@ -380,7 +383,7 @@ EXPORT_SYMBOL(dmi_check_system);
  *	Returns one DMI data value, can be used to perform
  *	complex DMI data checks.
  */
-char *dmi_get_system_info(int field)
+const char *dmi_get_system_info(int field)
 {
 	return dmi_ident[field];
 }
@@ -391,7 +394,7 @@ EXPORT_SYMBOL(dmi_get_system_info);
  *	dmi_name_in_vendors - Check if string is anywhere in the DMI vendor information.
  *	@str: 	Case sensitive Name
  */
-int dmi_name_in_vendors(char *str)
+int dmi_name_in_vendors(const char *str)
 {
 	static int fields[] = { DMI_BIOS_VENDOR, DMI_BIOS_VERSION, DMI_SYS_VENDOR,
 				DMI_PRODUCT_NAME, DMI_PRODUCT_VERSION, DMI_BOARD_VENDOR,
@@ -418,13 +421,15 @@ EXPORT_SYMBOL(dmi_name_in_vendors);
  *	A new search is initiated by passing %NULL as the @from argument.
  *	If @from is not %NULL, searches continue from next device.
  */
-struct dmi_device * dmi_find_device(int type, const char *name,
-				    struct dmi_device *from)
+const struct dmi_device * dmi_find_device(int type, const char *name,
+				    const struct dmi_device *from)
 {
-	struct list_head *d, *head = from ? &from->list : &dmi_devices;
+	const struct list_head *head = from ? &from->list : &dmi_devices;
+	struct list_head *d;
 
 	for(d = head->next; d != &dmi_devices; d = d->next) {
-		struct dmi_device *dev = list_entry(d, struct dmi_device, list);
+		const struct dmi_device *dev =
+			list_entry(d, struct dmi_device, list);
 
 		if (((type == DMI_DEV_TYPE_ANY) || (dev->type == type)) &&
 		    ((name == NULL) || (strcmp(dev->name, name) == 0)))
@@ -444,7 +449,7 @@ EXPORT_SYMBOL(dmi_find_device);
 int dmi_get_year(int field)
 {
 	int year;
-	char *s = dmi_get_system_info(field);
+	const char *s = dmi_get_system_info(field);
 
 	if (!s)
 		return -1;
diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index d575ee9..2317f4b 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -1449,7 +1449,7 @@ static int __init abituguru_init(void)
 	struct resource res = { .flags = IORESOURCE_IO };
 
 #ifdef CONFIG_DMI
-	char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
+	const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
 
 	/* safety check, refuse to load on non Abit motherboards */
 	if (!force && (!board_vendor ||
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 941729a..56213b7 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1071,7 +1071,7 @@ static const struct attribute_group temperature_attributes_group =
 /*
  * applesmc_dmi_match - found a match.  return one, short-circuiting the hunt.
  */
-static int applesmc_dmi_match(struct dmi_system_id *id)
+static int applesmc_dmi_match(const struct dmi_system_id *id)
 {
 	int i = 0;
 	struct dmi_match_data* dmi_data = id->driver_data;
diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
index e0cf5e6..a7c6d40 100644
--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -480,14 +480,14 @@ static struct attribute_group hdaps_attribute_group = {
 /* Module stuff */
 
 /* hdaps_dmi_match - found a match.  return one, short-circuiting the hunt. */
-static int __init hdaps_dmi_match(struct dmi_system_id *id)
+static int __init hdaps_dmi_match(const struct dmi_system_id *id)
 {
 	printk(KERN_INFO "hdaps: %s detected.\n", id->ident);
 	return 1;
 }
 
 /* hdaps_dmi_match_invert - found an inverted match. */
-static int __init hdaps_dmi_match_invert(struct dmi_system_id *id)
+static int __init hdaps_dmi_match_invert(const struct dmi_system_id *id)
 {
 	hdaps_invert = 1;
 	printk(KERN_INFO "hdaps: inverting axis readings.\n");
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 025689d..46d17b4 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -588,7 +588,7 @@ out:
  *	Cable special cases
  */
 
-static struct dmi_system_id cable_dmi_table[] = {
+static const struct dmi_system_id cable_dmi_table[] = {
 	{
 		.ident = "HP Pavilion N5430",
 		.matches = {
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 581316f..92d4ea6 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -418,7 +418,7 @@ static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const
  *	Cable special cases
  */
 
-static struct dmi_system_id cable_dmi_table[] = {
+static const struct dmi_system_id cable_dmi_table[] = {
 	{
 		.ident = "Acer Ferrari 3400",
 		.matches = {
diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
index 60121f1..b438d99 100644
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -247,7 +247,7 @@ static int have_wifi;
 static int have_bluetooth;
 static int have_leds;
 
-static int __init dmi_matched(struct dmi_system_id *dmi)
+static int __init dmi_matched(const struct dmi_system_id *dmi)
 {
 	const struct key_entry *key;
 
diff --git a/drivers/input/mouse/lifebook.c b/drivers/input/mouse/lifebook.c
index 91109b4..608674d 100644
--- a/drivers/input/mouse/lifebook.c
+++ b/drivers/input/mouse/lifebook.c
@@ -27,7 +27,7 @@ struct lifebook_data {
 
 static const char *desired_serio_phys;
 
-static int lifebook_set_serio_phys(struct dmi_system_id *d)
+static int lifebook_set_serio_phys(const struct dmi_system_id *d)
 {
 	desired_serio_phys = d->driver_data;
 	return 0;
@@ -35,13 +35,13 @@ static int lifebook_set_serio_phys(struct dmi_system_id *d)
 
 static unsigned char lifebook_use_6byte_proto;
 
-static int lifebook_set_6byte_proto(struct dmi_system_id *d)
+static int lifebook_set_6byte_proto(const struct dmi_system_id *d)
 {
 	lifebook_use_6byte_proto = 1;
 	return 0;
 }
 
-static struct dmi_system_id lifebook_dmi_table[] = {
+static const struct dmi_system_id lifebook_dmi_table[] = {
 	{
 		.ident = "FLORA-ie 55mi",
 		.matches = {
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 666ad3a..d349c4a 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -602,7 +602,7 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 
 #if defined(__i386__)
 #include <linux/dmi.h>
-static struct dmi_system_id toshiba_dmi_table[] = {
+static const struct dmi_system_id toshiba_dmi_table[] = {
 	{
 		.ident = "Toshiba Satellite",
 		.matches = {
diff --git a/drivers/misc/msi-laptop.c b/drivers/misc/msi-laptop.c
index 932a415..b5365e3 100644
--- a/drivers/misc/msi-laptop.c
+++ b/drivers/misc/msi-laptop.c
@@ -283,7 +283,7 @@ static struct platform_device *msipf_device;
 
 /* Initialization */
 
-static int dmi_check_cb(struct dmi_system_id *id)
+static int dmi_check_cb(const struct dmi_system_id *id)
 {
         printk("msi-laptop: Identified laptop model '%s'.\n", id->ident);
         return 0;
diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index d38ddce..e73a71f 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -807,7 +807,7 @@ static struct sony_nc_event *sony_nc_events;
 /* Vaio C* --maybe also FE*, N* and AR* ?-- special init sequence
  * for Fn keys
  */
-static int sony_nc_C_enable(struct dmi_system_id *id)
+static int sony_nc_C_enable(const struct dmi_system_id *id)
 {
 	int result = 0;
 
@@ -845,7 +845,7 @@ static struct sony_nc_event sony_C_events[] = {
 };
 
 /* SNC-only model map */
-static struct dmi_system_id sony_nc_ids[] = {
+static const struct dmi_system_id sony_nc_ids[] = {
 		{
 			.ident = "Sony Vaio FE Series",
 			.callback = sony_nc_C_enable,
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index bb8956d..6baa995 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -4425,7 +4425,7 @@ static void ibm_exit(struct ibm_struct *ibm)
 
 static void __init get_thinkpad_model_data(struct thinkpad_id_data *tp)
 {
-	struct dmi_device *dev = NULL;
+	const struct dmi_device *dev = NULL;
 	char ec_fw_string[18];
 
 	if (!tp)
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 0691f47..4e9fd37 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -500,7 +500,7 @@ static int __init pnpbios_probe_system(void)
 	return 0;
 }
 
-static int __init exploding_pnp_bios(struct dmi_system_id *d)
+static int __init exploding_pnp_bios(const struct dmi_system_id *d)
 {
 	printk(KERN_WARNING "%s detected. Disabling PnPBIOS\n", d->ident);
 	return 0;
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 805e5fc..4db17f7 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -237,7 +237,7 @@ static int resume_detect_interrupts_are_broken(struct uhci_hcd *uhci)
 static int remote_wakeup_is_broken(struct uhci_hcd *uhci)
 {
 	int port;
-	char *sys_info;
+	const char *sys_info;
 	static char bad_Asus_board[] = "A7V8X";
 
 	/* One of Asus's motherboards has a bug which causes it to
diff --git a/drivers/video/imacfb.c b/drivers/video/imacfb.c
index 18ea4a5..6455fd2 100644
--- a/drivers/video/imacfb.c
+++ b/drivers/video/imacfb.c
@@ -58,7 +58,7 @@ static int model		= M_UNKNOWN;
 static int manual_height;
 static int manual_width;
 
-static int set_system(struct dmi_system_id *id)
+static int set_system(const struct dmi_system_id *id)
 {
 	printk(KERN_INFO "imacfb: %s detected - set system to %ld\n",
 		id->ident, (long)id->driver_data);
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index b8ac7b0..00fc7a9 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -54,7 +54,7 @@ struct dmi_strmatch {
 };
 
 struct dmi_system_id {
-	int (*callback)(struct dmi_system_id *);
+	int (*callback)(const struct dmi_system_id *);
 	const char *ident;
 	struct dmi_strmatch matches[4];
 	void *driver_data;
@@ -71,22 +71,22 @@ struct dmi_device {
 
 #ifdef CONFIG_DMI
 
-extern int dmi_check_system(struct dmi_system_id *list);
-extern char * dmi_get_system_info(int field);
-extern struct dmi_device * dmi_find_device(int type, const char *name,
-	struct dmi_device *from);
+extern int dmi_check_system(const struct dmi_system_id *list);
+extern const char * dmi_get_system_info(int field);
+extern const struct dmi_device * dmi_find_device(int type, const char *name,
+	const struct dmi_device *from);
 extern void dmi_scan_machine(void);
 extern int dmi_get_year(int field);
-extern int dmi_name_in_vendors(char *str);
+extern int dmi_name_in_vendors(const char *str);
 
 #else
 
-static inline int dmi_check_system(struct dmi_system_id *list) { return 0; }
-static inline char * dmi_get_system_info(int field) { return NULL; }
-static inline struct dmi_device * dmi_find_device(int type, const char *name,
-	struct dmi_device *from) { return NULL; }
+static inline int dmi_check_system(const struct dmi_system_id *list) { return 0; }
+static inline const char * dmi_get_system_info(int field) { return NULL; }
+static inline const struct dmi_device * dmi_find_device(int type, const char *name,
+	const struct dmi_device *from) { return NULL; }
 static inline int dmi_get_year(int year) { return 0; }
-static inline int dmi_name_in_vendors(char *s) { return 0; }
+static inline int dmi_name_in_vendors(const char *s) { return 0; }
 
 #endif
 
