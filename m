Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbXKUQFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbXKUQFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXKUQFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:05:43 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:47703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbXKUQFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:05:42 -0500
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071121155842.GA864@tv-sign.ru>
References: <20071120234605.GG23667@elte.hu>
	 <20071121155842.GA864@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-21xRRuQNUkb1fHfQZ0Bl"
Date: Wed, 21 Nov 2007 17:06:13 +0100
Message-Id: <1195661173.12000.46.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-21xRRuQNUkb1fHfQZ0Bl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > Ok, then I have question: Is the following pseudocode correct
> > (and problem is in lock validation which checks something
> > already initialized for another queue) or reusing work_struct
> > is not permitted from inside called work function ?
> >
> > (Note comment in code "It is permissible to free the struct
> > work_struct from inside the function that is called from it".)
> >
> > struct work_struct work;
> > struct workqueue_struct *a, *b;
> >
> > do_b(*work)
> > {
> >         /* do something else */
> > }
> >
> > do_a(*work)
> > {
> >         /* do something */
> >         INIT_WORK(&work, do_b);
> >         queue_work(b, &work);
> > }
> >
> >
> > INIT_WORK(&work, do_a);
> > queue_work(a, &work);
>=20
> (just in case, in that particular case PREPARE_WORK() should be used)
>=20
> INIT_WORK(w) can be used if we know that "w" is not pending, and nobody
> else can write to this work (say, queue_work(w) or cancel_work_sync(w)).
> So currently the code above should work correctly.
>=20
> However, I'd say it is not correct, INIT_WORK() can throw out some debug
> info for example, or the implementation could be changed.
>=20
> I'm not sure about CONFIG_LOCKDEP (Johannes cc'ed). INIT_WORK() does
> lockdep_init_map(->lockdep_map) but run_workqueue() has a local copy,
> looks ok.

We explicitly need to use a copy of the lockdep_map for "locking" the
work struct as per the quoted comment. So as far as I can tell, what
INIT_WORK() is doing here is changing an at that point unused copy of
the lockdep map so I think it should be fine. Not sure about the other
fine points nor why you'd want this though :)

johannes

--=-21xRRuQNUkb1fHfQZ0Bl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0RXdKVg1VMiehFYAQLjYQ/5AbDtMq6cvtDAxJPmSDExXlwCtOLVIlmf
DXrqBxvU5Jkp68W2Xwq/Fr73LadV4ouuFArCCeNeekGbIvYjQQcZYfPWnEz5mqsC
He9G02nXn0hlzMEP6qouU/QYw+6L5LG5StaV0eDtznWThn+ylGe9Ci1NT30Co0pQ
Iiqkb2QDVPH4Y1O2OuV1EJxgXVEjvHPAaW3uy4S3YjGkn/r7d5e3EdZb6KPIlLKT
Nr9YeWeEkrtpX6O9XkjQCfAf0DDh9XsPShmi9RYfmFskRBo1UG9B5hWnwPmWkBYG
tw68hdAPveAMsw8xnP+T8zDr7/xwHPtSu5XHk+xNZeyFbMRGZTeJAF+nEYMmC5+z
w/VVSq0VaUpsBfBVB8FMKVvx2f7/o99JTxvhGAv0ERyqnUwtR/xwpiB74FXss1qX
/zh/VK0mpy/QkQ/ejz66C7aVBZTl7xFzOdRsuoSMaAPkR8fuXylLKwabite/vySx
Tym2kxMdgdog2GJtPlAzFDaEg2jYAytBE4n+OQSHF/MsPwq361bA+KDH+LE5VwR/
+M2LVYAgfcXw1hR8v6N48EkkkFIAw8ImuiAawVxRimMeJdlPsvzk2WHHNjKaNPyT
FFkr579Yc7GqYJU0ijfKAL7EXKHYJ7b4deiETFEUk43+0JeT7H9oWdD0zhwSy/fJ
rl2phP9SkrA=
=K3Ce
-----END PGP SIGNATURE-----

--=-21xRRuQNUkb1fHfQZ0Bl--

