Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbXGaStO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbXGaStO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932861AbXGaSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:48:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47652 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbXGaSsr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:48:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
In-Reply-To: Your message of "Mon, 30 Jul 2007 19:53:19 EDT."
             <5287.1185839599@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <20070725040304.111550f4.akpm@linux-foundation.org> <5208.1185508832@turing-police.cc.vt.edu> <23912.1185542889@turing-police.cc.vt.edu> <200707271643.14028.bjorn.helgaas@hp.com>
            <5287.1185839599@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185907709_12501P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 14:48:29 -0400
Message-ID: <17955.1185907709@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185907709_12501P
Content-Type: text/plain; charset=us-ascii

On Mon, 30 Jul 2007 19:53:19 EDT, Valdis.Kletnieks@vt.edu said:

> > > Just for the record, I see this in /sys:
> > > 
> > > % cat /sys/bus/pnp/devices/00:0e/id
> > > BCM0102
> > > PNP0c31
> > 
> > What's in /sys/bus/pnp/devices/00:0e/resources?
> 
> % cat /sys/bus/pnp/devices/00:0e/resources
> state = active
> io 0x378-0x37f
> io 0x778-0x77b
> irq 7
> dma 1

Scratch that.  When I wrote the first note, I was at home, and the TPM chip
did its PNP thing and became 00:0e.  I failed to notice that in my reply,
I was at work, and the printer port on the docking station became 00:0e and
the TPM became 00:0f.

% cat /sys/devices/pnp0/00:0f/id
BCM0102
PNP0c31
% cat /sys/devices/pnp0/00:0f/resources 
state = active
io 0xcb0-0xcbb
mem 0xfed40000-0xfed44fff

So there *isn't* an IRQ assigned.  When I tried the patch you sent,
I added a few debugging printk's, thusly:

        if (interrupts)
                chip->vendor.irq = irq;
printk(KERN_DEBUG "in tis_init, interrupts=%d irq=%d\n",interrupts,irq);
        if (interrupts && !chip->vendor.irq) {
                chip->vendor.irq =
                    ioread8(chip->vendor.iobase +
                            TPM_INT_VECTOR(chip->vendor.locality));
printk(KERN_DEBUG "after ioread8, interrupts=%d irq=%d\n",interrupts,chip->vendor.irq);

                for (i = 3; i < 16 && chip->vendor.irq == 0; i++) {

[ 1971.644193] in pnp_init, start=fed40000 len=5000 irq=-1
[ 1971.650907] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
[ 1971.650923] in tis_init, interrupts=1 irq=-1
[ 1971.650929] tpm_tis 00:0f: Unable to request irq: -1 for use

and it loads immediately.

I thought that !chip->vendor.irq looked like a wrong test, because if the
chip says '-1' meaning "no default assigned", and conversely, if the chip
had a positive number, we should be *using* that IRQ if we can, rather than
looping from 3 to 15 looking for one. So I tried it with (chip->vendor.irc < 0),
and this happened:

[ 2254.834377] in pnp_init, start=fed40000 len=5000 irq=-1
[ 2254.840422] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
[ 2254.840438] in tis_init, interrupts=1 irq=-1
[ 2254.840443] after ioread8, interrupts=1 irq=15
[ 2254.840457] tpm0 (IRQ 15) handled a spurious interrupt
[ 2256.839077] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62
[ 2376.771347] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62

Or am I wrong in thinking chip->vendor.irq == -1 means "Pick me an IRQ",
but instead means "I don't do that IRQ thing"? If so, maybe what we need
to be doing is something like:

	if (chip->vendor.irq == -1)
		interrupts = 0;

and force the use of interrupts off and do polling only?

--==_Exmh_1185907709_12501P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGr4P9cC3lWbTT17ARAqojAJ40OKt889pGYCAqMNHCFKVJIHQHLgCcCFpQ
VE4QzjGAJoZ81JwPtGIimOY=
=9lUE
-----END PGP SIGNATURE-----

--==_Exmh_1185907709_12501P--
