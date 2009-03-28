Return-Path: <linux-kernel-owner+w=401wt.eu-S1751390AbZC1WI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbZC1WI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZC1WIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:08:40 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:53532 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932125AbZC1WIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:08:39 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net A83B83CA1D1
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
Date: Sat, 28 Mar 2009 23:11:15 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903281431.36572.prakash@punnoor.de> <49CE860B.8090304@kernel.org>
In-Reply-To: <49CE860B.8090304@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2659995.3f0vk1ICVy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903282311.21140.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2659995.3f0vk1ICVy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 28 M=E4rz 2009 21:18:19 Yinghai Lu wrote:
> Prakash Punnoor wrote:
> > On Samstag 28 M=E4rz 2009 13:34:44 Prakash Punnoor wrote:
> >> On Freitag 27 M=E4rz 2009 00:10:01 Jesse Barnes wrote:
> >>> On Fri, 20 Mar 2009 19:29:41 -0700
> >>>
> >>> Yinghai Lu <yinghai@kernel.org> wrote:
> >>>> Impact: fix bug
> >>>>
> >>>> Prakash reported that his c51-mcp51 system ondie sound card doesn't
> >>>> work MSI but if he hack out the HT-MSI on mcp51, the MSI will work
> >>>> well with sound card.
> >>>>
> >>>> this patch rework the nv_msi_ht_cap_quirk()
> >>>> and will only try to avoid to enable ht_msi on device following that
> >>>> root dev, and don't touch that root dev
> >>>>
> >>>> v3: will enable c51...
> >>>> v4: will enable c51 kind of without leaf too.
> >>>> v5: update to mainline
> >>>>
> >>>> Reported-by: Prakash Punnoor <prakash@punnoor.de>
> >>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>>
> >>> Applied, thanks.  Prakash if you get a chance can you try testing my
> >>> linux-next branch (or just linux-next in general tomorrow) to make su=
re
> >>> this is still ok for you?
> >>>
> >>> Thanks,
> >>
> >> Finally I am able to test the linux-next branch of pci tree after Jesse
> >> gave some help with git.(Is it correct that the kernel calls itself
> >> 2.6.28-rc8? I looked into quirks.c and it seems to be correctly
> >> patched.) Unfortunately it doesn't seem to work for me (and I am
> >> wondering why as the old v4 version seemed to work ontop of one of the
> >> 2.6.29-rc versions):
> >>
> >> dmesg|grep HT
> >> pci 0000:00:00.0: Found disabled HT MSI Mapping
> >> pci 0000:00:03.0: Enabling HT MSI Mapping
> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
> >> pci 0000:00:0e.0: Enabling HT MSI Mapping
> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
> >> pci 0000:00:0f.0: Enabling HT MSI Mapping
> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
> >> pci 0000:00:10.0: Enabling HT MSI Mapping
> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
> >> pci 0000:00:10.1: Enabling HT MSI Mapping
> >>
> >> Device 09.0 doesn't get enabled (good) but 00.0 also not (bad). Then my
> >> Intel HDA cannot use MSI.
> >
> > I sprinkeld a few debugging messages around in the code and looking at
> > that I don't see how the code can enable NMSI for device 00.0, but not
> > for 09.0:
> >
> > Both will exit here:
> >
> > if (host_bridge =3D=3D dev && host_bridge_with_leaf(host_bridge))
> >
> > in nv_ht_enable_msi_mapping, so it seems host_bridge_with_leaf returns
> > true for both. I think because my hw configuration changed a bit
> > (inserted one PCIe card) comparing to last time I tested old v4 version,
> > this doesn't work anymore - so the leaf check alone is not realiable, I
> > guess. For me adding something like this, makes it work: (I hope the
> > description makes sense, as I am just refering to the function names and
> > trying to guess its meanings.)
> >
> > Patch is against linux-next branch of pci tree.
> >
> > [patch] pci: enable MSI on host bridge without checking for leaves
> >
> > On C51 the host bridge needs to be enabled, but the MCP51 host bridge
> > not. So don't check for leaves on the main host bridge.
> >
> > Signed-off-by: Prakash Punnoor <prakash@punnoor.de>
> >
> > --- drivers/pci/quirks.c.old    2009-03-28 14:06:07.249250095 +0100
> > +++ drivers/pci/quirks.c        2009-03-28 14:22:35.027510230 +0100
> > @@ -2292,8 +2292,10 @@ static void __devinit __nv_msi_ht_cap_qu
> >         if (pos !=3D 0) {
> >                 /* Host bridge is to HT */
> >                 if (found =3D=3D 1) {
> > -                       /* it is not enabled, try to enable it */
> > -                       if (all)
> > +                       /* it is not enabled, try to enable it;
> > +                        * don't check for leaves on host bridge
> > +                        */
> > +                       if (all || host_bridge->devfn =3D=3D dev->devfn)
> >                                 ht_enable_msi_mapping(dev);
> >                         else
> >                                 nv_ht_enable_msi_mapping(dev);
>
> seems it is not right, it may enable your 09.0 again.

No if you look into the whole function, you'll see that host_bridge is devi=
ce=20
0:0.  (	host_bridge =3D pci_get_bus_and_slot(0, PCI_DEVFN(0, 0)); )



--nextPart2659995.3f0vk1ICVy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknOoIkACgkQxU2n/+9+t5gMXACg6cARD2keWlbj60fcos+Jfr4U
lCkAoJGjq7qjbifQgL6uivrZn4n/IEIV
=A5AS
-----END PGP SIGNATURE-----

--nextPart2659995.3f0vk1ICVy--
