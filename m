Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYHVR5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYHVR5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYHVR5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:57:37 -0400
Received: from mx40.mail.ru ([194.67.23.36]:56624 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYHVR5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:57:36 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.27-rc4: 90% system time because of khubd, unable to reboot
Date: Fri, 22 Aug 2008 21:57:22 +0400
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0808221333110.2230-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808221333110.2230-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1420124.kVVLJoIB8I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808222157.29299.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1420124.kVVLJoIB8I
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 22 August 2008, Alan Stern wrote:
> On Fri, 22 Aug 2008, Andrey Borzenkov wrote:
>=20
> > > > reverting 38b375d9610e2467cb793a84d17c6f65e44cdb39 fixed it
> > > >=20
> > >=20
> > > ... that is:
> > >=20
> > > commit 38b375d9610e2467cb793a84d17c6f65e44cdb39
> > > Author: Alan Stern <stern@rowland.harvard.edu>
> > > Date:   Mon Jul 21 09:56:26 2008 -0400
> > >=20
> > >     USB: OHCI: fix system hang caused by earlier patch
> > >=20
> > >     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > >     Tested by: Andrey Borzenkov <arvidjaar@mail.ru>
> > >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > >=20
> > > so it apparently used to work for you at that time.  What gives?
> > >=20
> >=20
> > Well, you should not commit a fix without commiting code that has been
> > fixed first :)
>=20
> Actually the code to be fixed _was_ committed first -- but then it was=20
> reverted before the fix was accepted, so the fix was merged without it.
>=20
> My advice is not to worry about it.  That code has been sent once again
> to Linus -- it's not merged yet but presumably it will be soon. =20
> Certainly before 2.6.27-rc5 appears.
>=20
> On the other hand, I still have to wonder how the fix could have caused
> your problem without the original patch in place.  The fix itself
> should have been totally innocuous.
>=20

It looks even funnier. Right now I am running with commits
38b375d9610e2467cb793a84d17c6f65e44cdb39 *and*
e872154921a6b5256a3c412dd69158ac0b135176 reverted. I.e. this should be
the state which hopelessly failed in 2.6.26-rc. It seems to be doing
quite well now in 2.6.27-rc.

"git revert e872154921a6b5256a3c412dd69158ac0b135176" gives me this
one liner patch:

commit f3cf9ad86ee76077d1c6be9af7d197aa13ccdff9
Author: Andrey Borzenkov <arvidjaar@mail.ru>
Date:   Fri Aug 22 21:15:26 2008 +0400

    Revert "USB: don't explicitly reenable root-hub status interrupts"

    This reverts commit e872154921a6b5256a3c412dd69158ac0b135176.

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 107e1d2..d30f822 100644
=2D-- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3086,6 +3086,11 @@ static void hub_events(void)
                if (!hdev->parent && !hub->busy_bits[0])
                        usb_enable_root_hub_irq(hdev->bus);

+               /* If this is a root hub, tell the HCD it's okay to
+                * re-enable port-change interrupts now. */
+               if (!hdev->parent && !hub->busy_bits[0])
+                       usb_enable_root_hub_irq(hdev->bus);
+
 loop_autopm:
                /* Allow autosuspend if we're not going to run again */
                if (list_empty(&hub->event_list))

Either my git tree is completely botched or most parts were already reverted
before.

So the problem seems to have cured by itself between 2.6.26 and 2.6.27? =20

--nextPart1420124.kVVLJoIB8I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiu/gQACgkQR6LMutpd94xEQgCguqFRQgWBGRhXjZouLQM+eQZC
vCwAoKNKmgFA/Rtr8itqvdrkS3TrXQfa
=9z0E
-----END PGP SIGNATURE-----

--nextPart1420124.kVVLJoIB8I--
