Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYJQXZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYJQXZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYJQXZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:25:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbYJQXZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:25:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/linus
Cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 3/9] Modifying generic debug exception to use virtual
 debug registers
In-Reply-To: Alan Stern's message of  Friday, 17 October 2008 11:55:07 -0400 <Pine.LNX.4.44L0.0810171138510.2178-100000@iolanthe.rowland.org>
References: <20081016192247.20F831542DA@magilla.localdomain>
	<Pine.LNX.4.44L0.0810171138510.2178-100000@iolanthe.rowland.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081017232430.9F48C1544CB@magilla.localdomain>
Date: Fri, 17 Oct 2008 16:24:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I seem to recall doing some experiments to find out which bits in DR6
> the CPU would set and which it would clear.  According to the 386
> manual the processor never clears any of the bits, but this was changed
> in later models.  And I seem to recall that the experiments showed that
> gdb would not clear the bits either; it relied on the CPU to clear
> them.

Current Intel manuals say, "Certain debug exceptions may clear bits 0-3.
The remaining cntents of the DR6 register are never cleared by the processor."

Your experiments told us that "certain debug exceptions" includes at least
the data breakpoint hits.  I assume that what it really means is all the
exceptions that set one of those four bits, i.e. ones due to DR[0-3] use.
Perhaps someone from Intel can clarify exactly what it means.

> So this means that do_debug shouldn't modify the four low bits in vdr6.  
[...]

Right.

> I don't know how we should handle the BT (debug trap) and BS 
> (single-step exception) bits.  Maybe the kprobes code can take care of 
> them.

BT is for task switch with TSS.T set.  I don't think that can ever happen
in Linux, since we don't use hardware task-switching.  If at all, maybe in
vm86 mode.  I don't think there's a way to do it just from user_ldt.

I think BS (DR_STEP) should get set in vdr6 only when a SIGTRAP is
generated for the exception.  It should never get cleared by the system,
only by PTRACE_POKEUSR.  That is consistent with what we get now, AFAICT.

I don't think kprobes should "take care of" DR_STEP.  It should eat a
DR_STEP that it's responsible for, and leave any others alone.  i.e.,
CONFIG_KPROBE=n must not break the normal bookkeeping.

IIRC there can be one do_debug trap that's for both a breakpoint register
hit and a single-step (TF), with DR_STEP plus DR_TRAPn both set at once.
To handle that too, I think this will work:

do_debug does:
 
	get_debugreg(condition, 6);
	set_debugreg(0, 6);

Make sure the hw_breakpoint notifier is before the kprobes notifier.
hw_breakpoint is responsible for the low 4 bits of vdr6 and leaves its
other bits alone.  It returns NOTIFY_STOP iff both this hit is not a ptrace
hit and hardware %db6 (args->err) has no other nonreserved bits set.

kprobes stays as it, returns NOTIFY_STOP iff it's swallowing the step.
do_debug stays mostly the same, replace:

	tsk->thread.debugreg6 = condition;

with:

	tsk->thread.vdr6 &= DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3;
	tsk->thread.vdr6 |= condition & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);


Thanks,
Roland

