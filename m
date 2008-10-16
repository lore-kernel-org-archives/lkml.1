Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbYJPO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbYJPO1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYJPO1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:27:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56926 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753389AbYJPO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:27:05 -0400
Date: Thu, 16 Oct 2008 10:27:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 6/9] Use virtual debug registers in process/thread
 handling code
In-Reply-To: <20081016014407.81BDA1544CB@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0810161014270.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Roland McGrath wrote:

> +/*
> +	 * Handle debug registers.  This must be done _after_ current
> +	 * is updated.
> +	 */
> +	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
> +		switch_to_thread_hw_breakpoint(next_p);
> 
> It would be good if we could arrange that this works before current changes.
> That way it says in __switch_to_xtra, which is off the hot path.

There's a problem with moving the switch_to_thread_hw_breakpoint() call 
before current is updated.  Suppose a kernel breakpoint is triggered in 
between the two.  The hw-breakpoint handler will see that current is 
different from the task pointer stored in the chbi area, so it will 
think the task pointer is leftover from an old task (lazy switching) 
and will erase it.  Then until the next context switch, no 
user-breakpoints will be installed.

The real problem is that it's impossible to update both current and 
chbi->bp_task at the same instant, so there will always be a window in 
which they disagree and a breakpoint might get triggered.  Since we use 
lazy switching, we are forced to assume that a disagreement means that 
current is correct an chbi->bp_task is old.  But if you move the code 
above then you'll create a window in which current is old and 
chbi->bp_task is correct.

Alan Stern

