Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXKZSTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXKZSTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbXKZST3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:19:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbXKZST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:19:28 -0500
Date: Mon, 26 Nov 2007 10:17:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
In-Reply-To: <474323CA.9030306@zytor.com>
Message-ID: <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Nov 2007, H. Peter Anvin wrote:
> 
> If the whole thing about "a dozen new [system calls]" then a dozen system
> calls added to the existing tables are better than this mess.

No it's not.

The point about the indirect calls is that we can do it for other things 
than just a dozen random things that wants this one flag.

We'll eventually want AIO calls for filename lookup etc, for example. 
That's another dozen calls (stat, lstat, open, etc). Having an indirect 
call interface to do these kinds of things would be wonderful, instead of 
having to add new system calls every time some issue with a flag that 
changes behaviour for an already existing system call comes up.

THAT is why I'd much rather have indirect system calls. 

The actual calling convention details are open for debate, of course. We 
could encode the information in the system call number itself, for example 
(eg have a bit there that says "extended information"). But we'll never 
get away from the fact that we have the odd architecture-specific system 
call interfaces with things like "pselect()" having pointers etc, if only 
because of legacy issues.

So we can *never* have a truly "generic" argument marshalling setup. We'll 
have to live with each architecture having system calls with special 
rules: some of those rules will be architecture-specific (eg number of 
easily available registers and/or historical reasons), and a few of the 
rules will be architecture-independent (eg things like sigreturn, clone 
and execve, that need to have direct access to the whole kernel return 
stack and simply *cannot* be called from any indirect code!)

So the choice is basically one of:

 - come up with a totally new interface to system calls, and effectively 
   duplicating the whole system call table.

   I'd hate to do this. We already have duplicated system call tables due 
   to compat stuff, it's painful.

 - just emulate the *existing* interface exactly, but with indirection. 
   IOW, the system call interface on x86 an unconditional "six words in 
   six registers, the meaning of which is totally up to the system call 
   implementation itself".

   This is what Uli's sys_indirect() does.

 - add whole new system calls with extended information, making the 6-word 
   limits even worse, and likely forcing a whole new argument marshalling 
   code with conditionals depending on per-system-call flags, which 
   further complicates it and slows things down.

Quite frankly, I can't really see many other approaches. And of the above 
three ones, the sys_indirect() approach really does seem to be the 
simplest *and* the best-performing. It's basically faster to just 
unconditionally load six registers off an indirect block than it would be 
to have any conditionals based on which system call it is.

		Linus
