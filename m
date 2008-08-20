Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYHTRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYHTRzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYHTRzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:55:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:33865 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYHTRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HvLGoQRFaf9OfwN7Ho5q5s1LPp/wetT7c0fSCACanR8RaHOFmbgkqhF28x9SbzNb1J
         a1/P0FDMqOvgPC2ZEameLsHX1JuyR+tNwZ5ncXuetCLfKr8aI+QmBt/I/AKLIYscRk7e
         CnM82KbWp5ul2tyK+YmnP0pKIKoxSKPxz9Ai8=
Subject: Re: [PATCH 15/23] powerpc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <18602.9348.243840.223801@cargo.ozlabs.ibm.com>
References: <1219106893.17033.68.camel@brick>
	 <18602.9348.243840.223801@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 10:55:38 -0700
Message-Id: <1219254938.6115.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Paul, this preserves the ld_le16, ld_le32, st_le16, st_le32

The ld_* versions are synonyms for le16_to_cpup, le32_to_cpup, I can prepare
a drivers patch to move over to that if you wish.  The st_ versions are another
implementation of the aligned-byteswapping helpers that usb and others have as
well, perhaps once arches have moved to the new byteorder helpers, the storing
helpers can be consolidated there as well.

Thoughts?

 arch/powerpc/include/asm/byteorder.h |   43 ++++++++++++---------------------
 1 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/include/asm/byteorder.h b/arch/powerpc/include/asm/byteorder.h
index b377522..52a4802 100644
--- a/arch/powerpc/include/asm/byteorder.h
+++ b/arch/powerpc/include/asm/byteorder.h
@@ -11,36 +11,41 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
-#ifdef __KERNEL__
+#define __BIG_ENDIAN
 
-static __inline__ __u16 ld_le16(const volatile __u16 *addr)
+#ifndef __powerpc64__
+#define __SWAB_64_THRU_32__
+#endif /* __powerpc64__ */
+
+static inline __u16 __arch_swab16p(const volatile __u16 *addr)
 {
 	__u16 val;
 
 	__asm__ __volatile__ ("lhbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
 	return val;
 }
+#define __arch_swab16p __arch_swab16p
 
 static __inline__ void st_le16(volatile __u16 *addr, const __u16 val)
 {
 	__asm__ __volatile__ ("sthbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
 }
 
-static __inline__ __u32 ld_le32(const volatile __u32 *addr)
+static inline __u32 __arch_swab32p(const volatile __u32 *addr)
 {
 	__u32 val;
 
 	__asm__ __volatile__ ("lwbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
 	return val;
 }
+#define __arch_swab32p __arch_swab32p
 
 static __inline__ void st_le32(volatile __u32 *addr, const __u32 val)
 {
 	__asm__ __volatile__ ("stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
 }
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 value)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 value)
 {
 	__u16 result;
 
@@ -49,8 +54,9 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 value)
 	    : "r" (value), "0" (value >> 8));
 	return result;
 }
+#define __arch_swab16 __arch_swab16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 value)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 value)
 {
 	__u32 result;
 
@@ -61,29 +67,12 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 value)
 	    : "r" (value), "0" (value >> 24));
 	return result;
 }
-
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab32(x) ___arch__swab32(x)
+#define __arch_swab32 __arch_swab32
 
 /* The same, but returns converted value from the location pointer by addr. */
-#define __arch__swab16p(addr) ld_le16(addr)
-#define __arch__swab32p(addr) ld_le32(addr)
-
-/* The same, but do the conversion in situ, ie. put the value back to addr. */
-#define __arch__swab16s(addr) st_le16(addr,*addr)
-#define __arch__swab32s(addr) st_le32(addr,*addr)
-
-#endif /* __KERNEL__ */
-
-#ifndef __STRICT_ANSI__
-#define __BYTEORDER_HAS_U64__
-#ifndef __powerpc64__
-#define __SWAB_64_THRU_32__
-#endif /* __powerpc64__ */
-#endif /* __STRICT_ANSI__ */
-
-#endif /* __GNUC__ */
+#define ld_le16(addr) __arch_swab16p(addr)
+#define ld_le32(addr) __arch_swab32p(addr)
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_POWERPC_BYTEORDER_H */
-- 
1.6.0.284.ga408



