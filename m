Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYAOQ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYAOQ1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYAOQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:27:34 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:52129 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbYAOQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:27:32 -0500
Date: Tue, 15 Jan 2008 17:27:29 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
Message-ID: <20080115162729.GF5859@pengutronix.de>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1200336080.318.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3uUfsyyY1Pqa/ej"
Content-Disposition: inline
In-Reply-To: <1200336080.318.8.camel@localhost.localdomain>
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
X-Uptime: 17:04:10 up 8 days,  7:53,  1 user,  load average: 0.24, 0.31,
	0.24
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 10.1.0.69
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w3uUfsyyY1Pqa/ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 14, 2008 at 01:41:20PM -0500, Steven Rostedt wrote:
> We are pleased to announce the 2.6.24-rc7-rt2 tree, which can be
> downloaded from the location:
>=20
>   http://rt.et.redhat.com/download/
>=20
=2E.........=20
> Changes since 2.6.24-rc7-rt1
>=20
=20
=2E.........
>   - PPC compile fix (reported by: Robert Schwebel)
>=20

Compiling with tracing function turned seemed still to be broken to me:
kernel/built-in.o: In function `early_printk_name':
latency_trace.c:(.text+0x3cd18): undefined reference to `early_printk'
latency_trace.c:(.text+0x3cd40): undefined reference to `early_printk'
kernel/built-in.o: In function `early_print_entry':
latency_trace.c:(.text+0x3cd80): undefined reference to `early_printk'
latency_trace.c:(.text+0x3cdd8): undefined reference to `early_printk'
latency_trace.c:(.text+0x3cdfc): undefined reference to `early_printk'

We made a early_printk patch based on the 8250_early for powerpc 32bit here.
(still absolutely untested and incomplete, we will post it asap). I added
early_printk() and exported _mcount() and could compile succesfully. Howeve=
r the
kernel will not boot. I attached a bdi to it and found out that it stucks at
_mcount in arch/powerpc/kernel/entry_32.S at about line 1080, where the var=
iable
mcount_enabled is loaded and checked. Obviously the variable is still not v=
alid
at the time of check. To check this I took out the lines like above

--- arch/powerpc/kernel/entry_32.S.orig 2008-01-15 17:01:25.000000000 +0100
+++ arch/powerpc/kernel/entry_32.S      2008-01-15 17:17:18.000000000 +0100
@@ -1075,9 +1075,6 @@
        stw     r6, 24(r1)
        mflr    r3      /* will use as first arg to __trace() */
        mfcr    r4
-       lis     r5,mcount_enabled@ha
-       lwz     r5,mcount_enabled@l(r5)
-       cmpwi   r5,0
        stw     r3, 44(r1)      /* lr */
        stw     r4,  8(r1)      /* cr */
        stw     r7, 28(r1)

After recompiling the kernel started normally and it seems to work. I was e=
ven
able to make a trace with cyclictest. However there were several crashes (w=
hich
might be caused by other problems). I still have to take a closer look.

I am just wondering why the check for mcount_enabled is there at all and I =
think
that there due to be some better fixes than just throw it out ;-). On the o=
ther
side, I just can't find in which way mcount_enabled is used in the tracer at
all. Could you give me some hints on this one?

cheers
Luotao Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--w3uUfsyyY1Pqa/ej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHjN7xiruQY+UyUmERAhBcAKC09ucwz7Kt7Qp/vREztTaCxG6hXQCfRknv
y9KYRrVbzD1SiGjeEaNU8Zo=
=9Gl6
-----END PGP SIGNATURE-----

--w3uUfsyyY1Pqa/ej--
