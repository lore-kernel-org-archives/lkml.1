Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZC1N3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZC1N3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZC1N2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:28:53 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:51501 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752741AbZC1N2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:28:52 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net B447A332B58
From: Prakash Punnoor <prakash@punnoor.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
Date: Sat, 28 Mar 2009 14:31:30 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <20090326161001.526354ed@hobbes> <200903281334.51490.prakash@punnoor.de>
In-Reply-To: <200903281334.51490.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9527710.6UcW0cAZG7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903281431.36572.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9527710.6UcW0cAZG7
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 28 M=E4rz 2009 13:34:44 Prakash Punnoor wrote:
> On Freitag 27 M=E4rz 2009 00:10:01 Jesse Barnes wrote:
> > On Fri, 20 Mar 2009 19:29:41 -0700
> >
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > > Impact: fix bug
> > >
> > > Prakash reported that his c51-mcp51 system ondie sound card doesn't
> > > work MSI but if he hack out the HT-MSI on mcp51, the MSI will work
> > > well with sound card.
> > >
> > > this patch rework the nv_msi_ht_cap_quirk()
> > > and will only try to avoid to enable ht_msi on device following that
> > > root dev, and don't touch that root dev
> > >
> > > v3: will enable c51...
> > > v4: will enable c51 kind of without leaf too.
> > > v5: update to mainline
> > >
> > > Reported-by: Prakash Punnoor <prakash@punnoor.de>
> > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > Applied, thanks.  Prakash if you get a chance can you try testing my
> > linux-next branch (or just linux-next in general tomorrow) to make sure
> > this is still ok for you?
> >
> > Thanks,
>
> Finally I am able to test the linux-next branch of pci tree after Jesse
> gave some help with git.(Is it correct that the kernel calls itself
> 2.6.28-rc8? I looked into quirks.c and it seems to be correctly patched.)
> Unfortunately it doesn't seem to work for me (and I am wondering why as t=
he
> old v4 version seemed to work ontop of one of the 2.6.29-rc versions):
>
> dmesg|grep HT
> pci 0000:00:00.0: Found disabled HT MSI Mapping
> pci 0000:00:03.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:0e.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:0f.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:10.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:10.1: Enabling HT MSI Mapping
>
> Device 09.0 doesn't get enabled (good) but 00.0 also not (bad). Then my
> Intel HDA cannot use MSI.

I sprinkeld a few debugging messages around in the code and looking at that
I don't see how the code can enable NMSI for device 00.0, but not for 09.0:

Both will exit here:

if (host_bridge =3D=3D dev && host_bridge_with_leaf(host_bridge))

in nv_ht_enable_msi_mapping, so it seems host_bridge_with_leaf returns true=
=20
for both. I think because my hw configuration changed a bit (inserted one
PCIe card) comparing to last time I tested old v4 version, this doesn't work
anymore - so the leaf check alone is not realiable, I guess. For me adding
something like this, makes it work: (I hope the description makes sense, as
I am just refering to the function names and trying to guess its meanings.)

Patch is against linux-next branch of pci tree.

[patch] pci: enable MSI on host bridge without checking for leaves

On C51 the host bridge needs to be enabled, but the MCP51 host bridge not.
So don't check for leaves on the main host bridge.

Signed-off-by: Prakash Punnoor <prakash@punnoor.de>

=2D-- drivers/pci/quirks.c.old    2009-03-28 14:06:07.249250095 +0100
+++ drivers/pci/quirks.c        2009-03-28 14:22:35.027510230 +0100
@@ -2292,8 +2292,10 @@ static void __devinit __nv_msi_ht_cap_qu
        if (pos !=3D 0) {
                /* Host bridge is to HT */
                if (found =3D=3D 1) {
=2D                       /* it is not enabled, try to enable it */
=2D                       if (all)
+                       /* it is not enabled, try to enable it;
+                        * don't check for leaves on host bridge
+                        */
+                       if (all || host_bridge->devfn =3D=3D dev->devfn)
                                ht_enable_msi_mapping(dev);
                        else
                                nv_ht_enable_msi_mapping(dev);


--nextPart9527710.6UcW0cAZG7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknOJrgACgkQxU2n/+9+t5gA0ACeNs2AwaB4VaUp7wMQdeJOimwB
stEAoKQG9UKP9djFnNIaudwqnrx6JM1l
=sCV4
-----END PGP SIGNATURE-----

--nextPart9527710.6UcW0cAZG7--
