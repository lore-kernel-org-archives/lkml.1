Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZIZQ3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZIZQ3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZIZQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:29:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbZIZQ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:29:05 -0400
Date: Sat, 26 Sep 2009 09:28:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Theodore Ts'o" <tytso@mit.edu>
cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge
 commit
In-Reply-To: <E1MrRDa-0002WF-LO@closure.thunk.org>
Message-ID: <alpine.LFD.2.01.0909260909140.3303@localhost.localdomain>
References: <E1MrRDa-0002WF-LO@closure.thunk.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Sep 2009, Theodore Ts'o wrote:
> 
> One of the things I've been trying to track for the last couple of days
> is a suspend/resume regression which I've noticed on my T400 Lenovo
> laptop.  I first noticed it on a 2.6.31-git9 kernel with a some
> additional ext4 patches.  I've since bisected it to the following merge
> commit: a03fdb76.  The commit does have some merge conflict fix ups, but
> only for the some files in the m68knommu and mips architectures.

Yeah, no conflicts on the x86 side. But there can obviously be 
interactions between the timer changes and the other changes, although 
looking at it that does look rather unlikely.

One thing that _can_ be done for these kinds of merge conflicts is to just 
turn the merge into rebase, and then bisecting that rebase. So in this 
case, you could do something like this:

	# Check out the timer side of the merge
	git checkout -b timer-branch a03fdb76^2

	# instead of merging it into the mainline, rebase it on top of it
	git rebase a03fdb76^

	# resolve the trivial problem in arch/mips/lemote/lm2e/setup.c
	# the same way the merge did (do the 'git add' just to make 
	# checkout happy
	git rm arch/mips/lemote/lm2e/setup.c
	git rebase --continue

and now you have the exact same tree as the merge resulted in (apart from 
the 'arch/mips/loongson/common/time.c' that was broken in the merge 
anyway, but that also doesn't matter), and now you can bisect the series 
and see exactly _which_ commit it is that has problems.

So now you can just bisect it by doing

	git bisect start
	git bisect bad timer-branch
	git bisect good a03fdb76

and off you go.

The above is a generic way to handle bisection problems with merges, 
although admittedly it only really works in practice for the simple cases 
(if there is lots and lots of independent development on both sides, it's 
not going to be a reasonable thing to do).

That said, I do wonder if you're hitting some timing-dependent thing. The 
whole "second suspend fails" is not an uncommon problem case. Others have 
had it, and it's possible that it's not going to be the actual merge that 
is the problem, but that just some odd combination of code ends up hitting 
the case that causes it for you. But the bisect above should still be 
interesting, since it will point to _some_ commit that triggers it, and 
then we can say whether that commit makes sense or not..

		Linus
