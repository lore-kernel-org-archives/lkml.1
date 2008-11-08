Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYKHDAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYKHDAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKHDAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:00:35 -0500
Received: from hq2.tensilica.com ([65.205.227.30]:50206 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751790AbYKHDAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:00:34 -0500
Message-ID: <491500C0.90407@tensilica.com>
Date: Fri, 07 Nov 2008 19:00:16 -0800
From: Piet Delaney <piet.delaney@tensilica.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Chris Zankel <chris@zankel.net>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Marc Gauthier <marc@tensilica.com>,
       Joe Taylor <joetayloremail@gmail.com>, linux-xtensa@linux-xtensa.org,
       Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 10/10] xtensa: use the new byteorder headers - Merged
 with your previous xtensa-next and will remerge shortly.
References: <1225910131.5991.230.camel@brick> <49133094.6070407@zankel.net>
In-Reply-To: <49133094.6070407@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris:

   I've merged your recent xtensa-next with our 2.6.24-smp repo.
It seems to work fine and I'm in the process of cleaning it
up a bit and adding preliminary XTENSA kgdb support.

   Looks like you have moved xtensa include files to arch/xtensa.
I'm pulling your repo and re-merge with your latest bits. I'm
limiting the changes outside of arch/xtensa to just the few
required (like the open core Ethernet driver) and a very small
change I made to mm/slab.c to allow the kernel to be compiled -O0.

   One regression that came up after the merge with your previous
bits (2.6.27-rc3 last changed 2008-07-30) was that the NFS RPC
code wouldn't compile -O0 due to a problem with byte order macros
to convert IP addresses from local to net form. In this case it
appears to be the RPC code with it's initialization of a structure
with a htonl(INADDR_LOOPBACK) which isn't being optimized away.

		"net/sunrpc/rpcb_clnt.c
		-----------------------
static const struct sockaddr_in rpcb_inaddr_loopback = {
         .sin_family             = AF_INET,
         .sin_addr.s_addr        = htonl(INADDR_LOOPBACK),
         .sin_port               = htons(RPCBIND_PORT),
};

Looks like this convention was started by Chuck Lever on 7/14/2008 (Id:44).


   Still tweaking and testing a major change to entry.S that Marc wrote
to allow gdb to backtrace across an exception. It's been extremely
valuable while working on problems like bringing up the kgdb stub.

-piet

> Hi Harvey,
> 
> I have added your patch to the xtensa-next tree on kernel.org and will 
> push to Linus soon.
> 
> Thanks,
> -Chris
> 
> Harvey Harrison wrote:
>> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>> ---
>>  include/asm-xtensa/byteorder.h |   32 +++++++++++++++-----------------
>>  1 files changed, 15 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/asm-xtensa/byteorder.h 
>> b/include/asm-xtensa/byteorder.h
>> index 765edf1..07d10ad 100644
>> --- a/include/asm-xtensa/byteorder.h
>> +++ b/include/asm-xtensa/byteorder.h
>> @@ -14,7 +14,17 @@
>>  #include <asm/types.h>
>>  #include <linux/compiler.h>
>>  
>> -static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
>> +#ifdef __XTENSA_EL__
>> +# define __LITTLE_ENDIAN
>> +#elif defined(__XTENSA_EB__)
>> +# define __BIG_ENDIAN
>> +#else
>> +# error processor byte order undefined!
>> +#endif
>> +
>> +#define __SWAB_64_THRU_32__
>> +
>> +static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
>>  {
>>      __u32 res;
>>      /* instruction sequence from Xtensa ISA release 2/2000 */
>> @@ -28,8 +38,9 @@ static __inline__ __attribute_const__ __u32 
>> ___arch__swab32(__u32 x)
>>          );
>>      return res;
>>  }
>> +#define __arch_swab32 __arch_swab32
>>  
>> -static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
>> +static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
>>  {
>>      /* Given that 'short' values are signed (i.e., can be negative),
>>       * we cannot assume that the upper 16-bits of the register are
>> @@ -62,21 +73,8 @@ static __inline__ __attribute_const__ __u16 
>> ___arch__swab16(__u16 x)
>>  
>>      return res;
>>  }
>> +#define __arch_swab16 __arch_swab16
>>  
>> -#define __arch__swab32(x) ___arch__swab32(x)
>> -#define __arch__swab16(x) ___arch__swab16(x)
>> -
>> -#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
>> -#  define __BYTEORDER_HAS_U64__
>> -#  define __SWAB_64_THRU_32__
>> -#endif
>> -
>> -#ifdef __XTENSA_EL__
>> -# include <linux/byteorder/little_endian.h>
>> -#elif defined(__XTENSA_EB__)
>> -# include <linux/byteorder/big_endian.h>
>> -#else
>> -# error processor byte order undefined!
>> -#endif
>> +#include <linux/byteorder.h>
>>  
>>  #endif /* _XTENSA_BYTEORDER_H */
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
