Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZDXFvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZDXFvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 01:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZDXFvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 01:51:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:1624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538AbZDXFvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 01:51:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,240,1239001200"; 
   d="asc'?scan'208";a="451016800"
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49EEFB7E.4020605@linux.intel.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
	 <49EEFB7E.4020605@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hFlwJyKTyhUs4gmkXHSV"
Date: Fri, 24 Apr 2009 13:51:01 +0800
Message-Id: <1240552261.6842.857.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hFlwJyKTyhUs4gmkXHSV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-22 at 19:11 +0800, Andi Kleen wrote:
> Huang Ying wrote:
>=20
> Basic concept is good and it fixes some long standing problems.
>=20
> But some details need to be improved I think:
>=20
> > +/*
> > + * Initialize MCE per-CPU log buffer
> > + */
> > +static void mce_log_init(void)
> > +{
> > +	int cpu;
> > +	struct mce_log_cpu *mcelog_cpu;
> > +
> > +	if (mcelog.log_cpus)
> > +		return;
> > +	mcelog.log_cpus =3D kmalloc(num_possible_cpus() * sizeof(mcelog_cpu),
> > +				  GFP_KERNEL);
> > +	for_each_possible_cpu(cpu) {
> > +		mcelog_cpu =3D &per_cpu(mcelog_cpus, cpu);
> > +		mcelog.log_cpus[cpu] =3D mcelog_cpu;
> > +	}
>=20
> I don't understand why the separate allocation. Can't you just put
> the whole log buffer directly into the per cpu data?
>=20
> This would also make the initialization cleaner because you would need to=
 only
> initialize state for the currently initialized CPU.

The original intention to use mcelog.log_cpus is to make it easier to
find per-cpu buffers from memory image produced by kdump. But is seems
that something as follow is just sufficient.

mcelog.log_cpus =3D alloc_percpu(struct mce_log_cpu);

Is this what you suggested?

>=20
> > +			while (!mcelog_cpu->entry[i].finished) {
> > +				rdtscll(now);
> > +				if (now - start > WRITER_TIMEOUT_CYC) {
> > +					memset(mcelog_cpu->entry + i, 0,
> >  					       sizeof(struct mce));
> > +					head =3D mcelog_cpu->head;
> >  					goto timeout;
>=20
> This timeout should be reported somehow, perhaps with a printk.
> Also it's problematic to hardcode cycles here, i think it would
> be better to use a similar scheme as the Monarch timeout
> with a ndelay() and a spinunit. That is guaranteed to stay
> the same even as CPU frequencies change.

Yes. I will change this.

> > +static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t=
 usize,
> > +			loff_t *off)
> > +{
> > +	char __user *ubuf =3D inubuf;
> > +	struct mce_log_cpu *mcelog_cpu;
> > +	int cpu, new_mce, err =3D 0;
> > +	static DEFINE_MUTEX(mce_read_mutex);
> > +	size_t usize_limit;
> > +
> > +	/* Too large user buffer size may cause system not response */
>=20
> Did you understand why that happens? It's worrying.

The loop in mce_read() does not release the CPU in non-preempt kernel.
If the user buffer size is too large, it may cause the CPU to be
soft-lock-upped or not response. One way to solve the issue is to
constrain the size of user buffer, another way may be insert a
schedule() in the loop.=20

> > +static ssize_t show_log_flags(struct sys_device *s,
> > +			      struct sysdev_attribute *attr,
> > +			      char *buf)
> > +{
> > +	int cpu =3D s->id;
> > +	struct mce_log_cpu *mcelog_cpu =3D &per_cpu(mcelog_cpus, cpu);
> > +	unsigned flags;
> > +	do {
> > +		flags =3D mcelog_cpu->flags;
> > +	} while (cmpxchg((unsigned *)&mcelog_cpu->flags, flags, 0) !=3D flags=
);
> > +	return sprintf(buf, "0x%x\n", flags);
> > +}
> > +
> >  static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
> >  static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
> >  ACCESSOR(check_interval,check_interval,mce_restart())
> > +static SYSDEV_ATTR(log_flags, 0644, show_log_flags, NULL);
>=20
> Do we really need that interface? It seems rather obscure.
> mcelog should get these flags anyways. Better to drop it.

For overflow flag, it seems not very useful. I will drop this.

Best Regards,
Huang Ying


--=-hFlwJyKTyhUs4gmkXHSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxU0IACgkQKhFGF+eHlpiDUACgqvS5PObKnHwXv0+6z18JblEG
zXMAoJsf4/Yk5l7Q4fCcrErX7BUMjia+
=1VyK
-----END PGP SIGNATURE-----

--=-hFlwJyKTyhUs4gmkXHSV--

