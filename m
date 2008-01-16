Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbYAPMDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbYAPMDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYAPMDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:03:11 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:41438 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbYAPMDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:03:09 -0500
Date: Wed, 16 Jan 2008 13:03:07 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Luotao Fu <l.fu@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2 [PATCH] latency tracer fix for ppc32
Message-ID: <20080116120307.GI5859@pengutronix.de>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Luotao Fu <l.fu@pengutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1200336080.318.8.camel@localhost.localdomain> <20080115162729.GF5859@pengutronix.de> <Pine.LNX.4.58.0801151301550.26624@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MMMIZFJzhAsRj/+"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801151301550.26624@gandalf.stny.rr.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 12:42:19 up 9 days,  3:31,  1 user,  load average: 0.05, 0.07,
	0.08
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 10.1.0.69
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MMMIZFJzhAsRj/+
Content-Type: multipart/mixed; boundary="81JctsDUVPekGcy+"
Content-Disposition: inline


--81JctsDUVPekGcy+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

I found out that the tracer got stuck on ppc32 platforms because some early
functions call _mcount before mcount_enabled is initialized at all. I made a
patch, which marks these functions as notrace to solve this problem. With t=
his
patch I can successfully boot up our mpc5200b platform and make latency tra=
ce.
(tested with -b switch in cyclictest). Please comment.

I made my patch against the -rt2 tree since the dummy call early_printk() in
-rt3 conflicts with our implementation of a functional early_printk(). It
should also work with -rt3 though.

cheers
Luotao Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--81JctsDUVPekGcy+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ppc32_notrace_init_functions.diff"
Content-Transfer-Encoding: quoted-printable

Subject: don't trace early init functions for ppc32
By: Luotao Fu <l.fu@pengutronix.de>
  If the latency tracer is turned on in the kernel config, _mcount calls are
  added automatically to every function call during compiling since -pg
  compiling flag is set. _mcount() checks first the variable mcount_enabled.
  (see implementation of _mcount() in arch/powerpc/kernel/entry_32.S) This =
will
  stuck forever if _mcount is called before mcount_enabled is initialized. =
Hence
  we mark some init functions as notrace, so that _mcount calls are not add=
ed to
  these functions.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

---
 arch/powerpc/kernel/cputable.c |    4 ++--
 arch/powerpc/kernel/io.c       |    2 +-
 arch/powerpc/kernel/setup_32.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: arch/powerpc/kernel/cputable.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- arch/powerpc/kernel/cputable.c.orig
+++ arch/powerpc/kernel/cputable.c
@@ -1333,7 +1333,7 @@ static struct cpu_spec __initdata cpu_sp
=20
 static struct cpu_spec the_cpu_spec;
=20
-struct cpu_spec * __init identify_cpu(unsigned long offset, unsigned int p=
vr)
+notrace struct cpu_spec * __init identify_cpu(unsigned long offset, unsign=
ed int pvr)
 {
 	struct cpu_spec *s =3D cpu_specs;
 	struct cpu_spec *t =3D &the_cpu_spec;
@@ -1380,7 +1380,7 @@ struct cpu_spec * __init identify_cpu(un
 	return NULL;
 }
=20
-void do_feature_fixups(unsigned long value, void *fixup_start, void *fixup=
_end)
+notrace void do_feature_fixups(unsigned long value, void *fixup_start, voi=
d *fixup_end)
 {
 	struct fixup_entry {
 		unsigned long	mask;
Index: arch/powerpc/kernel/io.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- arch/powerpc/kernel/io.c.orig
+++ arch/powerpc/kernel/io.c
@@ -120,7 +120,7 @@ EXPORT_SYMBOL(_outsl_ns);
=20
 #define IO_CHECK_ALIGN(v,a) ((((unsigned long)(v)) & ((a) - 1)) =3D=3D 0)
=20
-void _memset_io(volatile void __iomem *addr, int c, unsigned long n)
+notrace void _memset_io(volatile void __iomem *addr, int c, unsigned long =
n)
 {
 	void *p =3D (void __force *)addr;
 	u32 lc =3D c;
Index: arch/powerpc/kernel/setup_32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- arch/powerpc/kernel/setup_32.c.orig
+++ arch/powerpc/kernel/setup_32.c
@@ -88,7 +88,7 @@ int ucache_bsize;
  * from the address that it was linked at, so we must use RELOC/PTRRELOC
  * to access static data (including strings).  -- paulus
  */
-unsigned long __init early_init(unsigned long dt_ptr)
+notrace unsigned long __init early_init(unsigned long dt_ptr)
 {
 	unsigned long offset =3D reloc_offset();
 	struct cpu_spec *spec;

--81JctsDUVPekGcy+--

--3MMMIZFJzhAsRj/+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHjfJ7iruQY+UyUmERArI6AKCwOkX7ozN8OmMFdxq5mVpgivdobQCgygNj
6pNMWfo5Mb05ldXwScFaPHE=
=Lv+y
-----END PGP SIGNATURE-----

--3MMMIZFJzhAsRj/+--
