Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXBERCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXBERCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXBERCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:02:35 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53697 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838AbXBERCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:02:34 -0500
In-Reply-To: <20070202222110.GA1212@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <87DE673C-92A0-4401-8DE5-BDC2C08B5F41@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 12:02:05 -0500
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ok, i think i noticed another misunderstanding. The kernel thread  
> based
> scheme i'm suggesting would /not/ 'switch' to another kernel thread in
> the cached case, by default. It would just execute in the original
> context (as if it were a synchronous syscall), and the switch to a
> kernel thread from the pool would only occur /if/ the context is about
> to block. (this 'switch' thing would be done by the scheduler)

Yeah, this is what I imagined when you described doing this with  
threads instead of these 'fibril' things.

It sounds like you're suggesting that we keep the 1:1 relationship  
between task_struct and thread_info.  That would avoid the risks that  
the current fibril approach brings.  It insists that all of  
task_struct is shared between concurrent fibrils (even if only  
between blocking points).  As I understand what Ingo is suggesting,  
we'd instead only explicitly share the fields that we migrate (copy  
or get a reference) as we move the stack from the submitting  
task_struct to a waiting_task struct as the submission blocks.

We trade initial effort to make things safe in the presence of  
universal sharing for effort to introduce sharing as people notice  
deficient behaviour.  If that's the way we prefer to go, I'm cool  
with that.  I might have gone slightly nuts in preferring *identical*  
sync and async behaviour.

The fast path would look almost identical to the existing fibril  
switch.  We'd just have a few more fields to sync up between the two  
task_structs.

Ingo, am I getting this right?  This sounds pretty straight forward  
to prototype from the current patches.  I can certainly give it a try.

> it's quite cheap to 'flip' it to under any arbitrary user-space  
> context:
> change its thread_info->task pointer to the user-space context's task
> struct, copy the mm pointer, the fs pointer to the "worker thread",
> switch the thread_info, update ptregs - done. Hm?

Or maybe you're talking about having concurrent executing  
thread_info's pointing to the user-space submitting task_struct?   
That really does sound like the current fibril approach, with even  
more sharing of thread_info's that might be executing on other cpus?

Either way, I want to give it a try.  If we can measure it performing  
reasonably in the cached case then I think everyone's happy?

> is not part of the signal set. (Although it might make sense to make
> such async syscalls interruptible, just like any syscall.)

I think we all agree that they have to be interruptible by now,  
right?  If for no other reason than to interrupt pending poll with no  
timeout, say, as the task exits..

> The 'pool' of kernel threads doesnt even have to be per-task, it  
> can be
> a natural per-CPU thing

Yeah, absolutely.

- z
