Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbXJWQ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbXJWQ06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbXJWQ0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:26:39 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59624 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753276AbXJWQ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:26:38 -0400
Subject: Re: [RFC/PATCH 3/5] rt: plist_head_splice
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@mvista.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <Pine.LNX.4.58.0710231108050.31159@gandalf.stny.rr.com>
References: <20071023120357.782284000@chello.nl>
	 <20071023120745.122724000@chello.nl>
	 <Pine.LNX.4.58.0710231108050.31159@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o3865CblFH4McvXQrR+C"
Date: Tue, 23 Oct 2007 18:26:33 +0200
Message-Id: <1193156793.6914.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o3865CblFH4McvXQrR+C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-23 at 11:10 -0400, Steven Rostedt wrote:
> --
> On Tue, 23 Oct 2007, Peter Zijlstra wrote:
> > +
> > +void plist_head_splice(struct plist_head *src, struct plist_head *dst)
> > +{
> > +	struct plist_node *src_iter_first, *src_iter_last, *dst_iter;
> > +	struct plist_node *tail =3D container_of(dst, struct plist_node, plis=
t);
> > +
> > +	dst_iter =3D next_prio(tail);
> > +
> > +	while (!plist_head_empty(src) && dst_iter !=3D tail) {
> > +		src_iter_first =3D plist_first(src);
> > +
> > +		src_iter_last =3D next_prio(src_iter_first);
> > +		src_iter_last =3D prev_node(src_iter_last);
> > +
> > +		WARN_ON(src_iter_first->prio !=3D src_iter_last->prio);
> > +		WARN_ON(list_empty(&src_iter_first->plist.prio_list));
> > +
> > +		while (src_iter_first->prio > dst_iter->prio) {
> > +			dst_iter =3D next_prio(dst_iter);
> > +			if (dst_iter =3D=3D tail)
> > +				goto tail;
> > +		}
> > +
> > +		list_del_init(&src_iter_first->plist.prio_list);
> > +
> > +		if (src_iter_first->prio < dst_iter->prio) {
>=20
> I may be confused here, but shouldn't we be linking the
> src_iter_first->prio_list somewhere here? Doesn't all different prios nee=
d
> to be in its separate prio_list? Otherwise two splices in a row can cause
> the above WARN_ON (prio !=3D prio).
>=20

> > +			list_add_tail(&src_iter_first->plist.node_list,
> > +					&dst_iter->plist.node_list);

Uhm, yeah, that was supposed the be prio_list indeed.

Thanks!

> > +		} else if (src_iter_first->prio =3D=3D dst_iter->prio) {
> > +			dst_iter =3D next_prio(dst_iter);
> > +		} else BUG();
> > +
> > +		list_splice2_tail(&src_iter_first->plist.node_list,
> > +			       	  &src_iter_last->plist.node_list,
> > +				  &dst_iter->plist.node_list);
> > +	}
> > +
> > +tail:
> > +	list_splice_tail_init(&src->prio_list, &dst->prio_list);
> > +	list_splice_tail_init(&src->node_list, &dst->node_list);
> > +}
> >
> > --
> >
> >
> >

--=-o3865CblFH4McvXQrR+C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHHiC5XA2jU0ANEf4RAm7dAJ93rWRrcWIlV9etfUYQtupsajvtfgCdHJoq
+AgRsNpgzea/l/jcmHc+9UQ=
=kOAD
-----END PGP SIGNATURE-----

--=-o3865CblFH4McvXQrR+C--

