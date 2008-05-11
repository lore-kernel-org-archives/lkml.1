Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYEKRvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYEKRvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYEKRvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:51:47 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57329 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbYEKRvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:51:46 -0400
Date: Sun, 11 May 2008 19:52:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511175222.GA31729@uranus.ravnborg.org>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511092132.GE1645@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 12:21:32PM +0300, Adrian Bunk wrote:
> kernel/sched* contained tons of inline's, and the result of removing 
> them all is impressing (with x86_64_defconfig)
>    text    data     bss     dec     hex filename
>   39557    8234     280   48071    bbc7 kernel/sched.o
>   41792    8234     280   50306    c482 kernel/sched.o.old
> 
> That's a 5.3% text size reduction (!), which is more than twice as much 
> as the 2.3% the "optimized inlining" achieves on average for the whole 
> kernel.

If we compare the size of sched.o in the three cases we see a clear effect:

                  text	   data	    bss	    dec	    hex	filename
forced inline:    31257	   2702	    200	  34159	   856f	kernel/sched.o
inline hint:      31105	   2702	    200	  34007	   84d7	kernel/sched.o
no inline (hint): 30704	   2702	    200	  33606	   8346	kernel/sched.o

The last line "no inline(hint)" is with Adrians patch applied.
So what is obvious from the above is that with the arch/gcc combination
I use here the inline hint has a clear effect and gcc inlines more
when we have given it a hint to do so than without the hint.
I conclude this solely on the cide size change between the line
"inline hint" and "no inline(hint)".

With adrians patch there were no difference in size with or
without the OPTIMIZE_INLINING enabled.

Or in other words the config option "OPTIMIZE_INLINING" is NOT
equal to removing all the inline annotations.

> 
> Note that any remarks regarding whether this patch might affect the 
> performance are invalid since noone cared about the performance when
> the "x86: add optimized inlining" commit that does the same for the 
> whole kernel entered the tree.

In one case it was an option it was easy to turn off/on so we could
compare and modulus bugs it was a noop on gcc < 4.0.
With the patch below we revet back to the broken gcc inline algorithm on
gcc < 4.0 and it cannot as easy be turned of (have to revert this patch).
Both issues are worth to consider before applying this.

	Sam
