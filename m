Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYILUKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYILUKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYILUJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:09:55 -0400
Received: from smtp8-g19.free.fr ([212.27.42.65]:33787 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbYILUJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:09:55 -0400
Message-ID: <48CACC8F.4050806@free.fr>
Date: Fri, 12 Sep 2008 22:09:51 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080702 Iceape/1.1.11 (Debian-1.1.11-1)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Keith A. Prickett" <keithp@marvell.com>
Subject: re : Building Kernel with -O0
Content-Type: multipart/mixed;
 boundary="------------060906000101030207050901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060906000101030207050901
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

last time I check kernel build for x86 and arm with -O0, there was 
several issues.

First there some code that rely in function inline and code elimination, 
and cause usage of disable symbol at  -O0

#ifdef CONFIG_FOO
int foo()
{
}
static inline int toto()
{
}
#else
static inline int toto()
{
return 0
}
#endif

if (toto())
    foo();

This doesn't work even when using __always_inline (try to build attached 
undec.c at -O0).


Second, I saw problem with swab macro [1].
When using -O0, __OPTIMIZE__ is not defined, and constant initialisation 
of some code fails (I don't remeber exactly the case but removing the 
defined(__OPTIMIZE__) fix the issue).

Next for x86 there a driver with asm optimisation that fail to build 
because gcc fail to allocate register.

And finaly as Andi say there some code doing check if undefined symbol. 
For example slab index_of [2]

In the end I build the kernel at -O instead of -O0.

Matthieu

PS : I am not sure __always_inline always work at -O0...

[1]
#if defined(__GNUC__) && defined(__OPTIMIZE__)
#  define __swab16(x) \
(__builtin_constant_p((__u16)(x)) ? \
  ___constant_swab16((x)) : \
  __fswab16((x)))
#  define __swab32(x) \
(__builtin_constant_p((__u32)(x)) ? \
  ___constant_swab32((x)) : \
  __fswab32((x)))
#  define __swab64(x) \
(__builtin_constant_p((__u64)(x)) ? \
  ___constant_swab64((x)) : \
  __fswab64((x)))
#else
#  define __swab16(x) __fswab16(x)
#  define __swab32(x) __fswab32(x)
#  define __swab64(x) __fswab64(x)
#endif /* OPTIMIZE */

[2]
static __always_inline int index_of(const size_t size)
{
     extern void __bad_size(void);

     if (__builtin_constant_p(size)) {
         int i = 0;

#define CACHE(x) \
     if (size <=x) \
         return i; \
     else \
         i++;
#include <linux/kmalloc_sizes.h>
#undef CACHE
         __bad_size();
     } else
         __bad_size();
     return 0;
}

--------------060906000101030207050901
Content-Type: text/x-csrc;
 name="undec.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="undec.c"

static inline __attribute__((always_inline)) int foo()
{
	return 0;
}

int main()
{
	if (foo())
		bar();
}

--------------060906000101030207050901--
