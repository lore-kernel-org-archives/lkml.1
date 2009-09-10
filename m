Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZIJU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZIJU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZIJU6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbZIJU6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:58:19 -0400
Date: Thu, 10 Sep 2009 16:56:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [RFC] IO scheduler based IO controller V9
Message-ID: <20090910205657.GD3617@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4AA918C1.6070907@redhat.com> <20090910205227.GB3617@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910205227.GB3617@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 04:52:27PM -0400, Vivek Goyal wrote:
> On Thu, Sep 10, 2009 at 05:18:25PM +0200, Jerome Marchand wrote:
> > Vivek Goyal wrote:
> > > Hi All,
> > > 
> > > Here is the V9 of the IO controller patches generated on top of 2.6.31-rc7.
> >  
> > Hi Vivek,
> > 
> > I've run some postgresql benchmarks for io-controller. Tests have been
> > made with 2.6.31-rc6 kernel, without io-controller patches (when
> > relevant) and with io-controller v8 and v9 patches.
> > I set up two instances of the TPC-H database, each running in their
> > own io-cgroup. I ran two clients to these databases and tested on each
> > that simple request:
> > $ select count(*) from LINEITEM;
> > where LINEITEM is the biggest table of TPC-H (6001215 entries,
> > 720MB). That request generates a steady stream of IOs.
> > 
> > Time is measure by psql (\timing switched on). Each test is run twice
> > or more if there is any significant difference between the first two
> > runs. Before each run, the cache is flush:
> > $ echo 3 > /proc/sys/vm/drop_caches
> > 
> > 
> > Results with 2 groups of same io policy (BE) and same io weight (1000):
> > 
> > 	w/o io-scheduler	io-scheduler v8		io-scheduler v9
> > 	first	second		first	second		first	second
> > 	DB	DB		DB	DB		DB	DB
> > 
> > CFQ	48.4s	48.4s		48.2s	48.2s		48.1s	48.5s
> > Noop	138.0s	138.0s		48.3s	48.4s		48.5s	48.8s
> > AS	46.3s	47.0s		48.5s	48.7s		48.3s	48.5s
> > Deadl.	137.1s	137.1s		48.2s	48.3s		48.3s	48.5s
> > 
> > As you can see, there is no significant difference for CFQ
> > scheduler.
> 
> Thanks Jerome.  
> 
> > There is big improvement for noop and deadline schedulers
> > (why is that happening?).
> 
> I think because now related IO is in a single queue and it gets to run
> for 100ms or so (like CFQ). So previously, IO from both the instances
> will go into a single queue which should lead to more seeks as requests
> from two groups will kind of get interleaved.
> 
> With io controller, both groups have separate queues so requests from
> both the data based instances will not get interleaved (This almost
> becomes like CFQ where ther are separate queues for each io context
> and for sequential reader, one io context gets to run nicely for certain
> ms based on its priority).
> 
> > The performance with anticipatory scheduler
> > is a bit lower (~4%).
> > 

Hi Jerome, 

Can you also run the AS test with io controller patches and both the
database in root group (basically don't put them in to separate group). I 
suspect that this regression might come from that fact that we now have
to switch between queues and in AS we wait for request to finish from
previous queue before next queue is scheduled in and probably that is
slowing down things a bit.., just a wild guess..

Thanks
Vivek

> 
> I will run some tests with AS and see if I can reproduce this lower
> performance and attribute it to a particular piece of code.
> 
> > 
> > Results with 2 groups of same io policy (BE), different io weights and
> > CFQ scheduler:
> > 			io-scheduler v8		io-scheduler v9
> > weights = 1000, 500	35.6s	46.7s		35.6s	46.7s
> > weigths = 1000, 250	29.2s	45.8s		29.2s	45.6s
> > 
> > The result in term of fairness is close to what we can expect from the
> > ideal theoric case: with io weights of 1000 and 500 (1000 and 250),
> > the first request get 2/3 (4/5) of io time as long as it runs and thus
> > finish in about 3/4 (5/8) of total time. 
> > 
> 
> Jerome, after 36.6 seconds, disk will be fully given to second group.
> Hence these times might not reflect the accurate measure of who got how
> much of disk time.
> 
> Can you just capture the output of "io.disk_time" file in both the cgroups
> at the time of completion of task in higher weight group. Alternatively,
> you can just run this a script in a loop which prints the output of
>  "cat io.disk_time | grep major:minor" every  2 seconds. That way we can
> see how disk times are being distributed between groups.
> 
> > 
> > Results  with 2 groups of different io policies, same io weight and
> > CFQ scheduler:
> > 			io-scheduler v8		io-scheduler v9
> > policy = RT, BE		22.5s	45.3s		22.4s	45.0s
> > policy = BE, IDLE	22.6s	44.8s		22.4s	45.0s
> > 
> > Here again, the result in term of fairness is very close from what we
> > expect.
> 
> Same as above in this case too.
> 
> These seem to be good test for fairness measurement in case of streaming 
> readers. I think one more interesting test case will be do how are the 
> random read latencies in case of multiple streaming readers present.
> 
> So if we can launch 4-5 dd processes in one group and then issue some
> random small queueries on postgresql in second group, I am keen to see
> how quickly the query can be completed with and without io controller.
> Would be interesting to see at results for all 4 io schedulers.
> 
> Thanks
> Vivek
