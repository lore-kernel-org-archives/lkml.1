Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbYBOLAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbYBOLAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbYBOLAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:00:41 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:2113 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYBOLAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:00:39 -0500
Date: Fri, 15 Feb 2008 12:00:23 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Mackall <mpm@selenic.com>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC] [PATCH] x86: Use ELF section to list CPU vendor specific code
 (Linux Tiny)
Message-ID: <20080215120023.252647bd@crazy>
In-Reply-To: <47B0EE46.6050208@zytor.com>
References: <200802082347.25364.michael-lists@free-electrons.com>
	<20080208231130.GA10511@elte.hu>
	<200802112342.23493.michael-lists@free-electrons.com>
	<1202770566.12383.59.camel@cinder.waste.org>
	<47B0D3B7.6070308@zytor.com>
	<1202772532.12383.67.camel@cinder.waste.org>
	<47B0EE46.6050208@zytor.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Xhht4=aU70jf4E75wAyE=uy";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Xhht4=aU70jf4E75wAyE=uy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le Mon, 11 Feb 2008 16:54:30 -0800,
"H. Peter Anvin" <hpa@zytor.com> a =C3=A9crit :

> b) would be my first choice, and yes, it would be a good thing to
> have a generalized mechanism for this.  For the registrant, it's
> pretty easy: just add a macro that adds a pointer to a named
> section.  We then need a way to get the base address and length of
> each such section in order to be able to execute each function in
> sequence.

You'll find below a tentative patch that implements this. Tuple
(vendor, pointer to cpu_dev structure) are stored in a
x86cpuvendor.init section of the kernel, which is then read by the
generic CPU code in arch/x86/kernel/cpu/common.c to fill the cpu_devs[]
function.

Moreover the early_init_...() calls are integrated into that mechanism
using a new c_early_init() member of the cpu_dev structure.

The patch is for review only at the moment. Disabling compilation of
unused CPU support code will be done in a separate patch (I've taken
over Michael Opdenacker's work for the moment, with his agreement).

Thanks for your review and comments,

Thomas

---

Replace the hardcoded list of initialization functions for each CPU
vendor by a list in an ELF section, which is read at initialization in
arch/x86/kernel/cpu/cpu.c to fill the cpu_devs[] array. The ELF
section, named .x86cpuvendor.init, is reclaimed after boot, and
contains entries of type "struct cpu_vendor_dev" which associates a
vendor number with a pointer to a "struct cpu_dev" structure.

This first modification allows to remove all the VENDOR_init_cpu()
functions.

This patch also removes the hardcoded calls to early_init_amd() and
early_init_intel(). Instead, we add a "c_early_init" member to the
cpu_dev structure, which is then called if not NULL by the generic CPU
initialization code. Unfortunately, in early_cpu_detect(), this_cpu is
not yet set, so we have to use the cpu_devs[] array directly.

This patch is part of the Linux Tiny project, and is needed for
further patch that will allow to disable compilation of unused CPU
support code.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

---
 arch/x86/kernel/cpu/amd.c        |    5 ++++-
 arch/x86/kernel/cpu/centaur.c    |    6 +-----
 arch/x86/kernel/cpu/common.c     |   33 ++++++++++-----------------------
 arch/x86/kernel/cpu/cpu.h        |   26 +++++++++++++-------------
 arch/x86/kernel/cpu/cyrix.c      |   13 ++-----------
 arch/x86/kernel/cpu/intel.c      |    9 +++------
 arch/x86/kernel/cpu/transmeta.c  |    6 +-----
 arch/x86/kernel/cpu/umc.c        |    7 ++-----
 arch/x86/kernel/vmlinux_32.lds.S |    5 +++++
 arch/x86/kernel/vmlinux_64.lds.S |    5 +++++
 10 files changed, 46 insertions(+), 69 deletions(-)

Index: linux/arch/x86/kernel/cpu/amd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/amd.c
+++ linux/arch/x86/kernel/cpu/amd.c
@@ -63,7 +63,7 @@
=20
 int force_mwait __cpuinitdata;
=20
-void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpuid_eax(0x80000000) >=3D 0x80000007) {
 		c->x86_power =3D cpuid_edx(0x80000007);
@@ -336,6 +336,7 @@
 		  }
 		},
 	},
+	.c_early_init   =3D early_init_amd,
 	.c_init		=3D init_amd,
 	.c_size_cache	=3D amd_size_cache,
 };
@@ -345,3 +346,5 @@
 	cpu_devs[X86_VENDOR_AMD] =3D &amd_cpu_dev;
 	return 0;
 }
+
+cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
Index: linux/arch/x86/kernel/cpu/centaur.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/centaur.c
+++ linux/arch/x86/kernel/cpu/centaur.c
@@ -464,8 +464,4 @@
 	.c_size_cache	=3D centaur_size_cache,
 };
=20
-int __init centaur_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_CENTAUR] =3D &centaur_cpu_dev;
-	return 0;
-}
+cpu_vendor_dev_register(X86_VENDOR_CENTAUR, &centaur_cpu_dev);
Index: linux/arch/x86/kernel/cpu/common.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -328,14 +328,9 @@
=20
 	get_cpu_vendor(c, 1);
=20
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		early_init_amd(c);
-		break;
-	case X86_VENDOR_INTEL:
-		early_init_intel(c);
-		break;
-	}
+	if (c->x86_vendor !=3D X86_VENDOR_UNKNOWN &&
+	    cpu_devs[c->x86_vendor]->c_early_init)
+		cpu_devs[c->x86_vendor]->c_early_init(c);
=20
 	early_get_cap(c);
 }
@@ -616,23 +611,15 @@
=20
 cpumask_t cpu_initialized __cpuinitdata =3D CPU_MASK_NONE;
=20
-/* This is hacky. :)
- * We're emulating future behavior.
- * In the future, the cpu-specific init functions will be called implicitly
- * via the magic of initcalls.
- * They will insert themselves into the cpu_devs structure.
- * Then, when cpu_init() is called, we can just iterate over that array.
- */
 void __init early_cpu_init(void)
 {
-	intel_cpu_init();
-	cyrix_init_cpu();
-	nsc_init_cpu();
-	amd_init_cpu();
-	centaur_init_cpu();
-	transmeta_init_cpu();
-	nexgen_init_cpu();
-	umc_init_cpu();
+	struct cpu_vendor_dev *cvdev;
+
+	for (cvdev =3D __x86cpuvendor_start ;
+	     cvdev < __x86cpuvendor_end   ;
+	     cvdev++)
+		cpu_devs[cvdev->vendor] =3D cvdev->cpu_dev;
+
 	early_cpu_detect();
 }
=20
Index: linux/arch/x86/kernel/cpu/cpu.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/cpu.h
+++ linux/arch/x86/kernel/cpu/cpu.h
@@ -14,6 +14,7 @@
=20
 	struct		cpu_model_info c_models[4];
=20
+	void            (*c_early_init)(struct cpuinfo_x86 *c);
 	void		(*c_init)(struct cpuinfo_x86 * c);
 	void		(*c_identify)(struct cpuinfo_x86 * c);
 	unsigned int	(*c_size_cache)(struct cpuinfo_x86 * c, unsigned int size);
@@ -21,18 +22,17 @@
=20
 extern struct cpu_dev * cpu_devs [X86_VENDOR_NUM];
=20
-extern int get_model_name(struct cpuinfo_x86 *c);
-extern void display_cacheinfo(struct cpuinfo_x86 *c);
+struct cpu_vendor_dev {
+	int vendor;
+	struct cpu_dev *cpu_dev;
+};
=20
-extern void early_init_intel(struct cpuinfo_x86 *c);
-extern void early_init_amd(struct cpuinfo_x86 *c);
+#define cpu_vendor_dev_register(cpu_vendor_id, cpu_dev) \
+	static struct cpu_vendor_dev __cpu_vendor_dev_##cpu_vendor_id __used \
+	__attribute__((__section__(".x86cpuvendor.init"))) =3D \
+	{ cpu_vendor_id, cpu_dev }
=20
-/* Specific CPU type init functions */
-int intel_cpu_init(void);
-int amd_init_cpu(void);
-int cyrix_init_cpu(void);
-int nsc_init_cpu(void);
-int centaur_init_cpu(void);
-int transmeta_init_cpu(void);
-int nexgen_init_cpu(void);
-int umc_init_cpu(void);
+extern struct cpu_vendor_dev __x86cpuvendor_start[], __x86cpuvendor_end[];
+
+extern int get_model_name(struct cpuinfo_x86 *c);
+extern void display_cacheinfo(struct cpuinfo_x86 *c);
Index: linux/arch/x86/kernel/cpu/cyrix.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/cyrix.c
+++ linux/arch/x86/kernel/cpu/cyrix.c
@@ -439,11 +439,7 @@
 	.c_identify	=3D cyrix_identify,
 };
=20
-int __init cyrix_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_CYRIX] =3D &cyrix_cpu_dev;
-	return 0;
-}
+cpu_vendor_dev_register(X86_VENDOR_CYRIX, &cyrix_cpu_dev);
=20
 static struct cpu_dev nsc_cpu_dev __cpuinitdata =3D {
 	.c_vendor	=3D "NSC",
@@ -451,9 +447,4 @@
 	.c_init		=3D init_nsc,
 };
=20
-int __init nsc_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_NSC] =3D &nsc_cpu_dev;
-	return 0;
-}
-
+cpu_vendor_dev_register(X86_VENDOR_NSC, &nsc_cpu_dev);
Index: linux/arch/x86/kernel/cpu/intel.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/intel.c
+++ linux/arch/x86/kernel/cpu/intel.c
@@ -30,7 +30,7 @@
 struct movsl_mask movsl_mask __read_mostly;
 #endif
=20
-void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
+static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
 	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
 	if (c->x86 =3D=3D 15 && c->x86_cache_alignment =3D=3D 64)
@@ -290,15 +290,12 @@
 		  }
 		},
 	},
+	.c_early_init   =3D early_init_intel,
 	.c_init		=3D init_intel,
 	.c_size_cache	=3D intel_size_cache,
 };
=20
-__init int intel_cpu_init(void)
-{
-	cpu_devs[X86_VENDOR_INTEL] =3D &intel_cpu_dev;
-	return 0;
-}
+cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
=20
 #ifndef CONFIG_X86_CMPXCHG
 unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
Index: linux/arch/x86/kernel/cpu/transmeta.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/transmeta.c
+++ linux/arch/x86/kernel/cpu/transmeta.c
@@ -109,8 +109,4 @@
 	.c_identify	=3D transmeta_identify,
 };
=20
-int __init transmeta_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_TRANSMETA] =3D &transmeta_cpu_dev;
-	return 0;
-}
+cpu_vendor_dev_register(X86_VENDOR_TRANSMETA, &transmeta_cpu_dev);
Index: linux/arch/x86/kernel/cpu/umc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/cpu/umc.c
+++ linux/arch/x86/kernel/cpu/umc.c
@@ -19,8 +19,5 @@
 	},
 };
=20
-int __init umc_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_UMC] =3D &umc_cpu_dev;
-	return 0;
-}
+cpu_vendor_dev_register(X86_VENDOR_UMC, &umc_cpu_dev);
+
Index: linux/arch/x86/kernel/vmlinux_32.lds.S
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux/arch/x86/kernel/vmlinux_32.lds.S
@@ -149,6 +149,11 @@
 	*(.con_initcall.init)
   	__con_initcall_end =3D .;
   }
+  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
+	__x86cpuvendor_start =3D .;
+	*(.x86cpuvendor.init)
+	__x86cpuvendor_end =3D .;
+  }
   SECURITY_INIT
   . =3D ALIGN(4);
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
Index: linux/arch/x86/kernel/vmlinux_64.lds.S
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux/arch/x86/kernel/vmlinux_64.lds.S
@@ -177,6 +177,11 @@
 	*(.con_initcall.init)
   }
   __con_initcall_end =3D .;
+  __x86cpuvendor_start =3D .;
+  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
+	*(.x86cpuvendor.init)
+  }
+  __x86cpuvendor_end =3D .;
   SECURITY_INIT
=20
   . =3D ALIGN(8);


--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/Xhht4=aU70jf4E75wAyE=uy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtXDK9lPLMJjT96cRAq3oAKCWsf7EMalt8/RHvOtvILNpQ7LF7QCgqlL5
SVNeV+VlHcC7Xny+GnQvZIA=
=9/JN
-----END PGP SIGNATURE-----

--Sig_/Xhht4=aU70jf4E75wAyE=uy--
