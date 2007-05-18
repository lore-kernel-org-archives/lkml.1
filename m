Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbXERMvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbXERMvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbXERMvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:51:32 -0400
Received: from chert.donpac.ru ([80.254.111.36]:33675 "EHLO chert.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXERMva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:51:30 -0400
X-Greylist: delayed 6016 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 08:51:29 EDT
Date: Fri, 18 May 2007 15:11:07 +0400
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
Message-ID: <20070518111107.GA27003@pazke.donpac.ru>
Mail-Followup-To: Nitin Gupta <nitingupta910@gmail.com>,
	linux-kernel@vger.kernel.org,
	Richard Purdie <richard@openedhand.com>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
X-Uname: Linux 2.6.18-1-amd64 x86_64
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andrey Panin <pazke@donpac.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 138, 05 18, 2007 at 03:28:31PM +0530, Nitin Gupta wrote:
> Hi,
>=20
> This is kernel port of LZO1X de/compression algo stripped down to just ~5=
00=20
> LOC!
> It is derived from original LZO 2.02 code found at:
> http://www.oberhumer.com/opensource/lzo/download/
> The code has also been reformatted to match general kernel style.
>=20
> Facts for LZO (at least for original code. Should hold true for this
> port also - hence the RFC!):
> - The compressor can never overrun buffer.
> - The "non-safe" version of decompressor can never overrun buffer if
> compressed data is unmodified. I am not sure about this if compressed
> data is malicious (to be confirmed from the author).
> - The "safe" version can never crash (buffer overrun etc.) - confirmed
> from the author.
>=20
> This patch, as of yet, only gives 'non-safe' version of decompressor.
> The 'safe' version  will be included soon.
>=20
> Since 'non-safe' version has no problems if compressed data is
> unmodified, it is useful in cases we have such guarantees on
> compressed data and hence don't want additional overhead of 'safe'
> version. For e.g. Compressed Caching project
> (http://linuxcompressed.sourceforge.net) has been using the 'non-safe'
> version of LZO1X since long time without any problems w.r.t.
> de/compression itself.
>=20
> For now, I have tested this on x86 only.
>=20
> Signed-off-by: Nitin Gupta <nitingupta910@gmail.com>
> ---
>=20
> diff --git a/include/linux/lzo1x.h b/include/linux/lzo1x.h
> new file mode 100755
> index 0000000..aae547e
> --- /dev/null
> +++ b/include/linux/lzo1x.h
> @@ -0,0 +1,61 @@
> +/* lzo1x.h -- public interface of the LZO1X compression algorithm
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
> +   All Rights Reserved.
> +
> +   The LZO library is free software; you can redistribute it and/or
> +   modify it under the terms of the GNU General Public License,
> +   version 2, as published by the Free Software Foundation.
> +
> +   The LZO library is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +   GNU General Public License for more details.
> +
> +   You should have received a copy of the GNU General Public License
> +   along with the LZO library; see the file COPYING.
> +   If not, write to the Free Software Foundation, Inc.,
> +   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> +
> +   Markus F.X.J. Oberhumer
> +   <markus@oberhumer.com>
> +   http://www.oberhumer.com/opensource/lzo/
> +
> +
> +   This file is modified version of lzo1x.h found in original LZO 2.02
> +   code. Some additional changes have also been made to make it work
> +   in kernel space.
> +
> +   Nitin Gupta
> +   <nitingupta910@gmail.com>
> + */
> +
> +#ifndef __LZO1X_H
> +#define __LZO1X_H
> +
> +/* Size of temp buffer (workmem) required by lzo1x_compress */
> +#define LZO1X_WORKMEM_SIZE	((size_t) (16384L * sizeof(unsigned char *)))
> +
> +/* LZO1X_1 compression */
> +int
> +lzo1x_compress(const unsigned char *src, size_t src_len,
> +		unsigned char *dst, size_t *dst_len,
> +		void *workmem);
> +
> +/* LZO1X_1 decompression */
> +int
> +lzo1x_decompress(const unsigned char *src, size_t src_len,
> +		unsigned char *dst, size_t *dst_len);
> +
> +#endif
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 2e7ae6b..9d30b1f 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -64,6 +64,12 @@ config ZLIB_INFLATE
>  config ZLIB_DEFLATE
>  	tristate
>=20
> +config LZO1X
> +	tristate "LZO1X Compression/Decompression"
> +	help
> +	  Compression: LZO1X-1
> +	  Decompression: LZO1X
> +
> #
> # Generic allocator support is selected if needed
> #
> diff --git a/lib/Makefile b/lib/Makefile
> index c8c8e20..4dad99d 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -49,6 +49,7 @@ obj-$(CONFIG_GENERIC_ALLOCATOR) +=3D genalloc.o
> obj-$(CONFIG_ZLIB_INFLATE) +=3D zlib_inflate/
> obj-$(CONFIG_ZLIB_DEFLATE) +=3D zlib_deflate/
> obj-$(CONFIG_REED_SOLOMON) +=3D reed_solomon/
> +obj-$(CONFIG_LZO1X)        +=3D lzo1x/
>=20
>  obj-$(CONFIG_TEXTSEARCH) +=3D textsearch.o
> obj-$(CONFIG_TEXTSEARCH_KMP) +=3D ts_kmp.o
> diff --git a/lib/lzo1x/Makefile b/lib/lzo1x/Makefile
> new file mode 100644
> index 0000000..322683e
> --- /dev/null
> +++ b/lib/lzo1x/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_LZO1X) +=3D lzo1x.o
> +lzo1x-objs :=3D lzo1x_compress.o lzo1x_decompress.o
> diff --git a/lib/lzo1x/lzo1x_compress.c b/lib/lzo1x/lzo1x_compress.c
> new file mode 100755
> index 0000000..02e3324
> --- /dev/null
> +++ b/lib/lzo1x/lzo1x_compress.c
> @@ -0,0 +1,255 @@
> +/* lzo1x_compress.c -- LZO1X-1 compression
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
> +   All Rights Reserved.
> +
> +   The LZO library is free software; you can redistribute it and/or
> +   modify it under the terms of the GNU General Public License,
> +   version 2, as published by the Free Software Foundation.
> +
> +   The LZO library is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +   GNU General Public License for more details.
> +
> +   You should have received a copy of the GNU General Public License
> +   along with the LZO library; see the file COPYING.
> +   If not, write to the Free Software Foundation, Inc.,
> +   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> +
> +   Markus F.X.J. Oberhumer
> +   <markus@oberhumer.com>
> +   http://www.oberhumer.com/opensource/lzo/
> +
> +
> +   This file is derived from lzo1x_1.c and lzo1x_c.ch found in original
> +   LZO 2.02 code. Some additional changes have also been made to make
> +   it work in kernel space.
> +
> +   Nitin Gupta
> +   <nitingupta910@gmail.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/compiler.h>
> +
> +#include "lzo1x_int.h"
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("LZO1X Compression");
> +
> +/* compress a block of data. */
> +static unsigned int
> +lzo1x_compress_worker(const unsigned char *in, size_t in_len,
> +			unsigned char *out, size_t *out_len,
> +			void *workmem)
> +{
> +	register const unsigned char *ip;

register keyword is meaningless for today's compiler.

> +	unsigned char *op;
> +	const unsigned char * const in_end =3D in + in_len;
> +	const unsigned char * const ip_end =3D in + in_len - M2_MAX_LEN - 5;
> +	const unsigned char *ii;
> +	const unsigned char ** const dict =3D (const unsigned char **)workmem;
> +
> +	op =3D out;

Why not write this as `unsigned char *op =3D out;` ?

> +	ip =3D in;
> +	ii =3D ip;
> +
> +	ip +=3D 4;
> +	for (;;) {
> +		register const unsigned char *m_pos;
> +		size_t m_off;
> +		size_t m_len;
> +		size_t dindex;
> +
> +		DINDEX1(dindex,ip);
> +		m_pos =3D dict[dindex];
> +
> +		if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
> +			goto literal;
> +		if (m_off <=3D M2_MAX_OFFSET || m_pos[3] =3D=3D ip[3])
> +			goto try_match;
> +
> +		DINDEX2(dindex,ip);
> +		m_pos =3D dict[dindex];
> +
> +		if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
> +			goto literal;
> +		if (m_off <=3D M2_MAX_OFFSET || m_pos[3] =3D=3D ip[3])
> +			goto try_match;
> +
> +		goto literal;
> +
> +try_match:
> +        if (*(const unsigned short *)m_pos !=3D *(const unsigned short *=
)ip)=20
> {

Empty if() body ?

> +        } else {
> +		if (likely(m_pos[2] =3D=3D ip[2]))
> +			goto match;
> +        }
> +
> +	/* a literal */
> +literal:
> +	dict[dindex] =3D ip;
> +	++ip;
> +	if (unlikely(ip >=3D ip_end))
> +		break;
> +	continue;
> +
> +
> +	/* a match */
> +match:
> +	dict[dindex] =3D ip;
> +	/* store current literal run */
> +	if (pd(ip,ii) > 0) {
> +		register size_t t =3D pd(ip,ii);
> +		if (t <=3D 3)
> +			op[-2] |=3D (unsigned char)(t);
> +		else if (t <=3D 18)
> +			*op++ =3D (unsigned char)(t - 3);
> +		else {
> +			register size_t tt =3D t - 18;
> +			*op++ =3D 0;
> +			while (tt > 255) {
> +				tt -=3D 255;
> +				*op++ =3D 0;
> +                	}
> +			*op++ =3D (unsigned char)(tt);
> +		}
> +		do *op++ =3D *ii++; while (--t > 0);
> +	}
> +
> +	/* code the match */
> +	ip +=3D 3;
> +	if (m_pos[3] !=3D *ip++ || m_pos[4] !=3D *ip++ || m_pos[5] !=3D *ip++ ||
> +            m_pos[6] !=3D *ip++ || m_pos[7] !=3D *ip++ || m_pos[8] !=3D =
*ip++) {
> +		--ip;
> +		m_len =3D pd(ip, ii);
> +
> +		if (m_off <=3D M2_MAX_OFFSET) {
> +			m_off -=3D 1;
> +			*op++ =3D (unsigned char)(((m_len - 1) << 5) | ((m_off=20
> & 7) << 2));
> +			*op++ =3D (unsigned char)(m_off >> 3);
> +		}
> +		else if (m_off <=3D M3_MAX_OFFSET) {
> +			m_off -=3D 1;
> +			*op++ =3D (unsigned char)(M3_MARKER | (m_len - 2));
> +			goto m3_m4_offset;
> +		} else {
> +			m_off -=3D 0x4000;

What's this magic number 0x4000 repeated everywhere ? M3_MAX_OFFSET perhaps=
 ?

> +			*op++ =3D (unsigned char)(M4_MARKER |
> +				((m_off & 0x4000) >> 11) | (m_len - 2));
> +			goto m3_m4_offset;
> +		}
> +        } else {
> +		const unsigned char *end =3D in_end;
> +		const unsigned char *m =3D m_pos + M2_MAX_LEN + 1;
> +		while (ip < end && *m =3D=3D *ip)
> +			m++, ip++;
> +		m_len =3D pd(ip, ii);
> +
> +		if (m_off <=3D M3_MAX_OFFSET) {
> +			m_off -=3D 1;
> +			if (m_len <=3D 33)
> +				*op++ =3D (unsigned char)(M3_MARKER | (m_len -=20
> 2));
> +			else {
> +				m_len -=3D 33;
> +				*op++ =3D M3_MARKER | 0;
> +				goto m3_m4_len;
> +			}
> +		} else {
> +			m_off -=3D 0x4000;
> +			if (m_len <=3D M4_MAX_LEN)
> +				*op++ =3D (unsigned char)(M4_MARKER |
> +					((m_off & 0x4000) >> 11) | (m_len -=20
> 2));
> +			else {
> +				m_len -=3D M4_MAX_LEN;
> +				*op++ =3D (unsigned char)(M4_MARKER | ((m_off=20
> & 0x4000) >> 11));
> +m3_m4_len:
> +				while (m_len > 255) {
> +					m_len -=3D 255;
> +					*op++ =3D 0;
> +				}
> +				*op++ =3D (unsigned char)(m_len);
> +			}
> +		}
> +
> +m3_m4_offset:
> +		*op++ =3D (unsigned char)((m_off & 63) << 2);
> +		*op++ =3D (unsigned char)(m_off >> 6);
> +	}
> +
> +	ii =3D ip;
> +	if (unlikely(ip >=3D ip_end))
> +		break;
> +	}
> +
> +	*out_len =3D pd(op, out);
> +	return pd(in_end,ii);
> +}
> +
> +
> +/*
> + * This requires buffer (workmem) of size LZO1X_WORKMEM_SIZE
> + * (exported by lzo1x.h).
> + */
> +int
> +lzo1x_compress(const unsigned char *in, size_t  in_len,
> +		unsigned char *out, size_t *out_len,
> +		void *workmem)
> +{
> +	unsigned char *op =3D out;
> +	size_t t;
> +
> +	if (!workmem)
> +		return -EINVAL;
> +
> +	if (unlikely(in_len <=3D M2_MAX_LEN + 5))
> +		t =3D in_len;
> +	else {
> +		t =3D lzo1x_compress_worker(in,in_len,op,out_len,workmem);
> +        	op +=3D *out_len;
> +	}
> +
> +	if (t > 0) {
> +		const unsigned char *ii =3D in + in_len - t;
> +
> +		if (op =3D=3D out && t <=3D 238)
> +			*op++ =3D (unsigned char)(17 + t);
> +		else if (t <=3D 3)
> +			op[-2] |=3D (unsigned char)(t);
> +		else if (t <=3D 18)
> +			*op++ =3D (unsigned char)(t - 3);
> +		else {
> +			size_t tt =3D t - 18;
> +			*op++ =3D 0;
> +			while (tt > 255) {
> +				tt -=3D 255;
> +				*op++ =3D 0;
> +			}
> +			*op++ =3D (unsigned char)(tt);
> +		}
> +		do {
> +			*op++ =3D *ii++;
> +		} while (--t > 0);
> +	}
> +	*op++ =3D M4_MARKER | 1;
> +	*op++ =3D 0;
> +	*op++ =3D 0;
> +
> +	*out_len =3D pd(op, out);
> +	return 0;
> +}
> +
> +EXPORT_SYMBOL(lzo1x_compress);
> diff --git a/lib/lzo1x/lzo1x_decompress.c b/lib/lzo1x/lzo1x_decompress.c
> new file mode 100755
> index 0000000..fbd4d69
> --- /dev/null
> +++ b/lib/lzo1x/lzo1x_decompress.c
> @@ -0,0 +1,216 @@
> +/* lzo1x_decompress.c -- LZO1X decompression
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
> +   All Rights Reserved.
> +
> +   The LZO library is free software; you can redistribute it and/or
> +   modify it under the terms of the GNU General Public License,
> +   version 2, as published by the Free Software Foundation.
> +
> +   The LZO library is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +   GNU General Public License for more details.
> +
> +   You should have received a copy of the GNU General Public License
> +   along with the LZO library; see the file COPYING.
> +   If not, write to the Free Software Foundation, Inc.,
> +   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> +
> +   Markus F.X.J. Oberhumer
> +   <markus@oberhumer.com>
> +   http://www.oberhumer.com/opensource/lzo/
> +
> +
> +   This file is derived from lzo1x_d1.c and lzo1x_d.ch found in original
> +   LZO 2.02 code. Some additional changes have also been made to make
> +   it work in kernel space.
> +
> +   Nitin Gupta
> +   <nitingupta910@gmail.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <asm/byteorder.h>
> +
> +#include "lzo1x_int.h"
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("LZO1X Decompression");
> +
> +int
> +lzo1x_decompress(const unsigned char *in, size_t in_len,
> +			unsigned char *out, size_t *out_len)
> +{
> +	register size_t t;
> +	register unsigned char *op;
> +	register const unsigned char *ip, *m_pos;
> +	const unsigned char * const ip_end =3D in + in_len;
> +
> +	*out_len =3D 0;
> +
> +	op =3D out;
> +	ip =3D in;
> +
> +	if (*ip > 17) {
> +		t =3D *ip++ - 17;
> +		if (t < 4)
> +			goto match_next;
> +		do
> +			*op++ =3D *ip++;
> +		while (--t > 0);
> +		goto first_literal_run;
> +	}
> +
> +	while (1) {
> +		t =3D *ip++;
> +		if (t >=3D 16)
> +			goto match;
> +		/* a literal run */
> +		if (t =3D=3D 0) {
> +			while (*ip =3D=3D 0) {
> +				t +=3D 255;
> +				ip++;
> +			}
> +			t +=3D 15 + *ip++;
> +		}
> +		/* copy literals */
> +		COPY4(op,ip);
> +		op +=3D 4;
> +		ip +=3D 4;
> +		if (--t > 0) {
> +			if (t >=3D 4) {
> +				do {
> +					COPY4(op,ip);
> +					op +=3D 4; ip +=3D 4; t -=3D 4;
> +				} while (t >=3D 4);
> +			if (t > 0)
> +				do
> +					*op++ =3D *ip++;
> +				while (--t > 0);
> +			} else
> +				do
> +					*op++ =3D *ip++;
> +				while (--t > 0);
> +		}
> +
> +first_literal_run:
> +
> +		t =3D *ip++;
> +		if (t >=3D 16)
> +			goto match;
> +		m_pos =3D op - (1 + M2_MAX_OFFSET);
> +		m_pos -=3D t >> 2;
> +		m_pos -=3D *ip++ << 2;
> +		*op++ =3D *m_pos++; *op++ =3D *m_pos++; *op++ =3D *m_pos;
> +		goto match_done;
> +=09
> +		/* handle matches */
> +		do {
> +	match:
> +			if (t >=3D 64) {		/* a M2 match */
> +				m_pos =3D op - 1;
> +				m_pos -=3D (t >> 2) & 7;
> +				m_pos -=3D *ip++ << 3;
> +				t =3D (t >> 5) - 1;
> +				goto copy_match;
> +			} else if (t >=3D 32) {	/* a M3 match */
> +				t &=3D 31;
> +				if (t =3D=3D 0) {
> +					while (*ip =3D=3D 0) {
> +						t +=3D 255;
> +						ip++;
> +					}
> +					t +=3D 31 + *ip++;
> +				}
> +#if defined(__LITTLE_ENDIAN)
> +				m_pos =3D op - 1;
> +				m_pos -=3D (*(const unsigned short *)ip) >> 2;
> +#else
> +				m_pos =3D op - 1;
> +				m_pos -=3D (ip[0] >> 2) + (ip[1] << 6);
> +#endif

IMHO you could write it this way:

m_pos =3D op - 1 - (le16_to_cpu(*(const u16 *)ip) >> 2);

> +			ip +=3D 2;
> +			} else if (t >=3D 16) {	/* a M4 match */
> +				m_pos =3D op;
> +				m_pos -=3D (t & 8) << 11;
> +				t &=3D 7;
> +				if (t =3D=3D 0) {
> +					while (*ip =3D=3D 0) {
> +						t +=3D 255;
> +						ip++;
> +					}
> +					t +=3D 7 + *ip++;
> +				}
> +#if defined(__LITTLE_ENDIAN)
> +				m_pos -=3D (*(const unsigned short *)ip) >> 2;
> +#else
> +				m_pos -=3D (ip[0] >> 2) + (ip[1] << 6);
> +#endif

m_pos -=3D le16_to_cpu(*(const u16 *)ip) >> 2;

> +				ip +=3D 2;
> +				if (m_pos =3D=3D op)
> +					goto eof_found;
> +				m_pos -=3D 0x4000;
> +			} else {		/* a M1 match */
> +				m_pos =3D op - 1;
> +				m_pos -=3D t >> 2;
> +				m_pos -=3D *ip++ << 2;
> +				*op++ =3D *m_pos++; *op++ =3D *m_pos;
> +				goto match_done;
> +			}
> +=09
> +			/* copy match */
> +			if (t >=3D 2 * 4 - (3 - 1) && (op - m_pos) >=3D 4) {
> +				COPY4(op,m_pos);
> +				op +=3D 4; m_pos +=3D 4; t -=3D 4 - (3 - 1);
> +				do {
> +					COPY4(op,m_pos);
> +					op +=3D 4; m_pos +=3D 4; t -=3D 4;
> +				} while (t >=3D 4);
> +				if (t > 0)
> +					do
> +						*op++ =3D *m_pos++;
> +					while (--t > 0);
> +			} else {
> +copy_match:
> +				*op++ =3D *m_pos++; *op++ =3D *m_pos++;
> +				do
> +					*op++ =3D *m_pos++;
> +				while (--t > 0);
> +			}
> +=09
> +match_done:
> +			t =3D ip[-2] & 3;
> +			if (t =3D=3D 0)
> +				break;
> +=09
> +			/* copy literals */
> +match_next:
> +			*op++ =3D *ip++;
> +			if (t > 1) {
> +				*op++ =3D *ip++;
> +				if (t > 2)
> +					*op++ =3D *ip++;
> +			}
> +			t =3D *ip++;
> +		} while (1);
> +	}
> +
> +eof_found:
> +	*out_len =3D pd(op, out);
> +	return (ip =3D=3D ip_end ? 0 : -1);
> +}
> +
> +EXPORT_SYMBOL(lzo1x_decompress);
> diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
> new file mode 100755
> index 0000000..4dd993d
> --- /dev/null
> +++ b/lib/lzo1x/lzo1x_int.h
> @@ -0,0 +1,105 @@
> +/* lzo1x_int.h -- to be used internally by LZO de/compression algorithms
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
> +   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
> +   All Rights Reserved.
> +
> +   The LZO library is free software; you can redistribute it and/or
> +   modify it under the terms of the GNU General Public License,
> +   version 2, as published by the Free Software Foundation.
> +
> +   The LZO library is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +   GNU General Public License for more details.
> +
> +   You should have received a copy of the GNU General Public License
> +   along with the LZO library; see the file COPYING.
> +   If not, write to the Free Software Foundation, Inc.,
> +   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> +
> +   Markus F.X.J. Oberhumer
> +   <markus@oberhumer.com>
> +   http://www.oberhumer.com/opensource/lzo/
> +
> +
> +   This file was derived from several header files found in original
> +   LZO 2.02 code. Some additional changes have also been made to make
> +   it work in kernel space.
> +
> +   Nitin Gupta
> +   <nitingupta910@gmail.com>
> + */
> +
> +#ifndef __LZO1X_INT_H
> +#define __LZO1X_INT_H
> +
> +#include <linux/types.h>
> +
> +#define D_SIZE		(1u << D_BITS)
> +#define D_MASK		(D_SIZE - 1)
> +#define D_HIGH		((D_MASK >> 1) + 1)
> +
> +#define DX2(p,s1,s2) \
> +	(((((size_t)((p)[2]) << (s2)) ^ (p)[1]) << (s1)) ^ (p)[0])
> +#define DX3(p,s1,s2,s3) ((DX2((p)+1,s2,s3) << (s1)) ^ (p)[0])
> +#define DMUL(a,b)	((size_t) ((a) * (b)))
> +#define DMS(v,s)	((size_t) (((v) & (D_MASK >> (s))) << (s)))
> +#define DM(v)		DMS(v,0)
> +
> +#define D_BITS		14
> +#define DINDEX1(d,p)	d =3D DM(DMUL(0x21,DX3(p,5,5,6)) >> 5)
> +#define DINDEX2(d,p)	d =3D (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f)
> +#define DENTRY(p,in)	(p)
> +
> +#define PTR(a)		((unsigned long) (a))
> +#define PTR_LT(a,b)	(PTR(a) < PTR(b))
> +#define PTR_GE(a,b)	(PTR(a) >=3D PTR(b))
> +#define PTR_DIFF(a,b)	(PTR(a) - PTR(b))
> +#define pd(a,b)		((size_t) ((a)-(b)))
> +
> +#define LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,max_offset) \
> +	( m_pos =3D ip - (size_t) PTR_DIFF(ip,m_pos), \
> +	PTR_LT(m_pos,in) || \
> +	(m_off =3D (size_t) PTR_DIFF(ip,m_pos)) <=3D 0 || \
> +	m_off > max_offset )
> +
> +#define COPY4(dst,src)	*(uint32_t *)(dst) =3D *(uint32_t *)(src)
> +
> +
> +/* LZO1X Specific constants */
> +
> +#define M1_MAX_OFFSET	0x0400
> +#define M2_MAX_OFFSET	0x0800
> +#define M3_MAX_OFFSET	0x4000
> +#define M4_MAX_OFFSET	0xbfff
> +
> +#define MX_MAX_OFFSET	(M1_MAX_OFFSET + M2_MAX_OFFSET)
> +
> +#define M1_MIN_LEN	2
> +#define M1_MAX_LEN	2
> +#define M2_MIN_LEN	3
> +#define M2_MAX_LEN	8
> +#define M3_MIN_LEN	3
> +#define M3_MAX_LEN	33
> +#define M4_MIN_LEN	3
> +#define M4_MAX_LEN	9
> +
> +#define M1_MARKER	0
> +#define M2_MARKER	64
> +#define M3_MARKER	32
> +#define M4_MARKER	16
> +
> +#define MIN_LOOKAHEAD	(M2_MAX_LEN + 1)
> +
> +#endif /* already included */



--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGTYnLIWZCBzwS8mkRAowIAKDAkleXDY33tnrIBH1TbXEz92arKQCeJxwz
0TNp/92amhoFL4pai1dytQw=
=syaD
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
