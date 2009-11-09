Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZKIWNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZKIWNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZKIWNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:13:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38581 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZKIWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:13:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=J4dlLdkKNSl60AK4o86aAFdwu+6OdN/3bh3FnQUFkNUz1VqY8OeTfUrz5crHrOvw3r
         Xs2udp3miHwJIMvElTJ+XWQZWWWc9EM8LdrfMdjeH8oqQhzvGgLsRdFYJfbOxboQtd3n
         KwYx+jWBeRXxiIyLGkKEYjvSwgeoWkl93Jppw=
From: Mark Veltzer <mark.veltzer@gmail.com>
Organization: veltzer.net
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: get_user_pages question
Date: Tue, 10 Nov 2009 00:13:31 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-1-686; KDE/4.3.2; i686; ; )
References: <200911090850.26724.mark.veltzer@gmail.com> <87skco59jl.fsf@basil.nowhere.org> <Pine.LNX.4.64.0911091031460.15199@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0911091031460.15199@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911100013.31768.mark.veltzer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009 12:32:52 you wrote:
> On Mon, 9 Nov 2009, Andi Kleen wrote:
> > Mark Veltzer <mark.veltzer@gmail.com> writes:
> > > I am testing this kernel module with several buffers from user space
> > > allocated in several different ways. heap, data segment, static
> > > variable in function and stack. All scenarious work EXCEPT the stack
> > > one. When passing the stack buffer the kernel sees one thing while user
> > > space sees another.
> >
> > In theory it should work, stack is no different from any other pages.
> > First thought was that you used some platform with incoherent caches,
> > but that doesn't seem to be the case if it's standard x86.
> 
> It may be irrelevant to Mark's stack case, but it is worth mentioning
> the fork problem: how a process does get_user_pages to pin down a buffer
> somewhere in anonymous memory, a thread forks (write protecting anonymous
> memory shared between parent and child), child userspace writes to a
> location in the same page as that buffer, causing copy-on-write which
> breaks the connection between the get_user_pages buffer and what child
> userspace sees there afterwards.
> 
> Hugh
> 

Thanks Hugh and Andi

Hugh, you actually hit the nail on the head!

I was forking while doing these mappings and the child won the race and got to 
keep the pinned pages while the parent got left with a copy which meant 
nothing. The thing is that it was hard to spot because I was using a library 
function which called a function etc... which eventually did some system(3). 
It only happened on in stack testing case bacause the child was not really 
doing anything with the pinned memory on purpose and so in all other cases did 
not touch the memory except the stack which it, ofcourse, uses. The child won 
the race in the stack case and so shared the data with the kernel and the 
parent got a copy with the old data.

I understand that madvise(2) can prevent this copy-on-write and race between 
child and parent and I also duplicated it in the kernel using the following 
code:

		[lock the current->mm for writing]
			vma=find_vma(current->mm, [user pointer])
			vma->vm_flags|=VM_DONTCOPY
		[unlock the current->mm for writing]

The above code is actually a kernel version of madvise(2) and MADV_DONTFORK.

The problem with this solution (either madvise in user space or DONTCOPY in 
kernel) is that I give up the ability to fork(2) since the child is left 
stackless (or with a hold in it's stack - im not sure...)

My question is: is there a way to allow forking while still pinning STACK 
memory via get_user_pages? I can actually live with the current solution since 
I can make sure that the user space thread that does the work with the driver 
never forks but I'm interested to know what other neat vm tricks linux has up 
it's sleeve...

BTW: would it not be a good addition to the madvise(2) manpage to state that 
you should be careful with doing madvise(DONTFORK) because you may segfault 
your children and that doing so on a stack address has even more chance of 
crashing children ? Who should I talk about adding this info to the manual 
page? The current manpage that I have only talks about scatter-gather uses of 
DONTFORK and does not mention the problems of DONTFORK...

Thanks in advance
	Mark
