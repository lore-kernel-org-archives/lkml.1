Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYHSQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYHSQfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYHSQfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:35:14 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30242 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753368AbYHSQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:35:12 -0400
Message-ID: <48AAF5F7.6040709@panasas.com>
Date: Tue, 19 Aug 2008 19:33:59 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au> <20080818075459.GH30694@elte.hu> <48A9472F.908@panasas.com> <20080819133422.GA24369@elte.hu>
In-Reply-To: <20080819133422.GA24369@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Aug 2008 16:33:16.0613 (UTC) FILETIME=[483C7750:01C90219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>> Link time warnings are easy enough to miss.
>>>
>>> So unless there's a better way of doing it all at compile time (i'd 
>>> really prefer that!) i'd prefer the link time error about botched 
>>> BUILD_BUG_ON() conditions - as my commits introduce.
>>>
>>> 	Ingo
>>> --
>> #define BUILD_BUG_ON(condition)						\
>> do {
>> 	enum { bad = !!(condition)}; 									\
>> 	static struct { char arr[1 - 2*bad]; } x __maybe_unused;	\
>> } while(0)
>>
>> the enum definition will not let in anything not compile-time constant.
> 
> nice trick!
> 
>> But then I fail on: (include/linux/virtio_config.h:99)
>>
>> 	if (__builtin_constant_p(fbit))
>> 		BUILD_BUG_ON(fbit >= 32);
>>
>> is that code broken?
> 
> hmm ... that's a bit sad, gcc ought to have been able to figure this 
> out. Can this be fixed somehow, without losing the strength of the 
> checking here? I think we should not change BUILD_BUG_ON() to make it 
> less useful.
> 
> 	Ingo

The BUILD_BUG_ON I proposed is not less useful. Actually with current
BUILD_BUG_ON above code does nothing, since fbit is a function parameter
it will translate to nothing. Certainly it will not check the size of passed
parameter, since that was converted on the stack to unsigned int. So my
definition will catch the bad programing here.

If the user of virtio_has_feature() must pass a compile-time constant then
it must be converted to a MACRO, and then the BUILD_BUG_ON will work.
Or it should be changed to a BUG_ON() if fbit is a runtime variable.

>From what I understood this is what you wanted, some way to make sure
a BUILD_BUG_ON will check that the check is actually useful (compile-time)
and is not silently ignored.

Same thing at the other place I sent.

Boaz
