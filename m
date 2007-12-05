Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbXLEGO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbXLEGO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 01:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXLEGOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 01:14:48 -0500
Received: from sineb-mail-2.sun.com ([192.18.19.7]:40056 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbXLEGOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 01:14:47 -0500
Date: Wed, 05 Dec 2007 16:14:46 +1000
From: David Holmes - Sun Microsystems <David.Holmes@Sun.COM>
Subject: Re: [PATCH -v2] fix for futex_wait signal stack corruption
In-reply-to: <alpine.LFD.0.9999.0712042151250.13796@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <475641D6.1060409@sun.com>
Organization: Sun Microsystems
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1196801858.1645.37.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
 <20071204213924.GA14915@goodmis.org>
 <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com>
 <alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042135030.18314@gandalf.stny.rr.com>
 <alpine.LFD.0.9999.0712041935140.13796@woody.linux-foundation.org>
 <4756382D.4040904@sun.com>
 <alpine.LFD.0.9999.0712042151250.13796@woody.linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for clarifying that Linus.

Regards,
David Holmes

Linus Torvalds said the following on  5/12/07 04:06 PM:
> 
> On Wed, 5 Dec 2007, David Holmes - Sun Microsystems wrote:
>> While this was observed with process control signals, my concern was that
>> other signals might cause pthread_cond_timedwait to return immediately in the
>> same way. The test program allows for SIGUSR1 and SIGRTMIN testing as well,
>> but these other signals did not cause the immediate return. But it would seem
>> from Steven's analysis that this is just a fortuitous result. If I understand
>> things correctly, any interruption of pthread_cond_timedwait by a signal,
>> could result in waiting until an arbitrary time - depending on how the stack
>> value was corrupted. Is that correct?
> 
> No, very few things can actually cause the restart_block path to be taken. 
> An actual signal execution would turn that into an EINTR, the only case 
> that should ever trigger this is a signal that causes some kernel action 
> (ie the system call *is* interrupted), but does not actually result in any 
> user-visible state changes.
> 
> The classic case is ^Z + bg, but iirc you can trigger it with ptrace too. 
> And I think two threads racing to pick up the same signal can cause it 
> too, for that matter (ie one thread takes the signal, the other one got 
> interrupted but there's nothing there, so it just causes a system call 
> restart).
> 
> There's basically two different system call restart mechanisms in the 
> kernel:
> 
>  - returning -ERESTARTNOHAND will cause the system call to be restarted 
>    with the *original* arguments if no signal handler was actually 
>    invoked. This has been around for a long time, and is used by a lot of 
>    system calls. It's fine for things that are idempotent, ie the argument 
>    meaning doesn't change over time (things like a "read()" system call, 
>    for example)
> 
>  - the "restart_block" model that returns -ERESTARTBLOCK, which will cause 
>    the system call to be restarted with the arguments specified in the 
>    system call restart block. This is for system calls that are *not* 
>    idempotent, ie the argument might be a relative timeout or something 
>    like that, where we need to actually behave *differently* when 
>    restarting.
> 
> The latter case is "new" (it's been around for a while, but relative to 
> the ERESTARTNOHAND one), and it relies on the system call itself setting 
> up its restart point and the argument save area. And each such system call 
> can obviously screw it up by saving/restoring the arguments with the 
> incorrect semantics.
> 
> So this bug was really (a) specific to that particular futex restart 
> mechanism, and (b) only triggers for the (rather unusual) case where the 
> system call gets interrupted by a signal, but no signal handler actually 
> happens. In practice, ^Z is the most common case by far (other signals are 
> either ignored and don't even cause an interrupt event in the first place, 
> or they are "real" signals, and cause a signal handler to be invoked).
> 
> 			Linus
