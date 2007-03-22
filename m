Return-Path: <linux-kernel-owner+w=401wt.eu-S965855AbXCVIn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965855AbXCVIn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965861AbXCVIn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:43:26 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:9222 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965855AbXCVInZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:43:25 -0400
Message-ID: <46024000.2070208@sciensis.com>
Date: Thu, 22 Mar 2007 10:36:16 +0200
From: Tasos Parisinos <t.parisinos@sciensis.com>
User-Agent: Mozilla Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][NEW] crypto API: rsa algorithm module patch (kernel
 version 2.6.20.3)
References: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr> <20070321090420.f46cef4f.randy.dunlap@oracle.com>
In-Reply-To: <20070321090420.f46cef4f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




> Hi,
> Lots of good progress here, but still a few comments below.
>
> Needs to apply to current mainline.
>
>
>   
What do you mean by mainline?
> Most (probably all) of these functions should also be "static"
> unless they are meant for use outside of this module.
>
> Which leads to the question:  which functions are meant for
> external/exported use?
>
> And it would be really Good if those function headers were
> documented in kernel-doc notation (not much of a change from
> what you already have here; see Documentation/kernel-doc-nano-HOWTO.txt).
>
>
>   

I think that if someone wants to do modular exponentiation rsa-style 
(where n is always odd)
using the montgomery algorithm i implement, only rsa_modexp should be static

But the rest of the API can be used for multi-precision integer 
arithmetics, so they could almost all
be exported (except rsa_load and rsa_unload). Do you think that this is 
namespace pollution?
In that case i should make them all static except rsa_modexp

About exportable comments, i just missed it, i will fix that
>>  = tmp = buf[i + j] + (abuf[j] * (u64)bbuf[i]) + (tmp >> 32);
>>     
>
> Break that line to < 80 columns, please.
>
>   
>> +			tmp[j] = product = tmp[j] + (m * (u64)nbuf[j]) + (product >> 32);
>>     
>
> Line too long.
>
>   
>
Well this is going to be a problem, because i believe that in this way 
gcc will create the best code. These internal product
computations are essential and they get run many-many times. I will do 
my best to write it in less than 80 columns


Then i need to comment on some of the changes that where suggested on 
the previous patch but where not carried out

First of all the

UINT32_T_MAX

This is nowhere in linux/kernel.h but there are some equivalents but they are 
defined as macros that do some computation to compute the max 32 bit unsigned integer
and this would steal some (enough) clocks in loops that execute a lot. So i use the static value
0xFFFFFFFF which is more efficient.

Secondly the chunk that initializes the mpi data

/* Copy the data */
for (i = size - 1, j = 0; i >= 0; i--, j++)
 buf[j / 4] |= ((u32)str[i] << ((j % 4) * 8));

Ok this is not pretty, its rather cruel. What i want to do is have a byte array for example

\xab\x11\xed\x43\x54\x34\x56\xcd

and make the mpi having data[0] = 0x543456cd and data[1]=0xab11ed43

I could reverse the byte array and then memcpy, what do you think?
Is there a faster (and prettier) way to do this? someone said ntohl but im not sure


Also there are places that memset or memcpy could be used, but i can't figure out if it
is more efficient to execute the set/copy loop my own or call such a function
What is your opinion on that?


All the other changes suggested where carried out

Tasos Parisinos
-



