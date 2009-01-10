Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbZAJBb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbZAJBb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbZAJBbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:31:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbZAJBbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:31:43 -0500
Date: Fri, 9 Jan 2009 17:30:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <1231549697.5700.7.camel@brick>
Message-ID: <alpine.LFD.2.00.0901091713150.6528@localhost.localdomain>
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>  <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>  <20090109204103.GA17212@elte.hu>  <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>  <20090109213442.GA20051@elte.hu>
 <1231537320.5726.2.camel@brick>  <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>  <20090109231227.GA25070@elte.hu>  <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>  <20090110010125.GA31031@elte.hu> <1231549697.5700.7.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Harvey Harrison wrote:

> On Sat, 2009-01-10 at 02:01 +0100, Ingo Molnar wrote:
> 
> >  - Headers could probably go back to 'extern inline' again. At not small 
> >    expense - we just finished moving to 'static inline'. We'd need to 
> >    guarantee a library instantiation for every header include file - this 
> >    is an additional mechanism with additional introduction complexities 
> >    and an ongoing maintenance cost.
> 
> Puzzled?  What benefit is there to going back to extern inline in headers?

There's none. In fact, it's wrong, unless you _also_ have an extern 
definition (according to the "new" gcc rules as of back in the days).

Of course, as long as "inline" really means _always_ inline, it won't 
matter. So in that sense Ingo is right - we _could_. Which has no bearing 
on whether we _should_, of course.

In fact, the whole mess with "extern inline" is a perfect example of why a 
inlining hit should be called "may_inline" or "inline_hint" or something 
like that.

Because then it actually makes sense to have "extern may_inline" with one 
definition, and another definition for the non-inline version.  And it's 
very clear what the deal is about, and why we literally have two versions 
of the same function.

But again, that's very much not a "let's use 'extern' instead of 
'static'". It's a totally different issue.

		Linus

[ A third reason to use "extern inline" is actually a really evil one: we 
  could do it for our unrelated issue with system call definitions on 
  architectures that require the caller to sign-extend the arguments. 

  Since we don't control the callers of system calls, we can't do that, 
  and architectures like s390 actually have potential security holes due 
  to callers that don't "follow the rules". So there are different needs 
  for trusted - in-kernel - system call users that we know do the sign 
  extension correctly, and untrusted - user-mode callers that just call 
  through the system call function table.

  What we _could_ do is for the wrappers to use

	extern inline int sys_open(const char *pathname, int flags, mode_t mode)
	{
		return SYS_open(pathname, mode);
	}

  which gives the C callers the right interface without any unnecessary 
  wrapping, and then

	long WRAP_open(const char *pathname, long flags, long mode)
	{
		return SYS_open(pathname, flags, mode);
	}
	asm ("\t.globl sys_alias\n\t.set WRAP_open");

  which is the one that gets linked from any asm code. So now asm code 
  and C code gets two different functions, even though they use the same 
  system call name - one with inline expansion, one with linker games. 

  Whee. The games we can play (and the odd reasons we must play them). ]
