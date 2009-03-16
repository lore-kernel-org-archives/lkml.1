Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZCPGD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZCPGD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 02:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZCPGDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 02:03:47 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:40855 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZCPGDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 02:03:46 -0400
Message-ID: <49BDEB28.7080302@cs.columbia.edu>
Date: Mon, 16 Mar 2009 02:01:12 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
References: <49B775B4.1040800@free.fr> <20090312145311.GC12390@us.ibm.com>	<1236891719.32630.14.camel@bahia>	<20090312212124.GA25019@us.ibm.com>	<604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com>	<20090313053458.GA28833@us.ibm.com>	<alpine.LFD.2.00.0903131018390.3940@localhost.localdomain>	<20090313193500.GA2285@x200.localdomain>	<alpine.LFD.2.00.0903131401070.3940@localhost.localdomain>	<20090314002059.GA4167@x200.localdomain> <20090314082532.GB16436@elte.hu>
In-Reply-To: <20090314082532.GB16436@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
>> On Fri, Mar 13, 2009 at 02:01:50PM -0700, Linus Torvalds wrote:
>>>
>>> On Fri, 13 Mar 2009, Alexey Dobriyan wrote:
>>>>> Let's face it, we're not going to _ever_ checkpoint any 
>>>>> kind of general case process. Just TCP makes that 
>>>>> fundamentally impossible in the general case, and there 
>>>>> are lots and lots of other cases too (just something as 
>>>>> totally _trivial_ as all the files in the filesystem 
>>>>> that don't get rolled back).
>>>> What do you mean here? Unlinked files?
>>> Or modified files, or anything else. "External state" is a 
>>> pretty damn wide net. It's not just TCP sequence numbers and 
>>> another machine.
>> I think (I think) you're seriously underestimating what's 
>> doable with kernel C/R and what's already done.
>>
>> I was told (haven't seen it myself) that Oracle installations 
>> and Counter Strike servers were moved between boxes just fine.
>>
>> They were run in specially prepared environment of course, but 
>> still.
> 
> That's the kind of stuff i'd like to see happen.
> 
> Right now the main 'enterprise' approach to do 
> migration/consolidation of server contexts is based on hardware 
> virtualization - but that pushes runtime overhead to the native 
> kernel and slows down the guest context as well - massively so.
> 
> Before we've blinked twice it will be a 'required' enterprise 
> feature and enterprise people will measure/benchmark Linux 
> server performance in guest context primarily and we'll have a 
> deep performance pit to dig ourselves out of.
> 
> We can ignore that trend as uninteresting (it is uninteresting 
> in a number of ways because it is partly driven by stupidity), 
> or we can do something about it while still advancing the 
> kernel.
> 
> With containers+checkpointing the code is a lot scarier (we 
> basically do system call virtualization), the environment 
> interactions are a lot wider and thus they are a lot more 
> difficult to handle - but it's all a lot faster as well, and 
> conceptually so. All the runtime overhead is pushed to the 
> checkpointing step - (with some minimal amount of data structure 
> isolation overhead).

It's worthwhile the make the distinction between virtualization and
checkpoint/restart (c/r). Virtualization is about decoupling of the
applications from the underlying operating system by providing a
private and and virtual namespace, that is - containers. Checkpoint/
restart is ability to save the state of a container so that it can
be restart later from that point.

The point is, that virtualization is *already* part of the kernel
through namespaces (pid, ipc, mounts, etc). This considerable body
of work was eventually merged and is mostly complete, covering most
of the environment interactions. The runtime overhead is negligible.

Seeing that namespaces are now part of the kernel, we now build on
the existing virtualization to allow checkpoint/restart. The code is
not at all scary: record the state on checkpoint, and restore it on
restart. There is no runtime overhead for checkpoint but the downtime
incurred on an application when it is frozen for the duration of the
checkpoint.

> 
> I see three conceptual levels of virtualization:
> 
>  - hardware based virtualization, for 'unaware OSs'
> 
>  - system call based virtualization, for 'unaware software'
> 
>  - no virtualization kernel help is needed _at all_ to 
>    checkpoint 'aware' software. We have libraries to checkpoint 
>    'aware' user-space just fine - and had them for a decade.

Checkpoint/restart is almost orthogonal to virtualization (c/r only
needs a way to request a specific resource identifier for resources
that it creates). Therefore, the effort required to allow c/r of
'aware' software is nearly the same as for 'unaware' software.

IMHO this is the natural next time: make the c/r useful and attractive
by making it transparent (support 'unaware' software), complete (cover
nearly all features) and efficient (with low application downtime).

And this is precisely what we aim for with the current patchset.

Oren.

