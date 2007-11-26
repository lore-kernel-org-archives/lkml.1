Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbXKZTVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbXKZTVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbXKZTVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:21:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbXKZTVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:21:09 -0500
Message-ID: <474B1C6D.6080405@zytor.com>
Date: Mon, 26 Nov 2007 11:20:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 20 Nov 2007, H. Peter Anvin wrote:
>> If the whole thing about "a dozen new [system calls]" then a dozen system
>> calls added to the existing tables are better than this mess.
> 
> No it's not.
> 
> The point about the indirect calls is that we can do it for other things 
> than just a dozen random things that wants this one flag.
> 
> We'll eventually want AIO calls for filename lookup etc, for example. 
> That's another dozen calls (stat, lstat, open, etc). Having an indirect 
> call interface to do these kinds of things would be wonderful, instead of 
> having to add new system calls every time some issue with a flag that 
> changes behaviour for an already existing system call comes up.
> 
> THAT is why I'd much rather have indirect system calls. 

I'm presuming you're not talking about some sort of 
syslets/fibrils/threadlets here (executing an interpreted thread of 
execution in kernel space).  That's a whole separate ball of wax.

> The actual calling convention details are open for debate, of course. We 
> could encode the information in the system call number itself, for example 
> (eg have a bit there that says "extended information"). But we'll never 
> get away from the fact that we have the odd architecture-specific system 
> call interfaces with things like "pselect()" having pointers etc, if only 
> because of legacy issues.
> 
> So we can *never* have a truly "generic" argument marshalling setup. We'll 
> have to live with each architecture having system calls with special 
> rules: some of those rules will be architecture-specific (eg number of 
> easily available registers and/or historical reasons), and a few of the 
> rules will be architecture-independent (eg things like sigreturn, clone 
> and execve, that need to have direct access to the whole kernel return 
> stack and simply *cannot* be called from any indirect code!)

> So the choice is basically one of:
> 
>  - come up with a totally new interface to system calls, and effectively 
>    duplicating the whole system call table.
> 
>    I'd hate to do this. We already have duplicated system call tables due 
>    to compat stuff, it's painful.

This would be the right thing to do if we were to redesign the system 
call interface from the ground up, which it doesn't exactly sound like 
we are intending.

>  - just emulate the *existing* interface exactly, but with indirection. 
>    IOW, the system call interface on x86 an unconditional "six words in 
>    six registers, the meaning of which is totally up to the system call 
>    implementation itself".
> 
>    This is what Uli's sys_indirect() does.
> 
>  - add whole new system calls with extended information, making the 6-word 
>    limits even worse, and likely forcing a whole new argument marshalling 
>    code with conditionals depending on per-system-call flags, which 
>    further complicates it and slows things down.

The 6-word limit is a red herring.  There is at least two ways to deal 
with it (and this doesn't mean wiping the legacy stuff we already have):

- Let each architecture pick a calling convention and redefine the 
architecture-independent bits to take an arbitrary number of arguments. 
  This is a one-time panarchitectural change.

- Define the architecture-independent interface inside the kernel to be 
a 6-word interface and use a marshalling thunk when the number of 
parameters exceed this number.  **This is what we're currently doing.** 
     This is inefficient for s390 (which already has to thunk 
6-parameter functions in its arch layer), but I think all other 
architectures are fine.  Those thunks (stubs) could be generated 
automatically if we wanted to.

So I would advocate admitting that we already broke the 6-word limit and 
abolish it.  Then we can create new system calls that match what the 
user would see.

> Quite frankly, I can't really see many other approaches. And of the above 
> three ones, the sys_indirect() approach really does seem to be the 
> simplest *and* the best-performing. It's basically faster to just 
> unconditionally load six registers off an indirect block than it would be 
> to have any conditionals based on which system call it is.

I find it very hard to see how it could be better performing than 
jumping through a thunk; in fact, for the second option (the one we're 
currently using) when gcc does top-level reordering the thunk (e.g. 
sys_pselect6) SHOULD simply the system call function proper (e.g. 
sys_pselect7).  For one thing, you will have at least one additional 
data-dependent indirect call in the path.

	-hpa

