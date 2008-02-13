Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbYBMIow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbYBMIow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbYBMIom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:44:42 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:1445 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbYBMIok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:44:40 -0500
Date: Wed, 13 Feb 2008 09:44:00 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Anvin" <hpa@zytor.com>, Matt Mackall <mpm@selenic.com>
Cc: Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] x86: Configure out compilation of Simple Boot Flag
 support
Message-ID: <20080213094400.6b7f3446@crazy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FTpqqCKFNU+k6OZwI8fp2wz";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FTpqqCKFNU+k6OZwI8fp2wz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

The Simple Boot Flag specification support (in
arch/x86/kernel/bootflag.c) is not really needed on embedded platforms,
so it can probably be compiled out. Zwane Mwaikambo did a patch a few
months (years ?) ago to configure out the compilation of that file, and
I've updated the patch to recent versions of the kernel.

However, after writing the patch, I discovered that the space savings
are not that interesting. When Zwane wrote the patch:

   text    data     bss     dec     hex filename
   1645       8       0    1653     675 arch/i386/kernel/bootflag.o

And now:

   text    data     bss     dec     hex filename
    310       8       0     318     13e arch/x86/kernel/bootflag.o

Which means that on the whole kernel, the savings are really small:

   text    data     bss     dec     hex filename
1081314  121464   94208 1296986  13ca5a vmlinux.before
1081106  121460   94208 1296774  13c986 vmlinux.after
   -208      -4       0    -212     -D4 +/-

Is it interesting to add such a patch to the kernel ?

I've enclosed the patch in that mail. Maybe it can considered as a
clean-up patch, because of the move to arch/x86/kernel/bootflag.c of
the acpi_parse_sbf() function ?

(Note: the arch/x86/kernel/acpi/boot.c file calls
acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf) twice, once in
acpi_boot_init() and once in acpi_boot_table_init(). Both functions are
called from setup_arch(), either in the 32bits and 64bits versions.
Can't we remove one of the call to acpi_table_parse() ? The patch below
assumes that the call to acpi_table_parse() has been removed from
acpi_boot_init(), but I can of course change that.)

Thanks for your comments,

Thomas

---

Allow to disable the compilation of Simple Boot Flag specification
support, which allows Linux to tell the BIOS various boot options.

Basically, the patch adds a BOOTFLAG configuration option, on which
the compilation of arch/x86/kernel/bootflag.c depends. The patch also
changes the way sbf_port is initialized by the ACPI initialization
routines. Instead of having sbf_port exported, we rather export the
sbf_acpi_parse() function (formerly known as acpi_parse_buf() and
implemented in the ACPI initialization code).

Result:
   text    data     bss     dec     hex filename
1081314  121464   94208 1296986  13ca5a vmlinux.before
1081106  121460   94208 1296774  13c986 vmlinux.after
   -208      -4       0    -212     -D4 +/-

This patch is part of the Linux Tiny project and is based on previous
work done by Zwane Mwaikambo <zwane@arm.linux.org.uk>.

---
 arch/x86/Kconfig            |    8 ++++++++
 arch/x86/kernel/Makefile    |    3 ++-
 arch/x86/kernel/acpi/boot.c |   17 +----------------
 arch/x86/kernel/bootflag.c  |   18 +++++++++++++++++-
 include/linux/acpi.h        |   10 +++++++++-
 5 files changed, 37 insertions(+), 19 deletions(-)

Index: linux/arch/x86/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -439,6 +439,14 @@
 	  affected by entries in the DMI blacklist. Required by PNP
 	  BIOS code.
=20
+config BOOTFLAG
+	default y
+	bool "Enable Simple Boot Flag specification support" if EMBEDDED
+	depends on ACPI
+	help
+	  Enable support for the Simple Boot Flag specification, that
+	  can be use by Linux to communicate boot options to the BIOS.
+
 config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
Index: linux/arch/x86/kernel/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/Makefile
+++ linux/arch/x86/kernel/Makefile
@@ -15,7 +15,7 @@
 obj-$(CONFIG_X86_32)	+=3D sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+=3D sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+=3D syscall_64.o vsyscall_64.o setup64.o
-obj-y			+=3D pci-dma_$(BITS).o  bootflag.o e820_$(BITS).o
+obj-y			+=3D pci-dma_$(BITS).o e820_$(BITS).o
 obj-y			+=3D quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+=3D alternative.o i8253.o
 obj-$(CONFIG_X86_64)	+=3D pci-nommu_64.o bugs_64.o
@@ -58,6 +58,7 @@
 obj-$(CONFIG_ACPI_SRAT) 	+=3D srat_32.o
 obj-$(CONFIG_EFI) 		+=3D efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+=3D doublefault_32.o
+obj-$(CONFIG_BOOTFLAG)          +=3D bootflag.o
 obj-$(CONFIG_VM86)		+=3D vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+=3D early_printk.o
=20
Index: linux/arch/x86/kernel/acpi/boot.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/acpi/boot.c
+++ linux/arch/x86/kernel/acpi/boot.c
@@ -584,21 +584,6 @@
=20
 EXPORT_SYMBOL(acpi_unregister_ioapic);
=20
-static int __init acpi_parse_sbf(struct acpi_table_header *table)
-{
-	struct acpi_table_boot *sb;
-
-	sb =3D (struct acpi_table_boot *)table;
-	if (!sb) {
-		printk(KERN_WARNING PREFIX "Unable to map SBF\n");
-		return -ENODEV;
-	}
-
-	sbf_port =3D sb->cmos_index;	/* Save CMOS port */
-
-	return 0;
-}
-
 #ifdef CONFIG_HPET_TIMER
 #include <asm/hpet.h>
=20
@@ -1170,7 +1155,7 @@
 		return error;
 	}
=20
-	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
+	acpi_table_parse(ACPI_SIG_BOOT, sbf_acpi_parse);
=20
 	/*
 	 * blacklist may disable ACPI entirely
Index: linux/arch/x86/kernel/bootflag.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/bootflag.c
+++ linux/arch/x86/kernel/bootflag.c
@@ -18,7 +18,7 @@
 #define SBF_DIAG     (1<<2)
 #define SBF_PARITY   (1<<7)
=20
-int sbf_port __initdata =3D -1;	/* set via acpi_boot_init() */
+static int sbf_port __initdata =3D -1;
=20
 static int __init parity(u8 v)
 {
@@ -76,6 +76,22 @@
 	return 1;
 }
=20
+/* called via acpi_boot_init() */
+int __init sbf_acpi_parse(struct acpi_table_header *table)
+{
+	struct acpi_table_boot *sb;
+
+	sb =3D (struct acpi_table_boot *)table;
+	if (!sb) {
+		printk(KERN_WARNING PREFIX "Unable to map SBF\n");
+		return -ENODEV;
+	}
+
+	sbf_port =3D sb->cmos_index;	/* Save CMOS port */
+
+	return 0;
+}
+
 static int __init sbf_init(void)
 {
 	u8 v;
Index: linux/include/linux/acpi.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -119,7 +119,15 @@
 extern struct acpi_mcfg_allocation *pci_mmcfg_config;
 extern int pci_mmcfg_config_num;
=20
-extern int sbf_port;
+#ifdef CONFIG_BOOTFLAG
+int sbf_acpi_parse(struct acpi_table_header *table);
+#else
+static inline int sbf_acpi_parse(struct acpi_table_header *table)
+{
+	return -ENODEV;
+}
+#endif
+
 extern unsigned long acpi_realmode_flags;
=20
 int acpi_register_gsi (u32 gsi, int triggering, int polarity);


--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/FTpqqCKFNU+k6OZwI8fp2wz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsq3Q9lPLMJjT96cRAoABAJ9/0AWsPO2soYD0M4X9xhoa37YeJQCfX/jy
KyOta+ukS+FfDkD80FkStP0=
=gqTR
-----END PGP SIGNATURE-----

--Sig_/FTpqqCKFNU+k6OZwI8fp2wz--
