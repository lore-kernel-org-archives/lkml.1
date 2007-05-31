Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbXEaMev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbXEaMev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbXEaMen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:34:43 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:9588 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760168AbXEaMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NQUS2lqz7BkML6fsU53Dwprj7WbjOb+3ScRUVCFVU1tmg4CTEzAgjSlhlSe5lY9uw/YXOCC/uFJop7tAYOM6g3QKiMVcsxabIe45T82aAi1ocJYgYN/X3GuKWpLlZ0eYhBHDfQxl6RQbK3Z+geT1CNIVieU+ftaSjrqd7wSrm/Y=
Message-ID: <4cefeab80705310534jb92535dy45fcf5fbe363b55b@mail.gmail.com>
Date: Thu, 31 May 2007 18:04:40 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FYI...

The author (Markus Oberhumer) of LZO  provided these comments for this patch:

---
I've only briefly looked over it, but it's obvious that your version does not
work on architechtures which do not allow unaligned access (arm, mips, ...).

As for further quality assurance, your version should generate byte-identical
object code to LZO 2.02 when using the same compiler & flags. So you could do
some semi-automatic testing by compiling with -ffunction-sections and use
"objcopy --only-section .text.XXX" to compare the md5sum of all generated
functions. This also works fine with crosscompilers.

Finally I'm not too happy that you renamed the functions and #defines like
LZO1X_WORKMEM_SIZE - please stay compatible with the official library version.
----

Still a lot to do...

- Nitin


On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> This is kernel port of LZO1X-1 compressor and LZO1X decompressor (safe
> version only).
>
> * Changes since 'take 5' (Full Changelog after this):
> - Added compressor and decomrpesssor as separate and hidden config
> options (default: n)
> - Cleanups: removed LZO_CHECK_MPOS_NON_DET macro
> - removed PTR* macros.
>
> * Benchmarks: (system: P4 3GHz, 1G RAM)
> (Using tester program from Daniel)
>
> Following compares this kernel port ('take 6') vs original miniLZO code:
>
> 'TinyLZO' refers to this kernel port.
>
> 10000 run averages:
> 'Tiny LZO':
>        Combined: 61.2223 usec
>        Compression: 41.8412 usec
>        Decompression: 19.3811 usec
> 'miniLZO':
>        Combined: 66.0444 usec
>        Compression: 46.6323 usec
>        Decompression: 19.4121 usec
>
> Result:
> Overall: TinyLZO is 7.3% faster
> Compressor: TinyLZO is 10.2% faster
> Decompressor: TinyLZO is 0.15% faster
>
> TODO: test 'take 6' port on archs other than x86(_32)
>
> * Changelog vs. original LZO:
> 1) Used standard/kernel defined data types: (this eliminated _huge_
> #ifdef chunks)
>   lzo_bytep -> unsigned char *
>   lzo_uint -> size_t
>   lzo_xint -> size_t
>   lzo_uint32p -> u32 *
>   lzo_uintptr_t  -> unsigned long
> 2) Removed everything #ifdef'ed under COPY_DICT (this is not set for
> LZO1X, so removed corres. parts).
> 3) Removed code #ifdef'ed for LZO1Y, LZO1Z, other variants.
> 4) Reformatted the code to match general kernel style.
> 5) The only code change: (as suggested by Andrey)
> -#if defined(__LITTLE_ENDIAN)
> -                             m_pos = op - 1;
> -                             m_pos -= (*(const unsigned short *)ip) >> 2;
> -#else
> -                             m_pos = op - 1;
> -                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> -#endif
>
> + m_pos = op - 1 - (cpu_to_le16(*(const u16 *)ip) >> 2);
>
> (Andrey suggested le16_to_cpu for above but I think it should be cpu_to_le16).
> *** Need testing on big endian machine ***
>
> Similarly:
> -#if defined(__LITTLE_ENDIAN)
> -                             m_pos -= (*(const unsigned short *)ip) >> 2;
> -#else
> -                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> -#endif
>
> + m_pos -= cpu_to_le16(*(const u16 *)ip) >> 2;
>
> 6) Get rid of LZO_CHECK_MPOS_NON_DET macro and PTR* macros.
>
>
> I think it's now ready for mainline inclusion.
>
>
>  include/linux/lzo1x.h        |   66 +++++++++++
>  lib/Kconfig                  |    6 +
>  lib/Makefile                 |    2 +
>  lib/lzo1x/Makefile           |    2 +
>  lib/lzo1x/lzo1x_compress.c   |  259 ++++++++++++++++++++++++++++++++++++++++++
>  lib/lzo1x/lzo1x_decompress.c |  238 ++++++++++++++++++++++++++++++++++++++
>  lib/lzo1x/lzo1x_int.h        |   85 ++++++++++++++
>  7 files changed, 658 insertions(+), 0 deletions(-)
>
> Signed-off-by: Nitin Gupta <nitingupta910 [at] gmail [dot] com>
> ---
> diff --git a/include/linux/lzo1x.h b/include/linux/lzo1x.h
> new file mode 100755
> index 0000000..11a6f23
> --- /dev/null
> +++ b/include/linux/lzo1x.h
> @@ -0,0 +1,66 @@
> +/* lzo1x.h -- public interface of the LZO1X compression algorithm
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
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
> +/* LZO return codes */
> +#define LZO_E_OK                       0
> +#define LZO_E_ERROR                    (-1)
> +#define LZO_E_OUT_OF_MEMORY            (-2)    /* [not used right now] */
> +#define LZO_E_NOT_COMPRESSIBLE         (-3)    /* [not used right now] */
> +#define LZO_E_INPUT_OVERRUN            (-4)
> +#define LZO_E_OUTPUT_OVERRUN           (-5)
> +#define LZO_E_LOOKBEHIND_OVERRUN       (-6)
> +#define LZO_E_EOF_NOT_FOUND            (-7)
> +#define LZO_E_INPUT_NOT_CONSUMED       (-8)
> +#define LZO_E_NOT_YET_IMPLEMENTED      (-9)    /* [not used right now] */
> +
> +/* Size of temp buffer (workmem) required by lzo1x_compress */
> +#define LZO1X_WORKMEM_SIZE     ((size_t) (16384L * sizeof(unsigned char *)))
> +
> +/*
> + * This requires 'workmem' of size LZO1X_WORKMEM_SIZE
> + */
> +int lzo1x_compress(const unsigned char *src, size_t src_len,
> +               unsigned char *dst, size_t *dst_len,
> +               void *workmem);
> +
> +/*
> + * This decompressor will catch all compressed data violations and
> + * return an error code in this case.
> + */
> +int lzo1x_decompress(const unsigned char *src, size_t src_len,
> +               unsigned char *dst, size_t *dst_len);
> +#endif
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 2e7ae6b..eb95eaa 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -64,6 +64,12 @@ config ZLIB_INFLATE
>  config ZLIB_DEFLATE
>         tristate
>
> +config LZO1X_COMPRESS
> +       tristate
> +
> +config LZO1X_DECOMPRESS
> +       tristate
> +
>  #
>  # Generic allocator support is selected if needed
>  #
> diff --git a/lib/Makefile b/lib/Makefile
> index c8c8e20..448ae37 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -49,6 +49,8 @@ obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
>  obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
>  obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
>  obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
> +obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x/
> +obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x/
>
>  obj-$(CONFIG_TEXTSEARCH) += textsearch.o
>  obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
> diff --git a/lib/lzo1x/Makefile b/lib/lzo1x/Makefile
> new file mode 100644
> index 0000000..7b56a4d
> --- /dev/null
> +++ b/lib/lzo1x/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x_compress.o
> +obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x_decompress.o
> diff --git a/lib/lzo1x/lzo1x_compress.c b/lib/lzo1x/lzo1x_compress.c
> new file mode 100755
> index 0000000..b525be6
> --- /dev/null
> +++ b/lib/lzo1x/lzo1x_compress.c
> @@ -0,0 +1,259 @@
> +/* lzo1x_compress.c -- LZO1X-1 compression
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
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
> +#include <linux/lzo1x.h>
> +
> +#include "lzo1x_int.h"
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("LZO1X Compression");
> +
> +/* compress a block of data. */
> +static noinline unsigned int
> +lzo1x_compress_worker(const unsigned char *in, size_t in_len,
> +                       unsigned char *out, size_t *out_len,
> +                       void *workmem)
> +{
> +       register const unsigned char *ip;
> +       unsigned char *op;
> +       const unsigned char * const in_end = in + in_len;
> +       const unsigned char * const ip_end = in + in_len - M2_MAX_LEN - 5;
> +       const unsigned char *ii;
> +       const unsigned char ** const dict = (const unsigned char **)workmem;
> +
> +       op = out;
> +       ip = in;
> +       ii = ip;
> +
> +       ip += 4;
> +       for (;;) {
> +               register const unsigned char *m_pos;
> +               size_t m_off;
> +               size_t m_len;
> +               size_t dindex;
> +
> +               DINDEX1(dindex, ip);
> +               m_pos = dict[dindex];
> +
> +               if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
> +                                || m_off > M4_MAX_OFFSET)
> +                       goto literal;
> +
> +               if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
> +                       goto try_match;
> +
> +               DINDEX2(dindex, ip);
> +               m_pos = dict[dindex];
> +
> +               if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
> +                                || m_off > M4_MAX_OFFSET)
> +                       goto literal;
> +
> +               if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
> +                       goto try_match;
> +
> +               goto literal;
> +
> +try_match:
> +               if (*(const unsigned short *)m_pos ==
> +                               *(const unsigned short *)ip) {
> +                       if (likely(m_pos[2] == ip[2]))
> +                               goto match;
> +               }
> +
> +               /* a literal */
> +literal:
> +               dict[dindex] = ip;
> +               ++ip;
> +               if (unlikely(ip >= ip_end))
> +                       break;
> +               continue;
> +
> +               /* a match */
> +match:
> +               dict[dindex] = ip;
> +               /* store current literal run */
> +               if ((size_t)(ip - ii) > 0) {
> +                       register size_t t = (size_t)(ip - ii);
> +                       if (t <= 3)
> +                               op[-2] |= (unsigned char)t;
> +                       else if (t <= 18)
> +                               *op++ = (unsigned char)(t - 3);
> +                       else {
> +                               register size_t tt = t - 18;
> +                               *op++ = 0;
> +                               while (tt > 255) {
> +                                       tt -= 255;
> +                                       *op++ = 0;
> +                               }
> +                               *op++ = (unsigned char)tt;
> +                       }
> +                       do
> +                               *op++ = *ii++;
> +                       while (--t > 0);
> +               }
> +
> +               /* code the match */
> +               ip += 3;
> +               if (m_pos[3] != *ip++ || m_pos[4] != *ip++ ||
> +                               m_pos[5] != *ip++ || m_pos[6] != *ip++ ||
> +                               m_pos[7] != *ip++ || m_pos[8] != *ip++) {
> +                       --ip;
> +                       m_len = (size_t)(ip - ii);
> +
> +                       if (m_off <= M2_MAX_OFFSET) {
> +                               m_off -= 1;
> +                               *op++ = (unsigned char)(((m_len - 1) << 5) |
> +                                       ((m_off & 7) << 2));
> +                               *op++ = (unsigned char)(m_off >> 3);
> +                       }
> +                       else if (m_off <= M3_MAX_OFFSET) {
> +                               m_off -= 1;
> +                               *op++ = (unsigned char)(M3_MARKER |
> +                                       (m_len - 2));
> +                               goto m3_m4_offset;
> +                       } else {
> +                               m_off -= 0x4000;
> +                               *op++ = (unsigned char)(M4_MARKER |
> +                                       ((m_off & 0x4000) >> 11) |
> +                                       (m_len - 2));
> +                               goto m3_m4_offset;
> +                       }
> +               } else {
> +                       const unsigned char *end = in_end;
> +                       const unsigned char *m = m_pos + M2_MAX_LEN + 1;
> +                       while (ip < end && *m == *ip)
> +                               m++, ip++;
> +                       m_len = (size_t)(ip - ii);
> +
> +                       if (m_off <= M3_MAX_OFFSET) {
> +                               m_off -= 1;
> +                               if (m_len <= 33)
> +                                       *op++ = (unsigned char)(M3_MARKER |
> +                                               (m_len - 2));
> +                               else {
> +                                       m_len -= 33;
> +                                       *op++ = M3_MARKER | 0;
> +                                       goto m3_m4_len;
> +                               }
> +                       } else {
> +                               m_off -= 0x4000;
> +                               if (m_len <= M4_MAX_LEN)
> +                                       *op++ = (unsigned char)(M4_MARKER |
> +                                               ((m_off & 0x4000) >> 11) |
> +                                               (m_len - 2));
> +                               else {
> +                                       m_len -= M4_MAX_LEN;
> +                                       *op++ = (unsigned char)(M4_MARKER |
> +                                               ((m_off & 0x4000) >> 11));
> +m3_m4_len:
> +                                       while (m_len > 255) {
> +                                               m_len -= 255;
> +                                               *op++ = 0;
> +                                       }
> +                                       *op++ = (unsigned char)(m_len);
> +                               }
> +                       }
> +
> +m3_m4_offset:
> +                       *op++ = (unsigned char)((m_off & 63) << 2);
> +                       *op++ = (unsigned char)(m_off >> 6);
> +               }
> +
> +               ii = ip;
> +               if (unlikely(ip >= ip_end))
> +                       break;
> +       }
> +
> +       *out_len = (size_t)(op - out);
> +       return (size_t)(in_end - ii);
> +}
> +
> +
> +/*
> + * This requires buffer (workmem) of size LZO1X_WORKMEM_SIZE
> + * (exported by lzo1x.h).
> + */
> +int
> +lzo1x_compress(const unsigned char *in, size_t  in_len,
> +               unsigned char *out, size_t *out_len,
> +               void *workmem)
> +{
> +       unsigned char *op = out;
> +       size_t t;
> +
> +       if (!workmem)
> +               return -EINVAL;
> +
> +       if (unlikely(in_len <= M2_MAX_LEN + 5))
> +               t = in_len;
> +       else {
> +               t = lzo1x_compress_worker(in, in_len, op, out_len, workmem);
> +               op += *out_len;
> +       }
> +
> +       if (t > 0) {
> +               const unsigned char *ii = in + in_len - t;
> +
> +               if (op == out && t <= 238)
> +                       *op++ = (unsigned char)(17 + t);
> +               else if (t <= 3)
> +                       op[-2] |= (unsigned char)t;
> +               else if (t <= 18)
> +                       *op++ = (unsigned char)(t - 3);
> +               else {
> +                       size_t tt = t - 18;
> +                       *op++ = 0;
> +                       while (tt > 255) {
> +                               tt -= 255;
> +                               *op++ = 0;
> +                       }
> +                       *op++ = (unsigned char)tt;
> +               }
> +               do
> +                       *op++ = *ii++;
> +               while (--t > 0);
> +       }
> +       *op++ = M4_MARKER | 1;
> +       *op++ = 0;
> +       *op++ = 0;
> +
> +       *out_len = (size_t)(op - out);
> +       return LZO_E_OK;
> +}
> +
> +EXPORT_SYMBOL(lzo1x_compress);
> diff --git a/lib/lzo1x/lzo1x_decompress.c b/lib/lzo1x/lzo1x_decompress.c
> new file mode 100755
> index 0000000..75ce294
> --- /dev/null
> +++ b/lib/lzo1x/lzo1x_decompress.c
> @@ -0,0 +1,238 @@
> +/* lzo1x_decompress.c -- LZO1X decompression
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
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
> +#include <linux/lzo1x.h>
> +
> +#include "lzo1x_int.h"
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("LZO1X Decompression");
> +
> +int
> +lzo1x_decompress(const unsigned char *in, size_t in_len,
> +                       unsigned char *out, size_t *out_len)
> +{
> +       register size_t t;
> +       register unsigned char *op = out;
> +       register const unsigned char *ip = in, *m_pos;
> +       const unsigned char * const ip_end = in + in_len;
> +       unsigned char * const op_end = out + *out_len;
> +       *out_len = 0;
> +
> +       if (*ip > 17) {
> +               t = *ip++ - 17;
> +               if (t < 4)
> +                       goto match_next;
> +               NEED_OP(t);
> +               NEED_IP(t + 1);
> +               do
> +                       *op++ = *ip++;
> +               while (--t > 0);
> +               goto first_literal_run;
> +       }
> +
> +       while (TEST_IP) {
> +               t = *ip++;
> +               if (t >= 16)
> +                       goto match;
> +               /* a literal run */
> +               if (t == 0) {
> +                       NEED_IP(1);
> +                       while (*ip == 0) {
> +                               t += 255;
> +                               ip++;
> +                               NEED_IP(1);
> +                       }
> +                       t += 15 + *ip++;
> +               }
> +               /* copy literals */
> +               NEED_OP(t + 3);
> +               NEED_IP(t + 4);
> +               COPY4(op, ip);
> +               op += 4; ip += 4;
> +               if (--t > 0) {
> +                       if (t >= 4) {
> +                               do {
> +                                       COPY4(op, ip);
> +                                       op += 4; ip += 4; t -= 4;
> +                               } while (t >= 4);
> +                               if (t > 0)
> +                                       do
> +                                               *op++ = *ip++;
> +                                       while (--t > 0);
> +                       }
> +                       else
> +                               do
> +                                       *op++ = *ip++;
> +                               while (--t > 0);
> +               }
> +
> +first_literal_run:
> +               t = *ip++;
> +               if (t >= 16)
> +                       goto match;
> +               m_pos = op - (1 + M2_MAX_OFFSET);
> +               m_pos -= t >> 2;
> +               m_pos -= *ip++ << 2;
> +               TEST_LB(m_pos);
> +               NEED_OP(3);
> +               *op++ = *m_pos++;
> +               *op++ = *m_pos++;
> +               *op++ = *m_pos;
> +               goto match_done;
> +
> +               /* handle matches */
> +               do {
> +match:
> +                       if (t >= 64) {          /* a M2 match */
> +                               m_pos = op - 1;
> +                               m_pos -= (t >> 2) & 7;
> +                               m_pos -= *ip++ << 3;
> +                               t = (t >> 5) - 1;
> +                               TEST_LB(m_pos);
> +                               NEED_OP(t + 3 - 1);
> +                               goto copy_match;
> +                       } else if (t >= 32) {   /* a M3 match */
> +                               t &= 31;
> +                               if (t == 0) {
> +                                       NEED_IP(1);
> +                                       while (*ip == 0) {
> +                                               t += 255;
> +                                               ip++;
> +                                               NEED_IP(1);
> +                                       }
> +                                       t += 31 + *ip++;
> +                               }
> +                               m_pos = op - 1 - (cpu_to_le16(
> +                                       *(const unsigned short *)ip) >> 2);
> +                               ip += 2;
> +                       } else if (t >= 16) {   /* a M4 match */
> +                               m_pos = op;
> +                               m_pos -= (t & 8) << 11;
> +                               t &= 7;
> +                               if (t == 0) {
> +                                       NEED_IP(1);
> +                                       while (*ip == 0) {
> +                                               t += 255;
> +                                               ip++;
> +                                               NEED_IP(1);
> +                                       }
> +                                       t += 7 + *ip++;
> +                               }
> +                               m_pos -= cpu_to_le16(
> +                                       *(const unsigned short *)ip) >> 2;
> +                               ip += 2;
> +                               if (m_pos == op)
> +                                       goto eof_found;
> +                               m_pos -= 0x4000;
> +                       } else {                /* a M1 match */
> +                               m_pos = op - 1;
> +                               m_pos -= t >> 2;
> +                               m_pos -= *ip++ << 2;
> +                               TEST_LB(m_pos);
> +                               NEED_OP(2);
> +                               *op++ = *m_pos++;
> +                               *op++ = *m_pos;
> +                               goto match_done;
> +                       }
> +
> +                       /* copy match */
> +                       TEST_LB(m_pos);
> +                       NEED_OP(t + 3 - 1);
> +
> +                       if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
> +                               COPY4(op, m_pos);
> +                               op += 4; m_pos += 4; t -= 4 - (3 - 1);
> +                               do {
> +                                       COPY4(op, m_pos);
> +                                       op += 4; m_pos += 4; t -= 4;
> +                               } while (t >= 4);
> +                               if (t > 0)
> +                                       do *op++ = *m_pos++;
> +                               while (--t > 0);
> +                       } else {
> +copy_match:
> +                               *op++ = *m_pos++;
> +                               *op++ = *m_pos++;
> +                               do
> +                                       *op++ = *m_pos++;
> +                               while (--t > 0);
> +                       }
> +
> +match_done:
> +                       t = ip[-2] & 3;
> +                       if (t == 0)
> +                               break;
> +
> +                       /* copy literals */
> +match_next:
> +                       NEED_OP(t);
> +                       NEED_IP(t + 1);
> +                       *op++ = *ip++;
> +                       if (t > 1) {
> +                               *op++ = *ip++;
> +                               if (t > 2)
> +                                       *op++ = *ip++;
> +                       }
> +                       t = *ip++;
> +               } while (TEST_IP);
> +       }
> +
> +       /* no EOF code was found */
> +       *out_len = (size_t)(op - out);
> +       return LZO_E_EOF_NOT_FOUND;
> +
> +eof_found:
> +       *out_len = (size_t)(op - out);
> +       return (ip == ip_end ? LZO_E_OK :
> +               (ip < ip_end ? LZO_E_INPUT_NOT_CONSUMED :
> +               LZO_E_INPUT_OVERRUN));
> +
> +input_overrun:
> +       *out_len = (size_t)(op - out);
> +       return LZO_E_INPUT_OVERRUN;
> +
> +output_overrun:
> +       *out_len = (size_t)(op - out);
> +       return LZO_E_OUTPUT_OVERRUN;
> +
> +lookbehind_overrun:
> +       *out_len = (size_t)(op - out);
> +       return LZO_E_LOOKBEHIND_OVERRUN;
> +}
> +
> +EXPORT_SYMBOL(lzo1x_decompress);
> diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
> new file mode 100755
> index 0000000..4f0fe8d
> --- /dev/null
> +++ b/lib/lzo1x/lzo1x_int.h
> @@ -0,0 +1,85 @@
> +/* lzo1x_int.h -- to be used internally by LZO de/compression algorithms
> +
> +   This file is part of the LZO real-time data compression library.
> +
> +   Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
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
> +#define D_BITS         14
> +#define D_SIZE         (1u << D_BITS)
> +#define D_MASK         (D_SIZE - 1)
> +#define D_HIGH         ((D_MASK >> 1) + 1)
> +
> +#define DX2(p,s1,s2) \
> +       (((((size_t)((p)[2]) << (s2)) ^ (p)[1]) << (s1)) ^ (p)[0])
> +#define DX3(p,s1,s2,s3) \
> +       ((DX2((p) + 1, s2, s3) << (s1)) ^ (p)[0])
> +#define DINDEX1(d,p) \
> +       d = ((size_t)(0x21 * DX3(p, 5, 5, 6)) >> 5) & D_MASK
> +#define DINDEX2(d,p) \
> +       d = (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f)
> +
> +#define COPY4(dst,src) *(u32 *)(dst) = *(u32 *)(src)
> +
> +/* LZO1X Specific constants */
> +#define M1_MAX_OFFSET  0x0400
> +#define M2_MAX_OFFSET  0x0800
> +#define M3_MAX_OFFSET  0x4000
> +#define M4_MAX_OFFSET  0xbfff
> +
> +#define M1_MIN_LEN     2
> +#define M1_MAX_LEN     2
> +#define M2_MIN_LEN     3
> +#define M2_MAX_LEN     8
> +#define M3_MIN_LEN     3
> +#define M3_MAX_LEN     33
> +#define M4_MIN_LEN     3
> +#define M4_MAX_LEN     9
> +
> +#define M1_MARKER      0
> +#define M2_MARKER      64
> +#define M3_MARKER      32
> +#define M4_MARKER      16
> +
> +/* Bounds checking */
> +#define TEST_IP        (ip < ip_end)
> +#define NEED_IP(x) \
> +       if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
> +#define NEED_OP(x) \
> +       if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
> +#define TEST_LB(m_pos) \
> +       if (m_pos < out || m_pos >= op) goto lookbehind_overrun
> +
> +#endif
>
>
