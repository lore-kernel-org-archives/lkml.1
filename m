Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYBSPzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYBSPzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYBSPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:55:32 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3815 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYBSPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:55:28 -0500
Date: Tue, 19 Feb 2008 16:55:02 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Message-ID: <20080219165502.2c202759@crazy>
In-Reply-To: <20080218041340.f1e46ec9.akpm@linux-foundation.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216211603.bb4f3582.randy.dunlap@oracle.com>
	<20080216214410.b9699910.akpm@linux-foundation.org>
	<20080218111536.511c4fbc@crazy>
	<20080218041340.f1e46ec9.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/dv.pLSa+KW+U_UU_PmWfz0f";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dv.pLSa+KW+U_UU_PmWfz0f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 18 Feb 2008 04:13:40 -0800,
Andrew Morton <akpm@linux-foundation.org> a =C3=A9crit :

> Option 3 wold be to add more #ifdef CONFIG_DMI lines around the
> place.  How ugly would that get?

Like the attached patch. #ifdef CONFIG_DMI everywhere :-(

Sincerly,

Thomas

---

Turn CONFIG_DMI into a selectable option if EMBEDDED is defined, in
order to be able to remove the DMI table scanning code if it's not
needed, and then reduce the kernel code size.

The DMI code users are modified, so that they either depend on
CONFIG_DMI (for the drivers who really need DMI to work) or their
DMI-related code is enclosed in #ifdef CONFIG_DMI.

With CONFIG_DMI (i.e before) :

   text    data     bss     dec     hex filename
1076076  128656   98304 1303036  13e1fc vmlinux

Without CONFIG_DMI (i.e after) :

   text    data     bss     dec     hex filename
1068092  126308   98304 1292704  13b9a0 vmlinux

Result:

   text    data     bss     dec     hex filename
  -7984   -2348       0  -10332   -285c vmlinux

The new option appears in "Processor type and features", only when
CONFIG_EMBEDDED is defined.

This patch is part of the Linux Tiny project, and is based on previous
work done by Matt Mackall <mpm@selenic.com>.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

---
 arch/x86/Kconfig                           |   13 ++++++++++---
 arch/x86/kernel/acpi/boot.c                |    4 ++--
 arch/x86/kernel/acpi/sleep_32.c            |    2 ++
 arch/x86/kernel/apm_32.c                   |    2 ++
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 ++--
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c  |    3 ++-
 arch/x86/kernel/io_delay.c                 |    2 ++
 arch/x86/kernel/reboot.c                   |    2 ++
 arch/x86/kernel/tsc_32.c                   |    2 ++
 arch/x86/mach-generic/bigsmp.c             |    3 ++-
 arch/x86/pci/acpi.c                        |    2 ++
 arch/x86/pci/common.c                      |    2 ++
 arch/x86/pci/fixup.c                       |    5 ++++-
 arch/x86/pci/irq.c                         |    2 ++
 drivers/acpi/sleep/main.c                  |    2 ++
 drivers/ata/ahci.c                         |    2 ++
 drivers/ata/ata_piix.c                     |    4 ++++
 drivers/ata/pata_cs5530.c                  |    2 ++
 drivers/ata/pata_via.c                     |    3 ++-
 drivers/char/Kconfig                       |    2 +-
 drivers/hwmon/Kconfig                      |    2 ++
 drivers/hwmon/abituguru.c                  |    2 --
 drivers/i2c/busses/i2c-piix4.c             |    2 ++
 drivers/ide/ide-acpi.c                     |    3 +++
 drivers/ide/pci/alim15x3.c                 |    3 ++-
 drivers/ide/pci/via82cxxx.c                |    3 ++-
 drivers/input/keyboard/atkbd.c             |    4 ++++
 drivers/input/misc/wistron_btns.c          |    2 ++
 drivers/input/mouse/lifebook.c             |    5 +++--
 drivers/input/mouse/synaptics.c            |    2 +-
 drivers/leds/leds-clevo-mail.c             |    2 ++
 drivers/misc/Kconfig                       |    1 +
 drivers/misc/acer-wmi.c                    |   14 ++++++++------
 drivers/misc/sony-laptop.c                 |    4 ++++
 drivers/net/via-rhine.c                    |    2 ++
 drivers/pnp/pnpbios/core.c                 |    2 ++
 drivers/pnp/quirks.c                       |    2 ++
 drivers/video/Kconfig                      |    2 +-
 include/linux/dmi.h                        |    3 ++-
 39 files changed, 96 insertions(+), 27 deletions(-)

Index: linux/arch/x86/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -90,9 +90,6 @@
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
=20
-config DMI
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !X86_XADD
=20
@@ -433,6 +430,15 @@
=20
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
+config DMI
+	default y
+	bool "Enable DMI scanning" if EMBEDDED
+	help
+	  Enabled scanning of DMI to identify machine quirks. Say Y
+	  here unless you have verified that your setup is not
+	  affected by entries in the DMI blacklist. Required by PNP
+	  BIOS code.
+
 config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
@@ -645,6 +651,7 @@
=20
 config I8K
 	tristate "Dell laptop support"
+	depends on DMI
 	---help---
 	  This adds a driver to safely access the System Management Mode
 	  of the CPU on the Dell Inspiron 8000. The System Management Mode
Index: linux/arch/x86/kernel/acpi/boot.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/acpi/boot.c
+++ linux/arch/x86/kernel/acpi/boot.c
@@ -900,7 +900,7 @@
 	return;
 }
=20
-#ifdef __i386__
+#if defined(__i386__) && defined(CONFIG_DMI)
=20
 static int __init disable_acpi_irq(const struct dmi_system_id *d)
 {
@@ -1121,7 +1121,7 @@
 	{}
 };
=20
-#endif				/* __i386__ */
+#endif				/* __i386__ && CONFIG_DMI */
=20
 /*
  * acpi_boot_table_init() and acpi_boot_init()
Index: linux/arch/x86/kernel/acpi/sleep_32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/acpi/sleep_32.c
+++ linux/arch/x86/kernel/acpi/sleep_32.c
@@ -12,6 +12,7 @@
=20
 #include <asm/smp.h>
=20
+#ifdef CONFIG_DMI
 /* Ouch, we want to delete this. We already have better version in userspa=
ce, in
    s2ram from suspend.sf.net project */
 static __init int reset_videomode_after_s3(const struct dmi_system_id *d)
@@ -30,6 +31,7 @@
 	 },
 	{}
 };
+#endif /* CONFIG_DMI */
=20
 static int __init acpisleep_dmi_init(void)
 {
Index: linux/arch/x86/kernel/apm_32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/apm_32.c
+++ linux/arch/x86/kernel/apm_32.c
@@ -1884,6 +1884,7 @@
 	&apm_bios_fops
 };
=20
+#ifdef CONFIG_DMI
=20
 /* Simple "print if true" callback */
 static int __init print_if_true(const struct dmi_system_id *d)
@@ -2204,6 +2205,7 @@
=20
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 /*
  * Just start the APM thread. We do NOT want to do APM BIOS
Index: linux/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -525,7 +525,7 @@
 	return 0;
 }
=20
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_DMI)
 /*
  * Some BIOSes do SW_ANY coordination internally, either set it up in hw
  * or do it in BIOS firmware and won't inform about it to OS. If not
@@ -592,7 +592,7 @@
 		policy->cpus =3D perf->shared_cpu_map;
 	}
=20
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_DMI)
 	dmi_check_system(sw_any_bug_dmi_table);
 	if (bios_with_sw_any_bug && cpus_weight(policy->cpus) =3D=3D 1) {
 		policy->shared_type =3D CPUFREQ_SHARED_TYPE_ALL;
Index: linux/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ linux/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -564,7 +564,7 @@
 	return (fsb * fid_codes[cfid] / 10);
 }
=20
-
+#ifdef CONFIG_DMI
 static int __init acer_cpufreq_pst(const struct dmi_system_id *d)
 {
 	printk(KERN_WARNING "%s laptop with broken PST tables in BIOS detected.\n=
", d->ident);
@@ -589,6 +589,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int __init powernow_cpu_init (struct cpufreq_policy *policy)
 {
Index: linux/arch/x86/kernel/io_delay.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/io_delay.c
+++ linux/arch/x86/kernel/io_delay.c
@@ -45,6 +45,7 @@
 }
 EXPORT_SYMBOL(native_io_delay);
=20
+#ifdef CONFIG_DMI
 static int __init dmi_io_delay_0xed_port(const struct dmi_system_id *id)
 {
 	if (io_delay_type =3D=3D CONFIG_IO_DELAY_TYPE_0X80) {
@@ -87,6 +88,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 void __init io_delay_init(void)
 {
Index: linux/arch/x86/kernel/reboot.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/reboot.c
+++ linux/arch/x86/kernel/reboot.c
@@ -109,6 +109,7 @@
  * Some machines require the "reboot=3Db"  commandline option,
  * this quirk makes that automatic.
  */
+#ifdef CONFIG_DMI
 static int __init set_bios_reboot(const struct dmi_system_id *d)
 {
 	if (reboot_type !=3D BOOT_BIOS) {
@@ -170,6 +171,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int __init reboot_init(void)
 {
Index: linux/arch/x86/kernel/tsc_32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/tsc_32.c
+++ linux/arch/x86/kernel/tsc_32.c
@@ -322,6 +322,7 @@
 }
 EXPORT_SYMBOL_GPL(mark_tsc_unstable);
=20
+#ifdef CONFIG_DMI
 static int __init dmi_mark_tsc_unstable(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
@@ -342,6 +343,7 @@
 	 },
 	 {}
 };
+#endif /* CONFIG_DMI */
=20
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
Index: linux/arch/x86/mach-generic/bigsmp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/mach-generic/bigsmp.c
+++ linux/arch/x86/mach-generic/bigsmp.c
@@ -21,6 +21,7 @@
=20
 static int dmi_bigsmp; /* can be set by dmi scanners */
=20
+#ifdef CONFIG_DMI
 static int hp_ht_bigsmp(const struct dmi_system_id *d)
 {
 #ifdef CONFIG_X86_GENERICARCH
@@ -43,7 +44,7 @@
 	 }},
 	 { }
 };
-
+#endif /* CONFIG_DMI */
=20
 static int probe_bigsmp(void)
 {=20
Index: linux/arch/x86/pci/acpi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/pci/acpi.c
+++ linux/arch/x86/pci/acpi.c
@@ -6,6 +6,7 @@
 #include <asm/numa.h>
 #include "pci.h"
=20
+#ifdef CONFIG_DMI
 static int __devinit can_skip_ioresource_align(const struct dmi_system_id =
*d)
 {
 	pci_probe |=3D PCI_CAN_SKIP_ISA_ALIGN;
@@ -44,6 +45,7 @@
 	},
 	{}
 };
+#endif /* CONFIG_DMI */
=20
 struct pci_root_info {
 	char *name;
Index: linux/arch/x86/pci/common.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/pci/common.c
+++ linux/arch/x86/pci/common.c
@@ -158,6 +158,7 @@
 		pcibios_fixup_device_resources(dev);
 }
=20
+#ifdef CONFIG_DMI
 /*
  * Only use DMI information to set this if nothing was passed
  * on the kernel command line (which was parsed earlier).
@@ -371,6 +372,7 @@
 	},
 	{}
 };
+#endif /* CONFIG_DMI */
=20
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
Index: linux/arch/x86/pci/fixup.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/pci/fixup.c
+++ linux/arch/x86/pci/fixup.c
@@ -355,7 +355,7 @@
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
=20
-
+#ifdef CONFIG_DMI
 static struct dmi_system_id __devinitdata msi_k8t_dmi_table[] =3D {
 	{
 		.ident =3D "MSI-K8T-Neo2Fir",
@@ -366,6 +366,7 @@
 	},
 	{}
 };
+#endif /* CONFIG_DMI */
=20
 /*
  * The AMD-Athlon64 board MSI "K8T Neo2-FIR" disables the onboard sound
@@ -413,6 +414,7 @@
  */
 static u16 toshiba_line_size;
=20
+#ifdef CONFIG_DMI
 static struct dmi_system_id __devinitdata toshiba_ohci1394_dmi_table[] =3D=
 {
 	{
 		.ident =3D "Toshiba PS5 based laptop",
@@ -437,6 +439,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static void __devinit pci_pre_fixup_toshiba_ohci1394(struct pci_dev *dev)
 {
Index: linux/arch/x86/pci/irq.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/pci/irq.c
+++ linux/arch/x86/pci/irq.c
@@ -1057,6 +1057,7 @@
 	}
 }
=20
+#ifdef CONFIG_DMI
 /*
  * Work around broken HP Pavilion Notebooks which assign USB to
  * IRQ 9 even though it is actually wired to IRQ 11
@@ -1104,6 +1105,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int __init pcibios_irq_init(void)
 {
Index: linux/drivers/acpi/sleep/main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/acpi/sleep/main.c
+++ linux/drivers/acpi/sleep/main.c
@@ -261,6 +261,7 @@
 	.end =3D acpi_pm_end,
 };
=20
+#ifdef CONFIG_DMI
 /*
  * Toshiba fails to preserve interrupts over S1, reinitialization
  * of 8259 is needed after S1 resume.
@@ -280,6 +281,7 @@
 	 },
 	{},
 };
+#endif /* CONFIG_DMI */
 #endif /* CONFIG_SUSPEND */
=20
 #ifdef CONFIG_HIBERNATION
Index: linux/drivers/ata/ahci.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/ata/ahci.c
+++ linux/drivers/ata/ahci.c
@@ -2164,6 +2164,7 @@
  */
 static void ahci_p5wdh_workaround(struct ata_host *host)
 {
+#ifdef CONFIG_DMI
 	static struct dmi_system_id sysids[] =3D {
 		{
 			.ident =3D "P5W DH Deluxe",
@@ -2175,6 +2176,7 @@
 		},
 		{ }
 	};
+#endif /* CONFIG_DMI */
 	struct pci_dev *pdev =3D to_pci_dev(host->dev);
=20
 	if (pdev->bus->number =3D=3D 0 && pdev->devfn =3D=3D PCI_DEVFN(0x1f, 2) &&
Index: linux/drivers/ata/ata_piix.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/ata/ata_piix.c
+++ linux/drivers/ata/ata_piix.c
@@ -1200,6 +1200,7 @@
 #ifdef CONFIG_PM
 static int piix_broken_suspend(void)
 {
+#ifdef CONFIG_DMI
 	static const struct dmi_system_id sysids[] =3D {
 		{
 			.ident =3D "TECRA M3",
@@ -1309,6 +1310,7 @@
=20
 		{ }	/* terminate list */
 	};
+#endif /* CONFIG_DMI */
 	static const char *oemstrs[] =3D {
 		"Tecra M3,",
 	};
@@ -1555,6 +1557,7 @@
=20
 static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
 {
+#ifdef CONFIG_DMI
 	static const struct dmi_system_id sysids[] =3D {
 		{
 			/* Clevo M570U sets IOCFG bit 18 if the cdrom
@@ -1570,6 +1573,7 @@
=20
 		{ }	/* terminate list */
 	};
+#endif /* CONFIG_DMI */
 	u32 iocfg;
=20
 	if (!dmi_check_system(sysids))
Index: linux/drivers/ata/pata_cs5530.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/ata/pata_cs5530.c
+++ linux/drivers/ata/pata_cs5530.c
@@ -212,6 +212,7 @@
 	.port_start	=3D ata_sff_port_start,
 };
=20
+#ifdef CONFIG_DMI
 static const struct dmi_system_id palmax_dmi_table[] =3D {
 	{
 		.ident =3D "Palmax PD1100",
@@ -222,6 +223,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int cs5530_is_palmax(void)
 {
Index: linux/drivers/ata/pata_via.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/ata/pata_via.c
+++ linux/drivers/ata/pata_via.c
@@ -129,7 +129,7 @@
 /*
  *	Cable special cases
  */
-
+#ifdef CONFIG_DMI
 static const struct dmi_system_id cable_dmi_table[] =3D {
 	{
 		.ident =3D "Acer Ferrari 3400",
@@ -140,6 +140,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int via_cable_override(struct pci_dev *pdev)
 {
Index: linux/drivers/char/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/char/Kconfig
+++ linux/drivers/char/Kconfig
@@ -869,7 +869,7 @@
=20
 config SONYPI
 	tristate "Sony Vaio Programmable I/O Control Device support (EXPERIMENTAL=
)"
-	depends on EXPERIMENTAL && X86 && PCI && INPUT && !64BIT
+	depends on EXPERIMENTAL && X86 && PCI && INPUT && !64BIT && DMI
 	---help---
 	  This driver enables access to the Sony Programmable I/O Control
 	  Device which can be found in many (all ?) Sony Vaio laptops.
Index: linux/drivers/hwmon/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/hwmon/Kconfig
+++ linux/drivers/hwmon/Kconfig
@@ -733,6 +733,7 @@
 	tristate "IBM Hard Drive Active Protection System (hdaps)"
 	depends on INPUT && X86
 	select INPUT_POLLDEV
+	select DMI
 	default n
 	help
 	  This driver provides support for the IBM Hard Drive Active Protection
@@ -755,6 +756,7 @@
 	select NEW_LEDS
 	select LEDS_CLASS
 	select INPUT_POLLDEV
+	select DMI
 	default n
 	help
 	  This driver provides support for the Apple System Management
Index: linux/drivers/hwmon/abituguru.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/hwmon/abituguru.c
+++ linux/drivers/hwmon/abituguru.c
@@ -1448,14 +1448,12 @@
 	int address, err;
 	struct resource res =3D { .flags =3D IORESOURCE_IO };
=20
-#ifdef CONFIG_DMI
 	const char *board_vendor =3D dmi_get_system_info(DMI_BOARD_VENDOR);
=20
 	/* safety check, refuse to load on non Abit motherboards */
 	if (!force && (!board_vendor ||
 			strcmp(board_vendor, "http://www.abit.com.tw/")))
 		return -ENODEV;
-#endif
=20
 	address =3D abituguru_detect();
 	if (address < 0)
Index: linux/drivers/i2c/busses/i2c-piix4.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/i2c/busses/i2c-piix4.c
+++ linux/drivers/i2c/busses/i2c-piix4.c
@@ -108,6 +108,7 @@
 static struct pci_driver piix4_driver;
 static struct i2c_adapter piix4_adapter;
=20
+#ifdef CONFIG_DMI
 static struct dmi_system_id __devinitdata piix4_dmi_table[] =3D {
 	{
 		.ident =3D "IBM",
@@ -115,6 +116,7 @@
 	},
 	{ },
 };
+#endif
=20
 static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
 				const struct pci_device_id *id)
Index: linux/drivers/ide/ide-acpi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/ide/ide-acpi.c
+++ linux/drivers/ide/ide-acpi.c
@@ -65,6 +65,8 @@
 extern int ide_noacpionboot;
=20
 static bool ide_noacpi_psx;
+
+#ifdef CONFIG_DMI
 static int no_acpi_psx(const struct dmi_system_id *id)
 {
 	ide_noacpi_psx =3D true;
@@ -86,6 +88,7 @@
=20
 	{ }	/* terminate list */
 };
+#endif /* CONFIG_DMI */
=20
 static int ide_acpi_blacklist(void)
 {
Index: linux/drivers/ide/pci/alim15x3.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/ide/pci/alim15x3.c
+++ linux/drivers/ide/pci/alim15x3.c
@@ -571,7 +571,7 @@
 /*
  *	Cable special cases
  */
-
+#ifdef CONFIG_DMI
 static const struct dmi_system_id cable_dmi_table[] =3D {
 	{
 		.ident =3D "HP Pavilion N5430",
@@ -589,6 +589,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int ali_cable_override(struct pci_dev *pdev)
 {
Index: linux/drivers/ide/pci/via82cxxx.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/ide/pci/via82cxxx.c
+++ linux/drivers/ide/pci/via82cxxx.c
@@ -375,7 +375,7 @@
 /*
  *	Cable special cases
  */
-
+#ifdef CONFIG_DMI
 static const struct dmi_system_id cable_dmi_table[] =3D {
 	{
 		.ident =3D "Acer Ferrari 3400",
@@ -386,6 +386,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int via_cable_override(struct pci_dev *pdev)
 {
Index: linux/drivers/input/keyboard/atkbd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/input/keyboard/atkbd.c
+++ linux/drivers/input/keyboard/atkbd.c
@@ -831,6 +831,7 @@
 	kfree(atkbd);
 }
=20
+#ifdef CONFIG_DMI
 /*
  * Most special keys (Fn+F?) on Dell Latitudes do not generate release
  * events so we have to do it ourselves.
@@ -847,6 +848,7 @@
 			__set_bit(forced_release_keys[i],
 				  atkbd->force_release_mask);
 }
+#endif
=20
 /*
  * atkbd_set_keycode_table() initializes keyboard's keycode table
@@ -1434,6 +1436,7 @@
 	return sprintf(buf, "%lu\n", atkbd->err_count);
 }
=20
+#ifdef CONFIG_DMI
 static int __init atkbd_setup_fixup(const struct dmi_system_id *id)
 {
 	atkbd_platform_fixup =3D id->driver_data;
@@ -1452,6 +1455,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int __init atkbd_init(void)
 {
Index: linux/drivers/input/misc/wistron_btns.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/input/misc/wistron_btns.c
+++ linux/drivers/input/misc/wistron_btns.c
@@ -247,6 +247,7 @@
 static int have_bluetooth;
 static int have_leds;
=20
+#ifdef CONFIG_DMI
 static int __init dmi_matched(const struct dmi_system_id *dmi)
 {
 	const struct key_entry *key;
@@ -916,6 +917,7 @@
 	},
 	{ NULL, }
 };
+#endif /* CONFIG_DMI */
=20
 /* Copy the good keymap, as the original ones are free'd */
 static int __init copy_keymap(void)
Index: linux/drivers/input/mouse/lifebook.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/input/mouse/lifebook.c
+++ linux/drivers/input/mouse/lifebook.c
@@ -26,15 +26,15 @@
 };
=20
 static const char *desired_serio_phys;
+static unsigned char lifebook_use_6byte_proto;
=20
+#ifdef CONFIG_DMI
 static int lifebook_set_serio_phys(const struct dmi_system_id *d)
 {
 	desired_serio_phys =3D d->driver_data;
 	return 0;
 }
=20
-static unsigned char lifebook_use_6byte_proto;
-
 static int lifebook_set_6byte_proto(const struct dmi_system_id *d)
 {
 	lifebook_use_6byte_proto =3D 1;
@@ -112,6 +112,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static psmouse_ret_t lifebook_process_byte(struct psmouse *psmouse)
 {
Index: linux/drivers/input/mouse/synaptics.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/input/mouse/synaptics.c
+++ linux/drivers/input/mouse/synaptics.c
@@ -600,7 +600,7 @@
 	return 0;
 }
=20
-#if defined(__i386__)
+#if defined(__i386__) and defined(CONFIG_DMI)
 #include <linux/dmi.h>
 static const struct dmi_system_id toshiba_dmi_table[] =3D {
 	{
Index: linux/drivers/leds/leds-clevo-mail.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/leds/leds-clevo-mail.c
+++ linux/drivers/leds/leds-clevo-mail.c
@@ -24,6 +24,7 @@
=20
 static struct platform_device *pdev;
=20
+#ifdef CONFIG_DMI
 static int __init clevo_mail_led_dmi_callback(const struct dmi_system_id *=
id)
 {
 	printk(KERN_INFO KBUILD_MODNAME ": '%s' found\n", id->ident);
@@ -79,6 +80,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static void clevo_mail_led_set(struct led_classdev *led_cdev,
 				enum led_brightness value)
Index: linux/drivers/misc/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/misc/Kconfig
+++ linux/drivers/misc/Kconfig
@@ -169,6 +169,7 @@
         depends on X86
         depends on ACPI_EC
         depends on BACKLIGHT_CLASS_DEVICE
+	depends on DMI
         ---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
 	  INTERNATIONAL):
Index: linux/drivers/misc/acer-wmi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/misc/acer-wmi.c
+++ linux/drivers/misc/acer-wmi.c
@@ -189,12 +189,6 @@
 		interface->capability |=3D ACER_CAP_BRIGHTNESS;
 }
=20
-static int dmi_matched(const struct dmi_system_id *dmi)
-{
-	quirks =3D dmi->driver_data;
-	return 0;
-}
-
 static struct quirk_entry quirk_unknown =3D {
 };
=20
@@ -202,11 +196,18 @@
 	.mailled =3D 1,
 };
=20
+#ifdef CONFIG_DMI
 /* This AMW0 laptop has no bluetooth */
 static struct quirk_entry quirk_medion_md_98300 =3D {
 	.wireless =3D 1,
 };
=20
+static int dmi_matched(const struct dmi_system_id *dmi)
+{
+	quirks =3D dmi->driver_data;
+	return 0;
+}
+
 static struct dmi_system_id acer_quirks[] =3D {
 	{
 		.callback =3D dmi_matched,
@@ -282,6 +283,7 @@
 	},
 	{}
 };
+#endif /* CONFIG_DMI */
=20
 /* Find which quirks are needed for a particular vendor/ model pair */
 static void find_quirks(void)
Index: linux/drivers/misc/sony-laptop.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/misc/sony-laptop.c
+++ linux/drivers/misc/sony-laptop.c
@@ -810,6 +810,7 @@
=20
 static struct sony_nc_event *sony_nc_events;
=20
+#ifdef CONFIG_DMI
 /* Vaio C* --maybe also FE*, N* and AR* ?-- special init sequence
  * for Fn keys
  */
@@ -890,6 +891,7 @@
 		},
 		{ }
 };
+#endif /* CONFIG_DMI */
=20
 /*
  * ACPI callbacks
@@ -2716,6 +2718,7 @@
 		},
 };
=20
+#ifdef CONFIG_DMI
 static struct dmi_system_id __initdata sonypi_dmi_table[] =3D {
 	{
 		.ident =3D "Sony Vaio",
@@ -2733,6 +2736,7 @@
 	},
 	{ }
 };
+#endif /* CONFIG_DMI */
=20
 static int __init sony_laptop_init(void)
 {
Index: linux/drivers/net/via-rhine.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/net/via-rhine.c
+++ linux/drivers/net/via-rhine.c
@@ -2001,6 +2001,7 @@
 	.shutdown =3D	rhine_shutdown,
 };
=20
+#ifdef CONFIG_DMI
 static struct dmi_system_id __initdata rhine_dmi_table[] =3D {
 	{
 		.ident =3D "EPIA-M",
@@ -2018,6 +2019,7 @@
 	},
 	{ NULL }
 };
+#endif /* CONFIG_DMI */
=20
 static int __init rhine_init(void)
 {
Index: linux/drivers/pnp/pnpbios/core.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/pnp/pnpbios/core.c
+++ linux/drivers/pnp/pnpbios/core.c
@@ -498,6 +498,7 @@
 	return 0;
 }
=20
+#ifdef CONFIG_DMI
 static int __init exploding_pnp_bios(const struct dmi_system_id *d)
 {
 	printk(KERN_WARNING "%s detected. Disabling PnPBIOS\n", d->ident);
@@ -525,6 +526,7 @@
 	 },
 	{}
 };
+#endif /* CONFIG_DMI */
=20
 static int __init pnpbios_init(void)
 {
Index: linux/drivers/pnp/quirks.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/pnp/quirks.c
+++ linux/drivers/pnp/quirks.c
@@ -112,6 +112,7 @@
 static void quirk_supermicro_h8dce_system(struct pnp_dev *dev)
 {
 	int i;
+#ifdef CONFIG_DMI
 	static struct dmi_system_id supermicro_h8dce[] =3D {
 		{
 			.ident =3D "Supermicro H8DCE",
@@ -122,6 +123,7 @@
 		},
 		{ }
 	};
+#endif /* CONFIG_DMI */
=20
 	if (!dmi_check_system(supermicro_h8dce))
 		return;
Index: linux/drivers/video/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/video/Kconfig
+++ linux/drivers/video/Kconfig
@@ -654,7 +654,7 @@
=20
 config FB_IMAC
 	bool "Intel-based Macintosh Framebuffer Support"
-	depends on (FB =3D y) && X86 && EFI
+	depends on (FB =3D y) && X86 && EFI && DMI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
Index: linux/include/linux/dmi.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/include/linux/dmi.h
+++ linux/include/linux/dmi.h
@@ -86,10 +86,11 @@
=20
 #else
=20
-static inline int dmi_check_system(const struct dmi_system_id *list) { ret=
urn 0; }
+#define dmi_check_system(list) ({ 0; })
 static inline const char * dmi_get_system_info(int field) { return NULL; }
 static inline const struct dmi_device * dmi_find_device(int type, const ch=
ar *name,
 	const struct dmi_device *from) { return NULL; }
+static inline void dmi_scan_machine(void) { return; }
 static inline int dmi_get_year(int year) { return 0; }
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
 #define dmi_available 0


--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/dv.pLSa+KW+U_UU_PmWfz0f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHuvva9lPLMJjT96cRAu40AKCYVyboSxfhESIkAJuvihUU2CLJlACgipKa
IlNP0PoPBDZALawnNboQpxI=
=G0p+
-----END PGP SIGNATURE-----

--Sig_/dv.pLSa+KW+U_UU_PmWfz0f--
