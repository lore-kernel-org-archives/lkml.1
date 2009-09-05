Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZIEQQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZIEQQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 12:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZIEQQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 12:16:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58507 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZIEQQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 12:16:33 -0400
Date: Sat, 5 Sep 2009 18:16:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
Message-ID: <20090905161635.GI18599@kernel.dk>
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com> <x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com> <20090903130731.GE18599@kernel.dk> <4e5e476b0909030936l66ac3f22jd3b43d38bca0249b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0909030936l66ac3f22jd3b43d38bca0249b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03 2009, Corrado Zoccolo wrote:
> Hi Jens,
> On Thu, Sep 3, 2009 at 3:07 PM, Jens Axboe<jens.axboe@oracle.com> wrote:
> > On Thu, Sep 03 2009, Jeff Moyer wrote:
> >> Corrado Zoccolo <czoccolo@gmail.com> writes:
> >>
> >> > When the number of processes performing I/O concurrently increases,  a
> >> > fixed time slice per process will cause large latencies.
> >> > In the patch, if there are more than 3 processes performing concurrent
> >> > I/O, we scale the time slice down proportionally.
> >> > To safeguard sequential bandwidth, we impose a minimum time slice,
> >> > computed from cfq_slice_idle (the idea is that cfq_slice_idle
> >> > approximates the cost for a seek).
> >> >
> >> > I performed two tests, on a rotational disk:
> >> > * 32 concurrent processes performing random reads
> >> > ** the bandwidth is improved from 466KB/s to 477KB/s
> >> > ** the maximum latency is reduced from 7.667s to 1.728
> >> > * 32 concurrent processes performing sequential reads
> >> > ** the bandwidth is reduced from 28093KB/s to 24393KB/s
> >> > ** the maximum latency is reduced from 3.781s to 1.115s
> >> >
> >> > I expect numbers to be even better on SSDs, where the penalty to
> >> > disrupt sequential read is much less.
> >>
> >> Interesting approach.  I'm not sure what the benefits will be on SSDs,
> >> as the idling logic is disabled for them (when nonrot is set and they
> >> support ncq).  See cfq_arm_slice_timer.
> >
> > Also, the problem with scaling the slice a lot is that throughput has a
> > tendency to fall off a cliff at some point.
> 
> This is the reason that I have a minimum slice. It is already reached
> for 32 processes as in my example, so the throughput drop is at most
> 20%.
> Currently it is computed as 2*slice_idle for sync, and 1*slice_idle
> for async queues.
> I think this causes the leveling of data transferred regardless of
> priorities. I'll cook up a formula to better scale also the minimum
> slice according to priority, to fix this issue.

For your case, it may be different for other hardware. But I think the
approach is sane to some degree, it'll require more work though. One
problem is that the count of busy queues will fluctuate a lot for sync
IO, so you'll have fairness issues. The number of potentially interested
processes needs to be a rolling average of some sort, not just looking
at ->busy_queues.

> > Have you tried benchmarking
> > buffered writes with reads?
> 
> Yes. I used that workload for benchmarks while tuning the patch.
> Adding async writes doesn't change the results, mostly because cfq
> preempts async queues when sync queues have new requests, and with
> many readers, there are always plenty of incoming reads. Writes almost
> have no chance to happen.

OK, it should not, if the slice start logic is working. Just wanted to
make sure :-)

-- 
Jens Axboe

