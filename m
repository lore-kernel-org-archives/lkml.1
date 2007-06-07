Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXFGL46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXFGL46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXFGL4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:56:51 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:53010 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbXFGL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:56:50 -0400
Subject: LZO patch comparision
From: Richard Purdie <rpurdie@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 12:56:29 +0100
Message-Id: <1181217390.6086.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a diff between our versions. I've annotated it with comments 
on the differences. There are some differences not easily seen in the
diff, the main one is the filenames. I've mentioned this elsewhere but I
will do so here for completeness. There are two reasons for my choice of
file/module names:

1. Its possible some other lzo algorithm will be added to the kernel in
the future. If that does happen, having only one "LZO" header and
Kconfig entry makes sense.

2. I have a stack of patches which use LZO and I wanted to maintain
compatibility with that.

I also kept the function names the same as minilzo, just so it was clear
which ones were chosen and what the behaviour is. I can't see a good
reason not to do this?


In the following,
- is Nitin's patch
+ is my version.

diff -uwr 1/lzo1x_compress.c 2/lzo1x_compress.c
--- 1/lzo1x_compress.c  2007-06-07 09:33:34.000000000 +0100
+++ 2/lzo1x_compress.c  2007-06-06 23:00:58.000000000 +0100
@@ -1,86 +1,58 @@

 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/compiler.h>
-#include <linux/lzo1x.h>
-
-#include "lzo1x_int.h"
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("LZO1X Compression");
-
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/string.h>
+#include <linux/lzo.h>
+#include "lzodefs.h"

My version has too many includes. Is compiler.h needed?

-/* compress a block of data. */
-static noinline unsigned int
-lzo1x_compress_worker(const unsigned char *in, size_t in_len,
-                       unsigned char *out, size_t *out_len,
-                       void *workmem)
+static noinline size_t
+_lzo1x_1_do_compress(const unsigned char *in , size_t in_len,
+               unsigned char *out, size_t *out_len, void *wrkmem)

Should be size_t, not int, no need to linewrap workmem.
Whitespace damage in mine.

 {
-       register const unsigned char *ip;
-       unsigned char *op;
        const unsigned char * const in_end = in + in_len;
        const unsigned char * const ip_end = in + in_len - M2_MAX_LEN - 5;
-       const unsigned char *ii;
-       const unsigned char ** const dict = (const unsigned char **)workmem;
-
-       op = out;
-       ip = in;
-       ii = ip;
+       const unsigned char ** const dict = wrkmem;
+       const unsigned char *ip = in, *ii = ip;
+       const unsigned char *end, *m, *m_pos;
+       size_t m_off, m_len, dindex;
+       unsigned char *op = out;
 
No need for register (doesn't change any compiler output I've seen)
Can merge the assignments into the declaration.
workmem has a pointless cast.

        ip += 4;
-       for (;;) {
-               register const unsigned char *m_pos;
-               size_t m_off;
-               size_t m_len;
-               size_t dindex;
 
Probably makes sense at the start of the function.

+       for (;;) {
-               DINDEX1(dindex, ip);
+               dindex = DMS((0x21 * DX3(ip,5,5,6)) >> 5, 0);
                m_pos = dict[dindex];

Probably makes sense to expand the define since its single use.

-               if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
-                                || m_off > M4_MAX_OFFSET)
+               if (m_pos < in)
+                       goto literal;
+
+               m_off = ip - m_pos;
+               if (m_off == 0 || m_off > M4_MAX_OFFSET)
                        goto literal;

This can be expanded to be more obvious. Need to be careful about
signage, the <= becomes a == but we can then lose the cast.
 
                if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
                        goto try_match;
 
-               DINDEX2(dindex, ip);
+               dindex = (dindex & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f);
                m_pos = dict[dindex];

Probably makes sense to expand the define since its single use.
 
-               if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
-                                || m_off > M4_MAX_OFFSET)
+               if (m_pos < in)
+                       goto literal;
+
+               m_off = ip - m_pos;
+               if (m_off == 0 || m_off > M4_MAX_OFFSET)
                        goto literal;

See above.

                if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])

@@ -107,95 +78,86 @@
                        break;
                continue;
 
-               /* a match */
 match:
                dict[dindex] = ip;
-               /* store current literal run */
-               if ((size_t)(ip - ii) > 0) {
+               if (ip != ii) {

These are equivalent. The version without the cast is probably
preferable.

-                       register size_t t = (size_t)(ip - ii);
+                       size_t t = ip - ii;

No register or cast needed.

-                       if (t <= 3)
+                       if (t <= 3) {
-                               op[-2] |= (unsigned char)t;
+                               op[-2] |= t;
-                       else if (t <= 18)
+                       } else if (t <= 18) {
-                               *op++ = (unsigned char)(t - 3);
-                       else {
-                               register size_t tt = t - 18;

No register needed.
If one element has braces, the others probably should too.
The unsigned char casts are all unneeded.
I'll skip future cases of these issues but there are more.

                } else {
-                       const unsigned char *end = in_end;
-                       const unsigned char *m = m_pos + M2_MAX_LEN + 1;
+                       end = in_end;
+                       m = m_pos + M2_MAX_LEN + 1;

My version moves the variable declaration to the start of the function.
Arguable either way (I thought CodingStyle mentioned this but it
doesn't).

                        while (ip < end && *m == *ip)
                                m++, ip++;
-                       m_len = (size_t)(ip - ii);
+                       m_len = ip - ii;

unneeded cast.

@@ -203,61 +165,60 @@
                        break;
        }
 
-       *out_len = (size_t)(op - out);
-       return (size_t)(in_end - ii);
+       *out_len = op - out;
+       return in_end - ii;

unneeded casts.
 
-
-/*
- * This requires buffer (workmem) of size LZO1X_WORKMEM_SIZE
- * (exported by lzo1x.h).
- */
-int
-lzo1x_compress(const unsigned char *in, size_t  in_len,
+int lzo1x_1_compress(const unsigned char *in , size_t in_len,
                unsigned char *out, size_t *out_len,
-               void *workmem)
+                       void *wrkmem )
 
Broken whitespace in my version.

+       const unsigned char *ii;
        unsigned char *op = out;
        size_t t;
 
-       if (!workmem)
-               return -EINVAL;

Could be confused with LZO's own error codes. Do we need this? 

-       if (unlikely(in_len <= M2_MAX_LEN + 5))
+       if (unlikely(in_len <= M2_MAX_LEN + 5)) {
                t = in_len;
-       else {
-               t = lzo1x_compress_worker(in, in_len, op, out_len, workmem);
+       } else {
+               t = _lzo1x_1_do_compress(in,in_len,op,out_len,wrkmem);
                op += *out_len;
        }

Broken whitespace in my version for lzo1x_compress_worker

        *op++ = M4_MARKER | 1;
        *op++ = 0;
        *op++ = 0;
 
-       *out_len = (size_t)(op - out);
+       *out_len = op - out;

Pointless cast.

        return LZO_E_OK;
 }
 
-EXPORT_SYMBOL(lzo1x_compress);
+EXPORT_SYMBOL_GPL(lzo1x_1_compress);

EXPORT_SYMBOL_GPL is preferable?

diff -uwr 1/lzo1x_decompress.c 2/lzo1x_decompress.c
--- 1/lzo1x_decompress.c        2007-06-07 09:33:34.000000000 +0100
+++ 2/lzo1x_decompress.c        2007-06-06 23:13:48.000000000 +0100

-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <asm/byteorder.h>
-#include <linux/lzo1x.h>
-
-#include "lzo1x_int.h"
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/string.h>
+#include <linux/lzo.h>
+#include "lzodefs.h"

My includes are wrong.

+#define HAVE_IP_OR(x, ip_end, ip) ((ip_end - ip) < (size_t)(x))
+#define HAVE_OP_OR(x, op_end, op) ((op_end - op) < (size_t)(x))
+#define HAVE_LB_OR(m_pos, out, op) (m_pos < out || m_pos >= op)

Your NEED_* defines affect flow control contra to CodingStyle, hence my
choice of these instead and the associated code changes which I'll skip
over.
 
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("LZO1X Decompression");
+#if defined(LZO_UNALIGNED_OK_4)
+#define COPY4(dst,src) *(u32 *)(dst) = *(const u32 *)(src)
+#endif

Only the decompressor uses COPY4 so I moved it to this file.

                do {
                        *op++ = *ip++;
                } while (--t > 0);
                goto first_literal_run;
        }
 
-       while (TEST_IP) {
+       while ((ip < ip_end)) {

Might as well expand this...


                        t += 15 + *ip++;
                }
-               /* copy literals */
-               NEED_OP(t + 3);
-               NEED_IP(t + 4);
-#ifndef UNALIGNED_OK
-               if (((ip | op ) & 3) == 0) {
-#endif
+               if (HAVE_OP_OR(t + 3, op_end, op))
+                       goto output_overrun;
+               if (HAVE_IP_OR(t + 4, ip_end, ip))
+                       goto input_overrun;
+
+#if defined(LZO_UNALIGNED_OK_4)
                        COPY4(op, ip);
                        op += 4;
                        ip += 4;

We have a fairly major difference in the code here. This is where you've
assumed LZO_ALIGNED_OK_4 was set and it wasn't set in any in LZO in any
of my tests. Assuming LZO_ALIGNED_OK_4 should be safe for the kernel and
the code path you've added probably performs better but why was it
disabled in minilzo? 
 
-#ifdef UNALIGNED_OK
+#if defined(LZO_UNALIGNED_OK_4)
                        if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
-#else
-                       if (t >= 2 * 4 - (3 - 1) &&
-                                       (((op | m_pos) &  3) == 0)) {
-#endif

Same again here.

@@ -229,42 +230,45 @@

                        t = *ip++;
-               } while (TEST_IP);
+               } while (ip < ip_end);

Might as well expand this.

        }
 
-       /* no EOF code was found */
-       *out_len = (size_t)(op - out);
+       *out_len = op - out;
        return LZO_E_EOF_NOT_FOUND;

Pointless cast (ditto all other returns below it)
 
-EXPORT_SYMBOL(lzo1x_decompress);
+EXPORT_SYMBOL_GPL(lzo1x_decompress_safe);

GPL?


diff -uwr 1/lzodefs.h 2/lzodefs.h
--- 1/lzodefs.h 2007-06-07 09:33:34.000000000 +0100
+++ 2/lzodefs.h 2007-06-06 17:40:56.000000000 +0100
 
-#ifndef __LZO1X_INT_H
-#define __LZO1X_INT_H

Pointless since only the LZO code will include this and it will do it
once.

-#include <linux/types.h>

Uneeded?

+#define LZO_VERSION             0x2020
+#define LZO_VERSION_STRING      "2.02"
+#define LZO_VERSION_DATE        "Oct 17 2005"

A good idea to leave these so the exact version this was created from is
documented.

-#ifdef UNALIGNED_OK
-#define COPY4(dst,src) *(u32 *)(dst) = *(u32 *)(src)
-#endif

Can move to decompressor only.


@@ -75,13 +51,21 @@
 #define M3_MARKER      32
 #define M4_MARKER      16
 
-/* Bounds checking */
-#define TEST_IP        (ip < ip_end)
-#define NEED_IP(x) \
-       if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
-#define NEED_OP(x) \
-       if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
-#define TEST_LB(m_pos) \
-       if (m_pos < out || m_pos >= op) goto lookbehind_overrun

See above, these break coding style due to the goto. Also, they're
decompressor only.

-#define DINDEX1(d,p) \
-       d = ((size_t)(0x21 * DX3(p, 5, 5, 6)) >> 5) & D_MASK
-#define DINDEX2(d,p) \
-       d = (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f)

Only used once, might as well just place in the main code.

+#define _DINDEX(dv,p)  (((0x9f5f * (dv))) >> 5)
+#define DINDEX(dv,p)   ((size_t)((_DINDEX(dv,p)) & D_MASK))

These are unused and can be removed from my version, I'd missed that.

+#define DMS(v,s)	((size_t) (((v) & (D_MASK >> (s))) << (s)))

You've merged this into DINDEX2. Since s is 0, that probably makes sense
(we can both lose the cast too).

+/* Which machines to allow unaligned accesses on */
+#if defined(CONFIG_X86_32) || defined(CONFIG_X86_64)
+#define LZO_UNALIGNED_OK_2
+#define LZO_UNALIGNED_OK_4
 #endif

Probably preferable to do this here using CONFIG options rather than in
the Makefile. I still need to do some further tests to ascertain whether
we can use get/put_unaligned without affecting performance instead.


So in summary apart from style issues, the code is the same apart from
the alignment access issues. 

http://folks.o-hand.com/richard/lzo/lzo_kernel-r5.patch is a version
I've updated as I went through this which should combine the good bits
from both *apart* from the alignment issues which I want to look at more
carefully before taking an approach.

Cheers,

Richard


