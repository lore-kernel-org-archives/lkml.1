Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZKSOba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZKSOba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZKSOb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:31:29 -0500
Received: from www.tglx.de ([62.245.132.106]:44988 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZKSOb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:31:29 -0500
Date: Thu, 19 Nov 2009 15:30:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: BUG: function graph tracer function frame assumptions
In-Reply-To: <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cOn Thu, 19 Nov 2009, Thomas Gleixner wrote:
> On Thu, 19 Nov 2009, Ingo Molnar wrote:
> > i've bisected back to it:
> > 
> > | 887a29f59b93cf54e21814869a4ab6e80b6fa623 is the first bad commit
> > | commit 887a29f59b93cf54e21814869a4ab6e80b6fa623
> > | Author: Feng Tang <feng.tang@intel.com>
> > | Date:   Thu Sep 3 16:32:53 2009 +0800
> > |
> > |    hrtimer: Fix /proc/timer_list regression
> > 
> > Config attached.
> > 
> > I've removed it from timers/urgent for now.
> 
> Come on, this is a patently wrong conclusion.
> 
> We call timer_stats_update_stats() which returns on top of the
> function due to:
> 
> 	if (likely(!timer_stats_active))
> 		return;
> 
> timer_stats_active is 0 during boot and you can only activate it by
> writing to /proc/timer_stats which you certainly did not at this
> point.
> 
> Can you please explain how a call to a function which returns right
> away can cause that problem ? 
> 
> That patch unearthed some other bug and your revert is just papering
> over that fact.

Looked deeper into that and found the root cause.

The function graph tracer expects that the first code sequence in a
function is:

function_start:
	 push	%ebp
	 mov	%esp, %ebp
	 ....
	 call   mcount

and on the return side:

       	 pop	%ebp
	 ret

which is the case for most functions except, but not for all

timer_stats_update_stats() and a few others have:

function_start:
	push   %edi
	lea    0x8(%esp),%edi
	and    $0xfffffff0,%esp
	pushl  -0x4(%edi)
	push   %ebp
	mov    %esp,%ebp
	...
	call   mcount

and the return does:

	pop    %ebp
	lea    -0x8(%edi),%esp
	pop    %edi
	ret

mcount calls prepare_ftrace_return() with the following calling sequence:

        pushl	%eax
        pushl	%ecx
        pushl	%edx
        movl	0xc(%esp), %edx
        lea	0x4(%ebp), %eax

Here is where the shit hits the fan.

For the usual function frames this is correct:

ebp points to the stack location where ebp was pushed and ebp + 4
points to the return address.

For the timer_stats_update_stats case points to the stack location
where ebp was pushed _BUT_ ebp + 4 is pointing to a stack entry
_BELOW_ the return address.

        movl	(%ebp), %ecx
        subl	$MCOUNT_INSN_SIZE, %edx
        call	prepare_ftrace_return
        popl	%edx
        popl	%ecx
        popl	%eax
        ret

prepare_ftrace_return does:

void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
			   unsigned long frame_pointer)
{
	unsigned long old;
	int faulted;
	unsigned long return_hooker = (unsigned long)
				&return_to_handler;

	asm volatile(
		"1: " _ASM_MOV " (%[parent]), %[old]\n"
		"2: " _ASM_MOV " %[return_hooker], (%[parent])\n"
		"   movl $0, %[faulted]\n"
		"3:\n"

So here we modify the "return" address on the stack where parent is
supposed to point to. That works for the standard function frames, but
not for the ones which look like timer_stats_update_stats().

In the timer_stats_update_stats() case we do not call the
return_to_handler when the function returns, because we did not modify
the return address. So the next return in the calling function will
trip over the sanity checking and panic.

I'm not yet sure whether this is a compiler problem (using gcc 4.4.1)
or just the stupid assumption that function frames always start with

	push	%ebp
	mov	%esp, %ebp

Thanks,

	tglx
