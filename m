Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYABXlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYABXlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYABXli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:41:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36274 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYABXlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:41:37 -0500
Date: Thu, 3 Jan 2008 10:41:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jochen Friedrich <jochen@scram.de>
Cc: Jon Smirl <jonsmirl@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCHv2] i2c: adds support for i2c bus on Frescale CPM1/CPM2
 controllers
Message-Id: <20080103104121.58697148.sfr@canb.auug.org.au>
In-Reply-To: <477BEB60.4070703@scram.de>
References: <477BEB60.4070703@scram.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Jan_2008_10_41_21_+1100_SkN8.jo6R1F/9AQQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jan_2008_10_41_21_+1100_SkN8.jo6R1F/9AQQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jochen,

Just a few trivial things.

On Wed, 02 Jan 2008 20:52:00 +0100 Jochen Friedrich <jochen@scram.de> wrote:
>
> +++ b/drivers/i2c/busses/i2c-cpm.c
> +
> +static irqreturn_t cpm_i2c_interrupt(int irq, void *dev_id)
> +{
> +	struct i2c_adapter *adap;
> +	struct cpm_i2c *cpm;
> +	struct i2c_reg __iomem *i2c_reg;
> +	int i;
> +
> +	adap =3D (struct i2c_adapter *) dev_id;

This cast is unnecessary. In fact, you could just pass dev_id to the
following call to i2c_get_adapdata() and eliminate adap completely.

> +	/* Get 'me going again.
> +	 */

For short comments, just make them one line.  Similarly later as well.

> +	/* This chip can't do zero length writes. However, the i2c core uses
> +	   them to scan for devices. The best we can do is to convert them
> +	   into 1 byte reads */

For multiline comments, we normally do
/*
 * blah ...
 * more blah
 */

> +static int cpm_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, =
int num)
> +{
> +
> +	while (tptr < num) {
> +		/* Check for outstanding messages */
> +		dev_dbg(&adap->dev, "test ready.\n");
> +		if (!(tbdf[tptr].cbd_sc & BD_SC_READY)) {
> +			dev_dbg(&adap->dev, "ready.\n");
> +			rmsg =3D &msgs[tptr];
> +			ret =3D cpm_i2c_check_message(adap, rmsg, tptr, rptr);
> +			tptr++;
> +			if (rmsg->flags & I2C_M_RD)
> +				rptr++;
> +			if (ret) {
> +				cpm_i2c_force_close(adap);
> +				mutex_unlock(&cpm->i2c_mutex);
> +				return ret;
> +			}
> +		} else {
> +			dev_dbg(&adap->dev, "not ready.\n");
> +			ret =3D wait_event_interruptible_timeout(cpm->i2c_wait,
> +				!(tbdf[tptr].cbd_sc & BD_SC_READY), 1 * HZ);
> +			if (ret =3D=3D 0) {
> +				cpm_i2c_force_close(adap);
> +				dev_dbg(&adap->dev, "I2C read: timeout!\n");
> +				mutex_unlock(&cpm->i2c_mutex);
> +				return -EREMOTEIO;
> +			}

You might want to consolidate the two error paths above using gotos to an
error return section below.

> +static void of_register_i2c_devices(struct i2c_adapter *adap,
> +				    struct device_node *adap_node)
> +{
> +	struct device_node *node =3D NULL;
> +
> +	while ((node =3D of_get_next_child(adap_node, node))) {

Use
	for_each_child_of_node(adap_node, node) {
instead and you don't need to initialise "node" above.

> +static struct of_device_id cpm_i2c_match[] =3D {

const?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Jan_2008_10_41_21_+1100_SkN8.jo6R1F/9AQQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHfCEnTgG2atn1QN8RAp7VAJ4k/Ifbxw+graKKsteTNun7k7wmLgCgga9t
9mJ0EjQ5KdFXogPKDKL84UQ=
=G5X1
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jan_2008_10_41_21_+1100_SkN8.jo6R1F/9AQQ--
