Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbZJCN6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbZJCN6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbZJCN6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:58:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:39757 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932171AbZJCN6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:58:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Ra1Z8LiURm4YvWLDnSZeiBFss1bwvw450a6IO3Q
	ozbuX3dYf47xmZ
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
 controller V10)
From: Mike Galbraith <efault@gmx.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
In-Reply-To: <20091003124049.GB12925@redhat.com>
References: <20091002171129.GG31616@kernel.dk>
	 <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk>
	 <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
	 <1254549378.8299.21.camel@marge.simson.net>
	 <20091003112915.GA12925@redhat.com>  <20091003124049.GB12925@redhat.com>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 15:57:57 +0200
Message-Id: <1254578277.7499.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 08:40 -0400, Vivek Goyal wrote:
> On Sat, Oct 03, 2009 at 07:29:15AM -0400, Vivek Goyal wrote:
> > On Sat, Oct 03, 2009 at 07:56:18AM +0200, Mike Galbraith wrote:
> > > On Sat, 2009-10-03 at 07:49 +0200, Mike Galbraith wrote:
> > > > On Fri, 2009-10-02 at 20:19 +0200, Jens Axboe wrote:
> > > > 
> > > > > If you could do a cleaned up version of your overload patch based on
> > > > > this:
> > > > > 
> > > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1d2235152dc745c6d94bedb550fea84cffdbf768
> > > > > 
> > > > > then lets take it from there.
> > > 
> > 
> > > Note to self: build the darn thing after last minute changes.
> > > 
> > > Block:  Delay overloading of CFQ queues to improve read latency.
> > > 
> > > Introduce a delay maximum dispatch timestamp, and stamp it when:
> > >         1. we encounter a known seeky or possibly new sync IO queue.
> > >         2. the current queue may go idle and we're draining async IO.
> > >         3. we have sync IO in flight and are servicing an async queue.
> > >         4  we are not the sole user of disk.
> > > Disallow exceeding quantum if any of these events have occurred recently.
> > > 
> > 
> > So it looks like primarily the issue seems to be that we done lot of
> > dispatch from async queue and if some sync queue comes in now, it will
> > experience latencies.
> > 
> > For a ongoing seeky sync queue issue will be solved up to some extent
> > because previously we did not choose to idle for that queue now we will
> > idle, hence async queue will not get a chance to overload the dispatch
> > queue.
> > 
> > For the sync queues where we choose not to enable idle, we still will see
> > the latencies. Instead of time stamping on all the above events, can we 
> > just keep track of last sync request completed in the system and don't
> > allow async queue to flood/overload the dispatch queue with-in certain 
> > time limit of that last sync request completion. This just gives a buffer
> > period to that sync queue to come back and submit more requests and
> > still not suffer large latencies?
> > 
> > Thanks
> > Vivek
> > 
> 
> Hi Mike,
> 
> Following is a quick hack patch for the above idea. It is just compile and
> boot tested. Can you please see if it helps in your scenario.

Box sends hugs and kisses.  s/desktop/latency and ship 'em :)

perf stat      1.70     1.94     1.32     1.89     1.87    1.7     fairness=1 overload_delay=1
               1.55     1.79     1.38     1.53     1.57    1.5     desktop=1 +last_end_sync

perf stat testo.sh                               Avg
108.12   106.33    106.34    97.00    106.52   104.8  1.000 fairness=0 overload_delay=0
 93.98   102.44     94.47    97.70     98.90    97.4   .929 fairness=0 overload_delay=1
 90.87    95.40     95.79    93.09     94.25    93.8   .895 fairness=1 overload_delay=0
 89.93    90.57     89.13    93.43     93.72    91.3   .871 fairness=1 overload_delay=1
 89.81    88.82     91.56    96.57     89.38    91.2   .870 desktop=1 +last_end_sync

	-Mike

