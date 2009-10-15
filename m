Return-Path: <linux-kernel-owner+w=401wt.eu-S1762716AbZJOLtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762716AbZJOLtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762609AbZJOLtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:49:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:45200 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163AbZJOLtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:49:33 -0400
Date: Thu, 15 Oct 2009 13:48:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: Anton Blanchard <anton@samba.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091015114856.GF3127@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091015100854.GA19948@kryten> <20091015105332.GB3127@wotan.suse.de> <20091015112329.GH4808@kryten> <20091015114119.GE3127@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015114119.GE3127@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 01:41:19PM +0200, Nick Piggin wrote:
> On Thu, Oct 15, 2009 at 10:23:29PM +1100, Anton Blanchard wrote:
> >  
> > Hi Nick,
> > 
> > > I wonder what other good performance tests you can add to your test
> > > framework? creat/unlink is another easy one. And for each case, putting
> > > threads in their own cwd versus a common cwd are the variants.
> > 
> > I did try the two combinations of creat/unlink but haven't had a chance to
> > digest the profiles yet. I've attached them (taken at 64 cores, ie worst
> > case :)
> > 
> > In both cases performance was significantly better than mainline.
> > 
> > > BTW. for these cases in your tests it will be nice if you can run on
> > > ramfs because that will isolate purely the vfs. Perhaps also include
> > > other filesystems as you get time, but I think ramfs is the most
> > > useful for us to start with.
> > 
> > Good point. I'll add that into the setup scripts.
> > 
> > Anton
> 
> > # Samples: 82617
> > #
> > # Overhead          Command                      Shared Object  Symbol
> > # ........  ...............  .................................  ......
> > #
> >     99.16%  unlink1_process  [kernel]                           [k] ._spin_lock
> >                 |          
> >                 |--99.98%-- ._spin_lock
> >                 |          |          
> >                 |          |--49.80%-- .path_get
> >                 |          |--49.58%-- .dput
> 
> Hmm, both your profiles look like they are hammering on a common cwd
> here. The lock-free path walk can probably be extended to help a bit,
> but you would still end up hitting locks on the parent dentry/inode
> when doing the create destroy. My 64-way numbers look like this:
> 
> 
> create-unlink 1 processes seperate-cwd 105306.58 ops/s
> create-unlink 2 processes seperate-cwd 103004.20 ops/s
> create-unlink 4 processes seperate-cwd 92438.69 ops/s
> create-unlink 8 processes seperate-cwd 91138.93 ops/s
> create-unlink 16 processes seperate-cwd 91025.36 ops/s
> create-unlink 32 processes seperate-cwd 83757.75 ops/s
> create-unlink 64 processes seperate-cwd 81718.29 ops/s

dumb profile for this guy looks like this:
206681 total                                      0.0270
 25851 _spin_lock                               161.5687
 13628 kmem_cache_free                            7.3427
  9890 _spin_unlock                              61.8125
  7087 kmem_cache_alloc                           6.5138
  6770 _read_lock                                35.2604
  5587 __call_rcu                                 4.8498
  5580 __link_path_walk                           0.5571
  5246 do_filp_open                               0.9476
  4946 __rcu_process_callbacks                    2.0608
  4904 __percpu_counter_add                      11.7885
  3933 d_alloc                                    5.1211
  3906 memset                                     3.6989
  3807 path_init_rcu                              3.2154
  3370 __mutex_init                              35.1042
  3254 mnt_want_write                             4.6222

oprofile isn't working on this guy either, and I no longer have
the patience to try working out where such locking is coming from
without lockdep or perf ;) But it sure is a lot better than your
profiles...
