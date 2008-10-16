Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYJPT3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYJPT3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYJPT3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:29:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbYJPT3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:29:04 -0400
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
In-Reply-To: Alan Stern's message of  Thursday, 16 October 2008 10:12:41 -0400 <Pine.LNX.4.44L0.0810161007560.2487-100000@iolanthe.rowland.org>
References: <20081016002555.808EF1544CB@magilla.localdomain>
	<Pine.LNX.4.44L0.0810161007560.2487-100000@iolanthe.rowland.org>
X-Zippy-Says: I own seven-eighths of all the artists in downtown Burbank!
Message-Id: <20081016192247.20F831542DA@magilla.localdomain>
Date: Thu, 16 Oct 2008 12:22:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not sure you should change vdr6 when notify_die returns NOTIFY_STOP.
> > Maybe Alan and I hashed out the logic of this before, I don't recall.
> > If the notifier is eating the event, then it should not affect the
> > thread-virtualized view of %db6.  That would be consistent with the
> > existing code, where ->thread.debugreg6 is only set later when all the
> > intercepted or spurious exceptions have been filtered out.
> 
> I think we have to leave the code as it is.  As each notifier routine 
> processes the event, it will turn off the corresponding bits in vdr6.  
> We don't want those bits to get turned back on again by overwriting 
> vdr6 after the notifier chain has finished.

Ah, I now almost remember discussing this before.  We went around with the
notifier getting a pointer to "condition" to clear its bits, etc.  So there
is a special requirement for DIE_DEBUG notifiers to fiddle the vdr6 bits.
That ought to be documented somewhere or other, as well as clearly
commented in do_debug itself.

And what does it mean exactly?  The bits that should be left in thread.vdr6
are the virtualized bits, not the raw hardware bits.  That is, the low four
bits might need to be reordered from the actual hardware order.

And what about this scenario?

1. do_debug hits for %db3, being used for a ptrace user watchpoint
   -> vdr6 = hardware %db6 = 0x...08
   -> send SIGTRAP
2. do_debug hits for %db0, being used for an in-kernel hw_breakpoint
   -> hardware clears the low four bits before setting one of them
   -> vdr6 = hardware %db6 = 0x...01
   -> vdr6 &= ~1 = 0x...00
   -> run hw_breakpoint callback
3. try to return to user, deliver SIGTRAP to ptrace'ing debugger
4. debugger does PTRACE_PEEKUSR u_debugreg[6]
   -> read vdr6 = 0x...00
   -> wtf? where is my db3 hit?

To get this scenario correct, the virtual db6 bits for ptrace need to
remain set when there is a later do_debug that ptrace won't see.


Thanks,
Roland
