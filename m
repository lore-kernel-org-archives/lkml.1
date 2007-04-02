Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXDBNdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXDBNdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXDBNdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:33:51 -0400
Received: from rwcrmhc12.comcast.net ([216.148.227.152]:35336 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965426AbXDBNdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:33:50 -0400
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
From: Dan Engel <dan@sourceharvest.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <d120d5000704020606y620df4bfu1cf3728070f02a38@mail.gmail.com>
References: <1175396188.7857.15.camel@monica.engel.home>
	 <Pine.LNX.4.64.0704011941310.6040@jikos.suse.cz>
	 <1175484539.12355.18.camel@monica.engel.home>
	 <200704020004.51861.dtor@insightbb.com>
	 <1175508842.12355.34.camel@monica.engel.home>
	 <d120d5000704020606y620df4bfu1cf3728070f02a38@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rBGpATzT0FC1jshuaOvi"
Date: Mon, 02 Apr 2007 09:33:48 -0400
Message-Id: <1175520828.12355.84.camel@monica.engel.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rBGpATzT0FC1jshuaOvi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-02 at 09:06 -0400, Dmitry Torokhov wrote:
> It may be a HID-class device but it is definetly not an input device
> and it would be wrong to present it to userspace as a device having 2
> LEDs on it - it would be a lie. If we did that then some application
> might mistake the device for something else and decide to switch that
> LED off thus turning your KVM off. A random application should not be
> aware how a random vendor decided to interpret the specs.

Okay, I did a little more exploration of the total device (I was
focusing on the PC control of switching up until now.)

This HID interface has two aspects:

One is the PC control over switching. This is represented by a single
report, with 3 fields, each with a single on/off usage. It can switch
KVM only, audio only, or both. This is the one that overloads the HID
LED usages, and is (as you say) not properly an input device.

The other one appears to have something to do with the case where you've
switched only audio. It's a single input report with four fields that
map to the key usages volume up, volume down, mute (I think), and
eject.=20

So, I think the "right" thing to is to allow it to be driven as both a
hiddev and an evdev (which is what the HID_QUIRK_HIDDEV does for this
device.)

Then, the switch controls would be accessed only through hiddev, while
the key events, if they're ever actually generated, would still be
received by the evdev driver.

On a side note, I'm not sure why those input key events are there. The
basic idea of the device is that you can switch KVM control back and
forth, while keeping audio on a single computer (e.g., to listen to
music), and at first I thought those key events were to feed audio
controls through from the computer with KVM focus to the one with audio
focus, so that if you're working on either computer you can adjust the
volume, etc. However, the computer that does not have KVM focus will
never receive these events, since switching KVM focus effectively
disconnects the device completely from the computer.



--=-rBGpATzT0FC1jshuaOvi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGEQY8eDYVehSTx+URAo9OAJ9aA9BJL5HwuP5EcSH1jeJj7YrY8QCgsFoB
lFqEX9lnShbW9wm8emnOOeg=
=C+yj
-----END PGP SIGNATURE-----

--=-rBGpATzT0FC1jshuaOvi--

