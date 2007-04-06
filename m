Return-Path: <linux-kernel-owner+w=401wt.eu-S1767496AbXDFCQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767496AbXDFCQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767497AbXDFCQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:16:08 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44887 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767496AbXDFCQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:16:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Snook <csnook@redhat.com>, Robin Holt <holt@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
Date: Thu, 05 Apr 2007 20:15:09 -0600
In-Reply-To: <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 5 Apr 2007 18:29:16 -0700 (PDT)")
Message-ID: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 5 Apr 2007, Chris Snook wrote:
>
>> Linus Torvalds wrote:
>>
>> > Another thing we could do is to just make sure that kernel threads simply
>> > don't end up as children of init. That whole thing is silly, they're really
>> > not children of the user-space init anyway. Comments?
>> 
>> Does anyone remember why we started doing this in the first place?  I'm sure
>> there are some tools that expect a process tree, rather than a forest, and
>> making it a forest could make them unhappy.
>
> I'm not sure anybody would really be unhappy with pptr pointing to some 
> magic and special task that has pid 0 (which makes it clear to everybody 
> that the parent is something special), and that has SIGCHLD set to SIG_IGN 
> (which should make the exit case not even go through the zombie phase).
>
> I can't even imagine *how* you'd make a tool unhappy with that, since even 
> tools like "ps" (and even more "pstree" won't read all the process states 
> atomically, so they invariably will see parent pointers that don't even 
> exist any more, because by the time they get to the parent, it has exited 
> already.

Right.  pid == 1 being missing might cause some confusing having 
but having ppid == 0 should be fine.  Heck pid == 1 already has 
ppid == 0, so it is a value user space has had to deal with for a
while.

In addition there was a period in 2.6 where most kernel threads
and init had a pgid == 0 and a session  == 0, and nothing seemed
to complain.

We should probably make all of the kernel threads children of
init_task.  The initial idle thread on the first cpu that is the
parent of pid == 1.   That will give the ppid == 0 naturally because
the idle thread has pid == 0.

>> The support angel on my shoulder says we should just put all the kernel
>> threads under a kthread subtree to shorten init's child list and minimize
>> impact.
>
> A number are already there, of course, since they use the kthread 
> infrastructure to get there. 

Almost everything should be using kthread by now.  I do admit that there
are a handful of kernel threads that still use kthread_create but it
is a relatively short list.

Looking we apparently have a couple of process started by
kthread_create that are not under kthread.  They all have  pid numbers
lower than kthread so I'm guessing it is some startup ordering issue.

Currently it looks like daemonize is reparenting everything to init,
changing that to init_task and making the threads self reaping
should be trivial.

.....

I'm a little nervous that we exceeded our default pid max just booting
the kernel.  32768 is a lot of kernel threads.  That sounds like 32
kernel threads per cpu.  That seems to be more than I have on any
of my little machines.


There is no defined order for reaping of child processes and in fact
I can't even see anything in the kernel right now that would even
accidentally give user space the idea we had a defined order.

So I think we have some options once we get the kernel threads out
of the way.  Getting the kernel threads out of the way would seem
to be the first priority.

Eric
