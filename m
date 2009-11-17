Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZKQLvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZKQLvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZKQLvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:51:37 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:45988 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbZKQLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:51:36 -0500
Date: Tue, 17 Nov 2009 12:51:37 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 19/21] workqueue: introduce worker
Message-ID: <20091117115137.GL4379@hawkmoon.kerlabs.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
	jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
	jens.axboe@oracle.com, rusty@rustcorp.com.au,
	cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
	torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
	andi@firstfloor.org, fweisbec@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-18173-1258458641-0001-2"
Content-Disposition: inline
In-Reply-To: <20091117113952.GK4379@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-18173-1258458641-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17/11/09 12:39 +0100, Louis Rilling wrote:
> Hi Tejun,
>=20
> On 17/11/09  2:15 +0900, Tejun Heo wrote:
> > Separate out worker thread related information to struct worker from
> > struct cpu_workqueue_struct and implement helper functions to deal
> > with the new struct worker.  The only change which is visible outside
> > is that now workqueue worker are all named "kworker/CPUID:WORKERID"
> > where WORKERID is allocated from per-cpu ida.
> >=20
> > This is in preparation of concurrency managed workqueue where shared
> > multiple workers would be available per cpu.
> >=20
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > ---
> >  kernel/workqueue.c |  219 +++++++++++++++++++++++++++++++++++++-------=
--------
> >  1 files changed, 157 insertions(+), 62 deletions(-)
> >=20
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index dce5ad5..6694b3e 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
>=20
> [...]
>=20
> > @@ -413,6 +426,105 @@ int queue_delayed_work_on(int cpu, struct workque=
ue_struct *wq,
> >  }
> >  EXPORT_SYMBOL_GPL(queue_delayed_work_on);
> > =20
> > +static struct worker *alloc_worker(void)
> > +{
> > +	struct worker *worker;
> > +
> > +	worker =3D kzalloc(sizeof(*worker), GFP_KERNEL);
> > +	return worker;
> > +}
> > +
> > +/**
> > + * create_worker - create a new workqueue worker
> > + * @cwq: cwq the new worker will belong to
> > + * @bind: whether to set affinity to @cpu or not
> > + *
> > + * Create a new worker which is bound to @cwq.  The returned worker
> > + * can be started by calling start_worker() or destroyed using
> > + * destroy_worker().
> > + *
> > + * CONTEXT:
> > + * Might sleep.  Does GFP_KERNEL allocations.
> > + *
> > + * RETURNS:
> > + * Pointer to the newly created worker.
> > + */
> > +static struct worker *create_worker(struct cpu_workqueue_struct *cwq, =
bool bind)
> > +{
> > +	int id =3D -1;
> > +	struct worker *worker =3D NULL;
> > +
> > +	spin_lock(&workqueue_lock);
> > +	while (ida_get_new(&per_cpu(worker_ida, cwq->cpu), &id)) {
> > +		spin_unlock_irq(&workqueue_lock);
> > +		if (!ida_pre_get(&per_cpu(worker_ida, cwq->cpu), GFP_KERNEL))
> > +			goto fail;
> > +		spin_lock(&workqueue_lock);
> > +	}
> > +	spin_unlock_irq(&workqueue_lock);
> > +
> > +	worker =3D alloc_worker();
> > +	if (!worker)
> > +		goto fail;
> > +
> > +	worker->cwq =3D cwq;
> > +	worker->id =3D id;
> > +
> > +	worker->task =3D kthread_create(worker_thread, worker, "kworker/%u:%d=
",
> > +				      cwq->cpu, id);
> > +	if (IS_ERR(worker->task))
> > +		goto fail;
> > +
> > +	if (bind)
> > +		kthread_bind(worker->task, cwq->cpu);
> > +
> > +	return worker;
> > +fail:
> > +	if (id >=3D 0) {
> > +		spin_lock(&workqueue_lock);
> > +		ida_remove(&per_cpu(worker_ida, cwq->cpu), id);
> > +		spin_unlock_irq(&workqueue_lock);
> > +	}
> > +	kfree(worker);
> > +	return NULL;
> > +}
>=20
> AFAIU create_worker() should call spin_lock_irq() instead of spin_lock().

spin_unlock() instead of spin_unlock_irq() looks better in fact ;).

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-18173-1258458641-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksCjkkACgkQVKcRuvQ9Q1TlOACfQxYnfJwDfUvnSKW1h/WI5mw6
aQsAn3vnA1r7G5Fj4KiBar52Q/FyJjaR
=YJOQ
-----END PGP SIGNATURE-----

--=_bohort-18173-1258458641-0001-2--
