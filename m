Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYFRLky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYFRLky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYFRLkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:40:46 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:47444 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbYFRLkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:40:45 -0400
Date: Wed, 18 Jun 2008 13:40:43 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH 3/3] configfs: Fix failing symlink() making
	rmdir() fail
Message-ID: <20080618114043.GB30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com> <1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com> <20080617221528.GA29091@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-10153-1213789154-0001-2"
Content-Disposition: inline
In-Reply-To: <20080617221528.GA29091@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-10153-1213789154-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2008 at 03:15:28PM -0700, Joel Becker wrote:
> On Tue, Jun 17, 2008 at 07:37:23PM +0200, Louis Rilling wrote:
> > For the parent's rmdir() case, we can use the same solution as with mkd=
ir() vs
> > rmdir(). For the target's rmdir() case, we cannot, since we do not and =
cannot
> > lock the target's inode while in symlink(). Fortunately, once create_li=
nk()
> > terminates, no further operation can fail in symlink(). So we first reo=
rder the
> > operations in create_link() to attach the new symlink to its target in =
last
> > place, and second handle symlink creation failure the same way as a new=
 item
> > creation failure.
>=20
> 	Oh, no, ugh.  We don't want to create vfs objects first and ask
> questions later.  Otherwise we wouldn't need ATTACHING - we'd just
> create the symlink, then check dropping.
> 	If you have ATTACHING set, the rmdir cannot continue - you can
> check dropping at that time.  That is, you keep the DROPPING check where
> it is - if it is already set, you know that rmdir() is going to complete
> successfully.  You can bail before even calling configfs_create_link().
> If, however, it isn't set, your ATTACHING protects you from rmdir
> throughout.

The problem is rmdir() of the target item (see below). ATTACHING only prote=
cts
us from rmdir() of the parent. This is the exact reason why I attach the li=
nk to
the target in last place, where we know that we won't have to rollback.
	And AFAICS, creating a VFS object can not hurt as long as we hold the
parent i_mutex, right? Otherwise there already is a problem in
configfs_attach_item() where a failure in populate_attrs() leads to rollbac=
k the
creation of the VFS object already created for the item.

> =20
> 	sl =3D kmalloc(sizeof(struct configfs_symlink), GFP_KERNEL);
>  	if (sl) {
>  		sl->sl_target =3D config_item_get(item);
>  		spin_lock(&configfs_dirent_lock);
> 		if (target_sd->s_type & CONFIGFS_USET_DROPPING) {
> 			spin_unlock(&configfs_dirent_lock);
> 			config_item_put(item);
> 			kfree(sl);
> 			return -ENOENT;
> 			/*
> 		 	* Force rmdir() of parent_item to wait until we know
> 		 	* if we succeed.
> 		 	*/
> 			parent_sd->s_type |=3D CONFIGFS_USET_ATTACHING;
> 		}
> 		list_add(&sl->sl_list, &target_sd->s_links);
>  		spin_unlock(&configfs_dirent_lock);
>  		ret =3D configfs_create_link(sl, parent_item->ci_dentry,
>  					   dentry);
> 		spin_lock(&configfs_dirent_lock);
> 		parent_sd->s_type &=3D ~CONFIGFS_USET_ATTACHING;
> 		if (ret) {

Here, if detach_prep() of the target failed because of the link attached ab=
ove,
it had no means to retry. rmdir() of the target fails because of this
temporary link, which results in a failing symlink() making rmdir() of the
target fail.

> 			list_del_init(&sl->sl_list);
>  			spin_unlock(&configfs_dirent_lock);
>  			config_item_put(item);
>  			kfree(sl);
>  		} else
> 			spin_unlock(&configfs_dirent_lock);
>  	}
> =20
>  	return ret;
>=20

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-10153-1213789154-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIWPQ7VKcRuvQ9Q1QRAvstAJ9b1QhYHTdZLYwD3XMVJEV2VvnHRgCghEnL
0aZ98ZQ/tXIDob0MfuQNQyc=
=KQ34
-----END PGP SIGNATURE-----

--=_bohort-10153-1213789154-0001-2--
