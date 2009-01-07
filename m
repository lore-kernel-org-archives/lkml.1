Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbZAGVkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbZAGVkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZAGVjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:39:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZAGVjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:39:51 -0500
Date: Wed, 7 Jan 2009 13:39:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
In-Reply-To: <alpine.LFD.2.00.0901071314490.3057@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901071325470.3057@localhost.localdomain>
References: <1231279660.11687.121.camel@twins> <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
 <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org>
 <alpine.LFD.2.00.0901071314490.3057@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Linus Torvalds wrote:
> 
> We've needed that before (and yes, we've simply mis-used __get_user() on 
> x86 before rather than add it).

Ahh, yeah, we have a really broken form of this in probe_kernel_address(), 
but it's disgustingly slow. And it actually does a whole lot more, since 
it is designed for addresses that we can't trust.

The thing about "thread->cpu" is that we can actually _trust_ the address, 
so we know it's not a user address or anything like that. So we don't need 
the whole pagefault_disable/enable around it. At least the x86 page fault 
handler knows that it absolutely must not take the mm semaphore for these 
things, for example (because it would be an insta-deadlock for the vmalloc 
space and thus any mm fault handlers in filesystems that are modules).

So we would be better off without that, but we could certainly also 
improve probe_kernel_address() if we had a better model. IOW, we *could* 
do something like

	#define get_kernel_mode(val, addr) __get_user(val, addr)

on the simple platforms, and then in the generic <linux/uaccess.h> code we 
can just do

	#ifndef get_kernel_mode
	 #define get_kernel_mode(val, addr) ({  \
		long _err;			\
		mm_segment_t old_fs = get_fs(); \
		set_fs(KERNEL_DS);		\
		_err = __get_user(val, addr);	\
		set_fs(old_fs);			\
		_err; })
	#endif

and then probe_kernel_address becomes

	#define probe_kernel_address(addr, val) ({	\
		long _err;				\
		pagefault_disable();			\
		_err = get_kernel_mode(val, addr);	\
		pagefault_enable();			\
		_err; })

which leaves all architectures with the trivial option to just define 
their own 'get_kernel_mode()' thing that _often_ is exactly the same as
__get_user().

Hmm? Anybody want to test it? 

				Linus
