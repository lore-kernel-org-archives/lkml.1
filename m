Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZGXKIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZGXKIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZGXKIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:08:10 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54570 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZGXKIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:08:10 -0400
Date: Fri, 24 Jul 2009 12:08:07 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Ben Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090724100807.GG11101@hawkmoon.kerlabs.com>
Mail-Followup-To: Ben Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org, akpm@linux-foundation.org,
	serue@us.ibm.com, lizf@cn.fujitsu.com, menage@google.com
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com> <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com> <20090724100220.GF11101@hawkmoon.kerlabs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-21203-1248430057-0001-2"
Content-Disposition: inline
In-Reply-To: <20090724100220.GF11101@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-21203-1248430057-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/07/09 12:02 +0200, Louis Rilling wrote:
> Hi Ben,
>=20
> On 23/07/09 20:22 -0700, Ben Blum wrote:
> > Makes procs file writable to move all threads by tgid at once
> >=20
> > This patch adds functionality that enables users to move all threads in=
 a
> > threadgroup at once to a cgroup by writing the tgid to the 'cgroup.proc=
s'
> > file. This current implementation makes use of a rwsem that's taken for
> > reading in the fork() path to prevent newly forking threads within the
> > threadgroup from "escaping" while moving is in progress.
> >=20
> > Signed-off-by: Ben Blum <bblum@google.com>
>=20

[...]

> > +int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> > +{
> > +	int retval;
> > +	struct cgroup_subsys *ss;
> > +	struct cgroup *oldcgrp;
> > +	struct css_set *oldcg;
> > +	struct cgroupfs_root *root =3D cgrp->root;
> > +	int subsys_id;
> > +	/* threadgroup list cursor */
> > +	struct task_struct *tsk;
> > +	/*
> > +	 * we need to make sure we have css_sets for all the tasks we're
> > +	 * going to move -before- we actually start moving them, so that in
> > +	 * case we get an ENOMEM we can bail out before making any changes.
> > +	 */
> > +	struct list_head newcg_list;
> > +	struct cg_list_entry *cg_entry;
> > +
> > +	/* first, make sure this came from a valid tgid */
> > +	if (!thread_group_leader(leader))
> > +		return -EINVAL;
> > +	/*
> > +	 * check that we can legitimately attach to the cgroup.
> > +	 */
> > +	for_each_subsys(root, ss) {
> > +		if (ss->can_attach) {
> > +			retval =3D ss->can_attach(ss, cgrp, leader);
> > +			if (retval)
> > +				return retval;
> > +		}
> >  	}
>=20
> So the semantics of ->can_attach() becomes: if called for a thread group =
leader,
> the result should be valid for the whole thread group, even if only the t=
hread
> group leader is being attached. This looks a bit fuzzy and thus not desir=
able.
> Why not checking ->can_attach() for all threads (and lock cgroup_fork_mut=
ex
> earlier)?

Ok I've read the next patch. Patch 6 should really go before this one, both=
 for
better understanding and safety.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-21203-1248430057-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkppiAcACgkQVKcRuvQ9Q1T8WQCeJdh1nPjuNw0IPoALo3/Omb4H
p4oAoIfE+CN3T5BwF/uOQuemosudVqII
=tcg3
-----END PGP SIGNATURE-----

--=_bohort-21203-1248430057-0001-2--
