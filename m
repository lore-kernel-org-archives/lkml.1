Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbXEBGyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbXEBGyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbXEBGyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:54:25 -0400
Received: from haxent.com ([65.99.219.155]:4107 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbXEBGyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:54:24 -0400
Message-ID: <4638359B.6050500@haxent.com.br>
Date: Wed, 02 May 2007 03:54:19 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
References: <20070502052235.914764000@haxent.com.br> <20070502053427.123392000@haxent.com.br> <4638279A.9010105@cosmosbay.com> <46382CA2.1020504@haxent.com.br> <46383218.4020406@cosmosbay.com>
In-Reply-To: <46383218.4020406@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Davi Arnaut a écrit :
>> Eric Dumazet wrote:
>>> Davi Arnaut a écrit :
>>>> Asynchronously wait for FUTEX_WAKE operation on a futex if it still contains
>>>> a given value. There can be only one futex wait per file descriptor. However,
>>>> it can be rearmed (possibly at a different address) anytime.
>>>>
>>>> The pollable futex approach is far superior (send and receive events from
>>>> userspace or kernel) to eventfd and fixes (supercedes) FUTEX_FD at the same time.
>>>>
>>>> Building block for pollable semaphores and user-defined events.
>>>>
>>>> Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
>>>>

<snip>

>>>> +
>>>> +struct futex_event {
>>>> +	union {
>>>> +		void __user *addr;
>>>> +		u64 padding;
>>>> +	};
>>>> +	int val;
>>>> +};
>>> Hum... Here we might have a problem with 64 bit futexes, or private futexes
>>>
>>> So I believe this interface is not well defined and not expandable: in case of 
>>> future additions to futexes, an old application compiled with an old pollable 
>>> futex_event type might fail.
>>>
>> Hmm, how about:
>>
>> struct futex_event {
>> 	union {
>> 		void __user *addr;
>> 		u64 padding;
>> 	};
>> 	union {
>> 		int val;
>> 		s64 val64;
>> 	};
>> 	/* whatever room is necessary for future improvements */
>> };
>>
>> I haven't been keeping up with 64 bit or private futexes. What else
>> could probably go wrong?
> 
> Well, that's the point : This interface is like an ioctl() one : pretty bad if 
> not properly designed :)

I was merely mirroring the futex syscall arguments for FUTEX_WAIT. Will
those change? I hope not :)

> You probably need to stick one field containing one command or version number, 
> something like that.

I'm a bit skeptical that we need versioning for such a simple operation
(command) as FUTEX_WAIT that takes an address and a value.

> 
> 
> struct futex_event {
> 	int     type;
> 	union {
> 		void __user *addr;
> 		u64 padding;
> 	};
> 	union {
> 		int val;
> 		s64 val64;
> 	};
> };
> 
> #define  FUTEX_EVENT_SHARED32  1
> #define  FUTEX_EVENT_SHARED64  2
> #define  FUTEX_EVENT_PRIVATE32 (128|1)
> #define  FUTEX_EVENT_PRIVATE64 (128|2)

I will take a look at the private futexes patches before commenting further.

> ...
> 
> Also, you should take care of alignements constraints (a 32bit user program 
> might run on a 64bit kernel)
> 

Compat code? or futex alignements constraints?

--
Davi Arnaut

