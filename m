Return-Path: <linux-kernel-owner+w=401wt.eu-S1763194AbZAUAsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763194AbZAUAsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbZAUAsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:48:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58297 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666AbZAUAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:48:22 -0500
Message-ID: <497670C6.7010304@zytor.com>
Date: Tue, 20 Jan 2009 16:48:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
References: <1232496257.3123.19.camel@localhost.localdomain> <20090120.161626.93641145.davem@davemloft.net>
In-Reply-To: <20090120.161626.93641145.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jaswinder Singh Rajput <jaswinder@kernel.org>
> Date: Wed, 21 Jan 2009 05:34:17 +0530
> 
>> usr/include/asm-generic/fcntl.h is giving 2 'make headers_check' warnings:
>>  usr/include/asm-generic/fcntl.h:127: leaks CONFIG_64BIT to userspace where it is not valid
>>  usr/include/asm-generic/fcntl.h:149: leaks CONFIG_64BIT to userspace where it is not valid
>>
>> usr/include/asm-generic/fcntl.h:
> ...
>> #ifndef CONFIG_64BIT will always be true for userspace. So what is the use of #ifndef CONFIG_64BIT ?
> 
> Good catch.
> 
> This file needs to test for 64-bit'ness using some non-CONFIG_*
> test.  And the standard built-in CPP macros which can be used
> to check for that are different on every platform.
> 

There are a few ways to check for 64-bitness that are 
platform-independent, unfortunately each of them have drawbacks.

a) the gcc-specific way:

	#if __SIZEOF_POINTER__ == 8

    or

	#ifdef __LP64__

    or any other number of variants.

    It has the obvious disadvantage of being gcc-specific, although
    it seems rather likely that other Linux-supporting compilers might
    also define these macros.

b) the standard C way:

	#include <limits.h>

	#if LONG_MAX > 2147483647L

    it has the obvious disadvantage of needing to include <limits.h>...

We can, of course, also do our own thing as DaveM suggested; this is 
probably the best option.  FWIW, glibc has _WORDSIZE which is equivalent 
to what we call BITS_PER_LONG.  We might as well export it under that 
name (presumably under #ifndef).

	-hpa
