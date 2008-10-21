Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYJUA5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYJUA5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYJUA5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:57:06 -0400
Received: from poll.devit.com ([216.165.189.132]:58607 "EHLO mx0.devit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751287AbYJUA5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:57:05 -0400
Message-ID: <48FD28F3.805@flurg.com>
Date: Mon, 20 Oct 2008 19:57:23 -0500
From: "David M. Lloyd" <dmlloyd@flurg.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: david@lang.hm
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield() options
References: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm> <20081020225318.GA10352@ghostprotocols.net> <alpine.DEB.1.10.0810201603510.21749@asgard.lang.hm> <48FD19E9.8010807@flurg.com> <alpine.DEB.1.10.0810201733000.21749@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0810201733000.21749@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2008 07:44 PM, david@lang.hm wrote:
> On Mon, 20 Oct 2008, David M. Lloyd wrote:
> 
>> On 10/20/2008 06:08 PM, david@lang.hm wrote:
>>> in the case I'm looking at there are two (or more) threads running 
>>> with one message queue in the center.
>>>
>>> 'input threads' are grabbing the lock to add messages to the queue
>>>
>>> 'output threads' are grabbing the lock to remove messages from the queue
>>>
>>> the programmer is doing a pthread_yield() after each message is 
>>> processed in an attempt to help fairness (he initially added it in 
>>> when he started seeing starvation on single-core systems)
>>>
>>> what should he be doing instead?
>>
>> If you're seeing starvation, to me that's a good indicator that the 
>> granularity of queue items are too small... probably there'd be an 
>> overall benefit of grabbing more things at once from the queue.
>> <...>
> I've suggested that, but the changes nessasary to support that mode of 
> operation are very invasive, and so not an option in the near/medium term.
> 
> in the meantime is there something better than sched_yield() that should 
> be happening
> <...>
> the sched_yield is an attempt to have the secretary pause once in a 
> while and check to see if the other line has someone waiting.
> 
> from looking at the software running, it doesn't seem to work very well. 
> I've also suggested investigating lockless algorithms for the queue, but 
> that is also a lot of high-risk (but high-reward) work. what else can be 
> done to make a mutex more fair?

No, you're not going to make much progress trying to fix the wrong problem 
in my opinion.  A lockless algorithm *might* work, but I suspect that since 
your computation units are apparently so small, you'll still spend a lot of 
time doing compare-and-swap and barriers and that sort of thing anyway, and 
it will still be the same sort of situation.  I think your design is 
basically broken.  You're frankly probably better off just ditching the 
queue and doing the work directly in the queuing threads.  At least then 
you won't have contention.

- DML
