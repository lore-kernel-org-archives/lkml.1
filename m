Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYLCXi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYLCXi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYLCXiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:38:46 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:61062 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYLCXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:38:45 -0500
Message-ID: <49371848.2080804@oracle.com>
Date: Wed, 03 Dec 2008 15:37:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Yet more ARM breakage in linux-next
References: <20081203192905.GA12502@flint.arm.linux.org.uk> <20081203124109.79f8f15b.akpm@linux-foundation.org> <200812040952.44957.rusty@rustcorp.com.au>
In-Reply-To: <200812040952.44957.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4937184C.0085:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 04 December 2008 07:11:09 Andrew Morton wrote:
>> On Wed, 3 Dec 2008 19:29:05 +0000
>>
>> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
>>> This seems to be causing lots of ARM breakage:
>>>
>>> lib/find_next_bit.c:183: error: implicit declaration of function '__fls'
>>>
>>> Whoever's responsible,
>> git-blame?
> 
> It's me.  Turns out sparc, avr32 and arm all don't define __fls in their
> asm/bitops.h, and I'm the first one to use it in generic code.
> 
> But as I prepared this patch, I note that the armv5 __fls/fls is wrong:
> 
>   /* Implement fls() in C so that 64-bit args are suitably truncated */
>   static inline int fls(int x)
>   {
>       return __fls(x);
>   }
> 
> __fls(x) returns a bit number (0-31).  fls() returns 0 or bitnumber+1.
> 
> (Yes, classic useless kerneldoc documentation doesn't actually *say* 
> this clearly).
 
oh fud.  That's not a fault of kernel-doc, just of whoever wrote it.
It's only as good as someone makes it.


> But here's the linux-next fix:
> 
> arm: define __fls for pre v5 ARM
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
> --- a/arch/arm/include/asm/bitops.h
> +++ b/arch/arm/include/asm/bitops.h
> @@ -239,6 +239,7 @@ extern int _find_next_bit_be(const unsig
>  #include <asm-generic/bitops/ffz.h>
>  #include <asm-generic/bitops/__ffs.h>
>  #include <asm-generic/bitops/fls.h>
> +#include <asm-generic/bitops/__fls.h>
>  #include <asm-generic/bitops/ffs.h>
>  
>  #else

