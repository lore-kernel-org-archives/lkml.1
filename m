Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbYJJRfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbYJJRfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbYJJRfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:35:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758105AbYJJRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:35:11 -0400
Date: Fri, 10 Oct 2008 10:34:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #2 - PAT updates
In-Reply-To: <20081010170426.GA5947@elte.hu>
Message-ID: <alpine.LFD.2.00.0810101023580.3503@nehalem.linux-foundation.org>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org> <20081010164537.GA23664@elte.hu> <20081010170426.GA5947@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:
> 
> the time gap between v1 and v2 was rather large, 10 days:
> 
>  CommitDate: Sun Sep 14 17:50:41 2008 +0200
>  CommitDate: Wed Sep 24 10:07:52 2008 +0200
> 
> because it took time to find and track down the lockup, and it also took 
> time to come up with the fix. So i definitely wanted a delta fix (we 
> handle another 150 append-only commits in a 10 day timespan so a delta 
> fix is the right approach), but messed up its generation.

So because you wanted a delta fix, and if you want to keep the old series, 
then yes, creating a new (local-to-your-repository-only, throw-away) 
branch with the new "v2" series of patches, and then just applying them on 
top of the old broken series as incremental fixes would probably be the 
right thing to do.

With the reverts, there's not only all that useless noise in the logs, the 
problem is that all that extra crud is actually _hiding_ what the real fix 
was. So instead of seeing the fix, we just see a revert and a totally new 
version. That's pretty pessimal - the whole sequence isn't bisectable 
anyway.

So what I suggest are good alternatives would be:

 - Make things bisectable by just using a totally new branch (and dropping 
   the old branch). This just throws out the buggy version, since it never 
   gets merged upstream, and as such nobody will ever really care what the 
   bug was.

   This obviously depends on _others_ not having based their work on the 
   broken crud.

 - Make nice incremental fix patches, rather than "revert and redo". This 
   isn't bisectable, but on the other hand it can certainly be 
   educational, and "git blame" etc will give reasonable results, and 
   people seeing the history can at least see what the bug was.

I tried to outline a couple of ways to have git help you do the second 
version in the previous email. It's still going to be somewhat manual, but 
especially if the difference between patch-series wasn't _that_ big, a 
simple sequence of

	git checkout broken
	git diff broken..fixed | git apply
	.. see how you want to commit the fix - maybe as one thing, maybe 
	   as a series of independent fixes depending on the size of it ..

will get you there with fairly little pain.

Of course, if the branch had other commits to it than just the broken 
series, you will need to cherry-pick those other commits to the "fixed" 
branch too, so that the difference between broken and fixed is literally 
just the difference between the two patch-series.

Hmm?

		Linus
