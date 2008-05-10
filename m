Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYEJRRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYEJRRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 13:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYEJRRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 13:17:38 -0400
Received: from gw.goop.org ([64.81.55.164]:47547 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYEJRRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 13:17:36 -0400
Message-ID: <4825D8A1.30008@goop.org>
Date: Sat, 10 May 2008 18:17:21 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Bart Van Assche <bart.vanassche@gmail.com>,
       John Reiser <jreiser@BitWagon.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
References: <47F630AE.7050801@gmail.com>	 <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>	 <482565A5.8010503@cs.helsinki.fi>	 <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
In-Reply-To: <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi!
>
> On Sat, May 10, 2008 at 1:04 PM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
>   
>>> Bart Van Assche wrote:
>>>       
>>>> It's a bit late but I finally found out about your announcement of
>>>> kmemcheck version 7. Are you familiar with the patch that adds support
>>>> to Valgrind for User Mode Linux ? I'm not sure what the best approach
>>>> is -- letting the kernel do its own checking like kmemcheck or extend
>>>> Valgrind such that it supports UML. Anyway, the techniques applied in
>>>> Valgrind may be useful for kmemcheck too, such as the algorithms used
>>>> in Valgrind to compress the memory state information.
>>>>         
>
> Yes, I have learned of it not so long ago, around January or so. I
> wanted to stop kmemcheck development back then, but Ingo and Pekka
> convinced me that it could still be useful :-)
>
> (The link is http://bitwagon.com/valgrind+uml/index.html)
>
> I guess the main disadvantages of using kmemcheck over valgrind-memcheck are:
>  - kmemcheck can only warn eagerly, whereas memcheck will wait until
> the uninitialized bits are actually used. This means that kmemcheck
> will report many false positives. (We have some workarounds but this
> is obviously not perfect.)
>  - kmemcheck can only warn for dynamic memory, whereas kmemcheck I
> believe will also work for local variables, static variables, etc.
>
> It would be interesting to compare the output of kmemcheck vs. the
> output of memcheck, though.
>
>   
>> On Sat, May 10, 2008 at 11:06 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>     
>>> It's better to do it with the native kernel so you can "valgrind" all the
>>> interesting driver code.
>>>       
>> That's right. This is the paper I was referring to that details how to
>> minimize the memory consumption when tracking state information:
>> http://www.valgrind.org/docs/shadow-memory2007.pdf
>>     
>
> Thanks. I have actually seen the paper before, but not read all of it.
> From a quick glace, it seems that the optimizations described there
> apply to the tracking of individual bits within a byte, but since we
> are tracking by byte granularity (as opposed to bit granularity), it
> also seems irrelevant to kmemcheck. (I am not saying that it isn't
> interesting, however.)
>
> Currently, we are using a full byte for each shadowed byte. Since we
> actually only use two bits out of eight, we could save three fourths
> compared to what we use today.
>
> However, memory usage doesn't seem to be much of a problem. I actually
> think it might be worth saving the CPU cycles that are needed for the
> lookups/bit operations (memory is cheap, cycles aren't). How is the
> speed of Valgrind+UML, does anybody know? Isn't there a problem that
> Valgrind will have to emulate all the userspace programs as well?
> That, I believe, would make the Valgrinded system painfully slow to
> work with. I have no benchmarks or profiler results to refer to, but
> kmemcheck at least boots to full userspace+X and is still quite
> usable.

No, I think valgrind+uml deliberately lets usermode code run directly on 
the cpu, not under valgrind.  Having the option to run everything under 
Valgrind would be interesting, since it would allow you to trace 
uninitialized values crossing the user-kernel boundary (both ways) 
indicating either usermode or kernel bugs (also user to user via the 
kernel, such as via a pipe).

I've thought about, but not actually implemented, running valgrind as a 
Xen guest, and then running a sub-guest under it, allowing you to run an 
entire virtual machine under Valgrind.  I think people have done vaguely 
similar stuff with qemu.

    J

