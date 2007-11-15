Return-Path: <linux-kernel-owner+w=401wt.eu-S1764607AbXKORCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764607AbXKORCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbXKORCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:02:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758688AbXKORCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:02:44 -0500
Date: Thu, 15 Nov 2007 09:02:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] x86&x86-64 support for sys_indirect
In-Reply-To: <200711151641.lAFGfMow024336@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.0.9999.0711150852470.2786@woody.linux-foundation.org>
References: <200711151641.lAFGfMow024336@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Ingo, Thomas - see the whole series on linux-kernel ]

On Thu, 15 Nov 2007, Ulrich Drepper wrote:
>
> This part adds support for sys_indirect on x86 and x86-64.

The thing is, not all system calls can do this.

Some system calls are magic, and don't just take the arguments in 
registers: they also care about the actual stack pointer and the whole 
pt_regs struct when returning to user mode. 

So this does need more infrastructure: some way of marking which system 
calls cannot be executed indirectly.

The magic system calls are things like:

 - sys_iopl() - this one changes the eflags value restored on iret
 - execve/clone/vfork() - need direct access to pt_regs
 - vm86() - does magic with the stack, cares about pt_regs
 - sigreturn - magic pt_regs accesses again

and there may be others I have forgotten about.

Calling these system calls from C code will just corrupt the kernel stack, 
and is a big big no-no.

		Linus
