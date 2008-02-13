Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbYBMQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbYBMQAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYBMQAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:00:47 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:4656 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbYBMQAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:00:46 -0500
Date: Wed, 13 Feb 2008 17:00:16 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Anvin" <hpa@zytor.com>, Matt Mackall <mpm@selenic.com>,
       zwane@arm.linux.org.uk
Cc: Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Configure out TSC support
Message-ID: <20080213170016.7fb3dd87@crazy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.oVhBN7Qc8UbUvRqHO5vPY9";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.oVhBN7Qc8UbUvRqHO5vPY9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

The following patch allows to remove the code needed to support the TSC
timer on x86 32 bits. The TSC seems to be mandatory on x86 64 bits. The
patch adds a X86_TSC_TIMER option to enable/disable the support.

A X86_TSC option already exists, but it is not an option, it's simply
set to true when the processor has a TSC. However, the purpose of the
patch is to disable the TSC support even if the processor has it.

Comments welcome.

Thanks,

Thomas

---

Add a new configuration option that allows the TSC timer support code
to not be compiled, in order to make some space savings on the kernel
code size. The option depends on X86_32, because on 64 bits, the TSC
seems to be mandatory.

The results are:

   text    data     bss     dec     hex filename
1068092  126308   98304 1292704  13b9a0 vmlinux.before
1066956  126296   98304 1291556  13b524 vmlinux.after
  -1136     -12       0   -1148    -47C +/

This patch is part of the Linux Tiny project, and is based on previous
work done by Zwane Mwaikambo <zwane@arm.linux.org.uk>.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

---
 arch/x86/Kconfig         |    6 ++++++
 arch/x86/kernel/Makefile |    3 ++-
 include/asm/tsc.h        |    4 ++++
 3 files changed, 12 insertions(+), 1 deletion(-)

Index: linux/arch/x86/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -395,6 +395,12 @@
 	def_bool y
 	depends on X86_32 && NUMA && (X86_SUMMIT || X86_GENERICARCH)
=20
+config X86_TSC_TIMER
+	default y
+	bool "Enable TSC timer" if EMBEDDED && X86_32
+	help
+	  Enable support for the Time Stamp Counter timer.
+
 config X86_CYCLONE_TIMER
 	def_bool y
 	depends on X86_32 && X86_SUMMIT || X86_GENERICARCH
Index: linux/arch/x86/kernel/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/kernel/Makefile
+++ linux/arch/x86/kernel/Makefile
@@ -19,8 +19,9 @@
 obj-y			+=3D quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+=3D alternative.o i8253.o
 obj-$(CONFIG_X86_64)	+=3D pci-nommu_64.o bugs_64.o
-obj-y			+=3D tsc_$(BITS).o io_delay.o rtc.o
+obj-y			+=3D io_delay.o rtc.o
=20
+obj-$(CONFIG_X86_TSC_TIMER)     +=3D tsc_$(BITS).o
 obj-y				+=3D i387.o
 obj-y				+=3D ptrace.o
 obj-y				+=3D ds.o
Index: linux/include/asm/tsc.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/include/asm/tsc.h
+++ linux/include/asm/tsc.h
@@ -45,7 +45,11 @@
 	return (cycles_t) __native_read_tsc();
 }
=20
+#ifdef CONFIG_X86_TSC_TIMER
 extern void tsc_init(void);
+#else
+static inline void tsc_init(void) { }
+#endif
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern void init_tsc_clocksource(void);


--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/.oVhBN7Qc8UbUvRqHO5vPY9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsxQT9lPLMJjT96cRAlwsAJ9d3Vi4Q6+7H7U+vlFV9Pe14GK5/QCgxGV/
xJfhMpUs/2HyngO+TCt6+pI=
=9yDi
-----END PGP SIGNATURE-----

--Sig_/.oVhBN7Qc8UbUvRqHO5vPY9--
