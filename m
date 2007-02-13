Return-Path: <linux-kernel-owner+w=401wt.eu-S1750974AbXBMUSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbXBMUSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXBMUSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:18:25 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4226 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbXBMUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:18:23 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 13 Feb 2007 12:18:16 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
In-Reply-To: <20070213142042.GG638@elte.hu>
Message-ID: <Pine.LNX.4.64.0702131117120.32055@alien.or.mcafeemobile.com>
References: <20070213142042.GG638@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Wow! You really helped Zach out ;)



On Tue, 13 Feb 2007, Ingo Molnar wrote:

> +The Syslet Atom:
> +----------------
> +
> +The syslet atom is a small, fixed-size (44 bytes on 32-bit) piece of
> +user-space memory, which is the basic unit of execution within the syslet
> +framework. A syslet represents a single system-call and its arguments.
> +In addition it also has condition flags attached to it that allows the
> +construction of larger programs (syslets) from these atoms.
> +
> +Arguments to the system call are implemented via pointers to arguments.
> +This not only increases the flexibility of syslet atoms (multiple syslets
> +can share the same variable for example), but is also an optimization:
> +copy_uatom() will only fetch syscall parameters up until the point it
> +meets the first NULL pointer. 50% of all syscalls have 2 or less
> +parameters (and 90% of all syscalls have 4 or less parameters).

Why do you need to have an extra memory indirection per parameter in 
copy_uatom()? It also forces you to have parameters pointed-to, to be 
"long" (or pointers), instead of their natural POSIX type (like fd being 
"int" for example). Also, you need to have array pointers (think about a 
"char buf[];" passed to an async read(2)) to be saved into a pointer 
variable, and pass the pointer of the latter to the async system. Same for 
all structures (ie. stat(2) "struct stat"). Let them be real argouments 
and add a nparams argoument to the structure:

struct syslet_atom {
       unsigned long                       flags;
       unsigned int                        nr;
       unsigned int                        nparams;
       long __user                         *ret_ptr;
       struct syslet_uatom     __user      *next;
       unsigned long                       args[6];
};

I can understand that chaining syscalls requires variable sharing, but the 
majority of the parameters passed to syscalls are just direct ones.
Maybe a smart method that allows you to know if a parameter is a direct 
one or a pointer to one? An "unsigned int pmap" where bit N is 1 if param 
N is an indirection? Hmm?





> +Running Syslets:
> +----------------
> +
> +Syslets can be run via the sys_async_exec() system call, which takes
> +the first atom of the syslet as an argument. The kernel does not need
> +to be told about the other atoms - it will fetch them on the fly as
> +execution goes forward.
> +
> +A syslet might either be executed 'cached', or it might generate a
> +'cachemiss'.
> +
> +'Cached' syslet execution means that the whole syslet was executed
> +without blocking. The system-call returns the submitted atom's address
> +in this case.
> +
> +If a syslet blocks while the kernel executes a system-call embedded in
> +one of its atoms, the kernel will keep working on that syscall in
> +parallel, but it immediately returns to user-space with a NULL pointer,
> +so the submitting task can submit other syslets.
> +
> +Completion of asynchronous syslets:
> +-----------------------------------
> +
> +Completion of asynchronous syslets is done via the 'completion ring',
> +which is a ringbuffer of syslet atom pointers user user-space memory,
> +provided by user-space in the sys_async_register() syscall. The
> +kernel fills in the ringbuffer starting at index 0, and user-space
> +must clear out these pointers. Once the kernel reaches the end of
> +the ring it wraps back to index 0. The kernel will not overwrite
> +non-NULL pointers (but will return an error), user-space has to
> +make sure it completes all events it asked for.

Sigh, I really dislike shared userspace/kernel stuff, when we're 
transfering pointers to userspace. Did you actually bench it against a:

int async_wait(struct syslet_uatom **r, int n);

I can fully understand sharing userspace buffers with the kernel, if we're 
talking about KB transferd during a block or net I/O DMA operation, but 
for transfering a pointer? Behind each pointer transfer(4/8 bytes) there 
is a whole syscall execution, that makes the 4/8 bytes tranfers have a 
relative cost of 0.01% *maybe*. Different case is a O_DIRECT read of 16KB 
of data, where in that case the memory transfer has a relative cost 
compared to the syscall, that can be pretty high. The syscall saving 
argument is moot too, because syscall are cheap, and if there's a lot of 
async traffic, you'll be fetching lots of completions to keep you dispatch 
loop pretty busy for a while.
And the API is *certainly* cleaner.



- Davide


