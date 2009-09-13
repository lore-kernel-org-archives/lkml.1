Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbZIMS4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbZIMS4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 14:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZIMS4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 14:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbZIMS4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 14:56:20 -0400
Date: Sun, 13 Sep 2009 14:54:47 -0400
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
Message-ID: <20090913185447.GA11003@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4AA918C1.6070907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA918C1.6070907@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 05:18:25PM +0200, Jerome Marchand wrote:
> Vivek Goyal wrote:
> > Hi All,
> > 
> > Here is the V9 of the IO controller patches generated on top of 2.6.31-rc7.
>  
> Hi Vivek,
> 
> I've run some postgresql benchmarks for io-controller. Tests have been
> made with 2.6.31-rc6 kernel, without io-controller patches (when
> relevant) and with io-controller v8 and v9 patches.
> I set up two instances of the TPC-H database, each running in their
> own io-cgroup. I ran two clients to these databases and tested on each
> that simple request:
> $ select count(*) from LINEITEM;
> where LINEITEM is the biggest table of TPC-H (6001215 entries,
> 720MB). That request generates a steady stream of IOs.
> 
> Time is measure by psql (\timing switched on). Each test is run twice
> or more if there is any significant difference between the first two
> runs. Before each run, the cache is flush:
> $ echo 3 > /proc/sys/vm/drop_caches
> 
> 
> Results with 2 groups of same io policy (BE) and same io weight (1000):
> 
> 	w/o io-scheduler	io-scheduler v8		io-scheduler v9
> 	first	second		first	second		first	second
> 	DB	DB		DB	DB		DB	DB
> 
> CFQ	48.4s	48.4s		48.2s	48.2s		48.1s	48.5s
> Noop	138.0s	138.0s		48.3s	48.4s		48.5s	48.8s
> AS	46.3s	47.0s		48.5s	48.7s		48.3s	48.5s
> Deadl.	137.1s	137.1s		48.2s	48.3s		48.3s	48.5s
> 
> As you can see, there is no significant difference for CFQ
> scheduler. There is big improvement for noop and deadline schedulers
> (why is that happening?). The performance with anticipatory scheduler
> is a bit lower (~4%).
> 

Ok, I think what's happening here is that by default slice lenght for
a queue is 100ms. When you put two instances of DB in two different
groups, one streaming reader can run at max for 100ms at a go and then 
we switch to next reader.

But when both the readers are in root group, then AS lets run one reader
to run at max 250ms (sometimes 125ms and sometimes 250ms based on at what
time as_fifo_expired() was invoked).

So because a reader gets to run longer at one stretch in root group, it
reduces number of seeks and leads to little enhanced throughput.

If you change the /sys/block/<disk>/queue/iosched/slice_sync to 250 ms, then
one group queue can run at max for 250ms before we switch the queue. In
this case you should be able to get same performance as in root group.

Thanks
Vivek
