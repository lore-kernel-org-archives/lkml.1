Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZEDKUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZEDKUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZEDKU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:20:28 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:59908 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZEDKU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:20:27 -0400
Date: Mon, 4 May 2009 12:20:25 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: [PATCH 2/2] configfs: Rework configfs_depend_item() locking
	and make lockdep happy
Message-ID: <20090504102025.GI13896@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com> <1233166713-9668-3-git-send-email-louis.rilling@kerlabs.com> <20090429185231.GE4743@mail.oracle.com> <20090430091828.GB13896@hawkmoon.kerlabs.com> <20090430172014.GA2762@mail.oracle.com> <20090430173035.GB2762@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-2163-1241432411-0001-2"
Content-Disposition: inline
In-Reply-To: <20090430173035.GB2762@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-2163-1241432411-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30/04/09 10:30 -0700, Joel Becker wrote:
> On Thu, Apr 30, 2009 at 10:20:14AM -0700, Joel Becker wrote:
> > On Thu, Apr 30, 2009 at 11:18:28AM +0200, Louis Rilling wrote:
> > > Agreed, I was going to suggest something like this. Actually I'd push=
 the
> > > initialization of s_type down to configfs_new_dirent(), so that s_typ=
e either
> > > is always NULL, or always shows the correct type of object.
> >=20
> > 	0, not "NULL", but yeah I think that's a good plan.
>=20
> 	Like this.  Please review the comment change mostly.

Indeed, the code is exactly what I had in mind. Small comments about the co=
mment
change below.

Thanks!

Acked-by: Louis Rilling <louis.rilling@kerlabs.com>

>=20
>=20
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index 63d8815..8e48b52 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -167,8 +167,8 @@ configfs_adjust_dir_dirent_depth_after_populate(struc=
t configfs_dirent *sd)
>  /*
>   * Allocates a new configfs_dirent and links it to the parent configfs_d=
irent
>   */
> -static struct configfs_dirent *configfs_new_dirent(struct configfs_diren=
t * parent_sd,
> -						void * element)
> +static struct configfs_dirent *configfs_new_dirent(struct configfs_diren=
t *parent_sd,
> +						   void *element, int type)
>  {
>  	struct configfs_dirent * sd;
> =20
> @@ -180,6 +180,7 @@ static struct configfs_dirent *configfs_new_dirent(st=
ruct configfs_dirent * pare
>  	INIT_LIST_HEAD(&sd->s_links);
>  	INIT_LIST_HEAD(&sd->s_children);
>  	sd->s_element =3D element;
> +	sd->s_type =3D type;
>  	configfs_init_dirent_depth(sd);
>  	spin_lock(&configfs_dirent_lock);
>  	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
> @@ -225,19 +226,12 @@ int configfs_make_dirent(struct configfs_dirent * p=
arent_sd,
>  {
>  	struct configfs_dirent * sd;
> =20
> -	sd =3D configfs_new_dirent(parent_sd, element);
> +	sd =3D configfs_new_dirent(parent_sd, element, type);
>  	if (IS_ERR(sd))
>  		return PTR_ERR(sd);
> =20
> -	/*
> -	 * We need configfs_dirent_lock so that configfs_depend_prep()
> -	 * can see s_type accurately on other CPUs.
> -	 */
> -	spin_lock(&configfs_dirent_lock);
>  	sd->s_mode =3D mode;
> -	sd->s_type =3D type;
>  	sd->s_dentry =3D dentry;
> -	spin_unlock(&configfs_dirent_lock);
>  	if (dentry) {
>  		dentry->d_fsdata =3D configfs_get(sd);
>  		dentry->d_op =3D &configfs_dentry_ops;
> @@ -1034,11 +1028,10 @@ static int configfs_dump(struct configfs_dirent *=
sd, int level)
>   * dead, as well as items in the middle of attachment since they virtual=
ly
>   * do not exist yet. This completes the locking out of racing mkdir() and
>   * rmdir().
> - * Note: items in the middle of attachment start with s_type =3D 0
> - * (configfs_new_dirent()), and configfs_make_dirent() (called from
> - * create_dir()) sets s_type =3D CONFIGFS_DIR|CONFIGFS_USET_CREATING. In=
 both
> - * cases the item is ignored.  configfs_make_dirent() is locked out from
> - * updating s_type by configfs_dirent_lock.
> + * Note: subdirectories in the middle of attachment start with s_type =3D
> + * CONFIGFS_DIR|CONFIGFS_USET_CREATING set by create_dir().  When

I'd say "As long as CONFIGFS_USET_CREATING is set", since, by design, once =
cleared,
CONFIGFS_USET_CREATING never comes back.

Louis

> + * CONFIGFS_USET_CREATING is set, we ignore the item.  The actual set of
> + * s_type is in configfs_new_dirent(), which has configfs_dirent_lock.
>   *
>   * If the target is not found, -ENOENT is bubbled up.
>   *
> @@ -1514,7 +1507,7 @@ static int configfs_dir_open(struct inode *inode, s=
truct file *file)
>  	 */
>  	err =3D -ENOENT;
>  	if (configfs_dirent_is_ready(parent_sd)) {
> -		file->private_data =3D configfs_new_dirent(parent_sd, NULL);
> +		file->private_data =3D configfs_new_dirent(parent_sd, NULL, 0);
>  		if (IS_ERR(file->private_data))
>  			err =3D PTR_ERR(file->private_data);
>  		else
>=20
> --=20
>=20
> "There is no sincerer love than the love of food." =20
>          - George Bernard Shaw=20
>=20
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker@oracle.com
> Phone: (650) 506-8127
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-2163-1241432411-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ/sFpVKcRuvQ9Q1QRAjn+AJ4wiV1mkxEBBo/sWb0Tjca3s7bd0gCff1TT
pd2JMZZt53zWc1+7y9ccaFY=
=+qKn
-----END PGP SIGNATURE-----

--=_bohort-2163-1241432411-0001-2--
