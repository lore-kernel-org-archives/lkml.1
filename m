Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYJQPzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYJQPzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbYJQPzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:55:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53340 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758079AbYJQPzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:55:08 -0400
Date: Fri, 17 Oct 2008 11:55:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 3/9] Modifying generic debug exception to use virtual
 debug registers
In-Reply-To: <20081016192247.20F831542DA@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0810171138510.2178-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Roland McGrath wrote:

> Ah, I now almost remember discussing this before.  We went around with the
> notifier getting a pointer to "condition" to clear its bits, etc.  So there
> is a special requirement for DIE_DEBUG notifiers to fiddle the vdr6 bits.
> That ought to be documented somewhere or other, as well as clearly
> commented in do_debug itself.
> 
> And what does it mean exactly?  The bits that should be left in thread.vdr6
> are the virtualized bits, not the raw hardware bits.  That is, the low four
> bits might need to be reordered from the actual hardware order.
> 
> And what about this scenario?
> 
> 1. do_debug hits for %db3, being used for a ptrace user watchpoint
>    -> vdr6 = hardware %db6 = 0x...08
>    -> send SIGTRAP
> 2. do_debug hits for %db0, being used for an in-kernel hw_breakpoint
>    -> hardware clears the low four bits before setting one of them
>    -> vdr6 = hardware %db6 = 0x...01
>    -> vdr6 &= ~1 = 0x...00
>    -> run hw_breakpoint callback
> 3. try to return to user, deliver SIGTRAP to ptrace'ing debugger
> 4. debugger does PTRACE_PEEKUSR u_debugreg[6]
>    -> read vdr6 = 0x...00
>    -> wtf? where is my db3 hit?
> 
> To get this scenario correct, the virtual db6 bits for ptrace need to
> remain set when there is a later do_debug that ptrace won't see.

I seem to recall doing some experiments to find out which bits in DR6
the CPU would set and which it would clear.  According to the 386
manual the processor never clears any of the bits, but this was changed
in later models.  And I seem to recall that the experiments showed that
gdb would not clear the bits either; it relied on the CPU to clear
them.

A kernel breakpoint shouldn't affect the task's virtualized view of
DR6.  But only the hw-breakpoint notifier handler knows whether a 
particular exception was caused by a kernel breakpoint.  Conversely, 
that handler knows _only_ about the 4 low-order bits in DR6; it can't 
virtualize any of the other bits.

So this means that do_debug shouldn't modify the four low bits in vdr6.  
Instead the hw-breakpoint handler should do whatever is needed to set 
them properly: Leave them alone when a kernel breakpoint occurs, 
otherwise clear them and set the bit corresponding to the user 
breakpoint.  In fact, the new ptrace_triggered() routine does set the 
appropriate bit in vdr6.

I don't know how we should handle the BT (debug trap) and BS 
(single-step exception) bits.  Maybe the kprobes code can take care of 
them.

Alan Stern

