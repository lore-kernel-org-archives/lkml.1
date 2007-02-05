Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbXBERon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbXBERon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXBERon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:44:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22375 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXBERom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:44:42 -0500
In-Reply-To: <20070203082308.GA6748@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org> <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org> <20070203082308.GA6748@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 12:44:00 -0500
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But really, being a scheduler guy i was much more concerned about the
> duplication and problems caused by the fibril concept itself - which
> duplication and complexity makes up 80% of Zach's submitted patchset.
> For example this bit:
>
>    [PATCH 3 of 4] Teach paths to wake a specific void * target
>
> would totally go away if we used kernel threads for this.

Uh, would it?  Are you talking about handing off the *task_struct*  
that it was submitted under to each worker thread that inherits the  
stack?

I guess I hadn't considered going that far.  I had somehow  
constructed a block in my mind that we couldn't release the  
task_struct from the submitting task.  But maybe we can be clever  
enough with the task_struct updating that userspace wouldn't notice a  
significant change.

Hmm.

> i totally agree that the API /should/ be the main focus - but i didnt
> pick the topic and most of the patchset's current size is due to  
> the IMO
> avoidable fibril concept.

I, too, totally agree.  I didn't even approach the subject for  
exactly the reason you allude to -- I wanted to get the hard parts of  
the kernel side right first.

> regarding the API, i dont really agree with the current form and  
> design
> of Zach's interface.

Haha, well, yes, of course.  You couldn't have thought that the dirt- 
stupid sys_asys_wait_for_completion() was anything more than simple  
scaffolding to test the kernel bits.

> fundamentally, the basic entity of this thing should be a /system  
> call/,
> not the artificial fibril thing:
>
>   +struct asys_call {
>   +       struct asys_result      *result;
>   +       struct fibril           fibril;
>   +};

You picked a weird struct to highlight here.  struct asys_input seems  
more related to the stuff you go on to discuss below.  This asys_call  
struct is a relatively irrelevant internal detail of how  
asys_teardown_stack() gets from a fibril to the pre-allocated  
completion state once the call has returned.

> The normal and most optimal workflow should be a user-space ring- 
> buffer
> of these constant-size struct async_syscall entries:
>
>   struct async_syscall ringbuffer[1024];
>
>   LIST_HEAD(submitted);
>   LIST_HEAD(pending);
>   LIST_HEAD(completed);

I strongly disagree here, and I'm hoping you're not as keen on this  
now -- your reply to Matt gives me hope.

As mentioned, that they complete out-of-order leads, at least, to  
having separate submission and completion rings.  I'm not sure a  
submission ring makes any sense given the goal of processing the  
calls in submission and only creating threads if it blocks.  A simple  
copy of an array of these input structs sounds fine to me.

When I think about the completion side I tend to hope we can end up  
with something like what VJ talked about in his net channels work.   
producer/consumer rings with head and tail pointers in different  
cache lines.  AFAIK the kevent work has headed in that direction, but  
I haven't kept up.  Uli has certainly mentioned it in his 'ec' (event  
channels) proposals.

The posix AIO list completion and, sadly, signals on completion need  
to be considered, too.

Honestly, though, I'm not worried about this part.  We'll easily come  
to an agreement.  I'm just not going to distract myself with it until  
we're happy with the scheduler side.

> Looks like we can hit many birds with this single stone: AIO, vectored
> syscalls, finegrained system-call parallelism. Hm?

Hmm, indeed.  Some flags could let userspace tell the kernel not to  
bother with all this threading/concurrency/aio nonsense and just  
issue them serially.  It'll sound nuts in these days of cheap  
syscalls and vsyscall helpers, but some Oracle folks might love this  
for issuing a gettimeofday() pair around syscalls they want to profile.

I hadn't considered that as a potential property of this interface.

- z
