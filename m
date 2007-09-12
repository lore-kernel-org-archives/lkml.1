Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbXILBLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbXILBLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 21:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXILBLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:11:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54961 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXILBLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:11:40 -0400
Date: Tue, 11 Sep 2007 18:11:38 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
Subject: Re: [PATCH] v3 of IBM power meter driver
Message-ID: <20070912011137.GF30825@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164905.GM32667@tree.beaverton.ibm.com> <20070828232504.GP32667@tree.beaverton.ibm.com> <20070911132335.GJ31992@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iBwuxWUsK/REspAd"
Content-Disposition: inline
In-Reply-To: <20070911132335.GJ31992@jupiter.solarsys.private>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--iBwuxWUsK/REspAd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2007 at 09:23:35AM -0400, Mark M. Hoffman wrote:

> I am not an IPMI expert, so I would appreciate getting an Acked-by from
> someone who knows more about that subsystem.
>=20
> Anyway, some comments are below.  This is nowhere near a complete review =
yet.

Thank you for the review!  Comments interspersed below, though for
brevity the one-liners have been fixed.

> > +config SENSORS_IBMPEX
> > +	tristate "IBM PowerExecutive temperature/power sensors"
> > +	depends on IPMI_SI
>=20
> Open question: can we use "select" here?  As written, it took some huntin=
g to
> even get this driver to show up as an option in menuconfig.

Changed, since it seems reasonable that someone looking for PEx support
might not necessarily know that it is based upon IPMI.

> > +struct ibmpex_bmc_data {
> > +	struct list_head	list;
> > +	struct class_device	*class_dev;
>=20
> My current stack of patches includes one which requires that this be chan=
ged
> to 'struct device *hwmon_dev', as 'struct class_device' is going away soo=
n.
> You may rebase on my testing tree[1], or else I will just follow up with a
> patch to fix this up after I eventually merge yours.
>=20
> [1] http://lm-sensors.org/kernel?p=3Dkernel/mhoffman/hwmon-2.6.git;a=3Dsh=
ortlog;h=3Dtesting

Done.

> > +static ssize_t ibmpex_show_sensor(struct device *dev,
> > +				  struct device_attribute *devattr,
> > +				  char *buf)
> > +{
> > +	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
> > +	int iface =3D PEX_INTERFACE(attr->index);
> > +	int sensor =3D PEX_SENSOR(attr->index);
> > +	int func =3D PEX_FUNC(attr->index);
> > +	struct ibmpex_bmc_data *data =3D get_bmc_data(iface);
>=20
> ... especially given how many times you're going to call it.  Is there any
> reason you can't use the driver_data field of struct device *dev for that?

I can (and did) update the code to use dev_get/set_drvdata for the
accessors.  However, the "iface" field exists as a mechanism to map
interface numbers to struct ibmpex_bmc_data/struct device data because
the callback that IPMI uses to notify clients that BMCs are going away
only passes the interface number, not the struct device itself.
Unfortunately, this means that get_bmc_data() must remain, but now it is
only used once at the end of life.

> E.g. i2c based hwmon drivers do this at some point during the probe:
>=20
> 	i2c_set_clientdata(new_client, data);
>=20
> (which becomes)
>=20
> 	dev_set_drvdata(&new_client->dev, data);
>=20
> If you could do that, then you no longer need 'iface' at all in the funct=
ion
> above... *that* may allow you to use the SENSOR_ATTR_2 mechanism from
> hwmon-sysfs.h - much easier to read than the manual number packing for 's=
ensor'
> and 'func'.

Doesn't look too hard; I'll have a go at it and see how it does.

> > +	err =3D ibmpex_query_sensor_count(data);
> > +	if (err < 0)
> > +		return -ENOENT;
> > +	data->num_sensors =3D err;
> > +
>=20
> Did you mean 'if (err <=3D 0)' ?

Yes.

> > +		/* Create attributes */
> > +		for (j =3D 0; j < PEX_NUM_SENSOR_FUNCS; j++)
> > +			if (create_sensor(data, sensor_type, sensor_counter,
> > +					  i, j))
>=20
> Why not 'err =3D create_sensor(...)' and propagate the actual error here?

Rough draft syndrome?  'tis fixed. :)

--D

--iBwuxWUsK/REspAd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG5zzJa6vRYYgWQuURAuFiAKCbB/OMQXuHB/BKd4VDfyapXisWGACgo1di
EJOMM4dnlkLBFRuBXPHZjKs=
=O7Zz
-----END PGP SIGNATURE-----

--iBwuxWUsK/REspAd--
