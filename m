Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab0CAKv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:51:27 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:59983 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab0CAKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:51:26 -0500
X-Spam-ASN: 
Date: Mon, 1 Mar 2010 13:51:15 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv2 5/6] pps: add parallel port PPS signal generator
Message-ID: <20100301135115.55c2c9ca@desktopvm.lvknet>
In-Reply-To: <20100301083855.GK3671@enneenne.com>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
	<5ba28a271f7a26a73d869735a81aa8756276c85c.1267008049.git.lasaine@lvk.cs.msu.su>
	<20100301083855.GK3671@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5t8qCbLuoEiVyq06paI0Jxa";
 protocol="application/pgp-signature"; micalg=PGP-SHA256
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5t8qCbLuoEiVyq06paI0Jxa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Mar 2010 09:38:56 +0100
Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Wed, Feb 24, 2010 at 03:28:16PM +0300, Alexander Gordeev wrote:
> > Add PPS signal generator which utilizes STROBE pin of a parallel port to
> > send PPS signals. It uses parport abstraction layer and hrtimers to
> > precisely control the signal.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  drivers/pps/Kconfig                      |    2 +
> >  drivers/pps/Makefile                     |    1 +
> >  drivers/pps/generators/Kconfig           |   17 ++
> >  drivers/pps/generators/Makefile          |    9 +
> >  drivers/pps/generators/pps_gen_parport.c |  264 ++++++++++++++++++++++=
++++++++
> >  5 files changed, 293 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/pps/generators/Kconfig
> >  create mode 100644 drivers/pps/generators/Makefile
> >  create mode 100644 drivers/pps/generators/pps_gen_parport.c
> >=20
> > diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
> > index 2bd4f65..f3b14cd 100644
> > --- a/drivers/pps/Kconfig
> > +++ b/drivers/pps/Kconfig
> > @@ -31,4 +31,6 @@ config PPS_DEBUG
> >  	  messages to the system log.  Select this if you are having a
> >  	  problem with PPS support and want to see more of what is going on.
> > =20
> > +source drivers/pps/generators/Kconfig
> > +
> >  endmenu
> > diff --git a/drivers/pps/Makefile b/drivers/pps/Makefile
> > index 19ea582..b299814 100644
> > --- a/drivers/pps/Makefile
> > +++ b/drivers/pps/Makefile
> > @@ -4,5 +4,6 @@
> > =20
> >  pps_core-y			:=3D pps.o kapi.o sysfs.o
> >  obj-$(CONFIG_PPS)		:=3D pps_core.o
> > +obj-y				+=3D generators/
>=20
> I suppose this patch doesn't apply on top of my latest PPS patchset,
> does it?
>=20
>    http://permalink.gmane.org/gmane.linux.kernel/954152
>=20
> Generators support should be added after PPS clients one.

Sure, I'll swap the patches. I've noticed conflicts too when applying
my patches on top of yours. Thanks!

> > =20
> >  ccflags-$(CONFIG_PPS_DEBUG) :=3D -DDEBUG
> > diff --git a/drivers/pps/generators/Kconfig b/drivers/pps/generators/Kc=
onfig
> > new file mode 100644
> > index 0000000..9cc1118
> > --- /dev/null
> > +++ b/drivers/pps/generators/Kconfig
> > @@ -0,0 +1,17 @@
> > +#
> > +# PPS clients configuration
> > +#
>=20
> s/clients/generators
>=20
> > +
> > +if PPS
> > +
> > +comment "PPS generators support"
> > +
> > +config PPS_GENERATOR_PARPORT
> > +	tristate "Parallel port PPS signal generator"
> > +	depends on PARPORT !=3D n && GENERIC_TIME
> > +	help
> > +	  If you say yes here you get support for a PPS signal generator which
> > +	  utilizes STROBE pin of a parallel port to send PPS signals. It uses
> > +	  parport abstraction layer and hrtimers to precisely control the sig=
nal.
> > +
> > +endif
> > diff --git a/drivers/pps/generators/Makefile b/drivers/pps/generators/M=
akefile
> > new file mode 100644
> > index 0000000..303304a
> > --- /dev/null
> > +++ b/drivers/pps/generators/Makefile
> > @@ -0,0 +1,9 @@
> > +#
> > +# Makefile for PPS generators.
> > +#
> > +
> > +obj-$(CONFIG_PPS_GENERATOR_PARPORT) +=3D pps_gen_parport.o
> > +
> > +ifeq ($(CONFIG_PPS_DEBUG),y)
> > +EXTRA_CFLAGS +=3D -DDEBUG
> > +endif
> > diff --git a/drivers/pps/generators/pps_gen_parport.c b/drivers/pps/gen=
erators/pps_gen_parport.c
> > new file mode 100644
> > index 0000000..e7cce30
> > --- /dev/null
> > +++ b/drivers/pps/generators/pps_gen_parport.c
> > @@ -0,0 +1,264 @@
> > +/*
> > + * pps_gen_parport.c -- kernel parallel port PPS signal generator
> > + *
> > + *
> > + * Copyright (C) 2009   Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + */
> > +
> > +
> > +/*
> > + * TODO:
> > + * 1. module parameters
> > + * 2. check that local interrupts are blocked in hrtimer handler
> > + * 3. fix issues when realtime clock is adjusted in a leap
> > + * 4. test under heavy load
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/time.h>
> > +#include <linux/hrtimer.h>
> > +#include <linux/parport.h>
> > +
> > +#define DRVNAME "pps_gen_parport"
> > +#define DRVDESC "parallel port PPS signal generator"
> > +
> > +#define SIGNAL		0
> > +#define NO_SIGNAL	PARPORT_CONTROL_STROBE
> > +
> > +#define SEND_DELAY	30000	/* delay between setting and
> > +				   dropping the signal (ns) */
> > +#define SAFETY_INTERVAL	3000	/* set the hrtimer earlier for safety (ns=
) */
> > +
> > +/* internal per port structure */
> > +struct pps_generator_pp {
> > +	struct pardevice *pardev;	/* parport device */
> > +	struct hrtimer timer;
> > +	long port_write_time;		/* calibrated port write time (ns) */
> > +};
> > +
> > +static struct pps_generator_pp device =3D {
> > +	.pardev =3D NULL,
> > +};
> > +
> > +static int attached;
> > +
> > +/* calibrated time between a hrtimer event and the reaction */
> > +static long hrtimer_error =3D SAFETY_INTERVAL;
> > +
> > +/* the kernel hrtimer event */
> > +static enum hrtimer_restart hrtimer_event(struct hrtimer *timer)
> > +{
> > +	struct timespec expire_time, ts1, ts2, ts3, dts;
> > +	struct pps_generator_pp *dev;
> > +	struct parport *port;
> > +	long lim, delta;
> > +	unsigned long flags;
> > +
> > +	/* NB: approx time with blocked interrupts =3D
> > +	   SEND_DELAY + 3 * SAFETY_INTERVAL */
> > +	local_irq_save(flags);
> > +
> > +	/* first of all we get the time stamp... */
> > +	getnstimeofday(&ts1);
> > +	expire_time =3D ktime_to_timespec(timer->_expires);
> > +	dev =3D container_of(timer, struct pps_generator_pp, timer);
> > +	lim =3D NSEC_PER_SEC - SEND_DELAY - dev->port_write_time;
> > +
> > +	/* check if we are late */
> > +	if (expire_time.tv_sec !=3D ts1.tv_sec || ts1.tv_nsec > lim) {
> > +		local_irq_restore(flags);
> > +		pr_err(DRVNAME ": we are late this time %ld.%09ld\n",
> > +				ts1.tv_sec, ts1.tv_nsec);
> > +		goto done;
> > +	}
> > +
> > +	/* busy loop until the time is right for an assert edge */
> > +	do {
> > +		getnstimeofday(&ts2);
> > +	} while (expire_time.tv_sec =3D=3D ts2.tv_sec && ts2.tv_nsec < lim);
> > +
> > +	/* set the signal */
> > +	port =3D dev->pardev->port;
> > +	port->ops->write_control(port, SIGNAL);
> > +
> > +	/* busy loop until the time is right for a clear edge */
> > +	lim =3D NSEC_PER_SEC - dev->port_write_time;
> > +	do {
> > +		getnstimeofday(&ts2);
> > +	} while (expire_time.tv_sec =3D=3D ts2.tv_sec && ts2.tv_nsec < lim);
> > +
> > +	/* unset the signal */
> > +	port->ops->write_control(port, NO_SIGNAL);
> > +
> > +	getnstimeofday(&ts3);
> > +
> > +	local_irq_restore(flags);
> > +
> > +	/* update calibrated port write time */
> > +	dts =3D timespec_sub(ts3, ts2);
> > +	dev->port_write_time =3D
> > +		(dev->port_write_time + timespec_to_ns(&dts)) >> 1;
> > +
> > +done:
> > +	/* update calibrated hrtimer error */
> > +	dts =3D timespec_sub(ts1, expire_time);
> > +	delta =3D timespec_to_ns(&dts);
> > +	/* If the new error value is bigger then the old, use the new
> > +	 * value, if not then slowly move towards the new value. This
> > +	 * way it should be safe in bad conditions and efficient in
> > +	 * good conditions.
> > +	 */
> > +	if (delta >=3D hrtimer_error)
> > +		hrtimer_error =3D delta;
> > +	else
> > +		hrtimer_error =3D (3 * hrtimer_error + delta) >> 2;
> > +
> > +	/* update the hrtimer expire time */
> > +	hrtimer_set_expires(timer,
> > +			ktime_set(expire_time.tv_sec + 1,
> > +				NSEC_PER_SEC - (SEND_DELAY +
> > +				dev->port_write_time + SAFETY_INTERVAL +
> > +				2 * hrtimer_error)));
> > +
> > +	return HRTIMER_RESTART;
> > +}
> > +
> > +/* calibrate port write time */
> > +#define PORT_NTESTS_SHIFT	5
> > +static void calibrate_port(struct pps_generator_pp *dev)
> > +{
> > +	struct parport *port =3D dev->pardev->port;
> > +	int i;
> > +	long acc =3D 0;
> > +
> > +	for (i =3D 0; i < (1 << PORT_NTESTS_SHIFT); i++) {
> > +		struct timespec a, b;
> > +		unsigned long irq_flags;
> > +
> > +		local_irq_save(irq_flags);
> > +		getnstimeofday(&a);
> > +		port->ops->write_control(port, NO_SIGNAL);
> > +		getnstimeofday(&b);
> > +		local_irq_restore(irq_flags);
> > +
> > +		b =3D timespec_sub(b, a);
> > +		acc +=3D timespec_to_ns(&b);
> > +	}
> > +
> > +	dev->port_write_time =3D acc >> PORT_NTESTS_SHIFT;
> > +	pr_info(DRVNAME ": port write takes %ldns\n", dev->port_write_time);
> > +}
> > +
> > +static inline ktime_t next_intr_time(struct pps_generator_pp *dev)
> > +{
> > +	struct timespec ts;
> > +
> > +	getnstimeofday(&ts);
> > +
> > +	return ktime_set(ts.tv_sec +
> > +			((ts.tv_nsec > 990 * NSEC_PER_MSEC) ? 1 : 0),
> > +			NSEC_PER_SEC - (SEND_DELAY +
> > +			dev->port_write_time + 3 * SAFETY_INTERVAL));
> > +}
> > +
> > +static void parport_attach(struct parport *port)
> > +{
> > +	if (attached) {
> > +		/* we already have a port */
> > +		return;
> > +	}
> > +
> > +	device.pardev =3D parport_register_device(port, DRVNAME,
> > +			NULL, NULL, NULL, 0, &device);
> > +	if (!device.pardev) {
> > +		pr_err(DRVNAME ": couldn't register with %s\n", port->name);
> > +		return;
> > +	}
> > +
> > +	if (parport_claim_or_block(device.pardev) < 0) {
> > +		pr_err(DRVNAME ": couldn't claim %s\n", port->name);
> > +		goto err_unregister_dev;
> > +	}
> > +
> > +	pr_info(DRVNAME ": attached to %s\n", port->name);
> > +	attached =3D 1;
> > +
> > +	calibrate_port(&device);
> > +
> > +	hrtimer_init(&device.timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
> > +	device.timer.function =3D hrtimer_event;
> > +#ifdef CONFIG_PREEMPT_RT
> > +	/* hrtimer interrupt will run in the interrupt context with this */
> > +	device.timer.irqsafe =3D 1;
> > +#endif
> > +
> > +	hrtimer_start(&device.timer, next_intr_time(&device), HRTIMER_MODE_AB=
S);
> > +
> > +	return;
> > +
> > +err_unregister_dev:
> > +	parport_unregister_device(device.pardev);
> > +}
> > +
> > +static void parport_detach(struct parport *port)
> > +{
> > +	if (port->cad !=3D device.pardev)
> > +		/* not our port */
> > +		return;
>=20
> Please use:
>=20
> if (port->cad !=3D device.pardev)
>         return;    /* not our port */

OK.

--=20
  Alexander

--Sig_/5t8qCbLuoEiVyq06paI0Jxa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJLi5wjAAoJEElrwznyooJbRVcH/2XBW7m/BJXLJtj9g4U2V+4+
0R2ey4BcsO4ncFSgC746WlUf7T+vwOcYHbRfkv+3Njfiun3BLbAiClBJVrdWNZUl
S8lIVeBtFJb1adjDEmmjzEbOWn0bXdaDArxBvJL6S7ZbwNT5ErVJNMGGOjjXa38W
giWGsM3GNCdMFGDHMrA0hsXUTWkf0pvxkoGBafT/XDyrucOxz+TnD56b52KFAMd8
CzSyJR055uK6FDaWMKWc0jdHegIjfr2ozXPrxHGN8XkRDvoP/1EAZAwU+Exv/LVF
An4QhbvjihoqfGNgEC5yPbOjuw76G4siWq01VMXrWMkUO/CS43cWNs2eyedcARc=
=EYCV
-----END PGP SIGNATURE-----

--Sig_/5t8qCbLuoEiVyq06paI0Jxa--
