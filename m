Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXF3VNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXF3VNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 17:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXF3VN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 17:13:29 -0400
Received: from mx27.mail.ru ([194.67.23.64]:19508 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbXF3VN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 17:13:28 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sun, 1 Jul 2007 01:13:24 +0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706300545.43181.bjorn.helgaas@hp.com> <200706301847.33834.arvidjaar@mail.ru>
In-Reply-To: <200706301847.33834.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6040947.ccfyaSeq4U";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707010113.25853.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6040947.ccfyaSeq4U
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 30 June 2007, Andrey Borzenkov wrote:
> On Saturday 30 June 2007, Bjorn Helgaas wrote:
> > This means that the SMCf010 device *did* respond, I think at the
> > FIR address 0x100.  (I can't figure out the "right" way to print
> > those resource_size_t things, so I added some casts in the appended
> > patch.)
>
> Those can be 64 bit if CONFIG_RESOURCE_64BIT is set; so you probably shou=
ld
> cast to unsigned long long and use %llx. Or do it conditionally depending
> on above macro.
>
> > Well, the whole problem I'm trying to fix is that we aren't doing
> > resource allocation correctly.  The BIOS has configured the IR
> > device to use port 0x100, and then something else came along and
> > decided to also use port 0x100.
>

After some digging, it works now :) So the story:

PCMCIA includes code for checking for free IO range(s)
code is active only if CONFIG_ISA is defined
CONFIG_ISA has this excellent help text:
          Find out whether you have ISA slots on your motherboard.=20
and I was stupid enough to take this literally (having notebook I obviously=
 do=20
not have any slots at all)

So after recompiling with CONFIG_ISA defined I now get

[ 2254.136611] cs: IO port probe 0x100-0x3af: excluding 0x100-0x107=20
0x2e8-0x2ef 0x378-0x37f
[ 2254.166638] cs: IO port probe 0x3e0-0x4ff: excluding 0x3f8-0x3ff=20
0x408-0x40f 0x480-0x48f 0x4d0-0x4d7
[ 2254.194838] cs: IO port probe 0x820-0x8ff: clean.
[ 2254.222401] cs: IO port probe 0xc00-0xcf7: clean.
[ 2254.250056] cs: IO port probe 0xa00-0xaff: clean.

(I wonder why this is repeated 3 times, but well ...) and smsc-ircc2 takes=
=20
over ports 0x100 - 0x107 and is happy.

THANK YOU!

Bjorn, I believe last touch that is needed is to sort out printf issues,=20
otherwise patch is fine here.

=2Dandrey

--nextPart6040947.ccfyaSeq4U
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGhsd1R6LMutpd94wRApmzAJ4wkJqmTOw1wKEEQL2Jtzm/yKh5NwCgzC7h
11ZA7nK1b8RTwsIdC5v4ZDY=
=kQzw
-----END PGP SIGNATURE-----

--nextPart6040947.ccfyaSeq4U--
