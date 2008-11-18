Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbYKRBFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbYKRBFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYKRBF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:05:29 -0500
Received: from ozlabs.org ([203.10.76.45]:49313 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbYKRBF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:05:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18722.5316.582974.95373@cargo.ozlabs.ibm.com>
Date: Tue, 18 Nov 2008 12:05:08 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.DEB.1.10.0811171936480.26123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
	<alpine.LFD.2.00.0811171309580.18283@nehalem.linux-foundation.org>
	<alpine.DEB.1.10.0811171936480.26123@gandalf.stny.rr.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve,

> On Mon, 17 Nov 2008, Linus Torvalds wrote:
> > 
> > I do wonder just _what_ it is that causes the stack frames to be so 
> > horrid. For example, you have
> > 
> > 	 18)     8896     160   .kmem_cache_alloc+0xfc/0x140
> > 
> > and I'm looking at my x86-64 compile, and it has a stack frame of just 8 
> > bytes (!) for local variables plus the save/restore area (which looks like 
> > three registers plus frame pointer plus return address). IOW, if I'm 
> > looking at the code right (so big caveat: I did _not_ do a real stack 
> > dump!) the x86-64 stack cost for that same function is on the order of 48 
> > bytes. Not 160.
> 
> Out of curiosity, I just ran stack_trace on the latest version of git 
> (pulled sometime today) and ran it on my x86_64.
> 
> I have SLUB and SLUB debug defined, and here's what I found:
> 
>  11)     3592      64   kmem_cache_alloc+0x64/0xa3
> 
> 64 bytes, still much lower than the 160 of PPC64.

The ppc64 ABI has a minimum stack frame of 112 bytes, due to having an
area for called functions to store their parameters (64 bytes) plus 6
slots for saving stuff and for the compiler and linker to use if they
need to.  That's before any local variables are allocated.

The ppc32 ABI has a minimum stack frame of 16 bytes, which is much
nicer, at the expense of a much more complicated va_arg().

Paul.
