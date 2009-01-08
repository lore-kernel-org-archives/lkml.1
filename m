Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZAHORr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZAHORr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbZAHORc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:17:32 -0500
Received: from ns0.wincor-nixdorf.com ([80.154.98.130]:48227 "EHLO
	mxpdbe2.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759546AbZAHORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:17:31 -0500
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 09:17:30 EST
Message-ID: <49660846.2090200@wincor-nixdorf.com>
Date: Thu, 08 Jan 2009 15:05:58 +0100
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Eugene Teo <eugeneteo@kernel.org>
CC: linux-kernel@vger.kernel.org, rolandd@cisco.com, sean.hefty@intel.com,
       hal.rosenstock@gmail.com
Subject: Re: [PATCH] IB: check for memory allocation failure
References: <20090108135549.GA9756@kernel.sg>
In-Reply-To: <20090108135549.GA9756@kernel.sg>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF47ED13F4A502352BD4E1C0D"
X-OriginalArrivalTime: 08 Jan 2009 14:08:48.0369 (UTC) FILETIME=[A037E610:01C9719A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF47ED13F4A502352BD4E1C0D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Eugene,

please see below.

Cheers,
Niels


Eugene Teo wrote:
> Fix error-path NULL deref in c2_register_device().
>=20
> Signed-off-by: Eugene Teo <eugeneteo@kernel.org>
> ---
>  drivers/infiniband/hw/amso1100/c2_provider.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/inf=
iniband/hw/amso1100/c2_provider.c
> index 5119d65..8cede6c 100644
> --- a/drivers/infiniband/hw/amso1100/c2_provider.c
> +++ b/drivers/infiniband/hw/amso1100/c2_provider.c
> @@ -780,11 +780,11 @@ int c2_register_device(struct c2_dev *dev)
>  	/* Register pseudo network device */
>  	dev->pseudo_netdev =3D c2_pseudo_netdev_init(dev);
>  	if (!dev->pseudo_netdev)
> -		goto out3;
> +		goto out4;
>
>  	ret =3D register_netdev(dev->pseudo_netdev);
>  	if (ret)
> -		goto out2;
> +		goto out3;
> =20
>  	pr_debug("%s:%u\n", __func__, __LINE__);
>  	strlcpy(dev->ibdev.name, "amso%d", IB_DEVICE_NAME_MAX);
> @@ -851,6 +851,8 @@ int c2_register_device(struct c2_dev *dev)
>  	dev->ibdev.post_recv =3D c2_post_receive;
> =20
>  	dev->ibdev.iwcm =3D kmalloc(sizeof(*dev->ibdev.iwcm), GFP_KERNEL);
> +	if (!dev->ibdev.iwcm)
> +		goto out2;

Is it not needed to set 'ret =3D -ENOMEM'?


>  	dev->ibdev.iwcm->add_ref =3D c2_add_ref;
>  	dev->ibdev.iwcm->rem_ref =3D c2_rem_ref;
>  	dev->ibdev.iwcm->get_qp =3D c2_get_qp;
> @@ -870,15 +872,17 @@ int c2_register_device(struct c2_dev *dev)
>  		if (ret)
>  			goto out0;
>  	}
> -	goto out3;
> +	goto out4;
> =20
>  out0:
>  	ib_unregister_device(&dev->ibdev);
>  out1:
> -	unregister_netdev(dev->pseudo_netdev);
> +	kfree(dev->ibdev.iwcm);
>  out2:
> -	free_netdev(dev->pseudo_netdev);
> +	unregister_netdev(dev->pseudo_netdev);
>  out3:
> +	free_netdev(dev->pseudo_netdev);
> +out4:
>  	pr_debug("%s:%u ret=3D%d\n", __func__, __LINE__, ret);
>  	return ret;
>  }
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--------------enigF47ED13F4A502352BD4E1C0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJZghG5KAkGQPO/QoRApNnAKCZev7VMHJ6qmNc3nk8xVzpwPVzxQCfWXTm
1NsC8HXmXGi0/F6ESm+/ZQM=
=cUOU
-----END PGP SIGNATURE-----

--------------enigF47ED13F4A502352BD4E1C0D--
