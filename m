Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZDXWTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZDXWTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 18:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbZDXWT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 18:19:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbZDXWT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 18:19:28 -0400
Date: Sat, 25 Apr 2009 00:19:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424221910.GB6403@elte.hu>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu> <20090424135821.GJ8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424135821.GJ8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Apr 24, 2009 at 10:06:34AM +0200, Ingo Molnar wrote:
> 
> > You've not replied to my request (attached below) to put these 
> > trivial BKL-pushdown bits into a separate branch/tree and not into 
> > the VFS tree. You've now mixed that commit with other VFS changes.
> > 
> > Had it been in a separate branch, and had we tested it, Linus could 
> > have pulled the trivial BKL pushdown bits out of normal merge order 
> > as well. That is not possible now.
> > 
> > Furthermore, by doing this you are also hindering the 
> > tip:kill-the-BKL effort (which has been ongoing for a year chipping 
> > away at various BKL details) which facilitated these changes. 
> > Alessio did these fixes to fix bugs he can trigger in that tree.
> > 
> > You've also not explained why you have done it this way. It would 
> > cost you almost nothing to apply these bits into a separate branch 
> > and merge that branch into your main tree. Lots of other maintainer 
> > are doing that.
> > 
> > So if you've done this by mistake, i'd like to ask you to reconsider 
> > and put these bits into a separate, stable-commit-ID branch. If 
> > you've done this intentionally, i'd like you to explain the reasons 
> > for it, instead of just doing it silently without explanation.
> > 
> > Anwyay, if there's no resolution, i'll apply Alessio's fixes with a 
> > different commit ID, to not hold up the rather useful work that is 
> > going on in the kill-the-BKL tree. Later on i'll have to rebase that 
> > portion of the tree to avoid duplicate commit IDs. I just wanted to 
> > put it on the record why i have to do that rebase.
> 
> Good grief...  You have the commit ID, git fetch + git-cherry-pick 
> would take two lines to type instead of more than a screenful.

I did that before writing this mail - look at the 
tip:core/kill-the-BKL tree. That is why i got worried about 
'poisonig' that tree with a patch like that.

> This patch is certainly trivial enough to go into the mainline at 
> any point. Including "right now".  However, the stuff to follow it 
> might get more convoluted and I wouldn't argue for pushing it 
> before the next merge window. It's not just the "push BKL down 
> there" - that I could simply do right now and ACK pushing it to 
> Linus/push myself.  Unless I'm mistaken, you want to pull the 
> subsequent "remove BKL in foofs" bits as well and those are almost 
> certainly going to get entangled with other stuff.
> 
> I'm not particulary against a separate branch for all that stuff 
> (including the remount changes that'll be needed, etc.).  The 
> question is, what merge time are you aiming for and how much VFS 
> stuff are you willing to tolerate in that branch?
> 
> Details, please...

As i pointed it out in the first mail: our immediate concern is NFS 
(nfs_get_sb() in particular), where we can reproduce real and easy 
deadlocks with BKL-as-a-mutex. So if you could push this patch to 
Linus (or just not NAK me cherry-picking your precise commit) that 
would be enough to continue here.

[ Surprisingly large amount of BKL code gets away with a plain-mutex 
  BKL - and that's the basis of our experimental tree: we removed 
  all BKL logic from the scheduler and turned it into a plain mutex 
  - and are using lockdep and other measures to map out all 
  'complex' BKL assumptions that trigger in practice - combined with 
  review efforts such as Frederic's.

  Basically lockdep is the 'binocular' that finds the trouble spots, 
  review is the knife that fixes the problem. ]

Anyway - regarding this commit, doing it via a branch would have 
been the most Git-ish way to solve it - and that's what i'm using in 
equivalent situations - but if you rebase your tree often as 
Christoph Hellwig suggests i can imagine that causing problems.

In fact, you do seem to have rebased a lot of commits just a couple 
of days ago:

earth4:~/linux.trees.git> git log --pretty=fuller linus/master..vfs/for-next  | grep CommitDate
CommitDate: Fri Apr 24 03:15:47 2009 -0400
CommitDate: Thu Apr 23 19:30:02 2009 -0400
CommitDate: Thu Apr 23 19:30:02 2009 -0400
CommitDate: Tue Apr 21 17:55:57 2009 -0400
CommitDate: Tue Apr 21 17:55:56 2009 -0400
CommitDate: Tue Apr 21 17:55:55 2009 -0400
CommitDate: Tue Apr 21 17:55:54 2009 -0400
CommitDate: Tue Apr 21 17:55:53 2009 -0400
CommitDate: Tue Apr 21 17:55:52 2009 -0400
CommitDate: Tue Apr 21 17:55:51 2009 -0400
CommitDate: Tue Apr 21 17:55:50 2009 -0400
CommitDate: Tue Apr 21 17:55:49 2009 -0400
CommitDate: Tue Apr 21 17:55:48 2009 -0400
CommitDate: Tue Apr 21 17:55:47 2009 -0400
CommitDate: Tue Apr 21 17:55:46 2009 -0400
CommitDate: Tue Apr 21 17:55:45 2009 -0400
CommitDate: Tue Apr 21 17:55:44 2009 -0400
CommitDate: Tue Apr 21 17:55:43 2009 -0400
CommitDate: Tue Apr 21 17:55:42 2009 -0400
CommitDate: Tue Apr 21 17:55:41 2009 -0400
CommitDate: Tue Apr 21 17:55:40 2009 -0400
CommitDate: Tue Apr 21 17:55:39 2009 -0400

So yes, a branch with a stable commit is not possible for you to do. 

Would you mind to describe the workflow that leads to such frequent 
rebasing? The commit dates are nicely apart:

earth4:~/linux.trees.git> git log --pretty=fuller linus/master..vfs/for-next | grep AuthorDate
AuthorDate: Fri Apr 24 09:06:53 2009 +0200
AuthorDate: Fri Apr 24 01:02:45 2009 +0200
AuthorDate: Fri Apr 24 01:01:56 2009 +0200
AuthorDate: Sat Apr 18 14:06:57 2009 -0400
AuthorDate: Sat Apr 18 13:59:41 2009 -0400
AuthorDate: Sat Apr 18 13:58:15 2009 -0400
AuthorDate: Sat Apr 18 03:28:19 2009 -0400
AuthorDate: Sat Apr 18 03:26:48 2009 -0400
AuthorDate: Sat Apr 18 03:00:46 2009 -0400
AuthorDate: Sat Apr 18 02:42:05 2009 -0400
AuthorDate: Sat Apr 18 02:14:32 2009 -0400
AuthorDate: Sat Apr 18 02:04:46 2009 -0400
AuthorDate: Tue Apr 7 12:21:18 2009 -0400
AuthorDate: Tue Apr 7 11:53:49 2009 -0400
AuthorDate: Tue Apr 7 11:49:53 2009 -0400
AuthorDate: Tue Apr 7 11:44:16 2009 -0400
AuthorDate: Tue Apr 7 11:08:56 2009 -0400
AuthorDate: Mon Apr 6 11:16:22 2009 -0400
AuthorDate: Mon Apr 6 09:38:49 2009 -0400
AuthorDate: Thu Apr 2 21:17:03 2009 -0400
AuthorDate: Tue Apr 7 13:19:18 2009 -0400
AuthorDate: Mon Apr 6 16:43:42 2009 -0700

so these are not commits developed in the same minute as the 
commit-date suggests. I.e. the whole tree got rebased at Apr 21 
17:55.

	Ing
