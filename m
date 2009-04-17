Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZDQUfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZDQUfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZDQUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:35:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbZDQUfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:35:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
Date: Fri, 17 Apr 2009 22:34:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <20090417091321.GP4593@kernel.dk> <alpine.LFD.2.00.0904170813550.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904170813550.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172234.36366.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Linus Torvalds wrote:
> 
> On Fri, 17 Apr 2009, Jens Axboe wrote:
> > 
> > Given the somewhat odd nature of the bug and the requirements to trigger
> > it, how confident are you in the bisection results?
> 
> I suspect it's timing-dependent. 
> 
> The failure case is a ENOMEM returned from the "echo disk > /sys/power/state", 
> and sadly there are a _lot_ of potential sources of ENOMEM's in the path. 
> And a numbe of them come from GFP_ATOMIC allocations etc.
> 
> Now, that explains why it only happens while in X (more memory being 
> used), and also why it succeeds the second time (the first try will have 
> triggered VM activity and then free'd the pages it allocated up to that 
> point).
> 
> IOW, I bet it would work on the first try if you were to just run 
> something like
> 
> 	ptr = malloc(BIGNUM);
> 	memset(ptr, 0, BIGNUM);
> 	exit(0);
> 
> first - just to make room for stuff.
> 
> And the thing is, swsusp_save() really does do odd things. For example, to 
> get rid of unnecessary memory, it does "drain_local_pages()", where the 
> "local" is "local cpu". Why does it do that? Likely nobody knows.
> 
> Now, that won't matter in Alan's case (he is UP), but the point is, the 
> swsuspend code does these random things to try to free up memory, and I 
> suspect it's mostly been a trial-and-error thing. And then subtle changes 
> in memory usage when allocating or writing things out will change things.
> 
> For example, there is a magic "PAGES_FOR_IO" #define, which is somewhat 
> arbitrarily set to 4MB worth of pages. Where did that number come from? 
> Who knows? But that's the number the code uses for the _initial_ check of 
> "do we have enough memory" (the one that must have passed, since it 
> actually started doing things and didn't print out a warning message).
> 
> Anyway, from the dmesg, we can see:
> 
> 	[   41.873619] PM: Shrinking memory...  Restarting tasks ... done.

Ah, thanks for pointing this out to me!
 
> and this is a clear indication that it's "swsusp_shrink_memory()" that 
> failed. If it had succeeded, you'd have seen
> 
> 	PM: Shrinking memory... done (xyz pages freed)
> 
> but it returned an error case, and then the suspend fails and starts 
> restarting tasks.

AFAICS, there's only one possible situation in which that can happen,
which is when shrink_all_memory() returns 0 and there was the assumption
that this could not happen unless there _really_ was no memory to free.
Apparently, that has recently changed and it is now possible that
shrink_all_memory() returns 0, even though there still is some memory to free.

At the moment I don't see what change caused that to happen, but shouldn't we
put .nr_reclaimed = 0 in the definition of sc in shrink_all_memory()?

Rafael
