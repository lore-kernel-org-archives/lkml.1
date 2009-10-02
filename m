Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZJBJzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZJBJzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbZJBJzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:55:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41881 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484AbZJBJzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:55:52 -0400
Date: Fri, 2 Oct 2009 11:55:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002095555.GB26962@kernel.dk>
References: <1254034500.7933.6.camel@marge.simson.net> <20090927164235.GA23126@kernel.dk> <1254340730.7695.32.camel@marge.simson.net> <1254341139.7695.36.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <1254473609.6378.24.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254473609.6378.24.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02 2009, Mike Galbraith wrote:
> On Fri, 2009-10-02 at 10:04 +0200, Jens Axboe wrote:
> > On Fri, Oct 02 2009, Mike Galbraith wrote:
> 
> > > If we're in the idle window and doing the async drain thing, we've at
> > > the spot where Vivek's patch helps a ton.  Seemed like a great time to
> > > limit the size of any io that may land in front of my sync reader to
> > > plain "you are not alone" quantity.
> > 
> > You can't be in the idle window and doing async drain at the same time,
> > the idle window doesn't start until the sync queue has completed a
> > request. Hence my above rant on device interference.
> 
> I'll take your word for it.
> 
>         /*
>          * Drain async requests before we start sync IO
>          */
>         if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> 
> Looked about the same to me as..
>  
> 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
> 
> ..where Vivek prevented turning 1 into 0, so I stamped it ;-)

cfq_cfqq_idle_window(cfqq) just tells you whether this queue may enter
idling, not that it is currently idling. The actual idling happens from
cfq_completed_request(), here:

                else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
                         sync && !rq_noidle(rq))
                        cfq_arm_slice_timer(cfqd);

and after that the queue will be marked as waiting, so
cfq_cfqq_wait_request(cfqq) is a better indication of whether we are
currently waiting for a request (idling) or not.

> > > Dunno, I was just tossing rocks and sticks at it.
> > > 
> > > I don't really understand the reasoning behind overloading:  I can see
> > > that allows cutting thicker slabs for the disk, but with the streaming
> > > writer vs reader case, seems only the writers can do that.  The reader
> > > is unlikely to be alone isn't it?  Seems to me that either dd, a flusher
> > > thread or kjournald is going to be there with it, which gives dd a huge
> > > advantage.. it has two proxies to help it squabble over disk, konsole
> > > has none.
> > 
> > That is true, async queues have a huge advantage over sync ones. But
> > sync vs async is only part of it, any combination of queued sync, queued
> > sync random etc have different ramifications on behaviour of the
> > individual queue.
> > 
> > It's not hard to make the latency good, the hard bit is making sure we
> > also perform well for all other scenarios.
> 
> Yeah, that's why I'm trying to be careful about what I say, I know full
> well this ain't easy to get right.  I'm not even thinking of submitting
> anything, it's just diagnostic testing.

It's much appreciated btw, if we can make this better without killing
throughput, then I'm surely interested in picking up your interesting
bits and getting them massaged into something we can include. So don't
be discouraged, I'm just being realistic :-)


-- 
Jens Axboe

