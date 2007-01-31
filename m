Return-Path: <linux-kernel-owner+w=401wt.eu-S1030550AbXAaTYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030550AbXAaTYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030556AbXAaTYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:24:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:46289 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030550AbXAaTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:24:12 -0500
In-Reply-To: <200701311821.59579.ak@suse.de>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <p73abzzpo75.fsf@bingen.suse.de> <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com> <200701311821.59579.ak@suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FA06EB13-4BF6-4E3A-B223-6494079F541F@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
Date: Wed, 31 Jan 2007 11:23:39 -0800
To: Andi Kleen <ak@suse.de>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31, 2007, at 9:21 AM, Andi Kleen wrote:

> On Wednesday 31 January 2007 18:15, Zach Brown wrote:
>>
>> On Jan 31, 2007, at 12:58 AM, Andi Kleen wrote:
>>
>>> Do you have any numbers how this compares cycle wise to just doing
>>> clone+syscall+exit in user space?
>>
>> Not yet, no.  Release early, release often, and all that.  I'll throw
>> something together.
>
> So what was the motivation for doing this then?

Most fundamentally?  Providing AIO system call functionality at a  
much lower maintenance cost.  The hope is that the cost of adopting  
these fibril things will be lower than the cost of having to touch a  
code path that wants AIO support.

I simply don't believe that it's cheap to update code paths to  
support non-blocking state machines.  As just one example of a  
looming cost, consider the retry-based buffered fs AIO patches that  
exist today.  Their requirement to maintain these precisely balanced  
code paths that know to only return -EIOCBRETRY once they're at a  
point where retries won't access current-> seems.. unsustainable to  
me.  This stems from the retries being handled off in the aio kernel  
threads which have their own task_struct.  fs/aio.c goes to the  
trouble of migrating ->mm from the submitting task_struct, but  
nothing else.  Continually adjusting this finely balanced  
relationship between paths that return -EIOCBRETY and the fields of  
task_struct that fs/aio.c knows to share with the submitting context  
seems unacceptably fragile.

Even with those buffered IO patches we still only get non-blocking  
behaviour at a few specific blocking points in the buffered IO path.   
It's nothing like the guarantee of non-blocking submission returns  
that the fibril-based submission guarantees.

>   It's only point
> is to have smaller startup costs for AIO than clone+fork without
> fixing the VFS code to be a state machine, right?

Smaller startup costs and fewer behavioural differences.  Did that  
message to Nick about ioprio and io_context resonate with you at all?

> I'm personally unclear if it's really less work to teach a lot of
> code in the kernel about a new thread abstraction than changing VFS.

Why are we limiting the scope of moving to a state machine just to  
the VFS?  If you look no further than some hypothetical AIO iscsi/aoe/ 
nbd/whatever target you obviously include networking.  Probably splice 
() if you're aggressive :).

Let's be clear.  I would be thrilled if AIO was implemented by native  
non-blocking handler implementations.  I don't think it will happen.   
Not because we don't think it sounds great on paper, but because it's  
a hugely complex endeavor that would take development and maintenance  
effort away from the task of keeping basic functionality working.

So the hope with fibrils is that we lower the barrier to getting AIO  
syscall support across the board at an acceptable cost.

It doesn't *stop* us from migrating very important paths (storage,  
networking) to wildly optimized AIO implementations.  But it also  
doesn't force AIO support to wait for that.

> Your patches don't look that complicated yet but you openly
> admitted you waved away many of the more tricky issues (like
> signals etc.) and I bet there are yet-unknown side effects
> of this too that will need more changes.

To quibble, "waved away" implies that they've been dismissed.  That's  
not right.  It's a work in progress, so yes, there will be more  
fiddly details discovered and addressed over time.  The hope is that  
when it's said and done it'll still be worth merging.  If at some  
point it gets to be too much, well, at least we'll have this work to  
reference as a decisive attempt.

> I'm not sure the fibrils thing will be that much faster than
> a possibly somewhat fast pathed for this case clone+syscall+exit.

I'll try and get some numbers for you sooner rather than later.

Thanks for being diligent, this is exactly the kind of hard look I  
want this work to get.

- z
