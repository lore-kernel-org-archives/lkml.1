Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYKQVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYKQVTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYKQVTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:19:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbYKQVTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:19:11 -0500
Date: Mon, 17 Nov 2008 13:18:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0811171309580.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Steven Rostedt wrote:
> 
> Here's my stack after boot up with CONFIG_IRQSTACKS set. Seems that 
> softirqs still use the same stack as the process.

Yes.

> This is still 12K. Kind of big even for a 16K stack.

And while that 1kB+ stack slot for block_read_full_page still stands out 
like a sore thumb, I do agree that there's way too many other functions 
too with big stack frames.

I do wonder just _what_ it is that causes the stack frames to be so 
horrid. For example, you have

	 18)     8896     160   .kmem_cache_alloc+0xfc/0x140

and I'm looking at my x86-64 compile, and it has a stack frame of just 8 
bytes (!) for local variables plus the save/restore area (which looks like 
three registers plus frame pointer plus return address). IOW, if I'm 
looking at the code right (so big caveat: I did _not_ do a real stack 
dump!) the x86-64 stack cost for that same function is on the order of 48 
bytes. Not 160.

Where does that factor-of-three+ difference come from? From the numbers, I 
suspect ppc64 has a 32-byte stack alignment, which may be part of it, and 
I guess the compiler is more eager to use all those extra registers and 
will happily have many more callee-saved regs that are actually used.

But that still a _lot_ of extra stack.

Of course, you may have things like spinlock debugging etc enabled. Some 
of our debugging options do tend to blow things up.

			Linus
