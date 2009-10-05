Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZJEOKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZJEOKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZJEOKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:10:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53762 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZJEOKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:10:18 -0400
Message-ID: <4AC9FE13.6060109@us.ibm.com>
Date: Mon, 05 Oct 2009 07:09:23 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Anirban Sinha <ani@anirban.org>,
       linux-kernel@vger.kernel.org, Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com> <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain> <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local> <4AC8CF32.8060108@anirban.org> <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain> <1254738974.26976.24.camel@twins> <1254743934.26976.42.camel@twins> <alpine.LFD.2.00.0910051358060.2646@localhost.localdomain> <1254745119.26976.43.camel@twins> <20091005122436.GA5626@elte.hu>
In-Reply-To: <20091005122436.GA5626@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Mon, 2009-10-05 at 13:59 +0200, Thomas Gleixner wrote:
>>
>>> Stared at the same place a minute ago :) But still I wonder if it's 
>>> a good idea to silently release locks and set the state to OWNERDEAD 
>>> instead of hitting the app programmer with a big clue stick in case 
>>> the app holds locks when calling execve().
>> Agreed, I rather like the feedback. With regular exit like things 
>> there's just not much we can do to avoid the mess, but here we can 
>> actually avoid it, seems a waste not to do so.
> 
> Well, exec() has been a 'exit() + boot-strap next process' kind of thing 
> from the get go - with little state carried over into the new task. This 
> has security and robustness reasons as well.
> 
> So i think exec() should release all existing state, unless told 
> otherwise. Making it behave differently for robust futexes sounds 
> assymetric to me.
> 
> It might make sense though - a 'prevent exec because you are holding 
> locks!' thing. Dunno.
> 
> Cc:-ed a few execve() semantics experts who might want to chime in.
> 
> If a (buggy) app calls execve() with a (robust) futex still held should 
> we auto-force-release robust locks held, or fail the exec with an error 
> code? I think the forced release is a 'anomalous exit' thing mostly, 
> while calling exec() is not anomalous at all.

My first thought earlier in the thread was that changing the exec 
behavior to fail if either a robust or pi futex is held would be liable 
to break existing applications. I can now see the argument that such 
apps are broken already, and if they aren't hanging, it's simply because 
they are hacking around it.

I think the semantics work for robust mutexes, if you exec, the exec'ing 
"thread" is effectively dead, so EOWNERDEAD makes sense.

This doesn't seem to work for PI futexes, unless they are also Robust of 
course.  Here I would expect a userspace application to hang.

The only locking related statements made in the SUS or our Linux man 
pages is in regards to named semaphores.  And here it is only said that 
the semaphore will be closed like a call to sem_close().  sem_close(3) 
doesn't specify a return value if the semaphore is held when called.

The closing of message queues and canceling of any pending asynchronous 
I/O might provide precedent for just unlocking held locks and moving on 
in the case of PI. EOWNERDEAD still makes more sense to me from a robust 
point of view.

And from the ignorant-fool department, the docs refer to replacing the 
"process image" on execve, doesn't that mean that if there are 20 
threads in a process and one of them calls execve that all 20 are 
destroyed?  If so, then we are only concerned with 
PTHREAD_PROCESS_SHARED futexes, since none of the private futexes will 
have any users after the execve.


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
