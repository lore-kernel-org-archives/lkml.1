Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYEKSvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYEKSvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbYEKSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:51:15 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40124 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbYEKSvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:51:14 -0400
Date: Sun, 11 May 2008 21:49:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511184952.GG1645@cs181133002.pp.htv.fi>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511175222.GA31729@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080511175222.GA31729@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 07:52:22PM +0200, Sam Ravnborg wrote:
> On Sun, May 11, 2008 at 12:21:32PM +0300, Adrian Bunk wrote:
> > kernel/sched* contained tons of inline's, and the result of removing 
> > them all is impressing (with x86_64_defconfig)
> >    text    data     bss     dec     hex filename
> >   39557    8234     280   48071    bbc7 kernel/sched.o
> >   41792    8234     280   50306    c482 kernel/sched.o.old
> > 
> > That's a 5.3% text size reduction (!), which is more than twice as much 
> > as the 2.3% the "optimized inlining" achieves on average for the whole 
> > kernel.
> 
> If we compare the size of sched.o in the three cases we see a clear effect:
> 
>                   text	   data	    bss	    dec	    hex	filename
> forced inline:    31257	   2702	    200	  34159	   856f	kernel/sched.o
> inline hint:      31105	   2702	    200	  34007	   84d7	kernel/sched.o
> no inline (hint): 30704	   2702	    200	  33606	   8346	kernel/sched.o

Is this with CONFIG_CC_OPTIMIZE_FOR_SIZE=y?

Otherwise your data has not much value since that's the interesting case 
for size comparisons and AFAIK also the common case in distribution 
kernels.

> The last line "no inline(hint)" is with Adrians patch applied.
> So what is obvious from the above is that with the arch/gcc combination
> I use here the inline hint has a clear effect and gcc inlines more
> when we have given it a hint to do so than without the hint.
> I conclude this solely on the cide size change between the line
> "inline hint" and "no inline(hint)".
> 
> With adrians patch there were no difference in size with or
> without the OPTIMIZE_INLINING enabled.
> 
> Or in other words the config option "OPTIMIZE_INLINING" is NOT
> equal to removing all the inline annotations.

Both do the same with the same justification:

Both give the decision whether or not to inline completely into the 
hands of gcc, which can make different inlining decisions depending on 
e.g. the gcc version and the CONFIG_CC_OPTIMIZE_FOR_SIZE setting, and
the only thing benchmarked is the code size.

And if gcc produces with CONFIG_CC_OPTIMIZE_FOR_SIZE=y bigger code due 
to some hint I'd argue that's a bug in gcc that might get fixed in 
future gcc releases.

> > Note that any remarks regarding whether this patch might affect the 
> > performance are invalid since noone cared about the performance when
> > the "x86: add optimized inlining" commit that does the same for the 
> > whole kernel entered the tree.
> 
> In one case it was an option it was easy to turn off/on so we could
> compare and modulus bugs it was a noop on gcc < 4.0.
> With the patch below we revet back to the broken gcc inline algorithm on
> gcc < 4.0 and it cannot as easy be turned of (have to revert this patch).
> Both issues are worth to consider before applying this.

Do we have any hard data that gcc < 4.0 has a "broken inline algorithm" 
and gcc >= 4.0 has a "working inline algorithm"?

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

