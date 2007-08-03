Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbXHCAO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbXHCAO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 20:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759246AbXHCAOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 20:14:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:53488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540AbXHCAOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 20:14:49 -0400
Date: Fri, 3 Aug 2007 02:14:47 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070803001447.GA14775@wotan.suse.de>
References: <20070802021525.GC15595@wotan.suse.de> <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org> <20070802024132.GD15595@wotan.suse.de> <20070802071956.GA23300@elte.hu> <20070802073123.GB16744@wotan.suse.de> <20070802154447.GA13725@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802154447.GA13725@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 05:44:47PM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > > > One thing to check out is whether the lmbench numbers are 
> > > > > "correct". Especially on SMP systems, the lmbench numbers are 
> > > > > actually *best* when the two processes run on the same CPU, even 
> > > > > though that's not really at all the best scheduling - it's just 
> > > > > that it artificially improves lmbench numbers because of the 
> > > > > close cache affinity for the pipe data structures.
> > > > 
> > > > Yes, I bound them to a single core.
> > > 
> > > could you send me the .config you used?
> > 
> > Sure, attached...
> > 
> > You don't see a regression? If not, then can you send me the .config 
> > you used? [...]
> 
> i used your config to get a few numbers and to see what happens. Here's 
> the numbers of 10 consecutive "lat_ctx -s 0 2" runs:
> 
>                         [ time in micro-seconds, smaller is better ]
> 
>         v2.6.22         v2.6.23-git          v2.6.23-git+const-param
>         -------         -----------          -----------------------
>          1.30              1.60                       1.19
>          1.30              1.36                       1.18
>          1.14              1.50                       1.01
>          1.26              1.27                       1.23
>          1.22              1.40                       1.04
>          1.13              1.34                       1.09
>          1.27              1.39                       1.05
>          1.20              1.30                       1.16
>          1.20              1.17                       1.16
>          1.25              1.33                       1.01
>        -------------------------------------------------------------
>   avg:   1.22              1.36 (+11.3%)              1.11 (-10.3%)
>   min:   1.13              1.17 ( +3.5%)              1.01 (-11.8%)
>   max:   1.27              1.60 (+26.0%)              1.23 ( -3.2%)
> 
> one reason for the extra overhead is the current tunability of CFS, but 
> that is not fundamental, it's caused by the many knobs that CFS has at 
> the moment. The const-tuning patch (attached below, results in the 
> rightmost column) changes those knobs to constants, allowing the 
> compiler to optimize the math better and reduce code size. (the code 
> movement in the patch makes up for most of its size, the change that it 
> does is simple otherwise.)

[...]

Oh good. Thanks for getting to the bottom of it. We have normally
disliked too much runtime tunables in the scheduler, so I assume
these are mostly going away or under a CONFIG option for 2.6.23?
Or...?

What CPU did you get these numbers on? Do the indirect calls hurt
much on those without an indirect predictor? (I'll try running some
tests).

I must say that I don't really like the indirect calls a great deal,
and they could be eliminated just with a couple of branches and
direct calls.
