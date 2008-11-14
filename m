Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYKNIOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYKNIOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYKNIOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:14:22 -0500
Received: from hq2.tensilica.com ([65.205.227.30]:6997 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734AbYKNIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:14:21 -0500
Message-ID: <491D3338.80405@tensilica.com>
Date: Fri, 14 Nov 2008 00:13:44 -0800
From: Piet Delaney <piet.delaney@tensilica.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>,
       Chris Zankel <chris@zankel.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Piet Delaney <piet.delaney@tensilica.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Marc Gauthier <marc@tensilica.com>,
       Joe Taylor <joetayloremail@gmail.com>, linux-xtensa@linux-xtensa.org,
       Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 10/10] xtensa: use the new byteorder headers - Merged
 with your previous xtensa-next and will remerge shortly.
References: <1225910131.5991.230.camel@brick> <49133094.6070407@zankel.net>	 <491500C0.90407@tensilica.com> <1226115481.11596.63.camel@brick> <49165F4A.4070905@tensilica.com>
In-Reply-To: <49165F4A.4070905@tensilica.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Piet Delaney wrote:
> Harvey Harrison wrote:
>> On Fri, 2008-11-07 at 19:00 -0800, Piet Delaney wrote:
>>> Hi Chris:
>>>
>>>    I've merged your recent xtensa-next with our 2.6.24-smp repo.
>>> It seems to work fine and I'm in the process of cleaning it
>>> up a bit and adding preliminary XTENSA kgdb support.
>>
>> 2.6.24?  In that case you probably don't have include/linux/byteorder.h,
>> or include/linux/swab.h which would explain your byteorder problems.
>>
>> Or is that a typo in the version numbers?
> 
> I was on 2.6.24 and didn't have a problem compiling the kernel -O0 other
> than a minor tweak in slab.c. Now in 2.6.27-rc3 I get a compile problem
> with rpcb_clnt.c at lines 122, 123, and 129:
> 
>    /export/src/xtensa-next/net/sunrpc/rpcb_clnt.c:129: error: (near 
> initialization for 'rpcb_in6addr_loopback.sin6_port')
> 

The problem is fixed by changing htons() to __constant_htons().
The __constant_*() flavors use a #define and always compile
to a constant. Ex:

#define ___constant_swab32(x) \
         ((__u32)( \
                 (((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
                 (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
                 (((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
                 (((__u32)(x) & (__u32)0xff000000UL) >> 24) ))

I tried compiling the recent snapshot from Linus's tree and it
has a new instance of the problem in a common network file.

In this case the recent change was FROM __constant_htons()
to htons(). See net/core/dev.c`simple_tx_hash():

  	Change by  Arnaldo Carvalho de Melo <acme@redhat.com>
	Date:   09/20/2008 10:20:49 PM

The log just says:

   net: Use hton[sl]() instead of __constant_hton[sl]() where applicable

Doesn't mention that it's prevent the kernel from being compiled for
unoptimized/easy kgdb debugging.

I'll leave this and similar changes on a xtensa smp branch and leave
the head of xtensa-next repo without these changes.

-piet

> 
>>
>> You should be able to just pull those two headers from Linus' tree
>> and drop them in, there is no dependencies other than those two
>> headers.
> 
> byteorder.h was already in sync with linus's tree and I updated swab.c
> as it had a few changes. Unfortunately the problem persist. I think the
> problem is likely in changes made to rpcb_clnt.c since 2.6.24.
> 
>>
>> If it is some other problem, let me know and I'll look into it.
> 
> You can likely reproduce it by configuring NFS and compiling -O0.
> 
> -piet
> 
>>
>> Harvey
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
