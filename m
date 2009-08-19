Return-Path: <linux-kernel-owner+w=401wt.eu-S1751348AbZHSJBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbZHSJBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZHSJBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:01:52 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:44775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZHSJBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:01:51 -0400
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Johannes Berg <johannes@sipsolutions.net>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A8B246D.7050004@dell.com>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
	 <4A8AE459.8060102@dell.com>
	 <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>
	 <1250631063.16393.14.camel@johannes.local>  <4A8B246D.7050004@dell.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z7+a4OP7t/CBP06CMvPl"
Date: Wed, 19 Aug 2009 11:01:15 +0200
Message-Id: <1250672475.25419.7.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z7+a4OP7t/CBP06CMvPl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ah, heh, thanks Alan for pointing out there was a patch here :)

> +static void compal_rfkill_poll(struct rfkill *rfkill, void *data)
> +{
> +       unsigned long radio =3D (unsigned long) data;
> +       u8 result;
> +       bool hw_blocked;
> +       bool sw_blocked;
> +
> +       ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> +
> +       hw_blocked =3D !(result & (KILLSWITCH_MASK | radio));

I don't quite understand the "| radio" bit since that seems to be the
soft kill bit according to rfkill_set()?

> +       sw_blocked =3D rfkill_set_hw_state(rfkill, hw_blocked);
> +
> +       rfkill_set_sw_state(rfkill, sw_blocked);

This is wrong. You can remove the entire part about sw_blocked, almost.

> +static int compal_rfkill_set(void *data, bool blocked)
> +{
> +       unsigned long radio =3D (unsigned long) data;
> +       u8 result, value;
> +
> +       ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> +
> +       if ((result & KILLSWITCH_MASK) =3D=3D 0)
> +               return -EINVAL;

Anyhow, here you reject the request to set the soft bit. I suspect you
could let it go through but it would only change the soft bit in the
BIOS, nothing else really.

Two options:
1) You can let it go though, in that case do that, and remove the sw
   block stuff from poll() completely.

2) You can't let it go through. In this case, you need to leave set as
   it is, but implement poll like this:

	sw_block =3D rfkill_set_hw_state(rfkill, hw_blocked);
	compal_rfkill_set(data, sw_block);

so that when the user soft-blocks the device while hard-blocked, the
soft block is still honoured after pushing the button on the laptop.

Also, I'm not entirely clear about the semantics -- you've called the
bit KILLSWITCH_MASK, but does it really control all technologies as a
hard block, i.e. it toggles both the bluetooth and wireless hard block?

johannes

--=-z7+a4OP7t/CBP06CMvPl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKi79XAAoJEODzc/N7+QmaDwwP/RhiniFzM7hXy6+dG8tRn0tw
t7uUUZByjlzZBbm/6xj11Wcd5Z5VEy8VDVu+HTvlL7rAnsDPnkVAMn+SIlftP5bZ
28Iw/tcusSQA0Et5yAMWXaxPAqvdRjYZwqZNd9sQwVuF3hQFQLEFWKFVSwnDU8B1
hUYStEQUJeJNOD3Zi3fvWZRVGQn299yl3lJCHy+wkhgaxsDmS1/Srp6B2+q1DRWg
UXpZ/cXHYM1fMGz0/Q64fq3wbUUBUNdOZzziViYjVoYlhLN4yQXrWbFkcwXiYJiB
L63uEQI4OFJHZy6WpGu+xHY7QgEnIm0k5zFShAxqrC05zAdNPeoFzqNfAiunPc6/
uAIeaAHr7agHbBXS/m3Q0IsU3o5yt5YodceJKKcZ61h0NOcTB2PvjovnBAgH0VMM
KTNmK/1whr6ZEZaW8Jf4JVHTlCYUk3Q2FFi4L52a0dWujj4W0lFtqv3agqKYoozd
ME40ltPGBqwffTT7EnHSURH9Hm5Bw9bQyjhSu8KPz5AQ/T/SwHikFTIIJwoQKNyq
voV5E8RaQlEXDfrrz96eFi+8v8bpMiHMKJL04cc5VwW9uZBokmPFUsFkJacUllcw
6mVSf0KkEs1r4OVeu8IiwB6vlQflkdfavxI/3Ca/6scmcR6z+w0ODaMqFsLBCSij
ngQFhYkagW0d5MaDHII8
=r38l
-----END PGP SIGNATURE-----

--=-z7+a4OP7t/CBP06CMvPl--

