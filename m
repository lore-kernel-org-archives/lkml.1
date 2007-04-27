Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbXD0Pxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbXD0Pxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbXD0Pxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:53:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032AbXD0Pxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:53:45 -0400
Date: Fri, 27 Apr 2007 08:52:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Johannes Berg <johannes@sipsolutions.net>,
       Alan Stern <stern@rowland.harvard.edu>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Adrian Bunk <bunk@stusta.de>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] driver power operations (was Re: suspend2 merge)
In-Reply-To: <200704271720.08150.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704270842430.9964@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
 <1177684764.3565.20.camel@johannes.berg> <1177685391.3565.22.camel@johannes.berg>
 <200704271720.08150.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Rafael J. Wysocki wrote:
> 
> I think we can use 'stages' and pass them as arguments to the functions.

No, no NOOOO!

If you use stages, just describe them in the function name instead.	

> quiesce(PREPARE) -- that may be needed for drivers that allocate much memory
> before quiescing devices (if any)
> ...
> quiesce(PRE_SNAPSHOT)
> ...
> quiesce(PRE_SNAPSHOT_IRQ_OFF)

There is *no* advantage to this (and _lots_ of disadvantages) compared to 
saying

	dev->snapshot_prepare(dev);
	dev->snapshot_freeze(dev);
	dev->snapshot(dev)

The latter is
 - more readable
 - MUCH easier for programmers to write readable code for (if-statements 
   and case-statements are *by*definition* more complicated to parse both 
   for humans and for CPU's - static information is good)
 - allows for the different stages to have different arguments, and 
   somewhat related to that, to have better static C type checking.

Look here, which one is more readable:

	int some_mixed_function(int arg)
	{
		do_one_thing();
		if (arg == SLEEP)
			do_another_thing();
		else
			do_yet_another_thing();
	}

or

	int do_sleep(void)
	{
		do_one_thing();
		do_another_thing();
	}

	int prepare_to_sleep(void)
	{
		do_one_thing();
		do_yet_another_thing();
	}

and quite frankly, while the second case may take more lines of code, 
anybody who says that it's not clearer what it does (because it can 
"self-document" with function names etc) is either lying, or just a really 
bad programmer. The second case is also likely faster and probably not 
larger code-size-wise either, since it does static decisions _statically_ 
(since all callers are realistically going to use a constant argument 
anyway, and the argument really is static).

Finally, the second case is *much* easier to fix, exactly because it 
doesn't mix up the cases. You can change the arguments, you can have 
totally different locking, you don't need things like

	int gfp = (arg == SLEEP) ? GFP_ATOMIC : GFP_KERNEL;

etc, and it's just more logical.

So don't overload a function. That's the *bug* with the current 
"dev->suspend()" interface already. Don't re-create it. The current one 
overloads two *totally*different* operations onto one function. 

Just don't do it. Not in the suspend part, not *ever*.

		Linus
