Return-Path: <linux-kernel-owner+w=401wt.eu-S1751034AbXA3LrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbXA3LrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 06:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXA3LrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 06:47:15 -0500
Received: from mivlgu.ru ([81.18.140.87]:35054 "EHLO mail.mivlgu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbXA3LrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 06:47:14 -0500
Date: Tue, 30 Jan 2007 14:47:01 +0300
From: Sergey Vlasov <vsu@altlinux.ru>
To: Jean Delvare <jdelvare@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: via irq quirk breakage
Message-Id: <20070130144701.e793c222.vsu@altlinux.ru>
In-Reply-To: <200701300854.06083.jdelvare@suse.de>
References: <45B6A94A.3010006@yahoo.com.au>
	<200701291600.32580.jdelvare@suse.de>
	<45BEAEE3.9080003@yahoo.com.au>
	<200701300854.06083.jdelvare@suse.de>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.10.2; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Jan_2007_14_47_01_+0300_xlfckaTm9UJ.4Y9S"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Jan_2007_14_47_01_+0300_xlfckaTm9UJ.4Y9S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 30 Jan 2007 08:54:05 +0100 Jean Delvare wrote:

> You have an old VT82C686 south bridge, which was tagged as "special" by
> Alan. For this chip, Alan's code only allows devices 00:00.x to be quirked.
> As my code was merely a reimplementation of Alan's idea, it does the same.
> Your USB controllers are at 00:07.x, so I'm not surprised they weren't
> quirked.
>
> Alan, why were dev_lo and dev_hi both set to 0 for the VT82C868 in your
> implementation? Is it a typo, or...?
>
> Nick, I guess the following patch would work better for you? I've listed
> devices 00:07.x as quirkable for the VT82C686.

The VT82C686 is very different from other devices, because it is
a PCI chip, and its device number is determined by IDSEL wiring.
Google shows that several different assignments are in use:

00:01.0:
http://ozlabs.org/pipermail/linuxppc-embedded/2005-January/016642.html
(but that's PPC)

00:04.0: http://www.cs.helsinki.fi/linux/linux-kernel/2001-36/0083.html
00:05.0: http://lkml.org/lkml/2003/12/11/78
00:07.0: this example and lots of other links
00:14.0: http://forum.freespire.org/showthread.php?t=2998

> +static void quirk_via_bridge(struct pci_dev *dev)
> +{
> +	/* See what bridge we have and find the device ranges */
> +	switch (dev->device) {
> +	case PCI_DEVICE_ID_VIA_82C686:
> +		/* 82C686 is special */
> +		via_vlink_dev_lo = 7;
> +		via_vlink_dev_hi = 7;

So this should probably be:

		/*
		 * 82C686 attaches to PCI and can have any device number, but
		 * all its subdevices are functions of that single device.
		 */
		via_vlink_dev_lo = via_vlink_dev_hi = PCI_SLOT(dev->devfn);

--Signature=_Tue__30_Jan_2007_14_47_01_+0300_xlfckaTm9UJ.4Y9S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFvzA4W82GfkQfsqIRAn1pAJ0RU+3YlEcYcCnZFX2HDgjiGImFZgCfVIAd
MgV0kIFd4KZD5NPME+7XV3A=
=3ZHI
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Jan_2007_14_47_01_+0300_xlfckaTm9UJ.4Y9S--
