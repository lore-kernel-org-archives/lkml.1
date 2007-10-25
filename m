Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbXJYGzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbXJYGzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXJYGyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:54:52 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:58388 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbXJYGyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:54:51 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/4] [SCSI] ips: PCI API cleanups
Date: Thu, 25 Oct 2007 08:54:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234830.8F7891F81A9@havoc.gtf.org>
In-Reply-To: <20071024234830.8F7891F81A9@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2036536.65UjCFJZ43";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710250854.47197.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2036536.65UjCFJZ43
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Jeff Garzik wrote:
> * pass Scsi_Host to ips_remove_device() via pci_set_drvdata(),
>   allowing us to eliminate the ips_ha[] search loop and call
>   ips_release() directly.
>
> * call pci_{request,release}_regions() and eliminate individual
>   request/release_[mem_]region() calls
>
> * call pci_disable_device(), paired with pci_enable_device()
>
> * s/0/NULL/ in a few places
>
> * check ioremap() return value

> @@ -7036,32 +7042,17 @@ ips_init_phase1(struct pci_dev *pci_dev, int
> *indexPtr) uint32_t base;
>  		uint32_t offs;
>
> -		if (!request_mem_region(mem_addr, mem_len, "ips")) {
> -			IPS_PRINTK(KERN_WARNING, pci_dev,
> -				   "Couldn't allocate IO Memory space %x len %d.\n",
> -				   mem_addr, mem_len);
> -			return -1;
> -		}
> -
>  		base =3D mem_addr & PAGE_MASK;
>  		offs =3D mem_addr - base;
>  		ioremap_ptr =3D ioremap(base, PAGE_SIZE);

This looks odd. What are we actually doing here?

It seems that we want to map that PCI BAR. Since we're playing with PAGE_MA=
SK=20
I assume the BAR always has a length <PAGE_SIZE, else we would get page=20
aligned memory anyway. If that's true something like

mem_ptr =3D pci_iomap(pci_dev, bar, 0)

should do the trick. Later we would do

pci_iounmap(pci_dev, mem_ptr)

This whole ioremap_ptr stuff can go away at all. Am I right? Then I'll cook=
 up=20
a patch soon.

Eike

--nextPart2036536.65UjCFJZ43
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHID23XKSJPmm5/E4RAt7XAJ9b10Ng9vVbJX/OliGop+uSIVmGHQCgmqGO
ntVQ9TqXYkQlrv9MzcKogV0=
=DgBH
-----END PGP SIGNATURE-----

--nextPart2036536.65UjCFJZ43--
