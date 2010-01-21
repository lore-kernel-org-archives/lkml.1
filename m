Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601Ab0AUTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab0AUTTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502Ab0AUTTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:19:23 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5743 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab0AUTTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:19:22 -0500
Message-ID: <4B58A89A.8050405@caviumnetworks.com>
Date: Thu, 21 Jan 2010 11:18:50 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
References: <1263932978.31321.53.camel@gandalf.stny.rr.com>
In-Reply-To: <1263932978.31321.53.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jan 2010 19:18:50.0767 (UTC) FILETIME=[904211F0:01CA9ACE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Peter Zijlstra and I were doing a look over of places that assign
> current->state = TASK_*INTERRUPTIBLE, by simply looking at places with:
> 
>  $ git grep -A1 'state[[:space:]]*=[[:space:]]*TASK_[^R]'
> 
> and it seems there are quite a few places that looks like bugs. To be on
> the safe side, everything outside of a run queue lock that sets the
> current state to something other than TASK_RUNNING (or dead) should be
> using set_current_state().
> 
> 	current->state = TASK_INTERRUPTIBLE;
> 	schedule();
> 
> is probably OK, but it would not hurt to be consistent. Here's a few
> examples of likely bugs:
> 
[...]

This may be a bit off topic, but exactly which type of barrier should 
set_current_state() be implying?

On MIPS, set_mb() (which is used by set_current_state()) has a full mb().

Some MIPS based processors have a much lighter weight wmb().  Could 
wmb() be used in place of mb() here?

If not, an explanation of the required memory ordering semantics here 
would be appreciated.

I know the documentation says:

     set_current_state() includes a barrier so that the write of
     current->state is correctly serialised wrt the caller's subsequent
     test of whether to actually sleep:

  	set_current_state(TASK_UNINTERRUPTIBLE);
  	if (do_i_need_to_sleep())
  		schedule();


Since the current CPU sees the memory accesses in order, what can be 
happening on other CPUs that would require a full mb()?


Thanks,
David Daney
