Return-Path: <linux-kernel-owner+w=401wt.eu-S939557AbXHIMxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939557AbXHIMxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939138AbXHIMxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:53:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXHIMxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:53:13 -0400
Message-ID: <46BB0E1F.2030003@redhat.com>
Date: Thu, 09 Aug 2007 08:52:47 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Jerry Jiang <wjiang@resilience.com>, Chris Friesen <cfriesen@nortel.com>,
       Zan Lynx <zlynx@acm.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com> <46B8E64E.7010708@nortel.com> <1186525977.232321.43.camel@localhost> <46B91D0C.5050704@redhat.com> <46B94B94.6000600@nortel.com> <46B96719.3050006@redhat.com> <20070808162755.61f50fbf.wjiang@resilience.com> <46BA2D72.9060202@redhat.com> <Pine.LNX.4.64.0708090836070.10666@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708090836070.10666@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Wed, 8 Aug 2007, Chris Snook wrote:
> 
>> Jerry Jiang wrote:
>>> On Wed, 08 Aug 2007 02:47:53 -0400
>>> Chris Snook <csnook@redhat.com> wrote:
>>>
>>>> Chris Friesen wrote:
>>>>> Chris Snook wrote:
>>>>>
>>>>>> This is not a problem, since indirect references will cause the CPU to
>>>>>> fetch the data from memory/cache anyway.
>>>>> Isn't Zan's sample code (that shows the problem) already using indirect
>>>>> references?
>>>> Yeah, I misinterpreted his conclusion.  I thought about this for a while,
>>>> and realized that it's perfectly legal for the compiler to re-use a value
>>>> obtained from atomic_read.  All that matters is that the read itself was
>>>> atomic.  The use (or non-use) of the volatile keyword is really more
>>>> relevant to the other atomic operations.  If you want to guarantee a
>>>> re-read from memory, use barrier().  This, incidentally, uses volatile
>>>> under the hood.
>>>>
>>>
>>> So for example, without volatile
>>>
>>> int a = read_atomic(v);
>>> int b = read_atomic(v);
>>>
>>> the compiler will optimize it as b = a, But with volatile, it will be forced
>>> to fetch v's value from memory
>>> again.
>>>
>>> So, come back our initial question,
>>> include/asm-v850/atomic.h:typedef struct { int counter; } atomic_t;
>>>
>>> Why is it right without volatile?
>> Because atomic_t doesn't promise a memory fetch every time.  It merely
>> promises that any atomic_* operations will, in fact, be atomic.  For example,
>> posted today:
>>
>> http://lkml.org/lkml/2007/8/8/122
> 
> i'm sure that, when this is all done, i'll finally have an answer to
> my original question, "why are some atomic_t's not volatile, while
> most are?"
> 
> i'm almost scared to ask any more questions.  :-)
> 
> rday

Momentarily I'll be posting a patchset that makes all atomic_t and atomic64_t 
declarations non-volatile, and casts them to volatile inside of atomic[64]_read. 
  This will ensure consistent behavior across all architectures, and is in 
keeping with the philosophy that memory reads should be enforced in running 
code, not declarations.

I hope you don't mind that we're mooting the question by making the code more 
sensible.

	-- Chris
