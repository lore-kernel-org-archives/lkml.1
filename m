Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZA1KdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZA1KdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZA1Kcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:32:51 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:45398 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZA1Kcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:32:50 -0500
Date: Wed, 28 Jan 2009 11:32:47 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: [PATCH 2/2] configfs: Rework configfs_depend_item() locking
	and make lockdep happy
Message-ID: <20090128103247.GK7532@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <20081218111536.GR19128@hawkmoon.kerlabs.com> <1229623218-8056-3-git-send-email-louis.rilling@kerlabs.com> <20090128041353.GF7244@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-20437-1233138605-0001-2"
Content-Disposition: inline
In-Reply-To: <20090128041353.GF7244@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-20437-1233138605-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27/01/09 20:13 -0800, Joel Becker wrote:
> On Thu, Dec 18, 2008 at 07:00:18PM +0100, Louis Rilling wrote:
> > configfs_depend_item() recursively locks all inodes mutex from configfs=
 root to
> > the target item, which makes lockdep unhappy. The purpose of this recur=
sive
> > locking is to ensure that the item tree can be safely parsed and that t=
he target
> > item, if found, is not about to leave.
> >=20
> > This patch reworks configfs_depend_item() locking using configfs_dirent=
_lock.
> > Since configfs_dirent_lock protects all changes to the configfs_dirent =
tree, and
> > protects tagging of items to be removed, this lock can be used instead =
of the
> > inodes mutex lock chain.
> > This needs that the check for dependents be done atomically with
> > CONFIGFS_USET_DROPPING tagging.
> >=20
> > Now lockdep looks happy with configfs.
>=20
> 	This looks almost, but not quite right.
> 	In the create path, we do configfs_new_dirent() before we set
> sd->s_type.  But configfs_new_dirent() attaches sd->s_sibling.  So, in
> aonther thread, configfs_depend_prep() can traverse this s_sibling
> without CONFIGFS_USET_CREATING being set.  This turns out to be safe
> because CONFIGFS_DIR is also not set - but boy I'd like a comment about
> that.

Definitely agreed. I should have written this comment instead of letting you
notice this.

> 	What if we're in mkdir(2) in one thread and another thread is =20
> trying to pin the parent directory?  That is, we are inside
> configfs_mkdir(parent, new_dentry, mode).  The other thread is doing
> configfs_depend_item(subsys, parent).  With this patch, the other thread
> will not take parent->i_mutex.  It will happily determine that
> parent is part of the tree and bump its s_dependent with no locking.  Is
> this OK?

Yes this is the expected impact. It is OK because
1) under a same critical section of configfs_dirent_lock, depend_item()
checks that CONFIGFS_USET_DROPPING is not set and bumps s_dependent;
2) under a same critical section of configfs_dirent_lock, configfs_rmdir()
checks the s_dependent count and tries to set CONFIGFS_USET_DROPPING.

> 	If it is - isn't this patch good without any other reason?  That
> is, aside from the issues of lockdep, isn't it better for
> configfs_depend_item() to never have to worry about the VFS locks other
> than the configfs root?

Yes, this patch may look like an improvement, independently from lockdep. I
think that locking is simpler this way, and this also removes the need for
configfs_depend_rollback(). Moreover this moves towards the management of
configfs_dirents protected by configfs_dirent_lock only. In the end, it's u=
p to
you to judge if this is a good direction ;)

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-20437-1233138605-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJgDRPVKcRuvQ9Q1QRAvcIAJ41AjxIGhZZGlrEAxwoINP7gayuUwCeNyii
HDBdvohmRZKe2eLCCSOdkQk=
=O/Jz
-----END PGP SIGNATURE-----

--=_bohort-20437-1233138605-0001-2--
