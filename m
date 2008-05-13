Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbYEMMab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbYEMMab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbYEMMaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:30:15 -0400
Received: from ns2.protei.ru ([195.239.28.26]:51908 "EHLO mail.protei.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbYEMMaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:30:13 -0400
Message-ID: <48298990.7040705@protei.ru>
Date: Tue, 13 May 2008 16:29:04 +0400
From: Nickolay Vinogradov <nickolay@protei.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
References: <481E076A.8060302@protei.ru> <1210677433.22341.1252875863@webmail.messagingengine.com>
In-Reply-To: <1210677433.22341.1252875863@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum пишет:

> Hi Nickolay,
> 
> The change is ok, I guess, but the cast should be a no-op (fls
> takes an int, which is always 32 bit in linux). What is the problem
> you are seeing? Does fls64() return a wrong value in some cases? If
> so, what cpu? Which values?
> 
> Why would this be a bug on big endian systems only? There is no
> pointer magic involved, so the compiler should take care of the
> casts in a correct way.
> 
> Maybe you see a compiler warning? Which compiler version?
> 
> (also note that current (development) kernels now have separate
> versions for 32-bit and 64-bit environments.)

Because fls() is a macro for asm-arm:

#define fls(x) \
         ( __builtin_constant_p(x) ? constant_fls(x) : \
         ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 
32-__r; }) )

We can fix it right here:

diff --git a/include/asm-arm/bitops.h b/include/asm-arm/bitops.h
index 5c60bfc..ce3fb6f 100644
--- a/include/asm-arm/bitops.h
+++ b/include/asm-arm/bitops.h
@@ -279,7 +279,7 @@ static inline int constant_fls(int x)

  #define fls(x) \
         ( __builtin_constant_p(x) ? constant_fls(x) : \
-         ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 
32-__r; }) )
+         ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"((__u32)x) : 
"cc"); 32-__r; }) )
  #define ffs(x) ({ unsigned long __t = (x); fls(__t & -__t); })
  #define __ffs(x) (ffs(x) - 1)
  #define ffz(x) __ffs( ~(x) )


-- 
Nickolay Vinogradov
Protei Research and Development Center
St.Petersburg, 194044, Russia
Tel.: +7 812 449 47 27
