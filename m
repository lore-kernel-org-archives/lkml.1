Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXERKPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXERKPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXERKPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:15:44 -0400
Received: from zakalwe.fi ([80.83.5.154]:33713 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbXERKPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:15:43 -0400
Date: Fri, 18 May 2007 13:14:49 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
Message-ID: <20070518101449.GH10873@zakalwe.fi>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good work..

On Fri, May 18, 2007 at 03:28:31PM +0530, Nitin Gupta wrote:
> Facts for LZO (at least for original code. Should hold true for this
> port also - hence the RFC!):
> - The compressor can never overrun buffer.
> - The "non-safe" version of decompressor can never overrun buffer if
> compressed data is unmodified. I am not sure about this if compressed
> data is malicious (to be confirmed from the author).
> - The "safe" version can never crash (buffer overrun etc.) - confirmed
> from the author.

What's the proof?

> +/* LZO1X_1 compression */
> +int
> +lzo1x_compress(const unsigned char *src, size_t src_len,
> +		unsigned char *dst, size_t *dst_len,
> +		void *workmem);

int lzo1x_compress(const unsigned char *src, size_t src_len,
		   unsigned char *dst, size_t *dst_len,
		   void *workmem);

is the preferred style.




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

Is the register directive really useful? Or any subsequent usage of that 
directive?

> +	unsigned char *op;
> +	const unsigned char * const in_end = in + in_len;
> +	const unsigned char * const ip_end = in + in_len - M2_MAX_LEN - 5;
> +	const unsigned char *ii;
> +	const unsigned char ** const dict = (const unsigned char **)workmem;
> +
> +	op = out;
> +	ip = in;
> +	ii = ip;
> +
> +	ip += 4;
> +	for (;;) {
> +		register const unsigned char *m_pos;
> +		size_t m_off;
> +		size_t m_len;
> +		size_t dindex;
> +
> +		DINDEX1(dindex,ip);

Put a space after the delimiter: DINDEX1(dindex, ip); This happens in 
many places in the source, fix them all.

> +		m_pos = dict[dindex];
> +
> +		if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
> +			goto literal;
> +		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
> +			goto try_match;
> +
> +		DINDEX2(dindex,ip);
> +		m_pos = dict[dindex];
> +
> +		if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
> +			goto literal;
> +		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
> +			goto try_match;
> +
> +		goto literal;
> +
> +try_match:
> +        if (*(const unsigned short *)m_pos != *(const unsigned short *)ip) 
> {
> +        } else {
> +		if (likely(m_pos[2] == ip[2]))
> +			goto match;
> +        }
> +
> +	/* a literal */
> +literal:
> +	dict[dindex] = ip;
> +	++ip;
> +	if (unlikely(ip >= ip_end))
> +		break;
> +	continue;
> +
> +
> +	/* a match */
> +match:
> +	dict[dindex] = ip;
> +	/* store current literal run */
> +	if (pd(ip,ii) > 0) {
> +		register size_t t = pd(ip,ii);
> +		if (t <= 3)
> +			op[-2] |= (unsigned char)(t);
> +		else if (t <= 18)
> +			*op++ = (unsigned char)(t - 3);
> +		else {
> +			register size_t tt = t - 18;
> +			*op++ = 0;
> +			while (tt > 255) {
> +				tt -= 255;
> +				*op++ = 0;
> +                	}
> +			*op++ = (unsigned char)(tt);

Useless brackets: (unsigned char) tt

> +		}
> +		do *op++ = *ii++; while (--t > 0);

memcpy(op, ii, t); ? Happens in other places as well.

> +	}
> +
> +	/* code the match */
> +	ip += 3;
> +	if (m_pos[3] != *ip++ || m_pos[4] != *ip++ || m_pos[5] != *ip++ ||
> +            m_pos[6] != *ip++ || m_pos[7] != *ip++ || m_pos[8] != *ip++) {
> +		--ip;
> +		m_len = pd(ip, ii);
> +
> +		if (m_off <= M2_MAX_OFFSET) {
> +			m_off -= 1;
> +			*op++ = (unsigned char)(((m_len - 1) << 5) | ((m_off 
> & 7) << 2));
> +			*op++ = (unsigned char)(m_off >> 3);
> +		}
> +		else if (m_off <= M3_MAX_OFFSET) {
> +			m_off -= 1;
> +			*op++ = (unsigned char)(M3_MARKER | (m_len - 2));
> +			goto m3_m4_offset;
> +		} else {
> +			m_off -= 0x4000;
> +			*op++ = (unsigned char)(M4_MARKER |
> +				((m_off & 0x4000) >> 11) | (m_len - 2));
> +			goto m3_m4_offset;
> +		}
> +        } else {
> +		const unsigned char *end = in_end;
> +		const unsigned char *m = m_pos + M2_MAX_LEN + 1;
> +		while (ip < end && *m == *ip)
> +			m++, ip++;
> +		m_len = pd(ip, ii);
> +
> +		if (m_off <= M3_MAX_OFFSET) {
> +			m_off -= 1;
> +			if (m_len <= 33)
> +				*op++ = (unsigned char)(M3_MARKER | (m_len - 
> 2));
> +			else {
> +				m_len -= 33;
> +				*op++ = M3_MARKER | 0;
> +				goto m3_m4_len;
> +			}
> +		} else {
> +			m_off -= 0x4000;
> +			if (m_len <= M4_MAX_LEN)
> +				*op++ = (unsigned char)(M4_MARKER |
> +					((m_off & 0x4000) >> 11) | (m_len - 
> 2));
> +			else {
> +				m_len -= M4_MAX_LEN;
> +				*op++ = (unsigned char)(M4_MARKER | ((m_off 
> & 0x4000) >> 11));
> +m3_m4_len:
> +				while (m_len > 255) {
> +					m_len -= 255;
> +					*op++ = 0;
> +				}
> +				*op++ = (unsigned char)(m_len);
> +			}
> +		}
> +
> +m3_m4_offset:
> +		*op++ = (unsigned char)((m_off & 63) << 2);
> +		*op++ = (unsigned char)(m_off >> 6);
> +	}
> +
> +	ii = ip;
> +	if (unlikely(ip >= ip_end))
> +		break;
> +	}
> +
> +	*out_len = pd(op, out);
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
> +	unsigned char *op = out;
> +	size_t t;
> +
> +	if (!workmem)
> +		return -EINVAL;
> +
> +	if (unlikely(in_len <= M2_MAX_LEN + 5))
> +		t = in_len;
> +	else {
> +		t = lzo1x_compress_worker(in,in_len,op,out_len,workmem);
> +        	op += *out_len;
> +	}
> +
> +	if (t > 0) {
> +		const unsigned char *ii = in + in_len - t;
> +
> +		if (op == out && t <= 238)
> +			*op++ = (unsigned char)(17 + t);
> +		else if (t <= 3)
> +			op[-2] |= (unsigned char)(t);
> +		else if (t <= 18)
> +			*op++ = (unsigned char)(t - 3);
> +		else {
> +			size_t tt = t - 18;
> +			*op++ = 0;
> +			while (tt > 255) {
> +				tt -= 255;
> +				*op++ = 0;
> +			}
> +			*op++ = (unsigned char)(tt);
> +		}
> +		do {
> +			*op++ = *ii++;
> +		} while (--t > 0);
> +	}
> +	*op++ = M4_MARKER | 1;
> +	*op++ = 0;
> +	*op++ = 0;
> +
> +	*out_len = pd(op, out);
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
> +	const unsigned char * const ip_end = in + in_len;
> +
> +	*out_len = 0;
> +
> +	op = out;
> +	ip = in;
> +
> +	if (*ip > 17) {
> +		t = *ip++ - 17;
> +		if (t < 4)
> +			goto match_next;
> +		do
> +			*op++ = *ip++;
> +		while (--t > 0);
> +		goto first_literal_run;
> +	}
> +
> +	while (1) {
> +		t = *ip++;
> +		if (t >= 16)
> +			goto match;
> +		/* a literal run */
> +		if (t == 0) {
> +			while (*ip == 0) {
> +				t += 255;
> +				ip++;
> +			}
> +			t += 15 + *ip++;
> +		}
> +		/* copy literals */
> +		COPY4(op,ip);
> +		op += 4;
> +		ip += 4;
> +		if (--t > 0) {
> +			if (t >= 4) {
> +				do {
> +					COPY4(op,ip);
> +					op += 4; ip += 4; t -= 4;
> +				} while (t >= 4);
> +			if (t > 0)
> +				do
> +					*op++ = *ip++;
> +				while (--t > 0);
> +			} else
> +				do
> +					*op++ = *ip++;
> +				while (--t > 0);
> +		}
> +
> +first_literal_run:
> +
> +		t = *ip++;
> +		if (t >= 16)
> +			goto match;
> +		m_pos = op - (1 + M2_MAX_OFFSET);
> +		m_pos -= t >> 2;
> +		m_pos -= *ip++ << 2;
> +		*op++ = *m_pos++; *op++ = *m_pos++; *op++ = *m_pos;
> +		goto match_done;
> +	
> +		/* handle matches */
> +		do {
> +	match:
> +			if (t >= 64) {		/* a M2 match */
> +				m_pos = op - 1;
> +				m_pos -= (t >> 2) & 7;
> +				m_pos -= *ip++ << 3;
> +				t = (t >> 5) - 1;
> +				goto copy_match;
> +			} else if (t >= 32) {	/* a M3 match */
> +				t &= 31;
> +				if (t == 0) {
> +					while (*ip == 0) {
> +						t += 255;
> +						ip++;
> +					}
> +					t += 31 + *ip++;
> +				}
> +#if defined(__LITTLE_ENDIAN)
> +				m_pos = op - 1;
> +				m_pos -= (*(const unsigned short *)ip) >> 2;
> +#else
> +				m_pos = op - 1;
> +				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> +#endif
> +			ip += 2;
> +			} else if (t >= 16) {	/* a M4 match */
> +				m_pos = op;
> +				m_pos -= (t & 8) << 11;
> +				t &= 7;
> +				if (t == 0) {
> +					while (*ip == 0) {
> +						t += 255;
> +						ip++;
> +					}
> +					t += 7 + *ip++;
> +				}
> +#if defined(__LITTLE_ENDIAN)
> +				m_pos -= (*(const unsigned short *)ip) >> 2;
> +#else
> +				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> +#endif
> +				ip += 2;
> +				if (m_pos == op)
> +					goto eof_found;
> +				m_pos -= 0x4000;
> +			} else {		/* a M1 match */
> +				m_pos = op - 1;
> +				m_pos -= t >> 2;
> +				m_pos -= *ip++ << 2;
> +				*op++ = *m_pos++; *op++ = *m_pos;
> +				goto match_done;
> +			}
> +	
> +			/* copy match */
> +			if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
> +				COPY4(op,m_pos);
> +				op += 4; m_pos += 4; t -= 4 - (3 - 1);
> +				do {
> +					COPY4(op,m_pos);
> +					op += 4; m_pos += 4; t -= 4;
> +				} while (t >= 4);
> +				if (t > 0)
> +					do
> +						*op++ = *m_pos++;
> +					while (--t > 0);
> +			} else {
> +copy_match:
> +				*op++ = *m_pos++; *op++ = *m_pos++;
> +				do
> +					*op++ = *m_pos++;
> +				while (--t > 0);
> +			}
> +	
> +match_done:
> +			t = ip[-2] & 3;
> +			if (t == 0)
> +				break;
> +	
> +			/* copy literals */
> +match_next:
> +			*op++ = *ip++;
> +			if (t > 1) {
> +				*op++ = *ip++;
> +				if (t > 2)
> +					*op++ = *ip++;
> +			}
> +			t = *ip++;
> +		} while (1);
> +	}
> +
> +eof_found:
> +	*out_len = pd(op, out);
> +	return (ip == ip_end ? 0 : -1);
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
> +#define DINDEX1(d,p)	d = DM(DMUL(0x21,DX3(p,5,5,6)) >> 5)
> +#define DINDEX2(d,p)	d = (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f)
> +#define DENTRY(p,in)	(p)
> +
> +#define PTR(a)		((unsigned long) (a))
> +#define PTR_LT(a,b)	(PTR(a) < PTR(b))
> +#define PTR_GE(a,b)	(PTR(a) >= PTR(b))
> +#define PTR_DIFF(a,b)	(PTR(a) - PTR(b))
> +#define pd(a,b)		((size_t) ((a)-(b)))
> +
> +#define LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,max_offset) \
> +	( m_pos = ip - (size_t) PTR_DIFF(ip,m_pos), \
> +	PTR_LT(m_pos,in) || \
> +	(m_off = (size_t) PTR_DIFF(ip,m_pos)) <= 0 || \
> +	m_off > max_offset )
> +
> +#define COPY4(dst,src)	*(uint32_t *)(dst) = *(uint32_t *)(src)

Use u32.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
