Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbYARQBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbYARQBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760763AbYARQB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:01:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50857 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611AbYARQB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:01:26 -0500
Date: Fri, 18 Jan 2008 16:01:23 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Mike Snitzer <snitzer@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James.Bottomley@steeleye.com
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Message-ID: <20080118160123.GB11840@csn.ul.ie>
References: <166634.14296.qm@web32603.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <166634.14296.qm@web32603.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/01/08 00:19), Martin Knoblauch didst pronounce:
> > > The effect  is  defintely  depending on  the  IO  hardware.
> > > performed the same tests
> > > on a different box with an AACRAID controller and there things
> > > look different.
> > 
> > I take it different also means it does not show this odd performance
> > behaviour and is similar whether the patch is applied or not?
> >
> 
> Here are the numbers (MB/s) from the AACRAID box, after a fresh boot:
> 
> Test            2.6.19.2  2.6.24-rc6  2.6.24-rc6-81eabcbe0b991ddef5216f30ae91c4b226d54b6d
> dd1             325       350         290
> dd1-dir         180       160         160
> dd2           2x 90     2x113       2x110
> dd2-dir       2x120     2x 92       2x 93
> dd3           3x 54     3x 70       3x 70
> dd3-dir       3x 83     3x 64       3x 64
> mix3       55,2x 30 400,2x 25   310,2x 25
> 
>  What we are seing here is that:
> 
> a) DIRECT IO takes a much bigger hit (2.6.19 vs. 2.6.24) on this IO system compared to the CCISS box
> b) Reverting your patch hurts single stream

Right, and this is consistent with other complaints about the PFN of the
page mattering to some hardware.

> c) dual/triple stream are not affected by your patch and are improved over 2.6.19

I am not very surprised. The callers to the page allocator are probably
making no special effort to get a batch of pages in PFN-order. They are just
assuming that subsequent calls give contiguous pages. With two or more
threads involved, there will not be a correlation between physical pages
and what is on disk any more.

> d) the mix3 performance is improved compared to 2.6.19.
> d1) reverting your patch hurts the local-disk part of mix3
> e) the AACRAID setup is definitely faster than the CCISS.
> 
>  So, on this box your patch is definitely needed to get the pre-2.6.24 performance
> when writing a single big file.
> 
>  Actually things on the CCISS box might be even more complicated. I forgot the fact
> that on that box we have ext2/LVM/DM/Hardware, while on the AACRAID box we have
> ext2/Hardware. Do you think that the LVM/MD are sensitive to the page order/coloring?
> 

I don't have enough experience with LVM setups to make an intelligent
guess.

>  Anyway: does your patch only address this performance issue, or are there also
> data integrity concerns without it?

Performance issue only. There are no data integrity concerns with that
patch.

> I may consider reverting the patch for my
> production environment. It really helps two thirds of my boxes big time, while it does
> not hurt the other third that much :-)
> 

That is certainly an option.

> > > 
> > >  I can certainly stress the box before doing the tests. Please
> > > define "many" for the kernel compiles :-)
> > > 
> > 
> > With 8GiB of RAM, try making 24 copies of the kernel and compiling them
> > all simultaneously. Running that for for 20-30 minutes should be enough
> > 
>  to randomise the freelists affecting what color of page is used for the
> > dd  test.
> > 
> 
>  ouch :-) OK, I will try that.
> 

Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
