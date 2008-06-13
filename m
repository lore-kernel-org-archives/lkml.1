Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYFMJwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYFMJwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYFMJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:52:04 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:51314 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbYFMJwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:52:01 -0400
Date: Fri, 13 Jun 2008 11:51:59 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] configfs: module reference counting rules
Message-ID: <20080613095159.GH30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080612235410.GC4012@localdomain> <20080613033309.GE20581@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-13801-1213350633-0001-2"
Content-Disposition: inline
In-Reply-To: <20080613033309.GE20581@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-13801-1213350633-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2008 at 08:33:12PM -0700, Joel Becker wrote:
> On Fri, Jun 13, 2008 at 01:54:11AM +0200, Louis Rilling wrote:
> > I'm a bit confused by configfs module reference counting, and I feel
> > that it does not really protect against module unloading. If my feeling
> > is correct, I'd suggest to change module reference counting rules in
> > configfs, for instance like in the attached patch. If my feeling is
> > wrong, could someone shed some light?
>=20
> 	You're wrong, sort of :-)  I worked quite hard on this, so I was
> scared you'd found something - you haven't.
> 	configfs is only responsible for its *own* references on the
> client module.  The client module is responsible for protecting itself.
> 	What do I mean?  In mkdir(), the problem is racing
> configfs_unregister_subsystem().  The group *has* to be live, because we
> have i_mutex - unregister_subsystem can't tear down the directory until
> we release it.  So we're safe to call ->make_item/group().  After we've
> done that, we have a type, and we can try_module_get().  If someone else
> is in unregister_subsystem, that fails and we clean up.  If not, we have
> a reference and they can't unload.

Ok, got it. The race is between unregister_subsystem() and mkdir() at the r=
oot
of the subsystem (or one of its default groups). In deeper, user-created gr=
oups,
this would be a design bug of the subsystem if this race could occur.

> 	This is hard logic, and not something we want each and every
> client module to have to figure out.  Your change has them explicitly
> __module_get() in ->make_item/group(), which isn't safe because of this
> race!

Well, this remains hard logic for the modules. But I agree that they should=
 not
impact the logic that deals with racing mkdir() and unregister_subsystem().

> 	What about attributes?  They can only be accessed via the
> filesystem exposure.  If they are in the filesystem, unregister can't
> happen.  If they are opened, the module refcount is incremented.
> 	Your big concern came from rmdir().  Specifically, while it was
> safe to allocate an object during ->make_item/group(), what happens
> after ->drop_item() is called and then module_put()?  If the item has a
> reference count still, the ->release() is not called.  We may be
> dropping our last reference on the module, and now the module can be
> unloaded.  This is the module's problem, not ours!  configfs no longer
> has a reference to the module, and thus cannot control its lifetime.

Sure. I was thinking that configfs helped subsystems with such module refer=
ence
counting issues, but I was wrong.

> 	Anyone who has just the single reference is safe, because that's
> the last reference.  When we call the last config_item_put(), the
> release happens.  That's the simple case.
> 	A module that takes an additional reference to the config item
> needs to have this protection in place.  All in-kernel users take and
> release items in one function call.  They don't hold long-term
> references.  If they did, they'd have to have a way of ensuring their
> structure remained alive - and this would be the case if configfs wasn't
> even involved.

Thanks for these explanations.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-13801-1213350633-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIUkM/VKcRuvQ9Q1QRAhwPAKCYJ7UD5+3vrV9C57fDwiNZ9lRuYwCgmQJG
RJUty+V2niRmKGBrNDS9Xhk=
=NaTD
-----END PGP SIGNATURE-----

--=_bohort-13801-1213350633-0001-2--
