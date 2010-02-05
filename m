Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab0BEVFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:05:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386Ab0BEVFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:05:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
Subject: Re: [patch] x86: ptrace and core-dump extensions for xstate
In-Reply-To: Suresh Siddha's message of  Thursday, 4 February 2010 14:05:14 -0800 <1265321114.2768.256.camel@sbs-t61.sc.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<1265315329.2768.167.camel@sbs-t61.sc.intel.com>
	<20100204205543.E1D11E7@magilla.sf.frob.com>
	<1265321114.2768.256.camel@sbs-t61.sc.intel.com>
X-Zippy-Says: When you said ``HEAVILY FORESTED'' it reminded me of an overdue
    CLEANING BILL..  Don't you SEE?  O'Grogan SWALLOWED a VALUABLE
    COIN COLLECTION and HAD to murder the ONLY MAN who KNEW!!
Message-Id: <20100205210249.7B486E7@magilla.sf.frob.com>
Date: Fri,  5 Feb 2010 13:02:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland, All I found after double checking is:
> 
> > For now, only first 8 bytes of the sw_usable_bytes[464..467]
> 
> should be
> 
> > For now, only first 8 bytes of the sw_usable_bytes[464..471]

I didn't notice that one, because I didn't check any of your arithmetic.

> Let me know if I am overlooking something.

I only meant the pure English errors.  Here is the comment with some
grammar and punctuation fixed:

+/*
+ * The structure layout used in PTRACE_GETXSTATEREGS/PTRACE_SETXSTATEREGS is
+ * the same as the memory layout of xsave used by the processor (except
+ * for the bytes 464..511, which can be used by the software).  The size
+ * of the structure that users need to use for these two interfaces can be
+ * obtained by doing:
+ * 	cpuid_count(0xd, 0, &eax, &ptrace_xstateregs_struct_size, &ecx, &edx);
+ * i.e., cpuid.(eax=0xd,ecx=0).ebx will be the size that user (debuggers, etc.)
+ * need to use.
+ *
+ * The format of this structure will be like:
+ * 	struct {
+ * 		fxsave_bytes[0..463]
+ * 		sw_usable_bytes[464..511]
+ * 		xsave_hdr_bytes[512..575]
+ * 		avx_bytes[576..831]
+ * 		future_state etc
+ * 	}
+ *
+ * The same memory layout will be used for the core-dump NT_X86_XSTATE
+ * note representing the xstate registers.
+ *
+ * For now, only the first 8 bytes of the sw_usable_bytes[464..471] will
+ * be used and will be set to OS enabled xstate mask (which is same as the
+ * 64bit mask returned by the xgetbv's xCR0).  Users (analyzing core dump
+ * remotely, etc.) can use this mask as well as the mask saved in the
+ * xstate_hdr bytes and interpret what states the processor/OS supports
+ * and what states are in modified/initialized conditions for the
+ * particular process/thread.
+ *
+ * Also when the user modifies certain state FP/SSE/etc through this
+ * PTRACE_SETXSTATEREGS, they must ensure that the xsave_hdr.xstate_bv
+ * bytes[512..519] of the above memory layout are updated correspondingly.
+ * i.e., for example when FP state is modified to a non-init state,
+ * xsave_hdr.xstate_bv's bit 0 must be set to '1', when SSE is modified to
+ * non-init state, xsave_hdr.xstate_bv's bit 1 must to be set to '1', etc.
+ */

> Yes. No size limit as of now.

Ok.  Thanks for the clear answer.

> Ok. I think I can agree, if we are ok with giving room for the ptrace
> (or any other user of the API) to make a mistake and corrupt reg-state
> of the process under debug, if it doesn't follow rules.

This is not new, and it's not a problem.  The bottom line is that ptrace
can do whatever the process could have done to itself.

> Thought some of them might be only relevant to core-dump or based on
> permissions etc. But I guess get/set routines of the regset should be
> able to take care of this?

The whole point of user_regset is that whatever user-space machine state
there is to be had can be accessed consistently by whatever means.  If
there is something that you don't want debuggers to be able to access, then
user_regset is not where it belongs.  There is no rationale I can imagine
for having something in a core dump but not readable by debuggers when the
process is still alive.

The only issue that I can imagine you might be referring to when you say
"based on permissions etc." is state that you cannot set arbitrarily from
user mode.  The only such example we have is NT_386_IOPERM, which you just
cannot set at all via user_regset.  If we were to allow debuggers to change
that data at all, then its .set function would need to do some permission
checking.  

For everything else that is really part of the user-mode register state per
se, it just doesn't make sense to think about any kind of "permission
checking" beyond the simple masks applied to eflags, mxcsr, etc.  The
debugger can make the user process do anything that the process could do
itself, which of course includes changing all its registers.

> So in the example you provided before:
> 
>         struct iovec iov = { mybuffer, mylength };
>         ret = ptrace(PTRACE_GETREGSET, NT_X86_XSTATE, &iov);
> 
> You wanted to propose common data format (iov) for all of the NT_* ?

I'm not sure I understand your question.  The iovec is just API trivia,
part of communicating "I want this regset and I want these bytes of it".
This has nothing to do with the actual data format of each regset.


Thanks,
Roland
