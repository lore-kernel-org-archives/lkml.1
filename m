Return-Path: <linux-kernel-owner+w=401wt.eu-S1764914AbXHQQXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764914AbXHQQXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXHQQXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:23:14 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10113 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754613AbXHQQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:23:12 -0400
Subject: Re: [PATCH 16/23] mm: scalable bdi statistics counters.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
In-Reply-To: <20070817162030.GA27836@filer.fsl.cs.sunysb.edu>
References: <20070816074525.065850000@chello.nl>
	 <20070816074628.520798000@chello.nl>
	 <20070817162030.GA27836@filer.fsl.cs.sunysb.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HE5+SSmnle+pT2IB5ITF"
Date: Fri, 17 Aug 2007 18:23:02 +0200
Message-Id: <1187367782.6114.132.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HE5+SSmnle+pT2IB5ITF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 12:20 -0400, Josef Sipek wrote:
> On Thu, Aug 16, 2007 at 09:45:41AM +0200, Peter Zijlstra wrote:
> ....
> > Index: linux-2.6/include/linux/backing-dev.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/include/linux/backing-dev.h
> > +++ linux-2.6/include/linux/backing-dev.h
> ....
> > @@ -24,6 +26,12 @@ enum bdi_state {
> > =20
> >  typedef int (congested_fn)(void *, int);
> > =20
> > +enum bdi_stat_item {
> > +	NR_BDI_STAT_ITEMS
> > +};
>=20
> enum numbering starts at 0, so NR_BDI_STAT_ITEMS =3D=3D 0
>=20
> > +
> > +#define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
> > +
> >  struct backing_dev_info {
> >  	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
> >  	unsigned long state;	/* Always use atomic bitops on this */
> > @@ -32,15 +40,86 @@ struct backing_dev_info {
> >  	void *congested_data;	/* Pointer to aux data for congested func */
> >  	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
> >  	void *unplug_io_data;
> > +
> > +	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
>=20
> So, this is a 0-element array.
>=20
> >  };
> > =20
> > -static inline int bdi_init(struct backing_dev_info *bdi)
> > +int bdi_init(struct backing_dev_info *bdi);
> > +void bdi_destroy(struct backing_dev_info *bdi);
> > +
> > +static inline void __add_bdi_stat(struct backing_dev_info *bdi,
> > +		enum bdi_stat_item item, s64 amount)
> >  {
> > -	return 0;
> > +	__percpu_counter_add(&bdi->bdi_stat[item], amount, BDI_STAT_BATCH);
>=20
> Boom!
>=20
> >  }

Quite so, but since there are no callers _yet_ it will not go boom :-)

This patch introduces the framework, patch 17 and 18 will introduce both
stat items and callers.

So it should all work out just fine.

--=-HE5+SSmnle+pT2IB5ITF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGxctmXA2jU0ANEf4RAonUAJ4iD7JBaQB2UgldCQniZdBibJwbpgCgiwcQ
q9JNa142MkTqspID2JJEZgM=
=WwQO
-----END PGP SIGNATURE-----

--=-HE5+SSmnle+pT2IB5ITF--

