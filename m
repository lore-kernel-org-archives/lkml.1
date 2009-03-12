Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbZCLC22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbZCLC22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZCLC1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:27:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbZCLC1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:27:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 04/11] Introduce virtual debug register in
	thread_struct and wrapper-routines around process related functions
In-Reply-To: Ingo Molnar's message of  Tuesday, 10 March 2009 15:35:43 +0100 <20090310143543.GE3850@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com>
	<20090305043830.GE17747@in.ibm.com>
	<20090310143543.GE3850@elte.hu>
X-Zippy-Says: Hey!!  Let's watch the' ELEVATOR go UP and DOWN at th' HILTON HOTEL!!
Message-Id: <20090312022650.C00DDFC3B6@magilla.sf.frob.com>
Date: Wed, 11 Mar 2009 19:26:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> detached from thread_struct? There's a lot of complications 
> (alloc/free, locking, etc.) from this for no good reason - the 
> hardware-breakpoints info structure is alway per thread and is 
> quite small, so there's no reason not to embedd it directly 
> inside thread_struct.

I do certainly think it's worthwhile to use a coherent struct type here
rather than many fields in thread_struct, independent of the allocation for
it being direct or indirect (not that you objected to that).  That makes
the code read cleaner, and should make it a minor change to most of the
code later if the allocation plan changes.

I think in the original effort another motivating factor was concern about
bloating the size of thread_struct.  The struct thread_hw_breakpoint is at
least a few times the size of the set old fields it replaces.  We were
concerned that inflating every task's thread_struct for the benefit of
these rarely-used fancy new features might meet resistance from arch
maintainers like you.  If that issue doesn't hold you back from taking the
new code, then I think we are more than happy to start with thread_struct
directly containing a struct thread_hw_breakpoint member.

I do think we'll want to make it a pointer with later incremental changes.
(But those may not need to come very soon.)  Firstly, the size reduction to
task_struct is fairly compelling since it's for the vast majority of tasks
which never need to allocate it.  The hair potential is really not very
much at least to begin with, if you just make it allocate on first setup
and never free (no locking et al, just if (thread->hwbkpt) ...).  Second,
eventually we'd like to have the possibility of sharing the struct among
threads.  This will come later on when we have higher-level things that
would like to set common watchpoints on a whole group of threads (what
debuggers usually really do).  Such APIs are far improved and optimized by
updating many threads together, and when a big app has thousands of threads
to which all the same watchpoints apply, sharing at low level makes many of
those intraprocess context switches quicker.  As I said, all in the future.
But it's far from being entirely baseless to think a pointer makes good sense.


Thanks,
Roland
