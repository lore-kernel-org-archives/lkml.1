Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZA1Ki4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZA1Ki4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZA1Kir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:38:47 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:43373 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZA1Kiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:38:46 -0500
Date: Wed, 28 Jan 2009 11:38:43 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: [PATCH 1/2] configfs: Silence lockdep on mkdir() and rmdir()
Message-ID: <20090128103843.GL7532@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <20081218111536.GR19128@hawkmoon.kerlabs.com> <1229623218-8056-2-git-send-email-louis.rilling@kerlabs.com> <20090128035547.GE7244@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-20491-1233138962-0001-2"
Content-Disposition: inline
In-Reply-To: <20090128035547.GE7244@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-20491-1233138962-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27/01/09 19:55 -0800, Joel Becker wrote:
> On Thu, Dec 18, 2008 at 07:00:17PM +0100, Louis Rilling wrote:

[...]

>=20
> >  #define CONFIGFS_ROOT		0x0001
> > diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> > index 8e93341..f21be74 100644
> > --- a/fs/configfs/dir.c
> > +++ b/fs/configfs/dir.c
> > @@ -94,6 +94,9 @@ static struct configfs_dirent *configfs_new_dirent(st=
ruct configfs_dirent * pare
> >  	INIT_LIST_HEAD(&sd->s_links);
> >  	INIT_LIST_HEAD(&sd->s_children);
> >  	sd->s_element =3D element;
> > +#ifdef CONFIG_LOCKDEP
> > +	sd->s_depth =3D -1;
> > +#endif
> >  	spin_lock(&configfs_dirent_lock);
> >  	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
> >  		spin_unlock(&configfs_dirent_lock);
> > @@ -176,6 +179,17 @@ static int init_symlink(struct inode * inode)
> >  	return 0;
> >  }
> > =20
> > +#ifdef CONFIG_LOCKDEP
> > +static void configfs_set_dir_dirent_depth(struct configfs_dirent *pare=
nt_sd,
> > +					  struct configfs_dirent *sd)
> > +{
> > +	int parent_depth =3D parent_sd->s_depth;
> > +
> > +	if (parent_depth >=3D 0)
> > +		sd->s_depth =3D parent_depth + 1;
> > +}
> > +#endif
> > +
> >  static int create_dir(struct config_item * k, struct dentry * p,
> >  		      struct dentry * d)
> >  {
> > @@ -187,6 +201,9 @@ static int create_dir(struct config_item * k, struc=
t dentry * p,
> >  		error =3D configfs_make_dirent(p->d_fsdata, d, k, mode,
> >  					     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
> >  	if (!error) {
> > +#ifdef CONFIG_LOCKDEP
> > +		configfs_set_dir_dirent_depth(p->d_fsdata, d->d_fsdata);
> > +#endif
> >  		error =3D configfs_create(d, mode, init_dir);
> >  		if (!error) {
> >  			inc_nlink(p->d_inode);
>=20
> 	Can you change this to provide non-lockdep versions of
> functions?  We don't want "#ifdef CONFIG_LOCKDEP" everywhere.  What we
> want is the code to call functions unconditionally, and the functions to
> do nothing if lockdep is not enabled.  Like:
>=20
> #ifdef CONFIG_LOCKDEP
> static inline void configfs_init_dir_dirent_depth(dirent)
> {
>     dirent->s_depth =3D -1;
> }
>=20
> static void configfs_set_dir_dirent_depth(struct configfs_dirent *parent_=
sd,
> 					  struct configfs_dirent *sd)
> {
> 	int parent_depth =3D parent_sd->s_depth;
>=20
> 	if (parent_depth >=3D 0)
> 		sd->s_depth =3D parent_depth + 1;
> }
> #else
> static inline void configfs_init_dir_dirent_depth(dirent)
> {
> }
>=20
> static void configfs_set_dir_dirent_depth(struct configfs_dirent *parent_=
sd,
> 					  struct configfs_dirent *sd)
> {
> }
> #endif
>=20
> 	This makes the callsites much nicer to read:
>=20
> @@ -94,6 +94,9 @@ static struct configfs_dirent *configfs_new_dirent(stru=
ct configfs_dirent * pare
>  	INIT_LIST_HEAD(&sd->s_links);
>  	INIT_LIST_HEAD(&sd->s_children);
>  	sd->s_element =3D element;
> +	configfs_init_dir_dirent_depth(sd);
>  	spin_lock(&configfs_dirent_lock);
>  	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
>  		spin_unlock(&configfs_dirent_lock);
> @@ -187,6 +201,7 @@ static int create_dir(struct config_item * k, struct =
dentry * p,
>  		error =3D configfs_make_dirent(p->d_fsdata, d, k, mode,
>  					     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
>  	if (!error) {
> +		configfs_set_dir_dirent_depth(p->d_fsdata, d->d_fsdata);
>  		error =3D configfs_create(d, mode, init_dir);
>  		if (!error) {
>  			inc_nlink(p->d_inode);

Sure, that's why I said that this could be cleaner ;)

>=20
> 	Otherwise, this patch seems pretty straightforward.

Cleaner patch coming.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-20491-1233138962-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJgDWzVKcRuvQ9Q1QRAqgKAJ4oXyOrNqIzImIkSdOunu8cn9sOHQCg0xnp
L0Gw/DvsgLVHwNSLD3zHiL4=
=amBH
-----END PGP SIGNATURE-----

--=_bohort-20491-1233138962-0001-2--
