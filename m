Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYH2Oyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYH2Oyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYH2Oy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:54:26 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34816 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750847AbYH2OyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:54:25 -0400
Date: Fri, 29 Aug 2008 16:54:23 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>
Subject: endianness and sparse warnings
Message-ID: <Pine.LNX.4.64.0808291639540.15307@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-970963371-1220021663=:15307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-970963371-1220021663=:15307
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

With `make  C=1 CF="-D__CHECK_ENDIAN__"', you can let sparse check for bad
handling of endian-annotated data.

Unfortunately several of the accessors for endian-annotated data do not cause
sparse warnings.

Summarized:
  - [bl]e{16,32,64}_to_cpu() is OK
  - [bl]e{16,32,64}_to_cpup() (aka get_aligned_[bl]e{16,32,64}() ;-) is OK
  - get_unaligned_[bl]e{16,32,64} is not OK
  - __get_unaligned_[bl]e() is partially OK, as long as you don't use it on
    non-annotated data, but
      o it's meant for internal use only
      o it incorrectly causes sparse warnings when assigning the resulting
        value to a non-annotated variable
 
To check it for yourself, plug in the code below into any kernel source file.
 
#include <asm/unaligned.h>

__u8 d8;
__u16 d16;
__u32 d32;
__u64 d64;

__be16 be16;
__be32 be32;
__be64 be64;

__le16 le16;
__le32 le32;
__le64 le64;

char dr[16];

#define get_aligned_be16	be16_to_cpup
#define get_aligned_be32	be32_to_cpup
#define get_aligned_be64	be64_to_cpup
#define get_aligned_le16	le16_to_cpup
#define get_aligned_le32	le32_to_cpup
#define get_aligned_le64	le64_to_cpup

int test(void)
{
	u64 x = 0;

	x ^= d8;

// ----------------------------------------------------------------------------

	x ^= d16;			/* OK */
	x ^= d32;			/* OK */
	x ^= d64;			/* OK */
	x ^= be16;			/* sparse warning */
	x ^= be32;			/* sparse warning */
	x ^= be64;			/* sparse warning */
	x ^= le16;			/* sparse warning */
	x ^= le32;			/* sparse warning */
	x ^= le64;			/* sparse warning */

// ----------------------------------------------------------------------------

	x ^= be16_to_cpu(d16);		/* sparse warning */
	x ^= be16_to_cpu(d32);		/* sparse warning */
	x ^= be16_to_cpu(d64);		/* sparse warning */
	x ^= be16_to_cpu(be16);		/* OK */
	x ^= be16_to_cpu(be32);		/* sparse warning */
	x ^= be16_to_cpu(be64);		/* sparse warning */
	x ^= be16_to_cpu(le16);		/* sparse warning */
	x ^= be16_to_cpu(le32);		/* sparse warning */
	x ^= be16_to_cpu(le64);		/* sparse warning */

	x ^= be32_to_cpu(d16);		/* sparse warning */
	x ^= be32_to_cpu(d32);		/* sparse warning */
	x ^= be32_to_cpu(d64);		/* sparse warning */
	x ^= be32_to_cpu(be16);		/* sparse warning */
	x ^= be32_to_cpu(be32);		/* OK */
	x ^= be32_to_cpu(be64);		/* sparse warning */
	x ^= be32_to_cpu(le16);		/* sparse warning */
	x ^= be32_to_cpu(le32);		/* sparse warning */
	x ^= be32_to_cpu(le64);		/* sparse warning */

	x ^= be64_to_cpu(d16);		/* sparse warning */
	x ^= be64_to_cpu(d32);		/* sparse warning */
	x ^= be64_to_cpu(d64);		/* sparse warning */
	x ^= be64_to_cpu(be16);		/* sparse warning */
	x ^= be64_to_cpu(be32);		/* sparse warning */
	x ^= be64_to_cpu(be64);		/* OK */
	x ^= be64_to_cpu(le16);		/* sparse warning */
	x ^= be64_to_cpu(le32);		/* sparse warning */
	x ^= be64_to_cpu(le64);		/* sparse warning */

	x ^= le16_to_cpu(d16);		/* sparse warning */
	x ^= le16_to_cpu(d32);		/* sparse warning */
	x ^= le16_to_cpu(d64);		/* sparse warning */
	x ^= le16_to_cpu(be16);		/* sparse warning */
	x ^= le16_to_cpu(be32);		/* sparse warning */
	x ^= le16_to_cpu(be64);		/* sparse warning */
	x ^= le16_to_cpu(le16);		/* OK */
	x ^= le16_to_cpu(le32);		/* sparse warning */
	x ^= le16_to_cpu(le64);		/* sparse warning */

	x ^= le32_to_cpu(d16);		/* sparse warning */
	x ^= le32_to_cpu(d32);		/* sparse warning */
	x ^= le32_to_cpu(d64);		/* sparse warning */
	x ^= le32_to_cpu(be16);		/* sparse warning */
	x ^= le32_to_cpu(be32);		/* sparse warning */
	x ^= le32_to_cpu(be64);		/* sparse warning */
	x ^= le32_to_cpu(le16);		/* sparse warning */
	x ^= le32_to_cpu(le32);		/* OK */
	x ^= le32_to_cpu(le64);		/* sparse warning */

	x ^= le64_to_cpu(d16);		/* sparse warning */
	x ^= le64_to_cpu(d32);		/* sparse warning */
	x ^= le64_to_cpu(d64);		/* sparse warning */
	x ^= le64_to_cpu(be16);		/* sparse warning */
	x ^= le64_to_cpu(be32);		/* sparse warning */
	x ^= le64_to_cpu(be64);		/* sparse warning */
	x ^= le64_to_cpu(le16);		/* sparse warning */
	x ^= le64_to_cpu(le32);		/* sparse warning */
	x ^= le64_to_cpu(le64);		/* OK */

// ----------------------------------------------------------------------------

	x ^= get_unaligned_be16(&d16);		/* NO WARNING!! */
	x ^= get_unaligned_be16(&d32);		/* NO WARNING!! */
	x ^= get_unaligned_be16(&d64);		/* NO WARNING!! */
	x ^= get_unaligned_be16(&be16);		/* OK */
	x ^= get_unaligned_be16(&be32);		/* NO WARNING!! */
	x ^= get_unaligned_be16(&be64);		/* NO WARNING!! */
	x ^= get_unaligned_be16(&le16);		/* NO WARNING!! */
	x ^= get_unaligned_be16(&le32);		/* NO WARNING!! */
	x ^= get_unaligned_be16(&le64);		/* NO WARNING!! */
	x ^= get_unaligned_be16(&dr[1]);	/* OK */

	x ^= get_unaligned_be32(&d16);		/* NO WARNING!! */
	x ^= get_unaligned_be32(&d32);		/* NO WARNING!! */
	x ^= get_unaligned_be32(&d64);		/* NO WARNING!! */
	x ^= get_unaligned_be32(&be16);		/* NO WARNING!! */
	x ^= get_unaligned_be32(&be32);		/* OK */
	x ^= get_unaligned_be32(&be64);		/* NO WARNING!! */
	x ^= get_unaligned_be32(&le16);		/* NO WARNING!! */
	x ^= get_unaligned_be32(&le32);		/* NO WARNING!! */
	x ^= get_unaligned_be32(&le64);		/* NO WARNING!! */
	x ^= get_unaligned_be32(&dr[1]);	/* OK */

	x ^= get_unaligned_be64(&d16);		/* NO WARNING!! */
	x ^= get_unaligned_be64(&d32);		/* NO WARNING!! */
	x ^= get_unaligned_be64(&d64);		/* NO WARNING!! */
	x ^= get_unaligned_be64(&be16);		/* NO WARNING!! */
	x ^= get_unaligned_be64(&be32);		/* NO WARNING!! */
	x ^= get_unaligned_be64(&be64);		/* OK */
	x ^= get_unaligned_be64(&le16);		/* NO WARNING!! */
	x ^= get_unaligned_be64(&le32);		/* NO WARNING!! */
	x ^= get_unaligned_be64(&le64);		/* NO WARNING!! */
	x ^= get_unaligned_be64(&dr[1]);	/* OK */

	x ^= get_unaligned_le16(&d16);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&d32);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&d64);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&be16);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&be32);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&be64);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&le16);		/* OK */
	x ^= get_unaligned_le16(&le32);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&le64);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&dr[1]);	/* OK */

	x ^= get_unaligned_le32(&d16);		/* NO WARNING!! */
	x ^= get_unaligned_le32(&d32);		/* NO WARNING!! */
	x ^= get_unaligned_le32(&d64);		/* NO WARNING!! */
	x ^= get_unaligned_le32(&be16);		/* NO WARNING!! */
	x ^= get_unaligned_le32(&be32);		/* NO WARNING!! */
	x ^= get_unaligned_le32(&be64);		/* NO WARNING!! */
	x ^= get_unaligned_le32(&le16);		/* NO WARNING!! */
	x ^= get_unaligned_le32(&le32);		/* OK */
	x ^= get_unaligned_le32(&le64);		/* NO WARNING!! */
	x ^= get_unaligned_le16(&dr[1]);	/* OK */

	x ^= get_unaligned_le64(&d16);		/* NO WARNING!! */
	x ^= get_unaligned_le64(&d32);		/* NO WARNING!! */
	x ^= get_unaligned_le64(&d64);		/* NO WARNING!! */
	x ^= get_unaligned_le64(&be16);		/* NO WARNING!! */
	x ^= get_unaligned_le64(&be32);		/* NO WARNING!! */
	x ^= get_unaligned_le64(&be64);		/* NO WARNING!! */
	x ^= get_unaligned_le64(&le16);		/* NO WARNING!! */
	x ^= get_unaligned_le64(&le32);		/* NO WARNING!! */
	x ^= get_unaligned_le64(&le64);		/* OK */
	x ^= get_unaligned_le16(&dr[1]);	/* OK */

// ----------------------------------------------------------------------------

	x ^= get_unaligned(&d16);		/* OK */
	x ^= get_unaligned(&d32);		/* OK */
	x ^= get_unaligned(&d64);		/* OK */
	x ^= get_unaligned(&be16);		/* sparse warning */
	x ^= get_unaligned(&be32);		/* sparse warning */
	x ^= get_unaligned(&be64);		/* sparse warning */
	x ^= get_unaligned(&le16);		/* sparse warning */
	x ^= get_unaligned(&le32);		/* sparse warning */
	x ^= get_unaligned(&le64);		/* sparse warning */
	x ^= get_unaligned(&dr[1]);		/* OK */

	x ^= __get_unaligned_be(&d16);		/* NO WARNING!! */
	x ^= __get_unaligned_be(&d32);		/* NO WARNING!! */
	x ^= __get_unaligned_be(&d64);		/* NO WARNING!! */
	x ^= __get_unaligned_be(&be16);		/* sparse warning */
	x ^= __get_unaligned_be(&be32);		/* sparse warning */
	x ^= __get_unaligned_be(&be64);		/* sparse warning */
	x ^= __get_unaligned_be(&le16);		/* sparse warning */
	x ^= __get_unaligned_be(&le32);		/* sparse warning */
	x ^= __get_unaligned_be(&le64);		/* sparse warning */
	x ^= __get_unaligned_be(&dr[1]);	/* NO WARNING!! */

	x ^= __get_unaligned_le(&d16);		/* NO WARNING!! */
	x ^= __get_unaligned_le(&d32);		/* NO WARNING!! */
	x ^= __get_unaligned_le(&d64);		/* NO WARNING!! */
	x ^= __get_unaligned_le(&be16);		/* sparse warning */
	x ^= __get_unaligned_le(&be32);		/* sparse warning */
	x ^= __get_unaligned_le(&be64);		/* sparse warning */
	x ^= __get_unaligned_le(&le16);		/* sparse warning */
	x ^= __get_unaligned_le(&le32);		/* sparse warning */
	x ^= __get_unaligned_le(&le64);		/* sparse warning */
	x ^= __get_unaligned_le(&dr[1]);	/* NO WARNING!! */

// ----------------------------------------------------------------------------

	x ^= get_aligned_be16(&d16);		/* sparse warning */
	x ^= get_aligned_be16(&d32);		/* gcc/sparse warning */
	x ^= get_aligned_be16(&d64);		/* gcc/sparse warning */
	x ^= get_aligned_be16(&be16);		/* OK */
	x ^= get_aligned_be16(&be32);		/* gcc/sparse warning */
	x ^= get_aligned_be16(&be64);		/* gcc/sparse warning */
	x ^= get_aligned_be16(&le16);		/* sparse warning */
	x ^= get_aligned_be16(&le32);		/* gcc/sparse warning */
	x ^= get_aligned_be16(&le64);		/* gcc/sparse warning */
	x ^= get_aligned_be16(&dr[1]);		/* gcc/sparse warning */

	x ^= get_aligned_be32(&d16);		/* gcc/sparse warning */
	x ^= get_aligned_be32(&d32);		/* sparse warning */
	x ^= get_aligned_be32(&d64);		/* gcc/sparse warning */
	x ^= get_aligned_be32(&be16);		/* gcc/sparse warning */
	x ^= get_aligned_be32(&be32);		/* OK */
	x ^= get_aligned_be32(&be64);		/* gcc/sparse warning */
	x ^= get_aligned_be32(&le16);		/* gcc/sparse warning */
	x ^= get_aligned_be32(&le32);		/* sparse warning */
	x ^= get_aligned_be32(&le64);		/* gcc/sparse warning */
	x ^= get_aligned_be32(&dr[1]);		/* gcc/sparse warning */

	x ^= get_aligned_be64(&d16);		/* gcc/sparse warning */
	x ^= get_aligned_be64(&d32);		/* gcc/sparse warning */
	x ^= get_aligned_be64(&d64);		/* sparse warning */
	x ^= get_aligned_be64(&be16);		/* gcc/sparse warning */
	x ^= get_aligned_be64(&be32);		/* gcc/sparse warning */
	x ^= get_aligned_be64(&be64);		/* OK */
	x ^= get_aligned_be64(&le16);		/* gcc/sparse warning */
	x ^= get_aligned_be64(&le32);		/* gcc/sparse warning */
	x ^= get_aligned_be64(&le64);		/* sparse warning */
	x ^= get_aligned_be64(&dr[1]);		/* gcc/sparse warning */

	x ^= get_aligned_le16(&d16);		/* sparse warning */
	x ^= get_aligned_le16(&d32);		/* gcc/sparse warning */
	x ^= get_aligned_le16(&d64);		/* gcc/sparse warning */
	x ^= get_aligned_le16(&be16);		/* sparse warning */
	x ^= get_aligned_le16(&be32);		/* gcc/sparse warning */
	x ^= get_aligned_le16(&be64);		/* gcc/sparse warning */
	x ^= get_aligned_le16(&le16);		/* OK */
	x ^= get_aligned_le16(&le32);		/* gcc/sparse warning */
	x ^= get_aligned_le16(&le64);		/* gcc/sparse warning */
	x ^= get_aligned_le16(&dr[1]);		/* gcc/sparse warning */

	x ^= get_aligned_le32(&d16);		/* gcc/sparse warning */
	x ^= get_aligned_le32(&d32);		/* sparse warning */
	x ^= get_aligned_le32(&d64);		/* gcc/sparse warning */
	x ^= get_aligned_le32(&be16);		/* gcc/sparse warning */
	x ^= get_aligned_le32(&be32);		/* sparse warning */
	x ^= get_aligned_le32(&be64);		/* gcc/sparse warning */
	x ^= get_aligned_le32(&le16);		/* gcc/sparse warning */
	x ^= get_aligned_le32(&le32);		/* OK */
	x ^= get_aligned_le32(&le64);		/* gcc/sparse warning */
	x ^= get_aligned_le16(&dr[1]);		/* gcc/sparse warning */

	x ^= get_aligned_le64(&d16);		/* gcc/sparse warning */
	x ^= get_aligned_le64(&d32);		/* gcc/sparse warning */
	x ^= get_aligned_le64(&d64);		/* sparse warning */
	x ^= get_aligned_le64(&be16);		/* gcc/sparse warning */
	x ^= get_aligned_le64(&be32);		/* gcc/sparse warning */
	x ^= get_aligned_le64(&be64);		/* sparse warning */
	x ^= get_aligned_le64(&le16);		/* gcc/sparse warning */
	x ^= get_aligned_le64(&le32);		/* gcc/sparse warning */
	x ^= get_aligned_le64(&le64);		/* OK */
	x ^= get_aligned_le16(&dr[1]);		/* gcc/sparse warning */

// ----------------------------------------------------------------------------

	return x;
}

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-970963371-1220021663=:15307--
