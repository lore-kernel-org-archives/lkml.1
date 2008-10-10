Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbYJJRYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbYJJRYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758855AbYJJRYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:24:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758159AbYJJRYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:24:12 -0400
Date: Fri, 10 Oct 2008 10:23:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #2 - PAT updates
In-Reply-To: <20081010165647.GA4363@elte.hu>
Message-ID: <alpine.LFD.2.00.0810101005160.3503@nehalem.linux-foundation.org>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org> <20081010164537.GA23664@elte.hu> <20081010165647.GA4363@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:
> 
> Correction: i did the reverts shortly before applying the v2 series - so 
> it was fully technical. I wanted to do a line by line review of the fix 
> (and did it), because the lockup took quite some time to pin down. To 
> avoid this mistake i could also have hard-reset the full v1 series and 
> could have redone the whole topic.
> 
> What's the best Git way to avoid such mishaps? I try to avoid resets and 
> rebases of already pushed out bits as much as possible, because that is 
> both risky because information can be lost and asocial because ongoing 
> work of contributors can be disturbed.

There's a couple of things you could have done.

The simplest approach is to kill the branch. Of course, you could do that 
with just a "git reset", but if you had already pushed the branch out and 
it wasn't one of the "gets rebased" branches, that's not very nice either.

But rather than doing "git reset" on an old branch, what I think is nicer 
is to just create a new branch instead, and call it "PAT-v2" or something 
like that - leaving the old one around, but simply never _using_ it for 
anything (and obviously not merging it). That seems to match how you work 
otherwise.

Just opening another branch has the advantage that it also allows you to 
easily do cross-branch compares. It's actually how I work a lot personally 
when I work with the git repo and do some new thing: I start a topic 
branch for it, but it's inevitably going to be ugly in the end because I'm 
finding problems as I go, so I just start another branch and basically 
re-create a cleaner version in that.

(I don't end up merging with Junio with git - I just send him patches, so 
all those branches end up being just private things, but it doesn't change 
the basic workflow).

And the nice thing with starting a new branch is that you can do your 
cleanups etc in it, and then things like

	git diff broken..new-branch

work fine to check the differences _between_ branches. In other words, 
this is also a good way to just take a "v2" of a patch-series, and then 
you basically get a inter-patch-series diff for free that shows what the 
differences were.

Of cource, once you do that, you can also decide that you're not actually 
going to use the new branch, you're just going to append the fixes from v2 
to the old branch instead. So you may decide that your new branch (that 
you never pushed out) is not worth making a new branch for, and that it's 
actually going to be easier for people involved if you just turn the 
second patch-series into a single (or multiple, for that matter) 
fix-commit on top of the old patch-series.

Finally, one option that I do not recommend in this case (simply because 
all of the commits got rewritten) is to actually keep both branches, but 
do a merge between them and just pick the correct end result in the merge. 
That can be useful as a way to show both histories, but I'd generally 
suggest that only if there is some big reason why you'd really want to 
have both sets of patches around later.

A reason for the last case could be two different approaches that were 
both valid, and actually ended up both with a very similar end result, and 
where the way they got to it was interesting and/or relevant exactly 
because they were different. Or even if they weren't that technically 
different, maybe they were done by different people, and keeping both ends 
up showing the real development history _and_ gives credit to both.

There are other ways to do this too, but they all boil down to the "make a 
new branch that starts at the common point". For example, instead of 
creating a diff with "git diff broken..fixed" (whether to just see what 
the breakage was, or to actually fix up the broken branch with), if the 
series are very similar in structure and in many of the sub-commits, you 
can end up using "git rebase" to rebase the fixed sequence on top of the 
broken branch.

That last "git rebase" approach will generally cause a lot of conflicts 
that you have to fix up by hand (since by definition the two branches will 
obviously be touching the same area, and in slightly different ways), but 
sometimes that can actually be exactly what you _want_, since the merge 
conflicts are going to be exactly the things that changed, and if the 
series was clean and didn't have lots of patches where one patch in the 
series changed something that an earlier patch already modified, then the 
rebase can be a nice way to get the incremental fixes on top of the old 
broken branch from the fixed one.

So there are certainly different things you can do.

			Linus
