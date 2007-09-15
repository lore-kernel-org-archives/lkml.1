Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbXIOTp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbXIOTp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbXIOTpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:45:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbXIOTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:45:20 -0400
Date: Sat, 15 Sep 2007 12:44:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
In-Reply-To: <46EC2702.3090000@oracle.com>
Message-ID: <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
 <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Sep 2007, Randy Dunlap wrote:
> 
> Had another on recent last night (probably not helpful):

At least the original "crashme" would write its random number seeds to a 
logfile each time (and I made it fsync it in some versions), which meant 
that once a crash happened, you could re-produce it immediately (if it was 
reproducible at all, of course).

Does your crashme have something like that?

All your crashes look basically identical - I don't think there is 
anything new in this one, they're all the same issue. What CPU do you have 
- vendor, stepping, version etc - and has something else than the kernel 
changed in your setup lately?

As mentioned, the crash does look like a user-level crash got reported as 
a kernel page fault, and while a CPU bug sounds incredibly unlikely, this 
does have the smell of something strange like a fault in the middle of an 
"iretq" or "sysretq", where part of the CPU state has already been 
restored - which would explain why rip/cs is user space - but some part of 
the CPU is still in kernel mode - which would explain the incorrect page 
fault error code.

Here's a really *stupid* patch (and untested too, btw) to see if it gets 
easier to debug when you don't oops, just print the register state 
instead.

(It might be interesting to also do something like

	force_sig_specific(SIGSTOP, current);

to then be able to more easily attach to the process that had problems, 
and debug it in user space to see what was going on..)

		Linus
---
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 327c9f2..1b81392 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -320,6 +320,11 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 
 	info.si_code = SEGV_MAPERR;
 
+	if (!(error_code & PF_USER) && user_mode(regs)) {
+		printk("kernel mode page fault from user space? Huh?\n");
+		__show_regs(regs);
+		error_code |= PF_USER;
+	}
 
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
