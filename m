Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXBEUjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXBEUjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933428AbXBEUjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:39:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253AbXBEUjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:39:43 -0500
Date: Mon, 5 Feb 2007 12:39:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org>
 <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
 <20070203082308.GA6748@elte.hu> <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, Davide Libenzi wrote:
>
> No, that's *really* it ;)
>
> The cookie you pass, and the return code of the syscall.
> If there other data transfered? Sure, but that data transfered during the 
> syscall processing, and handled by the syscall (filling up a sys_read 
> buffer just for example).

Indeed. One word is *exactly* what a normal system call returns too.

That said, normally we have a user-space library layer to turn that into 
the "errno + return value" thing, and in the case of async() calls we 
very basically wouldn't have that. So either:

 - we'd need to do it in the kernel (which is actually nasty, since 
   different system calls have slightly different semantics - some don't 
   return any error value at all, and negative numbers are real numbers)

 - we'd have to teach user space about the "negative errno" mechanism, in 
   which case one word really is alwats enough.

Quite frankly, I much prefer the second alternative. The "negative errno" 
thing has not only worked really really well inside the kernel, it's so 
obviously 100% superior to the standard UNIX "-1 + errno" approach that 
it's not even funny. 

To see why "negative errno" is better, just look at any threaded program, 
or look at any program that does multiple calls and needs to save the 
errno not from the last one, but from some earlier one (eg, it does a 
"close()" in between returning *its* error, and the real operation that 
we care about).

> Did I miss something? The async() syscall will allow (with few 
> restrictions) to execute whatever syscall in an async fashion. An syscall 
> returns a result code (long). Plus, you need to pass back the 
> userspace-provided cookie of course.

HOWEVER, they get returned differently. The cookie gets returned 
immediately, the system call result gets returned in-memory only after the 
async thing has actually completed.

I would actually argue that it's not the kernel that should generate any 
cookie, but that user-space should *pass*in* the cookie it wants to, and 
the kernel should consider it a pointer to a 64-bit entity which is the 
return code.

In other words, the only "cookie" we need is literally the pointer to the 
results. And that's obviously something that the user space has to set up 
anyway.

So how about making the async interface be:

	// returns negative for error
	// zero for "synchronous"
	// positive kernel "wait for me" cookie for success
	long sys_async_submit(
		unsigned long flags,
		long *user_result_ptr,
		long syscall,
		unsigned long *args);

and the "args" thing would literally just fill up the registers.

The real downside here is that it's very architecture-specific this way, 
and that means that x86-64 (and other 64-bit ones) would need to have 
emulation layers for the 32-bit ones, but they likely need to do that 
*anyway*, so it's probably not a huge downside. The alternative is to:

 - make a new architecture-independent system call enumeration for the 
   async interface

 - make everything use 64-bit values.
		
Now, making an architecture-independent system call enumeration may 
actually make sense regardless, because it would allow sys_async() to have 
its own system call table and put the limitations and rules for those 
system calls there, instead of depending on the per-architecture system 
call table that tends to have some really architecture-specific details.

Hmm?

		Linus
