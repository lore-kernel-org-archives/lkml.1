Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYBKRwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYBKRwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYBKRwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:52:40 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:2601 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYBKRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:52:38 -0500
X-Greylist: delayed 1999 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 12:52:37 EST
Date: Mon, 11 Feb 2008 17:58:44 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>
Cc: Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Configure out DMI scanning code
Message-ID: <20080211175844.3358a49b@crazy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3N4O+CNQKKLiZ/R+jVLiCRl";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3N4O+CNQKKLiZ/R+jVLiCRl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

The enclosed patch allows to remove the DMI scanning code when
CONFIG_EMBEDDED is defined. It's basically the dma_blacklist patch of
Linux-Tiny ported to 2.6.25-rc1, with the required modifications. It
allows to remove ~10k from the kernel code/data size.

On top of this patch, I've tested if removing the big dmi tables in the
code (for example in arch/x86/kernel/reboot.c) would allow to make more
space optimizations. However, it seems that simply defining
dmi_check_system() to an empty static inlined function already allows
gcc to optimize out the dmi tables, because there are not present in
the code. Is that possible, or is my understanding incorrect ?

Of course, your comments on this patch are more than welcome.

Thanks!

Thomas

---

Turn CONFIG_DMI into a selectable option if EMBEDDED is defined, in
order to be able to remove the DMI table scanning code if it's not
needed, and then reduce the kernel code size.

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

Signed-Off-By: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 arch/x86/Kconfig    |   12 +++++++++---
 include/linux/dmi.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

Index: linux/arch/x86/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/Kconfig	2008-02-11 16:51:50.000000000 +0100
+++ linux/arch/x86/Kconfig	2008-02-11 17:48:15.000000000 +0100
@@ -88,9 +88,6 @@
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
Index: linux/include/linux/dmi.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/include/linux/dmi.h	2008-02-11 16:51:30.000000000 +0100
+++ linux/include/linux/dmi.h	2008-02-11 17:40:31.000000000 +0100
@@ -90,6 +90,7 @@
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

--Sig_/3N4O+CNQKKLiZ/R+jVLiCRl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsH7I9lPLMJjT96cRAiRDAJ49F3FI0nDOZZbS+UpsvsG6QC/qjwCaA6tN
kldmwFMEHYv+sG94Ez6azjo=
=i6sf
-----END PGP SIGNATURE-----

--Sig_/3N4O+CNQKKLiZ/R+jVLiCRl--
