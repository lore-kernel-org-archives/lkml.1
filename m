Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZCIHKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZCIHKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 03:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZCIHJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 03:09:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:12696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZCIHJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 03:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,328,1233561600"; 
   d="scan'208";a="118156928"
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
From: Lin Ming <ming.m.lin@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1236328388.11608.35.camel@minggr.sh.intel.com>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
	 <1235639427.11390.11.camel@minggr> <20090226110336.GC32756@csn.ul.ie>
	 <1235647139.16552.34.camel@penberg-laptop>
	 <20090226112232.GE32756@csn.ul.ie> <1235724283.11610.212.camel@minggr>
	 <20090302112122.GC21145@csn.ul.ie> <1236132307.2567.25.camel@ymzhang>
	 <20090304090740.GA27043@wotan.suse.de> <1236218198.2567.119.camel@ymzhang>
	 <20090305103403.GB32407@elte.hu>
	 <1236328388.11608.35.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 15:03:06 +0800
Message-Id: <1236582186.11608.47.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 16:33 +0800, Lin Ming wrote:
> On Thu, 2009-03-05 at 18:34 +0800, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > On Wed, 2009-03-04 at 10:07 +0100, Nick Piggin wrote:
> > > > On Wed, Mar 04, 2009 at 10:05:07AM +0800, Zhang, Yanmin wrote:
> > > > > On Mon, 2009-03-02 at 11:21 +0000, Mel Gorman wrote:
> > > > > > (Added Ingo as a second scheduler guy as there are queries on tg_shares_up)
> > > > > > 
> > > > > > On Fri, Feb 27, 2009 at 04:44:43PM +0800, Lin Ming wrote:
> > > > > > > On Thu, 2009-02-26 at 19:22 +0800, Mel Gorman wrote: 
> > > > > > > > In that case, Lin, could I also get the profiles for UDP-U-4K please so I
> > > > > > > > can see how time is being spent and why it might have gotten worse?
> > > > > > > 
> > > > > > > I have done the profiling (oltp and UDP-U-4K) with and without your v2
> > > > > > > patches applied to 2.6.29-rc6.
> > > > > > > I also enabled CONFIG_DEBUG_INFO so you can translate address to source
> > > > > > > line with addr2line.
> > > > > > > 
> > > > > > > You can download the oprofile data and vmlinux from below link,
> > > > > > > http://www.filefactory.com/file/af2330b/
> > > > > > > 
> > > > > > 
> > > > > > Perfect, thanks a lot for profiling this. It is a big help in figuring out
> > > > > > how the allocator is actually being used for your workloads.
> > > > > > 
> > > > > > The OLTP results had the following things to say about the page allocator.
> > > > > In case we might mislead you guys, I want to clarify that here OLTP is
> > > > > sysbench (oltp)+mysql, not the famous OLTP which needs lots of disks and big
> > > > > memory.
> > > > > 
> > > > > Ma Chinang, another Intel guy, does work on the famous OLTP running.
> > > > 
> > > > OK, so my comments WRT cache sensitivity probably don't apply here,
> > > > but probably cache hotness of pages coming out of the allocator
> > > > might still be important for this one.
> > > Yes. We need check it.
> > > 
> > > > 
> > > > How many runs are you doing of these tests?
> > > We start sysbench with different thread number, for example, 8 12 16 32 64 128 for
> > > 4*4 tigerton, then get an average value in case there might be a scalability issue.
> > > 
> > > As for this sysbench oltp testing, we reran it for 7 times on 
> > > tigerton this week and found the results have fluctuations. 
> > > Now we could only say there is a trend that the result with 
> > > the pathces is a little worse than the one without the 
> > > patches.
> > 
> > Could you try "perfstat -s" perhaps and see whether any other of 
> > the metrics outside of tx/sec has less natural noise?
> 
> Thanks, I have used "perfstat -s" to collect cache misses data.
> 
> 2.6.29-rc7-tip: tip/perfcounters/core (b5e8acf)
> 2.6.29-rc7-tip-mg2: v2 patches applied to tip/perfcounters/core
> 
> I collected 5 times netperf UDP-U-4k data with and without mg-v2 patches
> applied to tip/perfcounters/core on a 4p quad-core tigerton machine, as
> below
> "value" means UDP-U-4k test result.

I forgot to mention that below are the results without client/server
bind to different cpus.

./netserver
./netperf -t UDP_STREAM -l 60 -H 127.0.0.1  -- -P 15888,12384 -s 32768 -S 32768 -m 4096

> 
> 2.6.29-rc7-tip
> ---------------
> value           cache misses    CPU migrations  cachemisses/migrations
> 5329.71          391094656       1710            228710
> 5641.59          239552767       2138            112045
> 5580.87          132474745       2172            60992
> 5547.19          86911457        2099            41406
> 5626.38          196751217       2050            95976
> 
> 2.6.29-rc7-tip-mg2
> -------------------
> value           cache misses    CPU migrations  cachemisses/migrations
> 4749.80          649929463       1132            574142
> 4327.06          484100170       1252            386661
> 4649.51          374201508       1489            251310
> 5655.82          405511551       1848            219432
> 5571.58          90222256        2159            41788
> 
> Lin Ming
> 
> > 
> > I think a more invariant number might be the ratio of "LLC 
> > cachemisses" divided by "CPU migrations".
> > 
> > The fluctuation in tx/sec comes from threads bouncing - but you 
> > can normalize that away by using the cachemisses/migrations 
> > ration.
> > 
> > Perhaps. It's definitely a difficult thing to measure.
> > 
> > 	Ingo

