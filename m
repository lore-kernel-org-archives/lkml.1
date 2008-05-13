Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbYEMNYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbYEMNYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYEMNYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:24:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58231 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755897AbYEMNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:24:14 -0400
Message-Id: <1210685053.13437.1252892061@webmail.messagingengine.com>
X-Sasl-Enc: j/OZ41inK+ICsf6EcRiB6PLJKQq5qbBKmCjIhCWV1kqs 1210685053
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Nickolay Vinogradov" <nickolay@protei.ru>
Cc: linux-kernel@vger.kernel.org, "Russell King" <rmk@arm.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <481E076A.8060302@protei.ru>
   <1210677433.22341.1252875863@webmail.messagingengine.com>
   <48298990.7040705@protei.ru>
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
In-Reply-To: <48298990.7040705@protei.ru>
Date: Tue, 13 May 2008 15:24:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 16:29:04 +0400, "Nickolay Vinogradov"
<nickolay@protei.ru> said:
> Alexander van Heukelum &#1087;&#1080;&#1096;&#1077;&#1090;:
> 
> > Hi Nickolay,
> > 
> > The change is ok, I guess, but the cast should be a no-op (fls
> > takes an int, which is always 32 bit in linux). What is the problem
> > you are seeing? Does fls64() return a wrong value in some cases? If
> > so, what cpu? Which values?
> > 
> > Why would this be a bug on big endian systems only? There is no
> > pointer magic involved, so the compiler should take care of the
> > casts in a correct way.
> > 
> > Maybe you see a compiler warning? Which compiler version?
> > 
> > (also note that current (development) kernels now have separate
> > versions for 32-bit and 64-bit environments.)
> 
> Because fls() is a macro for asm-arm:
> 
> #define fls(x) \
>          ( __builtin_constant_p(x) ? constant_fls(x) : \
>          ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 
> 32-__r; }) )
> 
> We can fix it right here:
> 
> diff --git a/include/asm-arm/bitops.h b/include/asm-arm/bitops.h
> index 5c60bfc..ce3fb6f 100644
> --- a/include/asm-arm/bitops.h
> +++ b/include/asm-arm/bitops.h
> @@ -279,7 +279,7 @@ static inline int constant_fls(int x)
> 
>   #define fls(x) \
>          ( __builtin_constant_p(x) ? constant_fls(x) : \
> -         ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 
> 32-__r; }) )
> +         ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"((__u32)x) : 
> "cc"); 32-__r; }) )
>   #define ffs(x) ({ unsigned long __t = (x); fls(__t & -__t); })
>   #define __ffs(x) (ffs(x) - 1)
>   #define ffz(x) __ffs( ~(x) )

Hmm, indeed.

Maybe: ({ int __r, __x = (x); asm("clz\t%0, %1" : "=r"(__r) : "r"(__x) :
"cc"); 32-__r; }) ?

This is a 32-bit machine, right? Doesn't the compiler complain about
feeding a long long into a 32-bit register?

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - I mean, what is it about a decent email service?

