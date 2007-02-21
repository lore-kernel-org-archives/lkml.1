Return-Path: <linux-kernel-owner+w=401wt.eu-S965263AbXBUAD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263AbXBUAD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965262AbXBUAD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:03:29 -0500
Received: from khc.piap.pl ([195.187.100.11]:39529 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965258AbXBUAD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:03:28 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl>
	<20070218155445.GV7584@csclub.uwaterloo.ca>
	<45D87BA2.9020001@xs4all.nl>
	<20070218193901.GN7582@csclub.uwaterloo.ca>
	<45D9BDBF.8040405@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>
	<45DA7A8F.3030008@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 21 Feb 2007 01:03:25 +0100
In-Reply-To: <45DA7A8F.3030008@xs4all.nl> (Udo van den Heuvel's message of "Tue, 20 Feb 2007 05:35:27 +0100")
Message-ID: <m3tzxg4bsi.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> saa7146: found saa7146 @ mem f896a000 (revision 1, irq 145) (0x153b,0x1157).
> saa7146: found saa7146 @ mem f89e6000 (revision 1, irq 153) (0x153b,0x1155).

IO-APICs can do such things...

Ok, I have experimented a bit with my old unused EPIA-M 600 MHz MB.

INT A, B, C, D - as seen at the MB PCI connector (using PCI-PCI
bridge or 4-function device).

Device#	IDSEL	INT (first)
0x08    A19	n/a
0x09	A20	n/a
0x0A	A21	INT C
0x0B	A22	n/a
0x0C	A23	n/a
0x0D	A24	IEEE1394 chip (INT A)
0x0E	A25	n/a
0x0F	A26	n/a
0x10	A27	USB (INT D, A, B, C)
0x11	A28	VT823x (11.5 uses INT B so it means INT A, B, C, D)
0x12	A29	onboard Ethernet (INT D)
0x13	A30	INT D
0x14	A31	INT A (the MB PCI slot is wired this way)

That's from BIOS summary screen, I haven't bothered to run Linux
and check IO-APIC stuff (there may be more than 1 set of 4 INTs).

I haven't tested devices 1-7, you can't probably use them anyway.

It means that (assuming your MB can use the same riser card as this
one), you need the following mapping on the riser:
- first slot, device 0x14 (=20), INT lines 1:1
  (the same INT and IDSEL wiring as at the motherboard PCI slot)
- second slot, device 0x13 (=19),
  INT lines rotated (device) ABCD -> DABC (MB) (i.e., line INT A as
  seen at the MB PCI slot becomes INT B at the device on the riser card
  and INT A as seen at the riser slot becomes INT D at the motherboard).

Chances are that you could probably use device 0x0A (=10) as well,
but it would require another INT rotation (= double rotation).

I bet your riser card have the following mapping:
device X   INTs 1:1
device X+1 INTs (device X+1) ABCD -> BCDA (MB = device X) (INT A
at the device slot becomes INT B at the MB connector and so on).

That means (unless INT rotations are configurable) you have to make
some (quite simple, in fact) modifications to the riser card :-(
-- 
Krzysztof Halasa
