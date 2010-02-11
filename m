Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab0BKNOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:14:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:44608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0BKNOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:14:10 -0500
Date: Thu, 11 Feb 2010 14:14:17 +0100
From: Jan Kara <jack@suse.cz>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com, jmoyer@redhat.com
Subject: Re: CFQ slower than NOOP with pgbench
Message-ID: <20100211131416.GA3242@quack.suse.cz>
References: <20100210223255.GC3367@quack.suse.cz>
 <201002110940.33303.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002110940.33303.knikanth@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-02-10 09:40:33, Nikanth Karthikesan wrote:
> On Thursday 11 February 2010 04:02:55 Jan Kara wrote:
> >   Hi,
> > 
> >   I was playing with a pgbench benchmark - it runs a series of operations
> > on top of PostgreSQL database. I was using:
> >   pgbench -c 8 -t 2000 pgbench
> > which runs 8 threads and each thread does 2000 transactions over the
> > database. The funny thing is that the benchmark does ~70 tps (transactions
> > per second) with CFQ and ~90 tps with a NOOP io scheduler. This is with
> > 2.6.32 kernel.
> >   The load on the IO subsystem basically looks like lots of random reads
> > interleaved with occasional short synchronous sequential writes (the
> > database does write immediately followed by fdatasync) to the database
> > logs. I was pondering for quite some time why CFQ is slower and I've tried
> > tuning it in various ways without success. What I found is that with NOOP
> > scheduler, the fdatasync is like 20-times faster on average than with CFQ.
> > Looking at the block traces (available on request) this is usually because
> > when fdatasync is called, it takes time before the timeslice of the process
> > doing the sync comes (other processes are using their timeslices for reads)
> > and writes are dispatched... The question is: Can we do something about
> > that? Because I'm currently out of ideas except for hacks like "run this
> > queue immediately if it's fsync" or such...
> 
> I guess, noop would be hurting those reads which is also a synchronous 
> operation like fsync. But it doesn't seem to have a huge negative impact on 
> the pgbench. Is it because reads are random in this benchmark and delaying 
> them might even help by getting new requests for sectors in between two random 
> reads? If that is the case, I dont think fsync should be given higher priority 
> than reads based on this benchmark.
> 
> Can you make the blktrace available?
  OK, traces are available from:
http://beta.suse.com/private/jack/pgbench-cfq-noop/pgbench-blktrace.tar.gz

  I've tried also two tests: I've run the database with LD_PRELOAD so that
fdatasync does
a) nothing
b) calls sync_file_range(fd, 0, LLONG_MAX, SYNC_FILE_RANGE_WRITE)
c) calls posix_fadvise(fd, 0, LLONG_MAX, POSIX_FADV_DONTNEED)
   - it does filemap_flush() which was my main aim..

  The results (CFQ as a IO scheduler) are interesting. In a) the performance
was slightly higher than with NOOP scheduler and fully functional fdatasync.
Not surprising - we spend only like 2 s (out of ~200) in fdatasync with NOOP
scheduler.
  In b) the performance was only about 2% better than with full fdatasync
(with NOOP scheduler, it's ~20% better). Looking at the strace
output, it seems sync_file_range() takes as long as fdatasync() took -
probably because we are waiting for PageWriteback or lock_page.
  In c) the performance was ~11% better - fadvise calls seem to be quite
quick - comparable times between CFQ and NOOP. So higher latency of fdatasync
seems to be at least part of a problem...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
