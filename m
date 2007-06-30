Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbXF3Orq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbXF3Orq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbXF3Orj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:47:39 -0400
Received: from mx34.mail.ru ([194.67.23.200]:6421 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757380AbXF3Ori (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:47:38 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sat, 30 Jun 2007 18:47:32 +0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706301116.19501.arvidjaar@mail.ru> <200706300545.43181.bjorn.helgaas@hp.com>
In-Reply-To: <200706300545.43181.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6964142.5Mll2utHJk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706301847.33834.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6964142.5Mll2utHJk
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 30 June 2007, Bjorn Helgaas wrote:
> This means that the SMCf010 device *did* respond, I think at the
> FIR address 0x100.  (I can't figure out the "right" way to print
> those resource_size_t things, so I added some casts in the appended
> patch.)
>

Those can be 64 bit if CONFIG_RESOURCE_64BIT is set; so you probably should=
=20
cast to unsigned long long and use %llx. Or do it conditionally depending o=
n=20
above macro.

> Well, the whole problem I'm trying to fix is that we aren't doing
> resource allocation correctly.  The BIOS has configured the IR
> device to use port 0x100, and then something else came along and
> decided to also use port 0x100.
>

That I already asked - how should PCMCIA subsystem know that some device=20
requires fixed io port? Or for that matter - how should PnP know that some=
=20
resource it believes is free is actually used by PCMCIA?

> It looks like the something else is the wlags49_h1_cs driver for
> the PCMCIA card you have inserted.  Can you temporarily remove that
> card and driver and try the patch below?  If the IR device works
> without the wlags49_h1_cs driver, then we'll have to look at
> wlags49_h1_cs to see whether it's doing something wrong.
>


Yes, this works. I did not use patch below, because it works with original =
too=20
of course. In this PCMCIA later sees that port range at 0x100 is already=20
taken and selects another one:

[  693.694389] SMsC IrDA Controller found
[  693.694395]  IrCC version 2.0, firport 0x100, sirport 0x2e8 dma=3D1, irq=
=3D5
[  693.735620] No transceiver found. Defaulting to Fast pin select
[  693.757188] IrDA: Registered device irda0
[  840.397539] Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
[  840.419345] Yenta: Using CSCINT to route CSC interrupts to PCI
[  840.441395] Yenta: Routing CardBus interrupts to PCI
[  840.463454] Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
[  840.713821] Yenta: ISA IRQ mask 0x0000, PCI irq 11
[  840.736937] Socket status: 30000059
[  840.761016] Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
[  840.910480] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  840.934571] Socket status: 30000087
[  840.959527] Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
[  841.110433] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  841.135628] Socket status: 30000087
[  841.393023] pccard: PCMCIA card inserted into slot 0
[  970.189560] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
=20
Systems, http://www.agere.com
[  970.212434] *** Modified for kernel 2.6 by Andrey Borzenkov=20
<arvidjaar@mail.ru> $Revision: 39 $
[  970.235874] *** Station Mode (STA) Support: YES
[  970.259328] *** Access Point Mode (AP) Support: YES
[ 1286.581694] cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcbff=
f=20
0xe0000-0xfffff
[ 1286.608294] cs: memory probe 0x60000000-0x60ffffff: clean.
[ 1286.642101] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[ 1286.676160] pcmcia: registering new device pcmcia0.0
[ 1287.186722] eth0: PRI 31 variant 2 version 9.48
[ 1287.208487] eth0: NIC 5 variant 2 version 1.02
[ 1287.234616] eth0: Wireless, io_addr 0x180, irq 11, mac_address=20
00:02:2D:26:95:6C

is it interesting to look at ports:

0100-0107 : smsc-ircc2
0170-0177 : 0000:00:04.0
  0170-0177 : libata
0180-01bf : pcmcia_socket0

notice that pcmcia_socket available resources do not change at all in this=
=20
case and still list port range 100 - 3af.

I do not think wlags driver has anything to do with it (directly). It just=
=20
requests resource allocation from PCMCIA core. So either we have to mark=20
resources of PnP devices reserved (even if devices are not active and no=20
driver is loaded) or we need some way to force PnP to allocate different=20
resources on device activation. Which means PCMCIA should somehow inform Pn=
P=20
that resources it allocated are in use.=20

Anyway if you want to get a look - driver is available at=20
http://arvidjaar.newmail.ru/wlags49.tar.bz2.=20

=2Dandrey

--nextPart6964142.5Mll2utHJk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGhm0FR6LMutpd94wRAnLlAJ4j2WMsRI1g5WgPG8hElf794V90YgCfSZVM
EIRr6lBejQ3yTiwAE5ALe1s=
=9Ddt
-----END PGP SIGNATURE-----

--nextPart6964142.5Mll2utHJk--
