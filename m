Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZFHM2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZFHM2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZFHM2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:28:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34487 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZFHM2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:28:33 -0400
Date: Mon, 8 Jun 2009 14:28:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, david@fromorbit.com,
       hch@infradead.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090608122834.GH11363@kernel.dk>
References: <20090604195013.GB11363@kernel.dk> <20090604201012.GD11363@kernel.dk> <20090604223449.GA13780@nowhere> <20090605191528.GV11363@kernel.dk> <20090605211438.GA11650@duck.suse.cz> <20090606001814.GD3824@think> <20090606002339.GH11650@duck.suse.cz> <20090606010629.GC7809@nowhere> <20090608092338.GD11363@kernel.dk> <20090608122302.GA8524@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608122302.GA8524@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08 2009, Jan Kara wrote:
> On Mon 08-06-09 11:23:38, Jens Axboe wrote:
> > On Sat, Jun 06 2009, Frederic Weisbecker wrote:
> > > On Sat, Jun 06, 2009 at 02:23:40AM +0200, Jan Kara wrote:
> > > > On Fri 05-06-09 20:18:15, Chris Mason wrote:
> > > > > On Fri, Jun 05, 2009 at 11:14:38PM +0200, Jan Kara wrote:
> > > > > > On Fri 05-06-09 21:15:28, Jens Axboe wrote:
> > > > > > > On Fri, Jun 05 2009, Frederic Weisbecker wrote:
> > > > > > > > The result with noop is even more impressive.
> > > > > > > > 
> > > > > > > > See: http://kernel.org/pub/linux/kernel/people/frederic/dbench-noop.pdf
> > > > > > > > 
> > > > > > > > Also a comparison, noop with pdflush against noop with bdi writeback:
> > > > > > > > 
> > > > > > > > http://kernel.org/pub/linux/kernel/people/frederic/dbench-noop-cmp.pdf
> > > > > > > 
> > > > > > > OK, so things aren't exactly peachy here to begin with. It may not
> > > > > > > actually BE an issue, or at least now a new one, but that doesn't mean
> > > > > > > that we should not attempt to quantify the impact.
> > > > > >   What looks interesting is also the overall throughput. With pdflush we
> > > > > > get to 2.5 MB/s + 26 MB/s while with per-bdi we get to 2.7 MB/s + 13 MB/s.
> > > > > > So per-bdi seems to be *more* fair but throughput suffers a lot (which
> > > > > > might be inevitable due to incurred seeks).
> > > > > >   Frederic, how much does dbench achieve for you just on one partition
> > > > > > (test both consecutively if possible) with as many threads as have those
> > > > > > two dbench instances together? Thanks.
> > > > > 
> > > > > Is the graph showing us dbench tput or disk tput?  I'm assuming it is
> > > > > disk tput, so bdi may just be writing less?
> > > >   Good, question. I was assuming dbench throughput :).
> > > > 
> > > > 									Honza
> > > 
> > > 
> > > Yeah it's dbench. May be that's not the right tool to measure the writeback
> > > layer, even though dbench results are necessarily influenced by the writeback
> > > behaviour.
> > > 
> > > May be I should use something else?
> > > 
> > > Note that if you want I can put some surgicals trace_printk()
> > > in fs/fs-writeback.c
> > 
> > FWIW, I ran a similar test here just now. CFQ was used, two partitions
> > on an (otherwise) idle drive. I used 30 clients per dbench and 600s
> > runtime. Results are nearly identical, both throughout the run and
> > total:
> > 
> > /dev/sdb1
> > Throughput 165.738 MB/sec  30 clients  30 procs  max_latency=459.002 ms
> > 
> > /dev/sdb2
> > Throughput 165.773 MB/sec  30 clients  30 procs  max_latency=607.198 ms
>   Hmm, interesting. 165 MB/sec (in fact 330 MB/sec for that drive) sounds
> like quite a lot ;). This usually happens with dbench when the processes
> manage to delete / redirty data before writeback thread gets to them (so
> some IO happens in memory only and throughput is bound by the CPU / memory
> speed). So I think you are on a different part of the performance curve
> than Frederic. Probably you have to run with more threads so that dbench
> threads get throttled because of total amount of dirty data generated...

Certainly, the actual disk data rate was consistenctly in the
60-70MB/sec region. The issue is likely that the box has 6GB of RAM, if
I boot with less than 30 clients will do.

But unless the situation changes radically with memory pressure, it
still shows a fair distribution of IO between the two. Since they have
identical results throughout, it should be safe to assume that the have
equal bandwidth distribution at the disk end. A fast dbench run is one
that doesn't touch the disk at all, once you start touching disk you
lose :-)

-- 
Jens Axboe

