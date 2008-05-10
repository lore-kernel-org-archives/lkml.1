Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYEJMCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYEJMCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 08:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYEJMCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 08:02:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:64653 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbYEJMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 08:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h24sK44V6IgUzyb9WSV3M4MsAmlzCBFOojoBhsS/YO79pVvaG06KrveNrFLJ9rIJvxpv9SnVg6rlKY2ZULujDw/lW5WUZMnCyMvvusZDNPO1iwn9PrIywpwyUnQPQsPPhlayA/v8EFHIm/HwMUC9o4akOng/Ek1CfZjV3RMI9QY=
Message-ID: <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
Date: Sat, 10 May 2008 14:02:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [ANNOUNCE] kmemcheck v7
Cc: "John Reiser" <jreiser@BitWagon.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Josh Aune" <luken@omner.org>,
       "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F630AE.7050801@gmail.com>
	 <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>
	 <482565A5.8010503@cs.helsinki.fi>
	 <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sat, May 10, 2008 at 1:04 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
>> Bart Van Assche wrote:
>>>
>>> It's a bit late but I finally found out about your announcement of
>>> kmemcheck version 7. Are you familiar with the patch that adds support
>>> to Valgrind for User Mode Linux ? I'm not sure what the best approach
>>> is -- letting the kernel do its own checking like kmemcheck or extend
>>> Valgrind such that it supports UML. Anyway, the techniques applied in
>>> Valgrind may be useful for kmemcheck too, such as the algorithms used
>>> in Valgrind to compress the memory state information.

Yes, I have learned of it not so long ago, around January or so. I
wanted to stop kmemcheck development back then, but Ingo and Pekka
convinced me that it could still be useful :-)

(The link is http://bitwagon.com/valgrind+uml/index.html)

I guess the main disadvantages of using kmemcheck over valgrind-memcheck are:
 - kmemcheck can only warn eagerly, whereas memcheck will wait until
the uninitialized bits are actually used. This means that kmemcheck
will report many false positives. (We have some workarounds but this
is obviously not perfect.)
 - kmemcheck can only warn for dynamic memory, whereas kmemcheck I
believe will also work for local variables, static variables, etc.

It would be interesting to compare the output of kmemcheck vs. the
output of memcheck, though.

> On Sat, May 10, 2008 at 11:06 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> It's better to do it with the native kernel so you can "valgrind" all the
>> interesting driver code.
>
> That's right. This is the paper I was referring to that details how to
> minimize the memory consumption when tracking state information:
> http://www.valgrind.org/docs/shadow-memory2007.pdf

Thanks. I have actually seen the paper before, but not read all of it.
>From a quick glace, it seems that the optimizations described there
apply to the tracking of individual bits within a byte, but since we
are tracking by byte granularity (as opposed to bit granularity), it
also seems irrelevant to kmemcheck. (I am not saying that it isn't
interesting, however.)

Currently, we are using a full byte for each shadowed byte. Since we
actually only use two bits out of eight, we could save three fourths
compared to what we use today.

However, memory usage doesn't seem to be much of a problem. I actually
think it might be worth saving the CPU cycles that are needed for the
lookups/bit operations (memory is cheap, cycles aren't). How is the
speed of Valgrind+UML, does anybody know? Isn't there a problem that
Valgrind will have to emulate all the userspace programs as well?
That, I believe, would make the Valgrinded system painfully slow to
work with. I have no benchmarks or profiler results to refer to, but
kmemcheck at least boots to full userspace+X and is still quite
usable.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
