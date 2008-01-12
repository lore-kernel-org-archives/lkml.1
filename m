Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYALEHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYALEHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 23:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYALEH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 23:07:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47075 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYALEH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 23:07:29 -0500
Date: Sat, 12 Jan 2008 15:07:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19 4/5] Convert PowerPC MPC i2c to of_platform_driver
 from platform_driver
Message-Id: <20080112150714.0afc9c06.sfr@canb.auug.org.au>
In-Reply-To: <20080112024745.7023.66422.stgit@terra.home>
References: <20080112024737.7023.61680.stgit@terra.home>
	<20080112024745.7023.66422.stgit@terra.home>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__12_Jan_2008_15_07_14_+1100_qSMnnLHQ5V2je.d7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Jan_2008_15_07_14_+1100_qSMnnLHQ5V2je.d7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jon,

On Fri, 11 Jan 2008 21:47:46 -0500 Jon Smirl <jonsmirl@gmail.com> wrote:
>
> +++ b/drivers/i2c/busses/i2c-mpc.c

> +static void of_register_i2c_devices(struct i2c_adapter *adap, struct dev=
ice_node *adap_node)
> +{
> +	struct device_node *node =3D NULL;
> +
> +	while ((node =3D of_get_next_child(adap_node, node))) {

We have for_each_child_of_node(adap_node, node) now for this (and it
means you don't need to initialize the "node" above).

> +		struct i2c_board_info info;
> +		const u32 *addr;
> +		const char *compatible;
> +		int len;
> +
> +		addr =3D of_get_property(node, "reg", &len);
> +		if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
> +			printk(KERN_ERR "i2c-mpc.c: invalid entry, missing reg attribute\n");
> +			continue;
> +		}
> +
> +		info.irq =3D irq_of_parse_and_map(node, 0);
> +		if (info.irq =3D=3D NO_IRQ)
> +			info.irq =3D -1;
> +
> +		compatible =3D of_get_property(node, "compatible", &len);
> +		if (!compatible) {
> +			printk(KERN_ERR "i2c-mpc.c: invalid entry, missing compatible attribu=
te\n");
> +			continue;

You may need to clean up from the irq_of_pase_and_map().

> +		}
> +	=09
> +		/* need full alias i2c:NOF,vendor,device */
> +		strcpy(info.type, I2C_OF_MODULE_PREFIX);
> +		strncat(info.type, compatible, sizeof(info.type));
> +		request_module(info.type);
> +	=09
> +		/* need module alias OF,vendor,device */
> +		strcpy(info.type, OF_I2C_PREFIX);
> +		strncat(info.type, compatible, sizeof(info.type));
> +	=09
> +		info.driver_name[0] =3D '\0';
> +		info.platform_data =3D NULL;
> +		info.addr =3D *addr;
> +
> +		if (!i2c_new_device(adap, &info)) {
> +			printk(KERN_ERR "i2c-mpc.c: Failed to load driver for %s\n", info.typ=
e);
> +			continue;

And again.

> +		}
> +	}
> +}
> +
> +static int mpc_i2c_probe(struct of_device *op, const struct of_device_id=
 *match)
> +{

> +	dev_set_drvdata(&op->dev, i2c);
> +
> +	i2c->adap =3D mpc_ops;
> +	i2c_set_adapdata(&i2c->adap, i2c);
> +	i2c->adap.dev.parent =3D &op->dev;
> +
> +	result =3D i2c_add_adapter(&i2c->adap);
> +	if (result < 0) {
> +		printk(KERN_ERR "i2c-mpc - failed to add adapter\n");
> +		goto fail_add;
> +	}
> +
> +	of_register_i2c_devices(&i2c->adap, op->node);
> +
> +	return result;
> +
> +fail_add:

	dev_set_dvdata(&op->dev, NULL);

> +	free_irq(i2c->irq, i2c);
> +fail_request:
> +	irq_dispose_mapping(i2c->irq);
> +fail_irq:
> +	iounmap(i2c->base);
> +fail_map:
> +	kfree(i2c);
> +	return result;
> +};

> +static struct of_device_id mpc_i2c_of_match[] =3D {

const, please.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__12_Jan_2008_15_07_14_+1100_qSMnnLHQ5V2je.d7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHiDz4TgG2atn1QN8RAjUxAJ9EKsqJwr8ROLgJ7AxjWDQGbSVaSgCeK860
NqKJFy9Qaslyhi+B8zY7s0s=
=R6J4
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Jan_2008_15_07_14_+1100_qSMnnLHQ5V2je.d7--
