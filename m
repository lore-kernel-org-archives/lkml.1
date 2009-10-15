Return-Path: <linux-kernel-owner+w=401wt.eu-S934984AbZJOLl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934984AbZJOLl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934383AbZJOLl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:41:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055AbZJOLl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:41:56 -0400
Date: Thu, 15 Oct 2009 13:41:19 +0200
From: Nick Piggin <npiggin@suse.de>
To: Anton Blanchard <anton@samba.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091015114119.GE3127@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091015100854.GA19948@kryten> <20091015105332.GB3127@wotan.suse.de> <20091015112329.GH4808@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015112329.GH4808@kryten>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 10:23:29PM +1100, Anton Blanchard wrote:
>  
> Hi Nick,
> 
> > I wonder what other good performance tests you can add to your test
> > framework? creat/unlink is another easy one. And for each case, putting
> > threads in their own cwd versus a common cwd are the variants.
> 
> I did try the two combinations of creat/unlink but haven't had a chance to
> digest the profiles yet. I've attached them (taken at 64 cores, ie worst
> case :)
> 
> In both cases performance was significantly better than mainline.
> 
> > BTW. for these cases in your tests it will be nice if you can run on
> > ramfs because that will isolate purely the vfs. Perhaps also include
> > other filesystems as you get time, but I think ramfs is the most
> > useful for us to start with.
> 
> Good point. I'll add that into the setup scripts.
> 
> Anton

> # Samples: 82617
> #
> # Overhead          Command                      Shared Object  Symbol
> # ........  ...............  .................................  ......
> #
>     99.16%  unlink1_process  [kernel]                           [k] ._spin_lock
>                 |          
>                 |--99.98%-- ._spin_lock
>                 |          |          
>                 |          |--49.80%-- .path_get
>                 |          |--49.58%-- .dput

Hmm, both your profiles look like they are hammering on a common cwd
here. The lock-free path walk can probably be extended to help a bit,
but you would still end up hitting locks on the parent dentry/inode
when doing the create destroy. My 64-way numbers look like this:


create-unlink 1 processes seperate-cwd 105306.58 ops/s
create-unlink 2 processes seperate-cwd 103004.20 ops/s
create-unlink 4 processes seperate-cwd 92438.69 ops/s
create-unlink 8 processes seperate-cwd 91138.93 ops/s
create-unlink 16 processes seperate-cwd 91025.36 ops/s
create-unlink 32 processes seperate-cwd 83757.75 ops/s
create-unlink 64 processes seperate-cwd 81718.29 ops/s

create-unlink 1 processes same-cwd 110139.61 ops/s
create-unlink 2 processes same-cwd 26611.69 ops/s
create-unlink 4 processes same-cwd 13819.46 ops/s
create-unlink 8 processes same-cwd 4724.83 ops/s
create-unlink 16 processes same-cwd 1368.99 ops/s
create-unlink 32 processes same-cwd 335.08 ops/s
create-unlink 64 processes same-cwd 114.88 ops/s

If your seperate-cwd numbers aren't scaling reasonably well, I will
have to get to the bottom of it.

BTW these numbers are ops/s/cpu which btw in some cases I like better.
At a quick glance it is very easy to see if scalability is linear,
and also when you graph it then there is less tendency to drown
out the low end numbers (although it could go the other way and drown
the high end numbers for non-scalable cases). Maybe you could add an
option to output either.

Thanks,
Nick
