Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbXG3N7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbXG3N7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXG3N7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:59:25 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:43183 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752320AbXG3N7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:59:24 -0400
Subject: Re: [-mm PATCH 6/9] Memory controller add per container LRU and
	reclaim (v4)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Gautham Shenoy <ego@in.ibm.com>
In-Reply-To: <20070730133758.GB22952@linux.vnet.ibm.com>
References: <20070727200937.31565.78623.sendpatchset@balbir-laptop>
	 <20070727201041.31565.14803.sendpatchset@balbir-laptop>
	 <20070730133758.GB22952@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2Lklq5LfYYsu8sQNs49t"
Date: Mon, 30 Jul 2007 15:59:20 +0200
Message-Id: <1185803960.6904.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2Lklq5LfYYsu8sQNs49t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-07-30 at 19:07 +0530, Dhaval Giani wrote:
> Hi Balbir,
>=20
> > diff -puN mm/memcontrol.c~mem-control-lru-and-reclaim mm/memcontrol.c
> > --- linux-2.6.23-rc1-mm1/mm/memcontrol.c~mem-control-lru-and-reclaim	20=
07-07-28 01:12:50.000000000 +0530
> > +++ linux-2.6.23-rc1-mm1-balbir/mm/memcontrol.c	2007-07-28 01:12:50.000=
000000 +0530
> =20
> >  /*
> >   * The memory controller data structure. The memory controller control=
s both
> > @@ -51,6 +54,10 @@ struct mem_container {
> >  	 */
> >  	struct list_head active_list;
> >  	struct list_head inactive_list;
> > +	/*
> > +	 * spin_lock to protect the per container LRU
> > +	 */
> > +	spinlock_t lru_lock;
> >  };
>=20
> The spinlock is not annotated by lockdep. The following patch should do
> it.

One does not need explicit lockdep annotations unless there is a non
obvious use of the locks. A typical example of that would be the inode
locks, that get placed differently in the various filesystem's locking
hierarchy and might hence seem to generate contradictory locking rules -
even though they are consistent within a particular filesystem.

So unless there are 2 or more distinct locking hierarchies this one lock
partakes in, there is no need for this annotation.

Was this patch driven by a lockdep report?

> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Signed-off-by: Gautham Shenoy R <ego@in.ibm.com>
>=20
>=20
> Index: linux-2.6.23-rc1/mm/memcontrol.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.23-rc1.orig/mm/memcontrol.c	2007-07-30 17:27:24.000000000 +=
0530
> +++ linux-2.6.23-rc1/mm/memcontrol.c	2007-07-30 18:43:40.000000000 +0530
> @@ -501,6 +501,9 @@
> =20
>  static struct mem_container init_mem_container;
> =20
> +/* lockdep should know about lru_lock */
> +static struct lock_class_key lru_lock_key;
> +
>  static struct container_subsys_state *
>  mem_container_create(struct container_subsys *ss, struct container *cont=
)
>  {
> @@ -519,6 +522,7 @@
>  	INIT_LIST_HEAD(&mem->active_list);
>  	INIT_LIST_HEAD(&mem->inactive_list);
>  	spin_lock_init(&mem->lru_lock);
> +	lockdep_set_class(&mem->lru_lock, &lru_lock_key);
>  	mem->control_type =3D MEM_CONTAINER_TYPE_ALL;
>  	return &mem->css;
>  }

--=-2Lklq5LfYYsu8sQNs49t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGre64XA2jU0ANEf4RAjOSAKCK8WyNBNLGJgmVOwILsEPLO56nXQCfdunm
inlGMlx6SW/1tPplB9QPjmU=
=q9aE
-----END PGP SIGNATURE-----

--=-2Lklq5LfYYsu8sQNs49t--

