Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYAOUE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYAOUE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYAOUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:04:16 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:33212 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbYAOUEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:04:14 -0500
Date: Tue, 15 Jan 2008 21:04:11 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Luotao Fu <l.fu@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
Message-ID: <20080115200411.GA12195@pengutronix.de>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Luotao Fu <l.fu@pengutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1200336080.318.8.camel@localhost.localdomain> <20080115162729.GF5859@pengutronix.de> <Pine.LNX.4.58.0801151301550.26624@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
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
X-Uptime: 20:39:54 up 2 days,  1:02,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 10.1.0.65
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Tue, Jan 15, 2008 at 01:06:25PM -0500, Steven Rostedt wrote:
>=20
>=20
> On Tue, 15 Jan 2008, Luotao Fu wrote:
> >
> > Compiling with tracing function turned seemed still to be broken to me:
>=20
> Could you email me your config (privately)

will send it later in another private mail, actually nothing spectacular. T=
he
early_printk() is simply missing for 32bit powerpc. The 64bit implementation
puts a dummy for early_printk in setup_64.c:
~ grep -A 4 EARLY_PRINTK ./arch/powerpc/kernel/setup_64.c | head -6
#ifdef CONFIG_EARLY_PRINTK
void notrace early_printk(const char *fmt, ...)
{
        BUG();
	}
	#endif /* CONFIG_EARLY_PRINTK */
;-)
that could be why it works for you.

>=20
=2E...
> > After recompiling the kernel started normally and it seems to work. I w=
as even
> > able to make a trace with cyclictest. However there were several crashe=
s (which
> > might be caused by other problems). I still have to take a closer look.
> >
> > I am just wondering why the check for mcount_enabled is there at all an=
d I think
> > that there due to be some better fixes than just throw it out ;-). On t=
he other
> > side, I just can't find in which way mcount_enabled is used in the trac=
er at
> > all. Could you give me some hints on this one?
> >
>=20
> The way we turn on and off mcount function calls at run time is through
> mcount_enable.  I'll look into why this is broken for you. I'm able to run
> with this. My box is a ppc64, and my ppc32 (powerbook) wont come close to
> booting RT (never did).  On boot up it locks up right away and the screen
> looks like it starts to melt. No serial, so I don't have much to debug
> that with.
>=20

ah, thx for the hint. I took a look in the entry_64.S file. The checking of
mcount_enabled is indeed literally the same as the 32bit architecture.
An important point for the failure on 32bit machines is that due to my bdi =
the
machine got stuck still before the mmu is running. Hence I get quite funny =
pc
address like
Current PC        : 0x000135dc
it still lies over on 0x0 as the physical adress of the decompressed kernel=
 in
memory. I think that mcount_enabled is linked somewhere in the virtual adde=
ss
space, so that the cmpwi stucks forever for _mcount is called so early, tha=
t we
still don't work with virtual addresses. I don't understand enough powerpc
assembler to work out how the LOAD_REG_ADDR() (used in entry_64.S to load
mcount_enabled) of 64 bit powerpcs work around this problem. Anyway, If my =
guess
is right, we might need something to get or simply ignore mcount_enabled
checking in the _mcount calls during early initialisation.

> Anyway, I'll take a deeper look into this.
>=20

Thanks


cheers
Luotao Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHjRG7iruQY+UyUmERAuPVAKCrM1MYPdAIWLF0M9PXvlXovS3LjwCcDT23
jp59pKaFF21eK47nVLPCg0A=
=KV8u
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
