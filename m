Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0BQSvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:51:55 -0500
Received: from mx1.riseup.net ([204.13.164.18]:55759 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab0BQSvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:51:53 -0500
X-Greylist: delayed 1237 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2010 13:51:53 EST
From: Francisco Jerez <currojerez@riseup.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: nouveau@lists.freedesktop.org, kernel-janitors@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Nouveau] [PATCH] drm/nouveau: fix pramdac_table range checking
References: <20100215124046.GB18821@bicker> <20100215222041.GA2823@joi.lan>
Date: Wed, 17 Feb 2010 19:36:06 +0100
In-Reply-To: <20100215222041.GA2823@joi.lan> (Marcin Slusarz's message of
	"Mon, 15 Feb 2010 23:20:41 +0100")
Message-ID: <87vddvyajt.fsf@riseup.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Marcin Slusarz <marcin.slusarz@gmail.com> writes:

> On Mon, Feb 15, 2010 at 03:40:56PM +0300, Dan Carpenter wrote:
>> This is the results from:
>>     make C=3D1 CHECK=3D"/path/to/smatch -p=3Dkernel" bzImage modules | t=
ee warns.txt
>>     grep -w overflow warns.txt | uniq -f 3 | tee err-list
>>=20
>> I hacked on the buffer overflow check last weekend and these are the=20
>> results.  It has way more false positives than the other bug lists=20
>> I've posted, but it's still kinda neat.
>>=20
>> It works like this:
>>=20
>> lib/zlib_inflate/inftrees.c
>>    112      for (min =3D 1; min <=3D MAXBITS; min++)
>>    113          if (count[min] !=3D 0) break;
>>    114      if (root < min) root =3D min;
>> smatch thinks "min" can be MAXBITS here.
>>=20
>> One bad thing is that if you have code like:
>>         if (foo =3D=3D 42)
>> 		frob();
>> Smatch thinks that "foo" can be 43 after the if statement.
>>=20
>> The format is:
>> file.c +<line> function(<lines into function>) warning 'array_name' <arr=
ay size> <=3D <offset>
>>=20
>> regards,
>> dan carpenter
>>=20
>> Previous bug lists:
>> * Putting too much data on the stack
>>   http://lkml.indiana.edu/hypermail/linux/kernel/1002.1/01252.html
>>=20
>> * Assigning negative values to unsigned variables
>>   http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01222.html
>>=20
>> * Doing dma on the stack
>>   http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01231.html
>>=20
>> * Dereferencing variables before verifying they are not null
>>   http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01980.html
>>=20
>> (...)
>> drivers/gpu/drm/nouveau/nouveau_bios.c +770 get_tmds_index_reg(36) error=
: buffer overflow 'pramdac_table' 4 <=3D 4
>> (...)
>
> ---
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH] drm/nouveau: fix pramdac_table range checking
>
> get_tmds_index_reg reads some value from stack when mlv happens
> to be equal to size of pramdac_table array. Fix it.
>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_bios.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nou=
veau/nouveau_bios.c
> index 2cd0fad..e7be506 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bios.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
> @@ -762,7 +762,7 @@ static uint32_t get_tmds_index_reg(struct drm_device =
*dev, uint8_t mlv)
>  			dacoffset ^=3D 8;
>  		return 0x6808b0 + dacoffset;
>  	} else {
> -		if (mlv > ARRAY_SIZE(pramdac_table)) {
> +		if (mlv >=3D ARRAY_SIZE(pramdac_table)) {
>  			NV_ERROR(dev, "Magic Lookup Value too big (%02X)\n",
>  									mlv);
>  			return 0;

Thanks. I've pushed all the three patches.

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt8NxcACgkQ196Zy2qEI5duawCfT6eVIiqH2BcJqELkpPO732mc
J9MAn3ZlSTF1MLoeDjxLee21WFmokZbN
=RGjB
-----END PGP SIGNATURE-----
--==-=-=--
