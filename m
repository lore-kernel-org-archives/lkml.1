Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbYHSTCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbYHSTCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYHSTCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:02:06 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:13492 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbYHSTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QVNKQJlW9smBIuNzQNv/LV3RosbNE2JrAxjJu6fLgKEZ3SLQo1cmaFZOqIvwSV6cH1
         9fn+RQ/l1qPpfrZuXzAKaLMdH/Mrl417dq0wWNPy0Ptqcr8jCr5se20ALZzU74KHFLlS
         2tRpcV6YI/i/iPb1AX8Egsy/avtGs0fbqB28g=
Subject: Re: [PATCH 18/23] sparc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080819.014350.79505195.davem@davemloft.net>
References: <1219106897.17033.71.camel@brick>
	 <20080819.014350.79505195.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 12:02:00 -0700
Message-Id: <1219172520.17033.85.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 01:43 -0700, David Miller wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Mon, 18 Aug 2008 17:48:17 -0700
> 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> I'm not so sure about this.
> 
> If I understand the ___swab*() inlines in linux/swab.h,
> it has the following priority of swapping methods:
> 
> 1) If arch defines __arch_swab*(), this is used.
> 
> 2) If arch defines __arch_swab*p(), variable is popped onto
>    the stack and we do the pointer based operation.

2a) If defined(__SWAB_64_THRU_32__) swab64 uses swab32 internally.

> 
> 3) Else normal C version is used.
> 

Your above understanding is correct.

> Case #2 is totally disagree with.
> 
> Especially for small swaps such as 16-bit the inline expansion
> of the portable C code is going to be much better than popping
> the variable onto and then back off the stack.
> 

I thought gcc wasn't too bad for this case these days for attribute_const
inlines?  But without evidence to back it up, you're right that the
generic C version should just be used if an arch hasn't provided an
override.

> Sparc 64-bit only provides the __arch_swab*p() routines so
> #2 is what will in fact be used here.
> 
> So NACK based upon that analysis.

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] byteorder: use generic C version for value byteswapping

David Miller noted that popping the variable on and back off the stack
will probably be more expensive than just using the generic C byteswapping
code.  Remove the fallback to the swap-from-pointer helper when no
arch override for the value byteswap has been defined.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/swab.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/include/linux/swab.h b/include/linux/swab.h
index 270d5c2..bbed279 100644
--- a/include/linux/swab.h
+++ b/include/linux/swab.h
@@ -47,8 +47,6 @@ static inline __attribute_const__ __u16 ___swab16(__u16 val)
 {
 #ifdef __arch_swab16
 	return __arch_swab16(val);
-#elif defined(__arch_swab16p)
-	return __arch_swab16p(&val);
 #else
 	return __const_swab16(val);
 #endif
@@ -58,8 +56,6 @@ static inline __attribute_const__ __u32 ___swab32(__u32 val)
 {
 #ifdef __arch_swab32
 	return __arch_swab32(val);
-#elif defined(__arch_swab32p)
-	return __arch_swab32p(&val);
 #else
 	return __const_swab32(val);
 #endif
@@ -69,8 +65,6 @@ static inline __attribute_const__ __u64 ___swab64(__u64 val)
 {
 #ifdef __arch_swab64
 	return __arch_swab64(val);
-#elif defined(__arch_swab64p)
-	return __arch_swab64p(&val);
 #elif defined(__SWAB_64_THRU_32__)
 	__u32 h = val >> 32;
 	__u32 l = val & ((1ULL << 32) - 1);
@@ -84,8 +78,6 @@ static inline __attribute_const__ __u32 ___swahw32(__u32 val)
 {
 #ifdef __arch_swahw32
 	return __arch_swahw32(val);
-#elif defined(__arch_swahw32p)
-	return __arch_swahw32p(&val);
 #else
 	return __const_swahw32(val);
 #endif
@@ -95,8 +87,6 @@ static inline __attribute_const__ __u32 ___swahb32(__u32 val)
 {
 #ifdef __arch_swahb32
 	return __arch_swahb32(val);
-#elif defined(__arch_swahb32p)
-	return __arch_swahb32p(&val);
 #else
 	return __const_swahb32(val);
 #endif
-- 
1.6.0.274.g8aacc



