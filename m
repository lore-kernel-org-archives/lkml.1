Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZAJFyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZAJFyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbZAJFyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:54:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46146 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJFyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:54:07 -0500
Message-ID: <496837FC.6010405@us.ibm.com>
Date: Fri, 09 Jan 2009 21:54:04 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] RFC: futex fault handling and futex key references (NOT
 FOR INCLUSION)
References: <20090109075148.2226.5222.stgit@Aeon> <1231538564.29452.16.camel@twins>
In-Reply-To: <1231538564.29452.16.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-01-08 at 23:52 -0800, Darren Hart wrote:
>> While trying to bend my brain around the various layers of fault handling in
>> futex.c, I think I may have uncovered some logical errors (or at least stale
>> code sections).  I've attached two patches that address the alleged problems
>> against linux-tip/core/futexes.  They are based on the following assumption:
>>
>> Since the uaddr passed to a futex function isn't updated within the function,
>> and the mm doesn't change while we're in there, 
> 
> That's not quite true, you _can_ change the memory map by issuing
> concurrent mmap/munmap/mremap etc.. calls from another thread.

Well, what I meant was that the pointer "current->mm" doesn't change, 
since that is what we store in the futex key union.

> The thing is, afaik futexes have never been completely safe wrt
> concurrent mm modifications -- that is, as long as we fail the futex op
> with -EFAULT or similar and not crash the kernel we're good.
> 
>> there should never be a need to
>> make repeat calls to futex_get_key().  Even if the queue_lock is dropped, the
>> futex_q might lose it's waiter (requeued) but the key stays the same.
> 
> Yes, so when we assume the mmap stable (and fail the op whenever that
> assumption proves false) we can say the futex keys are stable and should
> never need recomputation.

And if I understand correctly, we would catch this scenario any time we 
try to use uaddr and find it faulting (during the cmpxchg* calls for 
example).  If the mmap changes too much, we'll exhaust our fault 
tolerance (3) and exit with -EFAULT back to userspace.

Sound right?

Thanks for the review Peter,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
