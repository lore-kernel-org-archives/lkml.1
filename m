Return-Path: <linux-kernel-owner+w=401wt.eu-S1946292AbXBIKV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946292AbXBIKV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946311AbXBIKV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:21:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946292AbXBIKV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:21:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: Alan Stern's message of  Wednesday, 7 February 2007 14:22:13 -0500 <Pine.LNX.4.44L0.0702071356580.4502-100000@iolanthe.rowland.org>
X-Shopping-List: (1) Paradoxical Garden Weasel temptations
   (2) Anachronistic inversion dividers
   (3) Previous relaxers
Message-Id: <20070209102124.1DF3618003C@magilla.sf.frob.com>
Date: Fri,  9 Feb 2007 02:21:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> All right.  However this means thread_struct will have to grow in order to
> hold each task's debug-register allocations and priorities.  Would that be
> acceptable?  (This might be a good reason to keep the number of bits
> down.)

Well, noone seems to mind the wasted debugreg[5..6] words. ;-) 

I'm inclined to make thread_struct smaller than it is now by making it
indirect (debugreg[8] -> one pointer).  It feels like this would be pretty
safe now that we have TIF_DEBUG anyway.  Already nothing should be looking
at the field when TIF_DEBUG isn't set.

> Another question: How can a program using the ptrace API ever give up a
> debug-register allocation?  Disabling the register isn't sufficient; a
> user program should be able to store a watchpoint address in dr1, enable
> it in dr7, disable it in dr7, and then re-enable it in the expectation
> that the address stored in dr1 hasn't been overwritten.  As far as I can
> see, ptrace-type allocations have to be permanent (until the task exits or
> execs, or uses some other to-be-determined API to do the de-allocation.)

I hadn't really thought about this before, but it's pretty straightforward.
Each allocation is for one of %dr[0-3] and for its associated bits in %dr7.
%dr0 and bits 0,1,16-19; %dr1 and bits 2,3,20-23; etc.
%dr7 & (0x000f0003 << N) for %drN, I guess it is.
((((1 << DR_CONTROL_SIZE) - 1) << DR_CONTROL_SHIFT) |
 ((1 << DR_ENABLE_SIZE) - 1)) << N, I should say.

Each allocation owns those 38 bits (70 bits on x86_64).  When all those
bits are zero, the allocation is not active and might as well not be there
(except for whatever semantics you might want to have about an allocation's
lifetime as distinct from the event of resetting its contents).  

gdb already works this way: when it removes a watchpoint, it clears drN to
zero when it zeros all the corresponding bits in dr7.  (In fact it's in a
separate call after changing dr7, because of the ptrace interface.)

Your question made me think about the %dr6 issue, too, which I also hadn't
thought about before.  It looks like your patch handles this correctly, but
it's a subtle point that I think warrants some comments in the code.  When
userland inserts a watchpoint and it's hit, it gets a SIGTRAP via do_debug
and eventually looks at dr6 (via ptrace) to see what happened.  Kernel
watchpoints that come along after the user signal is generated can clobber
the CPU %dr6 with new hits, but userland should not perceive this.  This
works out because what userland sees is thread.debugreg[6], the only place
that sets it is do_debug, and a kwatch hit bails out before changing it.
Any other new users of the debugreg sharing interface need to be cognizant
of the %dr6 issue to avoid stepping on old ptrace uses.


Thanks,
Roland
