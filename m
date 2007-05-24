Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbXEXRPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbXEXRPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXEXRPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:15:25 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:41453 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXEXRPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:15:21 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Mime-Version: 1.0 (Apple Message framework v752.2)
To: lkml <linux-kernel@vger.kernel.org>
Message-Id: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk>
Content-Type: multipart/mixed; boundary=Apple-Mail-11--143745054
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>
Subject: [RFC] [-mm] Remove 'unsafe' LZO decompressor
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Date: Thu, 24 May 2007 18:15:17 +0100
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-11--143745054
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hi there,

Attached is a patch which may be desirable for -mm. It applies  
directly to 2.6.22-rc2-mm1.

The patch removes the 'unsafe' LZO decompression function, lowering  
the size of the minilzo.c file by nearly 500 out of an original 1727  
lines. It also removes references to the 'unsafe' decompression  
function in the public LZO header and the EXPORT_SYMBOL_GPL declaration.

This is intended to provoke some discussion over whether a  
decompression function able to scribble on arbitrary memory is  
desirable in the mainline kernel, whatever the performance increases.

Over and above the security/stability implications of using this  
code, it can also be argued to represent an unnecessary duplication  
of the vast majority of LZO decompression code. This is due to the  
lack of likely in-kernel uses of the 'unsafe' function.

Only a single user for this 'unsafe' code has been suggested, the  
'Compressed Caching' project. This code is highly unlikely to move  
into mainline in the same timeframe as the LZO code. All of the other  
suggested uses require decompression of untrusted data, such that the  
'safe' function should be used.

Comments / disagreement all welcome :)

Michael-Luke Jones


--Apple-Mail-11--143745054
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=lzo-remove-unsafe-decompressor.patch
Content-Disposition: attachment;
	filename=lzo-remove-unsafe-decompressor.patch

Remove the 'unsafe' LZO decompressor as there are no likely in-kernel
uses soon, and the code provides a potential security and stability
risk due to its intentional lack of memory write bounds checking.

Side effect of simplifying the 'spaghetti code' of minilzo.c by only
including one of the two decompressors that previously were present
as two near-identical separate functions.

Signed-off-by: Michael-Luke Jones <mlj28@cam.ac.uk>

---
 include/linux/lzo.h |    4 
 lib/lzo/lzointf.c   |    1 
 lib/lzo/minilzo.c   |  499 ----------------------------------------------------
 3 files changed, 504 deletions(-)

Index: linux-2.6.22-rc2-mm1/include/linux/lzo.h
===================================================================
--- linux-2.6.22-rc2-mm1.orig/include/linux/lzo.h	2007-05-24 17:37:28.000000000 +0100
+++ linux-2.6.22-rc2-mm1/include/linux/lzo.h	2007-05-24 17:43:44.000000000 +0100
@@ -37,10 +37,6 @@
 			unsigned char *dst, unsigned long *dst_len,
 			void *wrkmem);
 
-int lzo1x_decompress(const unsigned char *src, unsigned long src_len,
-			unsigned char *dst, unsigned long *dst_len,
-			void *wrkmem /* NOT USED */);
-
 /* safe decompression with overrun testing */
 int lzo1x_decompress_safe(const unsigned char *src, unsigned long src_len,
 			unsigned char *dst, unsigned long *dst_len,
Index: linux-2.6.22-rc2-mm1/lib/lzo/lzointf.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/lib/lzo/lzointf.c	2007-05-24 17:37:30.000000000 +0100
+++ linux-2.6.22-rc2-mm1/lib/lzo/lzointf.c	2007-05-24 17:42:33.000000000 +0100
@@ -29,7 +29,6 @@
 
 EXPORT_SYMBOL_GPL(lzo_copyright);
 EXPORT_SYMBOL_GPL(lzo1x_1_compress);
-EXPORT_SYMBOL_GPL(lzo1x_decompress);
 EXPORT_SYMBOL_GPL(lzo1x_decompress_safe);
 
 MODULE_LICENSE("GPL");
Index: linux-2.6.22-rc2-mm1/lib/lzo/minilzo.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/lib/lzo/minilzo.c	2007-05-24 17:37:30.000000000 +0100
+++ linux-2.6.22-rc2-mm1/lib/lzo/minilzo.c	2007-05-24 17:42:01.000000000 +0100
@@ -728,505 +728,6 @@
 #undef DO_COMPRESS
 #undef LZO_HASH
 
-#undef LZO_TEST_OVERRUN
-#undef DO_DECOMPRESS
-#define DO_DECOMPRESS       lzo1x_decompress
-
-#if !defined(MINILZO_CFG_SKIP_LZO1X_DECOMPRESS)
-
-#if defined(LZO_TEST_OVERRUN)
-#  if !defined(LZO_TEST_OVERRUN_INPUT)
-#    define LZO_TEST_OVERRUN_INPUT       2
-#  endif
-#  if !defined(LZO_TEST_OVERRUN_OUTPUT)
-#    define LZO_TEST_OVERRUN_OUTPUT      2
-#  endif
-#  if !defined(LZO_TEST_OVERRUN_LOOKBEHIND)
-#    define LZO_TEST_OVERRUN_LOOKBEHIND
-#  endif
-#endif
-
-#undef TEST_IP
-#undef TEST_OP
-#undef TEST_LB
-#undef TEST_LBO
-#undef NEED_IP
-#undef NEED_OP
-#undef HAVE_TEST_IP
-#undef HAVE_TEST_OP
-#undef HAVE_NEED_IP
-#undef HAVE_NEED_OP
-#undef HAVE_ANY_IP
-#undef HAVE_ANY_OP
-
-#if defined(LZO_TEST_OVERRUN_INPUT)
-#  if (LZO_TEST_OVERRUN_INPUT >= 1)
-#    define TEST_IP             (ip < ip_end)
-#  endif
-#  if (LZO_TEST_OVERRUN_INPUT >= 2)
-#    define NEED_IP(x) \
-            if ((lzo_uint)(ip_end - ip) < (lzo_uint)(x))  goto input_overrun
-#  endif
-#endif
-
-#if defined(LZO_TEST_OVERRUN_OUTPUT)
-#  if (LZO_TEST_OVERRUN_OUTPUT >= 1)
-#    define TEST_OP             (op <= op_end)
-#  endif
-#  if (LZO_TEST_OVERRUN_OUTPUT >= 2)
-#    undef TEST_OP
-#    define NEED_OP(x) \
-            if ((lzo_uint)(op_end - op) < (lzo_uint)(x))  goto output_overrun
-#  endif
-#endif
-
-#if defined(LZO_TEST_OVERRUN_LOOKBEHIND)
-#  define TEST_LB(m_pos)        if (m_pos < out || m_pos >= op) goto lookbehind_overrun
-#  define TEST_LBO(m_pos,o)     if (m_pos < out || m_pos >= op - (o)) goto lookbehind_overrun
-#else
-#  define TEST_LB(m_pos)        ((void) 0)
-#  define TEST_LBO(m_pos,o)     ((void) 0)
-#endif
-
-#if !defined(LZO_EOF_CODE) && !defined(TEST_IP)
-#  define TEST_IP               (ip < ip_end)
-#endif
-
-#if defined(TEST_IP)
-#  define HAVE_TEST_IP
-#else
-#  define TEST_IP               1
-#endif
-#if defined(TEST_OP)
-#  define HAVE_TEST_OP
-#else
-#  define TEST_OP               1
-#endif
-
-#if defined(NEED_IP)
-#  define HAVE_NEED_IP
-#else
-#  define NEED_IP(x)            ((void) 0)
-#endif
-#if defined(NEED_OP)
-#  define HAVE_NEED_OP
-#else
-#  define NEED_OP(x)            ((void) 0)
-#endif
-
-#if defined(HAVE_TEST_IP) || defined(HAVE_NEED_IP)
-#  define HAVE_ANY_IP
-#endif
-#if defined(HAVE_TEST_OP) || defined(HAVE_NEED_OP)
-#  define HAVE_ANY_OP
-#endif
-
-#undef __COPY4
-#define __COPY4(dst,src)    * (lzo_uint32p)(dst) = * (const lzo_uint32p)(src)
-
-#undef COPY4
-#if defined(LZO_UNALIGNED_OK_4)
-#  define COPY4(dst,src)    __COPY4(dst,src)
-#elif defined(LZO_ALIGNED_OK_4)
-#  define COPY4(dst,src)    __COPY4((lzo_uintptr_t)(dst),(lzo_uintptr_t)(src))
-#endif
-
-#if defined(DO_DECOMPRESS)
-LZO_PUBLIC(int)
-DO_DECOMPRESS  ( const lzo_bytep in , lzo_uint  in_len,
-                       lzo_bytep out, lzo_uintp out_len,
-                       lzo_voidp wrkmem )
-#endif
-{
-    register lzo_bytep op;
-    register const lzo_bytep ip;
-    register lzo_uint t;
-#if defined(COPY_DICT)
-    lzo_uint m_off;
-    const lzo_bytep dict_end;
-#else
-    register const lzo_bytep m_pos;
-#endif
-
-    const lzo_bytep const ip_end = in + in_len;
-#if defined(HAVE_ANY_OP)
-    lzo_bytep const op_end = out + *out_len;
-#endif
-#if defined(LZO1Z)
-    lzo_uint last_m_off = 0;
-#endif
-
-    LZO_UNUSED(wrkmem);
-
-#if defined(COPY_DICT)
-    if (dict)
-    {
-        if (dict_len > M4_MAX_OFFSET)
-        {
-            dict += dict_len - M4_MAX_OFFSET;
-            dict_len = M4_MAX_OFFSET;
-        }
-        dict_end = dict + dict_len;
-    }
-    else
-    {
-        dict_len = 0;
-        dict_end = NULL;
-    }
-#endif
-
-    *out_len = 0;
-
-    op = out;
-    ip = in;
-
-    if (*ip > 17)
-    {
-        t = *ip++ - 17;
-        if (t < 4)
-            goto match_next;
-        assert(t > 0); NEED_OP(t); NEED_IP(t+1);
-        do *op++ = *ip++; while (--t > 0);
-        goto first_literal_run;
-    }
-
-    while (TEST_IP && TEST_OP)
-    {
-        t = *ip++;
-        if (t >= 16)
-            goto match;
-        if (t == 0)
-        {
-            NEED_IP(1);
-	    // VF: BUG HERE
-            while (*ip == 0)
-            {
-                t += 255;
-                ip++;
-                NEED_IP(1);
-            }
-            t += 15 + *ip++;
-        }
-        assert(t > 0); NEED_OP(t+3); NEED_IP(t+4);
-#if defined(LZO_UNALIGNED_OK_4) || defined(LZO_ALIGNED_OK_4)
-#if !defined(LZO_UNALIGNED_OK_4)
-        if (PTR_ALIGNED2_4(op,ip))
-        {
-#endif
-        COPY4(op,ip);
-        op += 4; ip += 4;
-        if (--t > 0)
-        {
-            if (t >= 4)
-            {
-                do {
-                    COPY4(op,ip);
-                    op += 4; ip += 4; t -= 4;
-                } while (t >= 4);
-                if (t > 0) do *op++ = *ip++; while (--t > 0);
-            }
-            else
-                do *op++ = *ip++; while (--t > 0);
-        }
-#if !defined(LZO_UNALIGNED_OK_4)
-        }
-        else
-#endif
-#endif
-#if !defined(LZO_UNALIGNED_OK_4)
-        {
-            *op++ = *ip++; *op++ = *ip++; *op++ = *ip++;
-            do *op++ = *ip++; while (--t > 0);
-        }
-#endif
-
-first_literal_run:
-
-        t = *ip++;
-        if (t >= 16)
-            goto match;
-#if defined(COPY_DICT)
-#if defined(LZO1Z)
-        m_off = (1 + M2_MAX_OFFSET) + (t << 6) + (*ip++ >> 2);
-        last_m_off = m_off;
-#else
-        m_off = (1 + M2_MAX_OFFSET) + (t >> 2) + (*ip++ << 2);
-#endif
-        NEED_OP(3);
-        t = 3; COPY_DICT(t,m_off)
-#else
-#if defined(LZO1Z)
-        t = (1 + M2_MAX_OFFSET) + (t << 6) + (*ip++ >> 2);
-        m_pos = op - t;
-        last_m_off = t;
-#else
-        m_pos = op - (1 + M2_MAX_OFFSET);
-        m_pos -= t >> 2;
-        m_pos -= *ip++ << 2;
-#endif
-        TEST_LB(m_pos); NEED_OP(3);
-        *op++ = *m_pos++; *op++ = *m_pos++; *op++ = *m_pos;
-#endif
-        goto match_done;
-
-        do {
-match:
-            if (t >= 64)
-            {
-#if defined(COPY_DICT)
-#if defined(LZO1X)
-                m_off = 1 + ((t >> 2) & 7) + (*ip++ << 3);
-                t = (t >> 5) - 1;
-#elif defined(LZO1Y)
-                m_off = 1 + ((t >> 2) & 3) + (*ip++ << 2);
-                t = (t >> 4) - 3;
-#elif defined(LZO1Z)
-                m_off = t & 0x1f;
-                if (m_off >= 0x1c)
-                    m_off = last_m_off;
-                else
-                {
-                    m_off = 1 + (m_off << 6) + (*ip++ >> 2);
-                    last_m_off = m_off;
-                }
-                t = (t >> 5) - 1;
-#endif
-#else
-#if defined(LZO1X)
-                m_pos = op - 1;
-                m_pos -= (t >> 2) & 7;
-                m_pos -= *ip++ << 3;
-                t = (t >> 5) - 1;
-#elif defined(LZO1Y)
-                m_pos = op - 1;
-                m_pos -= (t >> 2) & 3;
-                m_pos -= *ip++ << 2;
-                t = (t >> 4) - 3;
-#elif defined(LZO1Z)
-                {
-                    lzo_uint off = t & 0x1f;
-                    m_pos = op;
-                    if (off >= 0x1c)
-                    {
-                        assert(last_m_off > 0);
-                        m_pos -= last_m_off;
-                    }
-                    else
-                    {
-                        off = 1 + (off << 6) + (*ip++ >> 2);
-                        m_pos -= off;
-                        last_m_off = off;
-                    }
-                }
-                t = (t >> 5) - 1;
-#endif
-                TEST_LB(m_pos); assert(t > 0); NEED_OP(t+3-1);
-                goto copy_match;
-#endif
-            }
-            else if (t >= 32)
-            {
-                t &= 31;
-                if (t == 0)
-                {
-                    NEED_IP(1);
-                    while (*ip == 0)
-                    {
-                        t += 255;
-                        ip++;
-                        NEED_IP(1);
-                    }
-                    t += 31 + *ip++;
-                }
-#if defined(COPY_DICT)
-#if defined(LZO1Z)
-                m_off = 1 + (ip[0] << 6) + (ip[1] >> 2);
-                last_m_off = m_off;
-#else
-                m_off = 1 + (ip[0] >> 2) + (ip[1] << 6);
-#endif
-#else
-#if defined(LZO1Z)
-                {
-                    lzo_uint off = 1 + (ip[0] << 6) + (ip[1] >> 2);
-                    m_pos = op - off;
-                    last_m_off = off;
-                }
-#elif defined(LZO_UNALIGNED_OK_2) && defined(LZO_ABI_LITTLE_ENDIAN)
-                m_pos = op - 1;
-                m_pos -= (* (const lzo_ushortp) ip) >> 2;
-#else
-                m_pos = op - 1;
-                m_pos -= (ip[0] >> 2) + (ip[1] << 6);
-#endif
-#endif
-                ip += 2;
-            }
-            else if (t >= 16)
-            {
-#if defined(COPY_DICT)
-                m_off = (t & 8) << 11;
-#else
-                m_pos = op;
-                m_pos -= (t & 8) << 11;
-#endif
-                t &= 7;
-                if (t == 0)
-                {
-                    NEED_IP(1);
-                    while (*ip == 0)
-                    {
-                        t += 255;
-                        ip++;
-                        NEED_IP(1);
-                    }
-                    t += 7 + *ip++;
-                }
-#if defined(COPY_DICT)
-#if defined(LZO1Z)
-                m_off += (ip[0] << 6) + (ip[1] >> 2);
-#else
-                m_off += (ip[0] >> 2) + (ip[1] << 6);
-#endif
-                ip += 2;
-                if (m_off == 0)
-                    goto eof_found;
-                m_off += 0x4000;
-#if defined(LZO1Z)
-                last_m_off = m_off;
-#endif
-#else
-#if defined(LZO1Z)
-                m_pos -= (ip[0] << 6) + (ip[1] >> 2);
-#elif defined(LZO_UNALIGNED_OK_2) && defined(LZO_ABI_LITTLE_ENDIAN)
-                m_pos -= (* (const lzo_ushortp) ip) >> 2;
-#else
-                m_pos -= (ip[0] >> 2) + (ip[1] << 6);
-#endif
-                ip += 2;
-                if (m_pos == op)
-                    goto eof_found;
-                m_pos -= 0x4000;
-#if defined(LZO1Z)
-                last_m_off = pd((const lzo_bytep)op, m_pos);
-#endif
-#endif
-            }
-            else
-            {
-#if defined(COPY_DICT)
-#if defined(LZO1Z)
-                m_off = 1 + (t << 6) + (*ip++ >> 2);
-                last_m_off = m_off;
-#else
-                m_off = 1 + (t >> 2) + (*ip++ << 2);
-#endif
-                NEED_OP(2);
-                t = 2; COPY_DICT(t,m_off)
-#else
-#if defined(LZO1Z)
-                t = 1 + (t << 6) + (*ip++ >> 2);
-                m_pos = op - t;
-                last_m_off = t;
-#else
-                m_pos = op - 1;
-                m_pos -= t >> 2;
-                m_pos -= *ip++ << 2;
-#endif
-                TEST_LB(m_pos); NEED_OP(2);
-                *op++ = *m_pos++; *op++ = *m_pos;
-#endif
-                goto match_done;
-            }
-
-#if defined(COPY_DICT)
-
-            NEED_OP(t+3-1);
-            t += 3-1; COPY_DICT(t,m_off)
-
-#else
-
-            TEST_LB(m_pos); assert(t > 0); NEED_OP(t+3-1);
-#if defined(LZO_UNALIGNED_OK_4) || defined(LZO_ALIGNED_OK_4)
-#if !defined(LZO_UNALIGNED_OK_4)
-            if (t >= 2 * 4 - (3 - 1) && PTR_ALIGNED2_4(op,m_pos))
-            {
-                assert((op - m_pos) >= 4);
-#else
-            if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4)
-            {
-#endif
-                COPY4(op,m_pos);
-                op += 4; m_pos += 4; t -= 4 - (3 - 1);
-                do {
-                    COPY4(op,m_pos);
-                    op += 4; m_pos += 4; t -= 4;
-                } while (t >= 4);
-                if (t > 0) do *op++ = *m_pos++; while (--t > 0);
-            }
-            else
-#endif
-            {
-copy_match:
-                *op++ = *m_pos++; *op++ = *m_pos++;
-                do *op++ = *m_pos++; while (--t > 0);
-            }
-
-#endif
-
-match_done:
-#if defined(LZO1Z)
-            t = ip[-1] & 3;
-#else
-            t = ip[-2] & 3;
-#endif
-            if (t == 0)
-                break;
-
-match_next:
-            assert(t > 0); assert(t < 4); NEED_OP(t); NEED_IP(t+1);
-#if 0
-            do *op++ = *ip++; while (--t > 0);
-#else
-            *op++ = *ip++;
-            if (t > 1) { *op++ = *ip++; if (t > 2) { *op++ = *ip++; } }
-#endif
-            t = *ip++;
-        } while (TEST_IP && TEST_OP);
-    }
-
-#if defined(HAVE_TEST_IP) || defined(HAVE_TEST_OP)
-    *out_len = pd(op, out);
-    return LZO_E_EOF_NOT_FOUND;
-#endif
-
-eof_found:
-    assert(t == 1);
-    *out_len = pd(op, out);
-    return (ip == ip_end ? LZO_E_OK :
-           (ip < ip_end  ? LZO_E_INPUT_NOT_CONSUMED : LZO_E_INPUT_OVERRUN));
-
-#if defined(HAVE_NEED_IP)
-input_overrun:
-    *out_len = pd(op, out);
-    return LZO_E_INPUT_OVERRUN;
-#endif
-
-#if defined(HAVE_NEED_OP)
-output_overrun:
-    *out_len = pd(op, out);
-    return LZO_E_OUTPUT_OVERRUN;
-#endif
-
-#if defined(LZO_TEST_OVERRUN_LOOKBEHIND)
-lookbehind_overrun:
-    *out_len = pd(op, out);
-    return LZO_E_LOOKBEHIND_OVERRUN;
-#endif
-}
-
-#endif
-
 #define LZO_TEST_OVERRUN
 #undef DO_DECOMPRESS
 #define DO_DECOMPRESS       lzo1x_decompress_safe

--Apple-Mail-11--143745054
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed



--Apple-Mail-11--143745054--
