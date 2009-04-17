Return-Path: <linux-kernel-owner+w=401wt.eu-S1760496AbZDQP6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496AbZDQP6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZDQP6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:58:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697AbZDQP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:58:42 -0400
Date: Fri, 17 Apr 2009 08:55:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
In-Reply-To: <20090417091321.GP4593@kernel.dk>
Message-ID: <alpine.LFD.2.00.0904170813550.4042@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090417063007.GB4593@kernel.dk> <49E83DC4.8040207@tuffmail.co.uk> <20090417091321.GP4593@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Jens Axboe wrote:
> 
> Given the somewhat odd nature of the bug and the requirements to trigger
> it, how confident are you in the bisection results?

I suspect it's timing-dependent. 

The failure case is a ENOMEM returned from the "echo disk > /sys/power/state", 
and sadly there are a _lot_ of potential sources of ENOMEM's in the path. 
And a numbe of them come from GFP_ATOMIC allocations etc.

Now, that explains why it only happens while in X (more memory being 
used), and also why it succeeds the second time (the first try will have 
triggered VM activity and then free'd the pages it allocated up to that 
point).

IOW, I bet it would work on the first try if you were to just run 
something like

	ptr = malloc(BIGNUM);
	memset(ptr, 0, BIGNUM);
	exit(0);

first - just to make room for stuff.

And the thing is, swsusp_save() really does do odd things. For example, to 
get rid of unnecessary memory, it does "drain_local_pages()", where the 
"local" is "local cpu". Why does it do that? Likely nobody knows.

Now, that won't matter in Alan's case (he is UP), but the point is, the 
swsuspend code does these random things to try to free up memory, and I 
suspect it's mostly been a trial-and-error thing. And then subtle changes 
in memory usage when allocating or writing things out will change things.

For example, there is a magic "PAGES_FOR_IO" #define, which is somewhat 
arbitrarily set to 4MB worth of pages. Where did that number come from? 
Who knows? But that's the number the code uses for the _initial_ check of 
"do we have enough memory" (the one that must have passed, since it 
actually started doing things and didn't print out a warning message).

Anyway, from the dmesg, we can see:

	[   41.873619] PM: Shrinking memory...  Restarting tasks ... done.

and this is a clear indication that it's "swsusp_shrink_memory()" that 
failed. If it had succeeded, you'd have seen

	PM: Shrinking memory... done (xyz pages freed)

but it returned an error case, and then the suspend fails and starts 
restarting tasks.

And the thing is, that "swsusp_shrink_memory()" is just full of 
heuristics. There's no hard numbers there. It doesn't seem to wait for 
writeout, it just does the equivalent of "shrink_list()" and 
"shrink_slab()", but it seems to have been basically cribbed half-way 
from the regular "try to free memory", without really doing it all.

Just as an example: it does that "zone_is_all_unreclaimable()" logic that 
expects kswapd to mark things reclaimable again, but it doesn't seem to 
actually ever wait for kswapd or pdflush. It also seems to set 
"swappiness" to zero etc. Maybe it's all intentional, but it does mean 
that it uses some shared heuristics with the "real" VM, but uses them 
differently.

		Linus
