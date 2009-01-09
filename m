Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZAIQKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZAIQKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZAIQKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:10:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbZAIQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:09:59 -0500
Date: Fri, 9 Jan 2009 08:09:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <20090109133710.GB31845@elte.hu>
Message-ID: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
 <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Ingo Molnar wrote:
>  
> -static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
> +static __asm_inline int
> +constant_test_bit(int nr, const volatile unsigned long *addr)
>  {
>  	return ((1UL << (nr % BITS_PER_LONG)) &
>  		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;

Thios makes absolutely no sense.

It's called "__always_inline", not __asm_inline.

Why add a new nonsensical annotations like that?

Also, the very fact that gcc gets that function wrong WHEN 'nr' IS 
CONSTANT (which is when it is called) just shows what kind of crap gcc is!

Ingo, the fact is, I care about size, but I care about debuggability and 
sanity more. I don't care one _whit_ about 3% size differences, if they 
are insane and cause idiotic per-compiler differences.

And you haven't done any interesting analysis per-file etc. It shoul be 
almost _trivial_ to do CONFIG_OPTIMIZE_INLINING on/off tests for the whole 
tree, and then comparing sizes of individual object files, and see if we 
find some obvious _bug_ where we just inline too much.

In fact, we shouldn't even do that - we should try to find a mode where 
gcc simply refuses to inline at all, and compare that to one where it 
_only_ inlines the things we ask it to. Because that's the more relevant 
test. The problem with gcc inlining is actually two-fold:

 - gcc doesn't inline things we ask for

   Here the sub-problem is that we ask for this too much, but see above on 
   how to figure -that- out!

 - gcc _does_ inline things that we haven't marked at all, causing too 
   much stack-space to be used, and causing debugging problems.

   And here the problem is that gcc should damn well not do that, at least 
   not as aggressively as it does!

IT DOES NOT MATTER if something is called in just one place and inlining 
makes things smaller! If it's not a clear performance win (and it almost 
never is, unless the function is really small), the inlining of especially 
functions that aren't even hot in the cache is ONLY a negative thing.

		Linus

