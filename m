Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZF2Jti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZF2Jti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbZF2JtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:49:03 -0400
Received: from stz-softwaretechnik.de ([217.160.223.211]:2687 "EHLO
	stlx01.stz-softwaretechnik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949AbZF2Jsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:48:54 -0400
Date: Mon, 29 Jun 2009 11:47:55 +0200
From: Ralf Gross <rg@stz-softwaretechnik.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Ralf Gross <rg@stz-softwaretechnik.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: io-scheduler tuning for better read/write ratio
Message-ID: <20090629094755.GD16642@p15145560.pureserver.info>
References: <20090616184027.GB7043@p15145560.pureserver.info> <4A37E7DB.7030100@redhat.com> <20090616185600.GC7043@p15145560.pureserver.info> <x49d494c4u0.fsf@segfault.boston.devel.redhat.com> <x49fxdsl46y.fsf@segfault.boston.devel.redhat.com> <20090622163113.GD12483@p15145560.pureserver.info> <x49hby8jbrd.fsf@segfault.boston.devel.redhat.com> <20090626021905.GA23981@localhost> <20090626104406.GK23611@kernel.dk> <20090627034658.GA13551@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090627034658.GA13551@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang schrieb:
> On Fri, Jun 26, 2009 at 06:44:06PM +0800, Jens Axboe wrote:
> > On Fri, Jun 26 2009, Wu Fengguang wrote:
> > > On Tue, Jun 23, 2009 at 03:42:46AM +0800, Jeff Moyer wrote:
> > > > Ralf Gross <rg@STZ-Softwaretechnik.com> writes:
> > > > 
> > > > > Jeff Moyer schrieb:
> > > > >> Jeff Moyer <jmoyer@redhat.com> writes:
> > > > >> 
> > > > >> > Ralf Gross <rg@stz-softwaretechnik.com> writes:
> > > > >> >
> > > > >> >> Casey Dahlin schrieb:
> > > > >> >>> On 06/16/2009 02:40 PM, Ralf Gross wrote:
> > > > >> >>> > David Newall schrieb:
> > > > >> >>> >> Ralf Gross wrote:
> > > > >> >>> >>> write throughput is much higher than the read throughput (40 MB/s
> > > > >> >>> >>> read, 90 MB/s write).
> > > > >> >>> > 
> > > > >> >>> > Hm, but I get higher read throughput (160-200 MB/s) if I don't write
> > > > >> >>> > to the device at the same time.
> > > > >> >>> > 
> > > > >> >>> > Ralf
> > > > >> >>> 
> > > > >> >>> How specifically are you testing? It could depend a lot on the
> > > > >> >>> particular access patterns you're using to test.
> > > > >> >>
> > > > >> >> I did the basic tests with tiobench. The real test is a test backup
> > > > >> >> (bacula) with 2 jobs that create 2 30 GB spool files on that device.
> > > > >> >> The jobs partially write to the device in parallel. Depending which
> > > > >> >> spool file reaches the 30 GB first, one starts reading from that file
> > > > >> >> and writing to tape, while to other is still spooling.
> > > > >> >
> > > > >> > We are missing a lot of details, here.  I guess the first thing I'd try
> > > > >> > would be bumping up the max_readahead_kb parameter, since I'm guessing
> > > > >> > that your backup application isn't driving very deep queue depths.  If
> > > > >> > that doesn't work, then please provide exact invocations of tiobench
> > > > >> > that reprduce the problem or some blktrace output for your real test.
> > > > >> 
> > > > >> Any news, Ralf?
> > > > >
> > > > > sorry for the delay. atm there are large backups running and using the
> > > > > raid device for spooling. So I can't do any tests.
> > > > >
> > > > > Re. read ahead: I tested different settings from 8Kb to 65Kb, this
> > > > > didn't help.
> > > > >
> > > > > I'll do some more tests when the backups are done (3-4 more days).
> > > > 
> > > > The default is 128KB, I believe, so it's strange that you would test
> > > > smaller values.  ;)  I would try something along the lines of 1 or 2 MB.
> > > > 
> > > > I'm CCing Fengguang in case he has any suggestions.
> > > 
> > > Jeff, thank you for the forwarding (and sorry for the long delay)!
> > > 
> > > The read:write (or rather sync:async) ratio control is an IO scheduler
> > > feature. CFQ has parameters slice_sync and slice_async for that.
> > > What's more, CFQ will let async IO wait if there are any in flight
> > > sync IO. This is good, but not quite enough. Normally sync IOs come
> > > one by one, with some small idle time window in between. If we only
> > > start dispatching async IOs after the last sync IO has completed for
> > > eg. 1ms, then we may stop the async background write IOs when there
> > > are active sync foreground read IO stream.
> > > 
> > > This simple patch aims to address the writes-push-aside-reads problem.
> > > Ralf, you can try applying this patch and run your workload with this
> > > (huge) CFQ parameter:
> > > 
> > >         echo 1000 > /sys/block/sda/queue/iosched/slice_sync 
> > > 
> > > The patch is based on 2.6.30, but can be trivially backported if you
> > > want to use some old kernel.
> > > 
> > > It may impact overall (sync+async) IO throughput when there are one or
> > > more ongoing sync IO streams, so requires considerable benchmarks and
> > > adjustments.
> > > 
> > > Thanks,
> > > Fengguang
> > > ---
> > > 
> > > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > > index a55a9bd..14011b7 100644
> > > --- a/block/cfq-iosched.c
> > > +++ b/block/cfq-iosched.c
> > > @@ -1064,7 +1064,6 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
> > >  	if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
> > >  		return;
> > >  
> > > -	WARN_ON(!RB_EMPTY_ROOT(&cfqq->sort_list));
> > >  	WARN_ON(cfq_cfqq_slice_new(cfqq));
> > >  
> > >  	/*
> > > @@ -2175,8 +2174,6 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
> > >  	 * or if we want to idle in case it has no pending requests.
> > >  	 */
> > >  	if (cfqd->active_queue == cfqq) {
> > > -		const bool cfqq_empty = RB_EMPTY_ROOT(&cfqq->sort_list);
> > > -
> > >  		if (cfq_cfqq_slice_new(cfqq)) {
> > >  			cfq_set_prio_slice(cfqd, cfqq);
> > >  			cfq_clear_cfqq_slice_new(cfqq);
> > > @@ -2190,8 +2187,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
> > >  		 */
> > >  		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
> > >  			cfq_slice_expired(cfqd, 1);
> > > -		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
> > > -			 sync && !rq_noidle(rq))
> > > +		else if (sync && !rq_noidle(rq) &&
> > > +			 !cfq_close_cooperator(cfqd, cfqq, 1))
> > >  			cfq_arm_slice_timer(cfqd);
> > >  	}
> > 
> > What's the purpose of this patch? If you have requests pending you don't
> > want to arm the idle timer and wait, you want to dispatch those.
> 
> You are right, please ignore this mindless hacking patch.
> 
> Ralf, you can do the read/write ratio in the CFQ scheduler by tuning
> the slice_sync/slice_async parameters.
> 
> For example,
> 
>         echo 10 > /sys//block/sda/queue/iosched/slice_async
>         echo 100 > /sys//block/sda/queue/iosched/slice_sync 
> 
> gives
> 
> -dsk/total-
>  read  writ
>   66M   25M
>   65M   20M
>   49M   32M
>   84M   19M
>   46M   28M
>   61M   23M
>   55M   25M
>   67M   23M
>   76M   18M
>   46M   31M
>   56M   29M
>   54M   23M
>   76M   20M


writing:

--dsk/md1--
_read _writ
   0   150M
   0   142M
   0   143M
   0   112M
   0   141M
   0   152M
   0   132M
   0   123M
   0   149M


reading:

--dsk/md1--
_read _writ
 143M    0 
 145M    0 
 160M    0 
 128M    0 
 148M    0 
 140M    0 
 158M    0 
 130M    0 
 122M    0 

reading + writing:

--dsk/md1--
_read _writ
  55M   76M
  41M   83M
  64M   81M
  64M   83M
  63M   68M
  56M  117M
  41M   61M
  64M   87M
  64M   69M
  61M   87M
  67M   81M
  64M   33M
  63M   68M
  56M   76M


 
> while 
> 
>         echo 10 > /sys//block/sda/queue/iosched/slice_async
>         echo 300 > /sys//block/sda/queue/iosched/slice_sync 
> 
> gives
> 
> -dsk/total-
>  read  writ
>  102M   11M
>   82M   10M
>  100M   12M
>   86M   10M
>   95M   11M
>  102M 3168k
>   96M   11M
>   88M   10M
>   96M   12M
> 
> However too large slice_sync may not be desirable.

writing:

--dsk/md1--
_read _writ
   0   131M
   0   136M
   0   145M
   0   136M
   0   128M
   0   150M
   0   127M
   0   149M
   0   127M
   0   156M
   0   125M
   0   142M

reading:

--dsk/md1--
_read _writ
 128M    0
 160M    0
 128M    0
 128M    0
 160M    0
 128M    0
 109M    0
 128M    0
 128M    0
 160M    0
 128M    0


writing:

--dsk/md1--
_read _writ
   0   183M
   0   142M
   0   137M
   0   147M
   0   135M
   0   147M
   0   117M
   0   135M
   0   156M
   0   120M
   0   147M
   0   135M

reading + writing:

--dsk/md1--
_read _writ
  96M   40M
  64M   38M
  96M   29M
  96M   24M
  96M   31M
  95M   35M
  97M   26M
  96M   23M
  96M   33M
  95M   73M
  91M   25M


Thanks, this seem to be what I was looking for. I'll change the scheduler
parameter for all spool devices and will run a backup with two concurrent
backups. This will show me if bacula behaves the same as the simple dd test
does.


Ralf
