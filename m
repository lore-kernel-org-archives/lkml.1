Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbYEURoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbYEURoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYEURn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:43:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbYEURnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:43:55 -0400
Date: Wed, 21 May 2008 10:43:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
cc: Rene Herman <rene.herman@keyaccess.nl>, alsa-devel@alsa-project.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
In-Reply-To: <s5htzgrvbvo.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.1.10.0805211003170.3081@woody.linux-foundation.org>
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz> <200805211430.06653.linux@audioscience.com> <Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz> <s5hve18vtml.wl%tiwai@suse.de> <483415E7.5080402@keyaccess.nl> <s5hfxsbx27f.wl%tiwai@suse.de>
 <48341DF5.4090307@keyaccess.nl> <s5habijww7r.wl%tiwai@suse.de> <48344271.3090700@keyaccess.nl> <s5hy763ve5n.wl%tiwai@suse.de> <alpine.LFD.1.10.0805210908460.3081@woody.linux-foundation.org> <s5htzgrvbvo.wl%tiwai@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Takashi Iwai wrote:
> 
> Well, what I meant is about the fixes to the subsystem (say, ALSA) by
> people in the outside.  Not every ALSA-bugfix patch goes into the
> upstream from ALSA tree.  You, Andrew and others pick individually
> ALSA-fix patches.  They will be missing in the ALSA subsystem tree.

Well, that's actually fairly rare, but when it happens, either:

 - if you didn't get the fix (ie you're are just seeing random patches go 
   in that happen to touch alsa), why should you then merge the WHOLE TREE 
   with all my experimental stuff anyway? You can largely ignore it, 
   knowing it's fixed, and when you ask me to pull, we'll have a good 
   end result.

 - if you got the same fix as a patch, just apply it to your tree (ie just 
   ignore what happens upstream). This happens all the time - people 
   duplicate patches simply because two people apply it.

But the real issue is here is that my tree sometimes gets ten THOUSAND 
commits during the merge window. Do you really want to pull those 
thousands of commits into your tree just for one or two possible ALSA 
fixes? 

In _my_ tree, at least the people involved with asking me to pull end up 
also having (a) people test it and (b) aware that it's in my tree, so they 
work on trying to fix it. But if ALSA just merges at random times, neither 
of those two cases are true. Nobody will know about or test some random 
state that ALSA merged into its own tree.

Ask yourself (and ignore the ALSA parts - think of some totally 
*different* development area) which you think is better

 - developing in one area based on a stable base, with the people who do 
   development in that area knowing about that area.

 - or develop on top of a churning sea of thousands of changes to other
   sub-areas that you don't know anything about?

In other words, the reason I ask people to not do lots of merges is more 
than just "it looks confusing". It's literally a matter of "it's bad 
development practice". It causes problems. The confusing history is 
actually *real* - it's not just a "visual artifact" of looking at the 
result in gitk. The confusing history is a real phenomenon, and implies 
that people are doing development not based on some tested base.

> And, what if that you need a fix for the fix that isn't in ALSA
> tree...?  IMO, either a rebase or a merge is better than
> cherry-picks.

First off, I don't see why you even need cherry-picks in the first place. 
I think your argument is bogus, and you're making it because you want to 
get the end result, not because the argument is valid on its own.

Here, let's see what I committed to the sound subsystem since 2.6.24 
(ignoring merges):

	git log --no-merges v2.6.24.. --committer=torvalds sound/

and look over that list. Remember: this is not some short timeframe, this 
is over TWO whole merge windows, ie this is way more commits than we would 
normally _ever_ get out of sync over.

Realistically, which of those commits aren't (a) either already from you 
sent to me just as a way to get a quick fix into my tree without merging 
the whole thing or (b) stuff that can't just be in my tree and doesn't 
have to be in the ALSA tree until the next release?

Honestly, now: does *any* of those commits look like "we should merge all 
the other changes just because we need that commit _now_ in ALSA"?

I really doubt it. 

So I'd seriously suggest submaintainers merge *AT*MOST* once a week, and 
preferably much much less often than that. There simply isn't any real 
reason to do it more often. Because it can cause problems.

That's why my suggested rule is:

 - merge with mainline at major releases

   This is "safe". Yes, releases still have bugs, but on the other hand, 
   they have much fewer problems than random git trees of the day, so they 
   are a lot safer targets to merge.

 - merge with mainline if you know there are real conflicts that need to 
   be resolved.

   This isn't "safe", but it's about trying to resolve conflicts early, so 
   at some point the downside of merging with a "random point" is smaller 
   than the downside of delaying the merge!

but perhaps the most important rule is that things should never be 
*really* black-and-white, and in the end the really fundamental rule 
should be:

 - Use your own judicious good sense, and merge at other points as 
   necessary, but just keep in mind that a merge is a big change.

Yes, merging with git may be technically really really trivial and take 
all of two seconds of your time, but:

 (a) you *do* potentially get thousands of new commits that aren't 
     actually related to your work and that you probably don't know 
     well.
 (b) others, when they look at your history, will have a harder time 
     following it.

so while I can give you a few guidelines, in the end those guidelines are 
just _examples_ of when merges can make sense. You need to understand what 
the impact of a merge is - and that while git makes merging technically 
pretty damn trivial most of the time, a merge should still be a big deal, 
and something you think about.

So the kinds of merges I *really* dislike are the ones that are basically 
"let's do a regular merge every day to keep up-to-date". That's fine if 
you don't do any development at all and "git pull" is just basically a 
"track the current development kernel for testing", but if it involves a 
merge, it means that there is something wrong in your development model.

> But, my question is about the divergence between the development and
> for-linus branches: how to apply patches that exist only in for-linus
> tree back.

How often does it happen? And how big/important are those? I really think 
it's probably a "maybe once or twice a release cycle".

And then, the actual answer can be different depending on the details. For 
example, there are really three things you can do:

 - ignore it. Is it a cleanup patch (like the sparse patches) or just 
   fairly trivial stuff that doesn't matter in real life ("remove 
   duplicated unlikely()" patch or the /proc fixups)

   This is often the right thing to do. You _will_ merge eventually 
   anyway, we know that. I'd expect merges to happen at least once in the 
   development cycle, maybe twice.

   Yes, the patch may touch the sound system, but do you really _care_ 
   about it happening rigth now, or can you just wait until the next merge 
   you do?

 - cherry-pick it. Is it a small, simple patch that you want, but that 
   isn't really worth pulling in all the other stuff that you simply don't 
   know?

   This isn't wrong. It shouldn't be *common*, but it's not wrong to have 
   the same patch in two different branches. It makes sense if it is 
   something you really want, but it's still not important or complex 
   enough to actually mege everything else!

 - and finally: merge. It really can be the RightThing(tm). Is it a 
   biggish infrastructure change? Is it a series of several related and 
   dependent commits?

   In other words: is it something big enough that you'd rather merge 
   everything else too (which at least has gotten tested together)? If so, 
   merging is absolutely the right thing to do!

So merging on its own is not "wrong or evil" at all. Merging is a very 
good operation to do, but *mindless* merging is bad. That's really all 
that I'm really trying to argue against.

If you thought it through, and decided that yes, you really want to merge, 
then you should merge. I just think a lot of people merge without even 
thinking about all the other things it involves, just because git made it 
*so* easy to do.

			Linus
