Return-Path: <linux-kernel-owner+w=401wt.eu-S1161386AbXBOVaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161386AbXBOVaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161394AbXBOVaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:30:55 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:58269 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161386AbXBOVay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:30:54 -0500
In-Reply-To: <20070215212259.GA3466@Krystal>
References: <117122149548-git-send-email-mathieu.desnoyers@polymtl.ca> <11712214961955-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214225653.345aad29.akpm@linux-foundation.org> <20070215072024.GA9137@Krystal> <27EC3349-5FD8-47BD-B909-E1180B86AF40@kernel.crashing.org> <20070215200245.GF31359@Krystal> <906FD21B-59B6-4A30-90F0-914E0CD3CFBF@kernel.crashing.org> <20070215212259.GA3466@Krystal>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3D84FDC0-3AA0-4144-A255-19D2E20AF0AA@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] local_t : powerpc extension - use long for powerpc32
Date: Thu, 15 Feb 2007 15:29:59 -0600
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15, 2007, at 3:23 PM, Mathieu Desnoyers wrote:

> * Kumar Gala (galak@kernel.crashing.org) wrote:
>>
>> On Feb 15, 2007, at 2:02 PM, Mathieu Desnoyers wrote:
>>
>>> * Kumar Gala (galak@kernel.crashing.org) wrote:
>>>> is there a reason this isn't local_add_return(long a, local_t  
>>>> *l) on
>>>> ppc32?
>>>>
>>>> (same comment for other functions)
>>>>
>>>> - k
>>>
>>> no, except that we use the code is taken from atomic.h and used an
>>> int parameter. However, due to the semantics of local_t, we should
>>> manipulate longs instead of ints, even if they are the same size  
>>> on a
>>> given architecture (ppc32 and mips32 are affectec by this).
>>>
>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>>
>> Right, this means we can simply for ppc version down to:
>>
>> +static __inline__ int local_add_return(int a, local_t *l)
>> +{
>> +	int t;
>> +
>> +	__asm__ __volatile__(
>> +"1:	PPC_LLARX	%0,0,%2		# local_add_return\n\
>> +	add	%0,%1,%0\n"
>> +	PPC405_ERR77(0,%2)
>> +"	PPC_STLCX	%0,0,%2 \n\
> what about the dot after stwcx ? (stwcx.) ? Is it no longer required ?

Its implied, PPC_LLARX and PPC_STLCW are #defines that expand to  
proper instructions.

(look in include/asm-powerpc/asm-compat.h) for the defines.

Also, the PPC405_ERR77 will preprocess out on ppc64 if you were  
concerned.

- k
