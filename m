Return-Path: <linux-kernel-owner+w=401wt.eu-S1030230AbXCVIKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230AbXCVIKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030238AbXCVIJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:09:44 -0400
Received: from mtaout2.012.net.il ([84.95.2.4]:25206 "EHLO mtaout2.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030230AbXCVIJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:09:42 -0400
Date: Thu, 22 Mar 2007 10:09:39 +0200
From: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Cleanup: rationalize paravirt wrappers
In-reply-to: <1174550442.2713.128.camel@localhost.localdomain>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
Message-id: <460239C3.5000404@qumranet.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu,
 22 Mar 2007 10:09:40 +0200 (IST)
References: <1174531311.2713.86.camel@localhost.localdomain>
 <46023096.8060809@qumranet.com>
 <1174550442.2713.128.camel@localhost.localdomain>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>>
>>> +#define rdmsr(msr,val1,val2)						\
>>> +	do {								\
>>> +		int __err;						\
>>> +		unsigned long long __val = native_read_msr(msr, &__err);	\
>>> +		val1 = __val;						\
>>> +		val2 = __val >> 32;					\
>>> +	} while(0)
>>> +
>>>   
>>>       
>> You're silently changing the behavior (as well as the prototype) here,  
>> rdmsr() used to fail loudly, now it fails silently, with no way for the 
>> caller to check.
>>     
>
> Hi Avi!
>
> 	Not sure what you're saying about the prototype: the old macro was:
>
> -#define rdmsr(msr,val1,val2) \
> -	__asm__ __volatile__("rdmsr" \
> -			  : "=a" (val1), "=d" (val2) \
> -			  : "c" (msr))
> -
>
> Which doesn't seem to be a great difference to me.
>   

Right, scratch that.  Was confused by rdmsr_safe().

> The behaviour change (don't oops when an invalid rdmsr is used) was
> there with CONFIG_PARAVIRT=y, the cleanup just made !CONFIG_PARAVIRT the
> same.  Is it important?

I think so.  A function should either never fail, or indicate that it 
has failed (panic, error return, debug message).  With the kinder, 
gentler rdmsr() one can code the wrong msr value and not notice that 
something is wrong.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

