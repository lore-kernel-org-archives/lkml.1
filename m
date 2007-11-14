Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbXKNOuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbXKNOuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbXKNOt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:49:56 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:48857 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758391AbXKNOty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:49:54 -0500
From: Rolf Eike Beer <eike-hotplug@sf-tec.de>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [Pcihpd-discuss] [PATCH 2/5] Construct one fakephp slot per pci slot
Date: Wed, 14 Nov 2007 15:49:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <200711141339.31839.eike-hotplug@sf-tec.de> <20071114141755.GA7523@ldl.fc.hp.com>
In-Reply-To: <20071114141755.GA7523@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2911031.OJdFHeQFKC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711141549.50433.eike-hotplug@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2911031.OJdFHeQFKC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch, 14. November 2007 schrieb Alex Chiang:
> Hi Eike,
>
> * Rolf Eike Beer <eike-hotplug@sf-tec.de>:
> > Alex Chiang wrote:
> > > --- a/drivers/pci/hotplug/fakephp.c
> > > +++ b/drivers/pci/hotplug/fakephp.c
> > > @@ -93,6 +93,7 @@ static int add_slot(struct pci_dev *dev)
> > >  	struct dummy_slot *dslot;
> > >  	struct hotplug_slot *slot;
> > >  	int retval =3D -ENOMEM;
> > > +	static int count =3D 1;
> > >
> > >  	slot =3D kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
> > >  	if (!slot)
> > > @@ -106,7 +107,8 @@ static int add_slot(struct pci_dev *dev)
> > >  	slot->info->max_bus_speed =3D PCI_SPEED_UNKNOWN;
> > >  	slot->info->cur_bus_speed =3D PCI_SPEED_UNKNOWN;
> > >
> > > -	slot->name =3D &dev->dev.bus_id[0];
> > > +	slot->name =3D kmalloc(8, GFP_KERNEL);
> > > +	sprintf(slot->name, "fake%d", count++);
> > >  	dbg("slot->name =3D %s\n", slot->name);
> > >
> > >  	dslot =3D kmalloc(sizeof(struct dummy_slot), GFP_KERNEL);
> >
> > This is ugly. Please do it the way we already do e.g. for
> > acpiphp: add a char[8] to "struct dummy_slot" and just
> > reference that here.
>
> I took at look at the code in acpiphp you're talking about, and
> I'm not sure why you think the above is "ugly". We're talking
> about a runtime vs compile time storage for the name, and doing a
> kmalloc/sprintf is a pretty standard idiom.
>
> BTW, I did incorporate both Linas' and Willy's comments, by
> changing the kmalloc size to an explicit 32, and using snprintf
> instead.
>
> In any case, for your particular comment, I think I'm going to
> leave it alone for now, and let Greg weigh in with the final
> recommendation.

Because we have another allocation of very small size for every slot here.

struct dummy_slot has a size of 4 pointers, that's 16 byte for 32 bit=20
architectures. Putting 8 byte of additional storage here would save a=20
complete allocation on 32 bit platforms. For 64 bit platforms the memory=20
usage is the same but we do less allocations (i.e. less points to fail) and=
=20
less memory fragmentation.

Btw: your code lacks a check if kmalloc() returns NULL.

Eike

--nextPart2911031.OJdFHeQFKC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHOwsOXKSJPmm5/E4RAiQwAJ9ZuP2yY/8ny+cUt54EhT8g9otzaQCgg/Qt
V+4g92h1i2GWQGu2aUFAUbM=
=wQuR
-----END PGP SIGNATURE-----

--nextPart2911031.OJdFHeQFKC--
