Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbYGQTNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbYGQTNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbYGQTNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:13:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbYGQTNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:13:44 -0400
Date: Thu, 17 Jul 2008 12:12:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <alpine.LFD.1.10.0807171402110.2965@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0807171154560.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org> <487EE940.1050007@firstfloor.org>
 <alpine.LFD.1.10.0807170752190.2959@woody.linux-foundation.org> <alpine.LFD.1.10.0807171402110.2965@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Len Brown wrote:
> 
> ps.
> 
> One thing I wish I had in git is a way to make this sequence easier...

Actually, it _is_ easier, although apparently the thing that made it 
easier isn't necessarily widely known or documented.

I'm going to quote your whole sequence, because it's not a really odd 
thing do want to do, and quoting how you do it now also makes the "proper 
git way" actually much more understandable:

> Say I have a big topic branch with 30 patches in it.
> The 3rd patch turns out to have a bug in it, but the
> rest of the series is okay.  Today I invoke gitk on
> the branch and keep that open.
>
> Then I create a new topic branch at the broken patch.
> 
> I always consult ~/src/git/Documentation/git-reset.txt
> so I can remember the following sequence...
> 
> $ git reset --soft HEAD^
> $ edit
> $ git commit -a -c ORIG_HEAD
> 
> Now I've got the fixed 3rd patch checked in,
> but 27 patches in the original branch are hanging
> off the original broken 3rd patch.
> So I git-cherry-pick 27 patches
> I hope I get them in the right order and don't miss any...
> 
> It would be nice if we could somehow git rebase those
> 27 patches in a single command, but if we do,
> that pulls with it the broken 3rd patch.
> 
> come to think of it, I can probably export 4..27 as
> an mbox and then import it on top of the new 3,
> maybe that is what others do.

No, what others do (if they know the tricks) is to say something like:

	git rebase -i <starting-point>

("-i" is short for "--interactive") where the starting point is just where 
you want to start your work. It might be "origin", or it might be 
"HEAD~30" to say "30 commits ago" or whatever. Anyway, it's basically the 
stable point before the place you want to fix up.

That thing will literally show you the list of commits in an editor, and 
then you can re-order them or mark them for special actions.

The normal action is to "pick" the commit (ie you just cherry-pick it). 
But rather than just picking a commit (remember - you can change the order 
by just editing the list), you can also do

 - "edit": this just basically pauses the rebase after committing the 
    cherry-pick, so that you can then edit things and fix them with "git 
    commit --amend", and when you're happy, you do "git rebase --continue"
    to continue your series.

 - "squash": this squashes the commit in togethr with the previous one, 
   and is very useful together with moving commits around. IOW, maybe you 
   committed a fix to a previous commit, and want to integrate the fix 
   into the original commit - in that case you'd move the commit in the 
   list up to just after the commit you want to fix, and change the "pick" 
   into a "squash"

so it actually makes doing what you do above by hand much easier.

[ Honesty in advertising: I actually don't use this at all. I've tested 
  it, and I think it's very useful, but I have so far mostly ended up 
  doing this by hand in the very few cases I do it at all. Part of the 
  reason is that "git rebase -i" is fairly recent, so it's not part of my 
  normal tool set.

  But the bigger reason is that obviously all the commits I tend to do are 
  just merges, and I don't maintain "patch series" in my trees except 
  sometimes for git itself ]

Git rebase can also try to rebase merges (the "-p" flag - short form of 
"--preserve-merges"), so this _does_ work with a non-linear history too to 
some degree, but quite frankly, I would seriously suggest people try to 
avoid getting quite that funky with it. It's useful for emergencies, but 
you'd better know what you are doing, and you should look at the 
before-and-after state very carefully.

			Linus
