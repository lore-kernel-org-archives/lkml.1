Return-Path: <linux-kernel-owner+w=401wt.eu-S1422663AbXCBAox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663AbXCBAox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422660AbXCBAox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:44:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60137 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422667AbXCBAow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:44:52 -0500
Date: Thu, 1 Mar 2007 16:41:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
In-Reply-To: <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703011631380.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
 <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk>
 <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk>
 <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk>
 <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu>
 <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu>
 <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Mar 2007, Linus Torvalds wrote:
> 
> Once you have that, you now actually have a way to "correct" for that 
> known bug, and by correcting for the known bug, you now *can* separate the 
> behaviour of the two bugs:
> 
>  - You can now re-do a totally mindless git bisection for the *other* bug, 
>    but what you now need to do is that at each bisection step, you look at 
>    whether the bisection point has the known bug, and if so, you apply the 
>    known fix for that known bug, and thus you can test the kernel 
>    *without* the interaction of the bug you already found.
> 
> This makes bisection a lot less automated (you have to apply the "fix" for 
> the other bug at each step)

Side note: it's still usually fairly easy. Especially if you have a known 
fix for the other bug, you can usually just do the equivalent of

	git cherry-pick <fixcommit>

at each point during this bisect (or just have a known patch that you keep 
applying and un-applying), and you're largely done.

Of course, if the area with the fix keeps changing, or if the fix is 
really intrusive and nasty, this gets hairy, but at least in this case the 
patch is fairly trivial and it shouldn't cause any trouble at all to do 
this.

The only real down-side is just the mindless extra work, and the possible 
added confusion you get from modifying the history at the points you're 
testing. "git bisect" is not necessarily happy about auto-picking a new 
bisection point with a dirty tree, for example, so before you mark 
something "good" or "bad", you should generally try to do so with a clean 
git tree (ie if you apply a patch at each stage, do "git reset --hard" to 
remove the patch before you do the "git bisect bad/good" stage).

Similarly, especially at the end of the bisection run, if you actually use 
"git cherry-pick" to *add* a commit, the bisection will now take that 
added commit into account when trying to pick the next commit to check, 
which is not what you really want. It probably doesn't matter that much 
during the early stages (when bisection is really jumping around wildly 
anyway, and one commit more or less doesn't really matter), but again, it 
might be a good idea to make a habit of undoing the cherry-pick, the same 
way you'd undo a patch (eg "git reset --hard HEAD^" would do it, if you 
have exactly one cherry-pick that you tested).

		Linus
