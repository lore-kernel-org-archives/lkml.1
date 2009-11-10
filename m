Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZKJQdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZKJQdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZKJQdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:33:32 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:7470 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbZKJQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:33:31 -0500
X-Trace: 287308201/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.123.216/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.123.216
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkFAE4k+UpPRXvY/2dsb2JhbACBTt03hD4E
X-IronPort-AV: E=Sophos;i="4.44,717,1249254000"; 
   d="scan'208";a="287308201"
Date: Tue, 10 Nov 2009 16:33:30 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mark Veltzer <mark.veltzer@gmail.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: get_user_pages question
In-Reply-To: <200911100013.31768.mark.veltzer@gmail.com>
Message-ID: <Pine.LNX.4.64.0911101613080.22198@sister.anvils>
References: <200911090850.26724.mark.veltzer@gmail.com> <87skco59jl.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0911091031460.15199@sister.anvils> <200911100013.31768.mark.veltzer@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009, Mark Veltzer wrote:
> On Monday 09 November 2009 12:32:52 you wrote:
> > On Mon, 9 Nov 2009, Andi Kleen wrote:
> > > Mark Veltzer <mark.veltzer@gmail.com> writes:
> > > > I am testing this kernel module with several buffers from user space
> > > > allocated in several different ways. heap, data segment, static
> > > > variable in function and stack. All scenarious work EXCEPT the stack
> > > > one. When passing the stack buffer the kernel sees one thing while user
> > > > space sees another.
> > >
> > > In theory it should work, stack is no different from any other pages.
> > > First thought was that you used some platform with incoherent caches,
> > > but that doesn't seem to be the case if it's standard x86.
> > 
> > It may be irrelevant to Mark's stack case, but it is worth mentioning
> > the fork problem: how a process does get_user_pages to pin down a buffer
> > somewhere in anonymous memory, a thread forks (write protecting anonymous
> > memory shared between parent and child), child userspace writes to a
> > location in the same page as that buffer, causing copy-on-write which
> > breaks the connection between the get_user_pages buffer and what child
> > userspace sees there afterwards.
> 
> Thanks Hugh and Andi
> 
> Hugh, you actually hit the nail on the head!

I'm glad that turned out to be relevant and helpful.

> 
> I was forking while doing these mappings and the child won the race and got to 
> keep the pinned pages while the parent got left with a copy which meant 
> nothing. The thing is that it was hard to spot because I was using a library 
> function which called a function etc... which eventually did some system(3). 
> It only happened on in stack testing case bacause the child was not really 
> doing anything with the pinned memory on purpose and so in all other cases did 
> not touch the memory except the stack which it, ofcourse, uses. The child won 
> the race in the stack case and so shared the data with the kernel and the 
> parent got a copy with the old data.
> 
> I understand that madvise(2) can prevent this copy-on-write and race between 
> child and parent and I also duplicated it in the kernel using the following 
> code:
> 
> 		[lock the current->mm for writing]
> 			vma=find_vma(current->mm, [user pointer])
> 			vma->vm_flags|=VM_DONTCOPY
> 		[unlock the current->mm for writing]
> 
> The above code is actually a kernel version of madvise(2) and MADV_DONTFORK.
> 
> The problem with this solution (either madvise in user space or DONTCOPY in 
> kernel) is that I give up the ability to fork(2) since the child is left 
> stackless (or with a hold in it's stack - im not sure...)
> 
> My question is: is there a way to allow forking while still pinning STACK 
> memory via get_user_pages? I can actually live with the current solution since 
> I can make sure that the user space thread that does the work with the driver 
> never forks but I'm interested to know what other neat vm tricks linux has up 
> it's sleeve...

I think MADV_DONTFORK is as far as we've gone,
but I might be forgetting something.

In fairness I've added Andrea and KOSAKI-san to the Cc, since I know
they are two people keen to fix this issue once and for all.  Whereas
I am with Linus in the opposite camp: solutions have looked nasty,
and short of bright new ideas, I feel we've gone as far as we ought.

Just don't do that: don't test the incompatibility of GUP pinning
versus COW semantics, by placing such buffers in problematic areas
while forking.

(That sentence might be more convincing if we put in more thought,
to enumerate precisely which areas are "problematic".)

> 
> BTW: would it not be a good addition to the madvise(2) manpage to state that 
> you should be careful with doing madvise(DONTFORK) because you may segfault 
> your children and that doing so on a stack address has even more chance of 
> crashing children ? Who should I talk about adding this info to the manual 
> page? The current manpage that I have only talks about scatter-gather uses of 
> DONTFORK and does not mention the problems of DONTFORK...

Michael looks after the manpages, I've added him to the Cc.
Yes, an additional sentence there might indeed be helpful.

Hugh
