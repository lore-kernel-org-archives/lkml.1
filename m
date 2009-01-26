Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbZAZNZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbZAZNZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZAZNY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:24:57 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:51661 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZAZNY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:24:56 -0500
Date: Mon, 26 Jan 2009 14:24:53 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joel Becker <Joel.Becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20090126132453.GD7532@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Joel Becker <Joel.Becker@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	swhiteho <swhiteho@redhat.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com> <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com> <20081217134020.42da55fc.akpm@linux-foundation.org> <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com> <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins> <20081218225837.GB21870@mail.oracle.com> <1232973009.4863.76.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-8514-1232976132-0001-2"
Content-Disposition: inline
In-Reply-To: <1232973009.4863.76.camel@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-8514-1232976132-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

Thank you for continuing this discussion :)

On 26/01/09 13:30 +0100, Peter Zijlstra wrote:
> On Thu, 2008-12-18 at 14:58 -0800, Joel Becker wrote:
> > On Thu, Dec 18, 2008 at 01:28:28PM +0100, Peter Zijlstra wrote:
> > > In fact, both (configfs) mkdir and rmdir seem to synchronize on
> > > su_mutex..
> > >=20
> > >  mkdir B/C/bar
> > >=20
> > >    C.i_mutex
> > >      su_mutex
> > >=20
> > > vs
> > >=20
> > >  rmdir foo
> > >=20
> > >    parent(foo).i_mutex
> > >      foo.i_mutex
> > >        su_mutex
> > >=20
> > >=20
> > > once holding the rmdir su_mutex you can check foo's user-content, sin=
ce
> > > any mkdir will be blocked. All you have to do is then re-validate in
> > > mkdir's su_mutex that !IS_DEADDIR(C).
> >=20
> > 	We explicitly do not take any i_mutex locks after taking
> > su_mutex.  That's an ABBA risk.  su_mutex protects the hierarchy of
> > config_items.  i_mutex protects the vfs view thereof.
>=20
> I don't think I was suggesting that. All you need is to serialize any
> mkdir/creat against the rmdir of the youngest non-default group, and you
> can do that by holding su_mutex.
>=20
> In rmdir, you already own all the i_mutex instances you need to uncouple
> the whole tree, all you need to do is validate that its indeed empty --
> you don't need i_mutex's for that, because you're holding su_mutex, and
> any concurrent mkdir/creat will be blocking on that.
>=20
> If you find it empty, just mark everybody DEAD, drop su_mutex and
> decouple. All concurrent mkdir/creat thingies that were blocking will
> now bail because their parent is found DEAD.
>=20
> > 	If you look in mkdir, we take su_mutex, get a new item from the
> > client subsystem, then drop su_mutex.=20
>=20
> All you need to do before dropping su_mutex again is checking
> IS_DEADDIR(), if so, you just fail the whole mkdir() no extra i_mutex's
> needed.
>=20
> >  After that, we go about building
> > our filesystem structure, using i_mutex where appropriate.=20
>=20
> Sure, but its ok to grow the default groups non-atomically, right? mkdir
> will only need to check that everything is empty in as far as it has
> been linked, and ensure the not yet linked entries won't be.
>=20
> >  More
> > importantly is rmdir(2), where we use i_mutex in
> > configfs_detach_group(), but are not holding su_sem.  Only when
> > configfs_detach_group() has successfully returned and we have torn down
> > the filesystem structure do we take su_mutex and tear down the
> > config_item structure.
>=20
> The only thing that matters is that you can hold su_mutex inside
> i_mutex.
>=20
>=20
> configfs_rmdir( "foo" )
> {
>  /* we hold i_mutex for foo and its parent */
>=20
>  mutex_lock(&subsys->su_mutex);
>  if (default_tree_empty())
>   mark_default_tree_dead();
>  else
>   ret =3D -EBUSY;
>  mutex_unlock(&subsys->su_mutex);
>=20
>  if (ret)
>   return ret;
>=20
>  /* do actual unlink foo */
> }
>=20
>=20
> configfs_mkdir( "B/A/bar" )
> {
>  /* we hold i_mutex for A */
>=20
>  mutex_lock(&subsys->su_mutex);
>  if (IS_DEADDIR(A))
>   ret =3D -EINVAL; /* or whatever */
>=20
>  /* increase A's use count, so default_tree_empty() will fail. *
>  inc_A_or_subsys_use_count();
>  mutex_unlock(&subsys->su_mutex);
>  if (ret)
>   return ret;
>=20
>  /* do actual mkdir */
> }
>=20
>=20
> Surely something along these lines ought to work?

I may have missed something important here, but how does your suggestion re=
move
the need for recursively locking inodes?

In configfs_rmdir(), we do not need to lock default groups inodes to prevent
racing mkdir() under them. This race is already dealt with earlier in
configfs_detach_prep(), which tries to set the CONFIGS_USET_DROPPING flag o=
n the
group to remove and on all its hierarchy of default groups, protected by
configfs_dirent_lock. The matching logic in configfs_mkdir() may look a bit
burried but is simple: configfs_attach_item()/configfs_attach_group() event=
ually
calls configfs_new_dirent(), which fails whenever the parent is tagged with
CONFIGFS_USET_DROPPING. Again, no inode locking is required for this logic.

However configfs_rmdir() and configfs_mkdir() (recursively) lock inodes bec=
ause
this is how the VFS works when removing/adding entries under a directory wh=
ich
has already lived in the dcache.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-8514-1232976132-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJfbmlVKcRuvQ9Q1QRAqBmAKCQvwHNb1W8vz2hZL4n/8Lnt/YSNgCgw4cm
vLfbMxgo7NV9nhXy7znHGzg=
=SjH1
-----END PGP SIGNATURE-----

--=_bohort-8514-1232976132-0001-2--
