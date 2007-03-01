Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXCAT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXCAT7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXCAT7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:59:25 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1760 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965549AbXCAT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:59:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=wC3vjYoC8502TrfSttfobNDzV6p38ryN0YxdsjWqHg65zUlr8OoeIfx7VSXCFOWNx
	+hJnyYcCCZnJe1CHR64VQ==
Message-ID: <45E7308B.3050106@google.com>
Date: Thu, 01 Mar 2007 11:59:07 -0800
From: Mathieu Desnoyers <compudj@google.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: Re: Thread flags modified without set_thread_flag() (non atomically)
References: <45E33EBD.6020603@google.com>	<20070228220349.b42bf571.akpm@linux-foundation.org>	<20070301103451.2618cc35@dhcp-252-105.norway.atmel.com> <20070301014523.e45c3cc5.akpm@linux-foundation.org>
In-Reply-To: <20070301014523.e45c3cc5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 1 Mar 2007 10:34:51 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
>
>   
>>> On Mon, 26 Feb 2007 12:10:37 -0800 Mathieu Desnoyers <compudj@google.com> wrote:
>>>       
>>>> avr32/kernel/ptrace.c:          ti->flags |= _TIF_BREAKPOINT;
>>>>         
>>> No, I don't immediately see anything in the flush_old_exec() code path
>>> which tells us that nobody else can look up this thread_info (or be holding
>>> a ref to it) in this context.
>>>
>>>
>>>       
>>>> avr32/kernel/ptrace.c:                  ti->flags |= TIF_SINGLE_STEP;
>>>>         
>>> heh.  Haarvard, you got a bug.
>>>       
>> Heh, yeah. That would indeed explain some strange gdb behaviour. It
>> will only trigger when single-stepping into an exception or interrupt
>> handler so thanks for pointing it out; I would have had a hard time
>> figuring it out on my own...
>>     
>
> yup, tricky.
>
> If there's a lesson here, it is "don't provide #defines in the header for
> both versions".
>
>   

Hrm, but the bitmask version is useful (and correctly used) whenever
the flag is read and tested.

The proper way to do this would be to change every use the _TIF_* flag 
in a flag comparison
for a call to test_ti_thread_flag(). I wonder if gcc optimizes multiple 
constant test_bit() applying
on the same variable linked by logical and/or so it becomes a single 
read and a small set of comparisons.

> The block code does a similar thing:
>
> #define REQ_RW          (1 << __REQ_RW)
> #define REQ_FAILFAST    (1 << __REQ_FAILFAST)
> #define REQ_SORTED      (1 << __REQ_SORTED)
> #define REQ_SOFTBARRIER (1 << __REQ_SOFTBARRIER)
>
> and I've caught Jens using the wrong identifier at least twice in the past.
>
> It's better I think to just provide #defines for the bit offsets and
> open-code the shifting if needed.  Like PG_foo and BH_Foo.
>
>   
>> I don't think either of those need to be atomic though, since both of
>> them happen in monitor mode with interrupts disabled.
>>     
>
> That's true until you implement SMP ;)
>   

