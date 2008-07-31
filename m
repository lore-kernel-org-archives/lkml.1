Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYGaNjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYGaNjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYGaNjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:39:32 -0400
Received: from ozlabs.org ([203.10.76.45]:34421 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYGaNjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:39:32 -0400
Subject: Re: [PATCH] powerpc - Initialize the irq radix tree earlier
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org, jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org
In-Reply-To: <20080731152606.5ae7c379@bull.net>
References: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
	 <1217497241-10685-2-git-send-email-sebastien.dugue@bull.net>
	 <1217504456.9817.22.camel@localhost> <20080731140002.31bbe4a0@bull.net>
	 <1217509104.19050.11.camel@localhost> <1217509299.19050.15.camel@localhost>
	 <20080731152606.5ae7c379@bull.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vW9406vhric++rHHzA/k"
Date: Thu, 31 Jul 2008 23:39:26 +1000
Message-Id: <1217511566.19050.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vW9406vhric++rHHzA/k
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-31 at 15:26 +0200, Sebastien Dugue wrote:
> On Thu, 31 Jul 2008 23:01:39 +1000 Michael Ellerman <michael@ellerman.id.=
au> wrote:
>=20
> > On Thu, 2008-07-31 at 22:58 +1000, Michael Ellerman wrote:
> > > On Thu, 2008-07-31 at 14:00 +0200, Sebastien Dugue wrote:
> > > > On Thu, 31 Jul 2008 21:40:56 +1000 Michael Ellerman <michael@ellerm=
an.id.au> wrote:
> > > > >=20
> > > > > This boot ordering stuff is pretty hairy, so I might have missed
> > > > > something, but this is how the code is ordered AFAICT:
> > > > > =EF=BB=BF
> > > > > start_kernel()
> > > > > 	init_IRQ()
> > > > > 	...
> > > > > 	local_irq_enable()
> > > > > 	...
> > > > > 	rest_init()
> > > > > 		kernel_thread()
> > > > > 			kernel_init()
> > > > > 				smp_prepare_cpus()
> > > > > 					smp_xics_probe()	(via smp_ops->probe())
> > > > >=20
> > > > >=20
> > > > > What's stopping us from taking an irq between local_irq_enable() =
and
> > > > > smp_xics_probe() ?  Is it just that no one's request_irq()'ed the=
m yet?
> > > >=20
> > > >   It's hairy, I agree, but as you've mentioned no one has done a re=
quest_irq()
> > > > at that point. The first one to do it is smp_xics_probe() for the I=
PI.
> > >=20
> > > Hmm, I don't think that's strong enough. I can trivially cause irqs t=
o
> > > fire during a kexec reboot just by mashing the keyboard.
> > >=20
> > > And during a kdump boot all sorts of stuff could be firing. Even duri=
ng
> > > a clean boot, from firmware, I don't think we can guarantee that
> > > nothing's going to fire.
> > >=20
> > > .. after a bit of testing ..
> > >=20
> > > It seems it actually works (sort of).=20
> > >=20
> > > xics_remap_irq() calls irq_radix_revmap_lookup(), which calls:
> > >=20
> > > ptr =3D radix_tree_lookup(&host->revmap_data.tree, hwirq);
> > >=20
> > > And because =EF=BB=BFhost->revmap_data.tree was zalloc'ed we trip on =
the first
> > > check here:
> >=20
> > @#$% ctrl-enter =3D=3D send!
> >=20
> > Continuing ...
> >=20
> > void *radix_tree_lookup(struct radix_tree_root *root, unsigned long ind=
ex)
> > {
> >         unsigned int height, shift;
> >         struct radix_tree_node *node, **slot;
> >=20
> >         node =3D rcu_dereference(root->rnode);
> >         if (node =3D=3D NULL)
> >                 return NULL;
> >=20
> > Which means =EF=BB=BFirq_radix_revmap_lookup() will return NO_IRQ, whic=
h is cool.
>=20
>   Which is what I intended so that as long as no IRQ is registered we
> return NO_IRQ.
>=20
> >=20
> >=20
> > So I think it can fly, as long as we're happy that we can't reverse map
> > anything until smp_xics_probe() - and I think that's true, as any irq w=
e
> > take will be invalid.
>=20
>   That's true as no IRQs are registered before smp_xics_probe() and for a=
ny
> interrupt we might get before that, irq_radix_revmap_lookup() will return
> NO_IRQ.

Cool, we agree :)=20

My only worry is that we might be relying on on the particular radix
tree implementation a bit too much. Is it documented somewhere that
the /very/ first check is for =EF=BB=BFroot->rnode !=3D NULL, and the rest =
of the
root may be unintialised?

And I think it needs a big fat comment in the irq code saying that it's
safe because revmap_data is zalloc'ed, and that means the radix lookup
will fail (safely).

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-vW9406vhric++rHHzA/k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIkcCOdSjSd0sB4dIRAuxGAJ0TguBTpS0p4xdDf+dAZKTcHyTkvQCeNc7S
6UpVTe06vYU5VRVjCJNvKYU=
=IyZ5
-----END PGP SIGNATURE-----

--=-vW9406vhric++rHHzA/k--

