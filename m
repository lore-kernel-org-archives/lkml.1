Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbYJRPfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbYJRPfM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYJRPe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:34:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2349 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751115AbYJRPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:34:58 -0400
Date: Sat, 18 Oct 2008 11:34:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 6/9] Use virtual debug registers in process/thread
 handling code
In-Reply-To: <20081018000829.519111544CB@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0810181123220.1469-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Roland McGrath wrote:

> > There's a problem with moving the switch_to_thread_hw_breakpoint() call 
> > before current is updated. [...]
> 
> I got this.  I'm just saying let's look for ways to do this better.
> 
> Hmm.  The 64-bit version of __switch_to does the current change much
> earlier, before __switch_to_xtra and math_state_restore.  I wonder if the
> 32-bit version could change to match.  I can't see what in __switch_to_xtra
> would care either way, though I may be overlooking something.  Ingo?

Would it be better to move __switch_to_xtra down below the change to 
current, rather than moving the change to current up above 
__switch_to_xtra?

> If this does not change, then __switch_to_xtra can pass prev,next to
> switch_hw_breakpoint.  You can always do some slightly different
> bookkeeping in there to know that prev->next is the switch happening,
> so if there is a hit when current still == prev you can filter it out.

The cpu_hw_breakpoint structure would have to keep track of two tasks:  
the one whose breakpoints are currently loaded and the task that
preceded it.  When a breakpoint occurs and current is not equal to the
first task, we would skip clearing the user-breakpoint registers if
current was equal to the second.

But then what happens when the system alternates between running two 
tasks, one of which is being debugged and the other isn't?  The task 
not being debugged would constantly encounter breakpoints meant for the 
other task, because the breakpoint registers wouldn't get cleared.

Alan Stern

