Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZG0X7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZG0X7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZG0X7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:59:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45160 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZG0X7g (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:59:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 31-rc3-mmotm0716 - dead USB trackball mouse kills entire system
In-Reply-To: Your message of "Fri, 24 Jul 2009 10:29:51 EDT."
             <Pine.LNX.4.44L0.0907241023110.3165-100000@iolanthe.rowland.org>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.44L0.0907241023110.3165-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248739158_3074P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 19:59:18 -0400
Message-ID: <70893.1248739158@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248739158_3074P
Content-Type: text/plain; charset=us-ascii

On Fri, 24 Jul 2009 10:29:51 EDT, Alan Stern said:

> You're talking about messages like this:
> 
> > Jul 23 11:10:29 turing-police kernel: [  571.965568] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> 
> Those messages are produced by the following statement in
> drivers/hid/usbhid/hid-core.c:hid_reset():
> 
> 		err_hid("can't reset device, %s-%s/input%d, status %d",
> 				hid_to_usb_dev(hid)->bus->bus_name,
> 				hid_to_usb_dev(hid)->devpath,
> 				usbhid->ifnum, rc);
> 
> I don't know how long that subroutine and in particular that line have
> been present, but it has been quite a while.  Certainly since 2.6.20.

That code may have been there for a long time, but apparently something
*else* in the USB/HID pile of code changed, that we're now calling hid_reset()
where we didn't used to before, or hid_reset() never reached that err_hid()
call before, or something.

> > > This is a bug.  For more discussion see this thread:
> > > 
> > > 	http://marc.info/?t=124807676700001&r=1&w=2
> > > 
> > > You should try the patch given there.
> > 
> > OK, will do that, see if it improves things...
> 
> Let me know what happens.

Confirming - the patch in that thread prevents the system lockup I was
seeing.

So it looks like hid_reset() getting more chatty sometime in the last 2 weeks
was a red herring, and one I can't actually complain about - it was quite
legitimately whinging about not being able to reset a device that was in fact
dead in the water at the time.  Given that, and a working patch for ehci-hcd.c,
I'm having a hard time finding the enthusiasm to track down what exactly
changed in hid-core.c. :)

The change in hid-core.c behavior just had the bad luck to land in -mmotm at
the exact same time the bug in ehci-hcd.c landed.  So we had two user-visible
behavior changes in the same area of code at the same time.  Hilarity ensues. :)

Thanks for pointing me at the actual fix. ;)

--==_Exmh_1248739158_3074P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKbj9WcC3lWbTT17ARAgySAKC6Mt/7VT7kuD8cSsfhDWRVctx37QCg4y0x
MTD8RzRdwRs+FFocihEzKgE=
=3Ha1
-----END PGP SIGNATURE-----

--==_Exmh_1248739158_3074P--
