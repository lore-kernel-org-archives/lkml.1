Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0BRS4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:56:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:37042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab0BRS4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:56:48 -0500
Date: Thu, 18 Feb 2010 19:56:56 +0100
From: Jan Kara <jack@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Nikanth Karthikesan <knikanth@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
       jmoyer@redhat.com
Subject: Re: CFQ slower than NOOP with pgbench
Message-ID: <20100218185656.GD3364@quack.suse.cz>
References: <20100210223255.GC3367@quack.suse.cz>
 <201002110940.33303.knikanth@suse.de>
 <20100211131416.GA3242@quack.suse.cz>
 <20100211193040.GA2714@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211193040.GA2714@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-02-10 14:30:41, Vivek Goyal wrote:
> On Thu, Feb 11, 2010 at 02:14:17PM +0100, Jan Kara wrote:
> > On Thu 11-02-10 09:40:33, Nikanth Karthikesan wrote:
> > > On Thursday 11 February 2010 04:02:55 Jan Kara wrote:
> > > >   Hi,
> > > > 
> > > >   I was playing with a pgbench benchmark - it runs a series of operations
> > > > on top of PostgreSQL database. I was using:
> > > >   pgbench -c 8 -t 2000 pgbench
> > > > which runs 8 threads and each thread does 2000 transactions over the
> > > > database. The funny thing is that the benchmark does ~70 tps (transactions
> > > > per second) with CFQ and ~90 tps with a NOOP io scheduler. This is with
> > > > 2.6.32 kernel.
> > > >   The load on the IO subsystem basically looks like lots of random reads
> > > > interleaved with occasional short synchronous sequential writes (the
> > > > database does write immediately followed by fdatasync) to the database
> > > > logs. I was pondering for quite some time why CFQ is slower and I've tried
> > > > tuning it in various ways without success. What I found is that with NOOP
> > > > scheduler, the fdatasync is like 20-times faster on average than with CFQ.
> > > > Looking at the block traces (available on request) this is usually because
> > > > when fdatasync is called, it takes time before the timeslice of the process
> > > > doing the sync comes (other processes are using their timeslices for reads)
> > > > and writes are dispatched... The question is: Can we do something about
> > > > that? Because I'm currently out of ideas except for hacks like "run this
> > > > queue immediately if it's fsync" or such...
> > > 
> > > I guess, noop would be hurting those reads which is also a synchronous 
> > > operation like fsync. But it doesn't seem to have a huge negative impact on 
> > > the pgbench. Is it because reads are random in this benchmark and delaying 
> > > them might even help by getting new requests for sectors in between two random 
> > > reads? If that is the case, I dont think fsync should be given higher priority 
> > > than reads based on this benchmark.
> > > 
> > > Can you make the blktrace available?
> >   OK, traces are available from:
> > http://beta.suse.com/private/jack/pgbench-cfq-noop/pgbench-blktrace.tar.gz
> > 
> 
> I had a quick look at the blktrace of cfq. Looks like CFQ is idling on 
> random read sync queues also and that could be one reason contributing to
> reduced throughput of pgpbench. This helpled in reducing random workload
> latencies in the presence of other sequential read or write going on.
> 
> Later corrodo changed the logic to do group wait on all random readers
> instead of individual queue. 
> 
> Can you please try latest kernel 2.6.32-rc7 and see if you still see the
> issue. This version does group wait on random readers as well as drives
> deeper queue depths for writers. (deeper queue depth might not help on 
> SATA but does help if multiple spindles are behind RAID card).
> 
> Or, if your SATA, disk suppports NCQ, then just set low_latency=0 on
> 2.6.32 kernel. Looking at 2.6.32 code, it looks like that will also
> disable idling on random reader queues.
  Thanks for suggestions! I've now got to do the testing and the latest
upstream kernel has the same CFQ performance as NOOP for pgbench. Also
setting low_latency to 0 helped in 2.6.32 kernel...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
