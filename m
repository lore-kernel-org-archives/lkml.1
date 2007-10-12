Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbXJLMIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbXJLMIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759965AbXJLMId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:08:33 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:59715 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759699AbXJLMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:08:31 -0400
Date: Fri, 12 Oct 2007 16:08:26 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Chris Bergeron <chris@pcburn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071012120826.GB23378@pazke.donpac.ru>
Mail-Followup-To: Chris Bergeron <chris@pcburn.com>,
	linux-kernel@vger.kernel.org
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <470E5714.4040303@pcburn.com>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: multipart/mixed; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 284, 10 11, 2007 at 01:02:12PM -0400, Chris Bergeron wrote:
> Andrey Panin wrote:
>> On 278, 10 05, 2007 at 05:31:05PM -0400, Chris Bergeron wrote:
>>  =20
>>> Hello all,
>>>
>>> I've just installed a multiport serial card released by an outfit calle=
d=20
>>> Syba.  This is an 8 port serial-only card with an Octopus style breakou=
t=20
>>> cable.  The main chipset on it is an ITE IT8871F.
>>>    =20
>>
>> Are you sure ? IIRC IT887x are PCI-ISA bridges with additional periphery
>> and your lspci shows PLX chip. Can you send complete lspci -vv output ?
>> Output of dmesg could be useful too.
>>
>>
>>  =20
> I'm sure that's what it says on the largest chip on the PCI card.  It cou=
ld=20
> be that the other two chips are more relevant... the numbers from them ar=
e=20
> included below.
>
> I've posted up a quick text only page with the diagnostic information fro=
m=20
> the system (full dmesg, lspci, etc) plus links to pictures of the board=
=20
> (since others might see something important that I'm not aware of).  You=
=20
> can access that at=20
> http://pcburn.com/files/Syba_serial_controller/index.html

Can you try an attached patch ? I hope it should at least detect UARTs on=
=20
your board. Be ready that baudrate could be wrong, because we do not know
what frequency is used to clock these UARTs.

> One chip has "ITE IT8871F 0641-AYS ZF1M04L" written on it, and the other=
=20
> two have  a stylized celtic knot looking "T" followed by "TG16C554CJG=20
> FTA6M-001 0620-B".

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-syba
Content-Transfer-Encoding: quoted-printable

diff -urdpNX /usr/share/dontdiff linux-2.6.23.vanilla/drivers/serial/8250_p=
ci.c linux-2.6.23/drivers/serial/8250_pci.c
--- linux-2.6.23.vanilla/drivers/serial/8250_pci.c	2007-10-12 14:20:44.0000=
00000 +0400
+++ linux-2.6.23/drivers/serial/8250_pci.c	2007-10-12 14:07:08.000000000 +0=
400
@@ -1036,6 +1036,7 @@ enum pci_board_num_t {
 	pbn_b0_2_115200,
 	pbn_b0_4_115200,
 	pbn_b0_5_115200,
+	pbn_b0_8_115200,
=20
 	pbn_b0_1_921600,
 	pbn_b0_2_921600,
@@ -1172,6 +1173,12 @@ static struct pciserial_board pci_boards
 		.base_baud	=3D 115200,
 		.uart_offset	=3D 8,
 	},
+	[pbn_b0_8_115200] =3D {
+		.flags		=3D FL_BASE0,
+		.num_ports	=3D 8,
+		.base_baud	=3D 115200,
+		.uart_offset	=3D 8,
+	},
=20
 	[pbn_b0_1_921600] =3D {
 		.flags		=3D FL_BASE0,
@@ -2520,6 +2527,11 @@ static struct pci_device_id serial_pci_t
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b3_8_115200 },
=20
+	/* Syba PCI8871-PR8 8-port serial card */
+	{	PCI_VENDOR_ID_PLX, 0x9016,
+		0x544e, 0x0008, 0, 0,
+		pbn_b0_8_115200 },
+
 	/*
 	 * Exar Corp. XR17C15[248] Dual/Quad/Octal UART
 	 */

--aM3YZ0Iwxop3KEKx--

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHD2O6IWZCBzwS8mkRAtLcAKCaCi/7vqAyXV8B98rsJ49t3S1f3ACgjt8w
2nFLN20PnbEFWtBxNOq72K8=
=ObiC
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
