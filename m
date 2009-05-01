Return-Path: <linux-kernel-owner+w=401wt.eu-S1761763AbZEAOLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761763AbZEAOLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbZEAOLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:11:31 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43599 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEAOLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:11:30 -0400
Message-ID: <49FB030F.8060300@monstr.eu>
Date: Fri, 01 May 2009 16:11:27 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH V3] asm-generic: add a generic uaccess.h
References: <cover.1241105648.git.arnd@arndb.de> <200905011513.25344.arnd@arndb.de> <49FAFD63.2080102@monstr.eu> <200905011606.05319.arnd@arndb.de>
In-Reply-To: <200905011606.05319.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 01 May 2009, Michal Simek wrote:
>> Arnd Bergmann wrote:
>>> +
>>> +#include <asm/segment.h>
>>> +
>>> +#ifndef get_fs
>>> +#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
>> one line above -> get_fs could be defined in different space
>> and this arch could use MAKE_MM_SEG too -> for example powerpc.
> 
> I don't think I understand what you are trying to tell me.
> How do you think this should look?

I meant move MAKE_MM_SEG macro to this position because this macro could be use
with arch which define different get_fs.

#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
#ifndef get_fs
...


> 
>>> +
>>> +#define VERIFY_READ	0
>>> +#define VERIFY_WRITE	1
>>> +
>>
>> Not sure if any arch do READ/WRITE check but if yes.
> 
> I could not find any architecture using it either, but the
> API is defined this way.
> 
>> #ifndef access_ok
>>
>>> +#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
>> #endif
> 
> right, will change.
> 
>>> +
>>> +/*
>>> + * The architecture should really override this if possible, at least
>>> + * doing a check on the get_fs()
>>> + */
>> If they should really override it but why write it here.
> 
> Mostly for documentation purposes, so that an architecture maintainer
> can copy the prototype. I see the asm-generic headers as both fallbacks
> for architectures and as templates of what should be implemented.
> 
>>> +#define get_user(x, ptr)					\
>>> +({								\
>>> +	might_sleep();						\
>>> +	__access_ok(ptr, sizeof (*ptr)) ?			\
>>> +		__get_user(x, ptr) :				\
>>> +		-EFAULT;					\
>>> +})
>> I am getting here (for put_user macro too) any error on noMMU. :-(
> 
> What kind of error do you see?

System is getting crazy with -> I am debugging it.


>  
>>> +static inline long
>>> +strncpy_from_user(char *dst, const char __user *src, long count)
>>> +{
>>> +	if (!__access_ok(src, 1))
>>> +		return -EFAULT;
>>> +	return __strncpy_from_user(dst, src, count);
>>> +}
>> Is it a good place to add might_sleep() and unlikely(+ some other cases) too?
>> We have almost the same code.
> 
> Yes, I think so. The unlikely() can probably go into __access_ok() though,
> so we don't have to write it every time.

ok

Michal


> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
