Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbYEEVED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbYEEVED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761883AbYEEVDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:03:38 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42365 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761825AbYEEVDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:03:37 -0400
Date: Tue, 6 May 2008 00:02:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
	(was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505210229.GC1544@cs181133002.pp.htv.fi>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080505201906.GA900@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 10:19:06PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch makes the following needlessly global code in kernel/sched.c  
> > static:
> > - sched_feat_names[]
> > - sched_feat_open()
> 
> Adrian, you've been doing these "make needlessly global code static" 
> patches for years meanwhile. I'm asking whether you have made any 
> thoughts about going to the next level and automating (or at least 
> half-automating) the generation of these trivial patches, so that they 
> become less disruptive to our patch flow?
> 
> My opinion is that the technical benefit of these patches is positive to 
> Linux: they make the kernel image a tiny bit smaller - for example this 
> sched.c patch of yours i'm replying to makes the 64-bit kernel 8 bytes 
> smaller. So i always applied your patches, and will do so in the future 
> too.
> 
> But the per patch benefit is arguably extremely low: for example this 
> particular patch saves 0.00016% from my particular vmlinux's size. Even 
> on a Linux-Tiny kernel config, it's just 0.0008% of the vmlinux's size. 
> We'd need more than 600 such patches (!) to make just 0.1% of a code 
> size difference to my vmlinux, and even 0.1% is still very, very small. 
> [ and many of these patches do not even trigger any savings on tiny 
>   configs. ]
> 
> The point that many kernel developers make is that if we compare this 
> small benefit to the disruption to the workflow this many small patches 
> can cause, they could in fact become a net negative contribution (!). So 
> it is extremely important to reduce the disruption, as much as we can.


I could have announced this patch as "fixes two sparse warnings"
(which is true and seems to even make Linus bypass maintainers for 
applying patches for similar patches I've seen from other people).

Fact is that I only very rarely use sparse, do the things from different 
perspectives, and only the result often happens to overlap with what 
sparse does.

If the labeling is what makes you say "benefit is arguably extremely 
low" I can put more emphasize on which of my patches also fix sparse 
warnings.


> And unlike other kernel developers, my opinion is not that we should 
> eliminate this disruption by not doing these trivial patches _at all_. 


Who are these "other kernel developers"?


> My opinion is that we should make it easier for maintainers to _avoid 
> introducing_ these problems.
> 
> I.e. we need to fight the root of this problem (the steady introduction 
> of needlessly global symbols), not its symptoms (the needlessly global 
> symbols themselves).
> 
> Let me raise some thoughts about what we could do to achieve these 
> goals.
> 
> Firstly, the methodology: you are using "make namespacecheck" on an 

- "make namespacecheck"
- "make export_report"
- the -Wmissing-prototypes gcc flag

The latter is what I actually started with many years ago (that might 
even predate sparse), and we are slowly getting nearer to being able to 
enable it in the kernel (also thanks to sparse now emitting warnings 
for the same things).

And it might even be the automation you are looking for.

> allyesconfig kernel to find these 'needlessly global' sites, correct?

Not exactly allyesconfig since my compile tests predate the 
introduction of the *config targets in 2.5, but my standard
.config's are roughly identical to allmodconfig and allyesconfig.

> Do 
> you perhaps also generate them via Sparse, or via some other special 
> scripting? Could you perhaps describe how you generate them? Do you 
> create the patches manually perhaps?

I grep the sources and check in git what happened and what to do
(this sometimes finds some real bugs).

I edit the file(s).

Then I do:
  cg-commit < /dev/null; git-show --pretty=oneline > /tmp/patch-static-sched

Write the email with mutt+nano.

Store the email in my postponed-msgs folder.

Give a batch of patches some compile testing and check the output 
(e.g. removing some code might make gcc complain about now unused 
static code).

>...
> What do you think?

You can implement whatever you want to implement.

If that results in me sending less patches that's not a problem for me.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

