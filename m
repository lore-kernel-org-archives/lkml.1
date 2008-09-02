Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYIBVna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYIBVna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYIBVnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:43:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYIBVnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:43:21 -0400
Date: Tue, 2 Sep 2008 17:41:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       randy.dunlap@oracle.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, akpm@linux-foundation.org, agk@sourceware.org,
       subrata@linux.vnet.ibm.com, axboe@kernel.dk,
       Marco Innocenti <m.innocenti@cineca.it>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com, dradford@bluehost.com
Subject: Re: [RFC][PATCH -mm 0/5] cgroup: block device i/o controller (v9)
Message-ID: <20080902214146.GA3382@redhat.com>
References: <1219853257-11052-1-git-send-email-righi.andrea@gmail.com> <20080902180620.GE15847@redhat.com> <48BDA704.9040000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BDA704.9040000@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 10:50:12PM +0200, Andrea Righi wrote:
> Vivek Goyal wrote:
> > On Wed, Aug 27, 2008 at 06:07:32PM +0200, Andrea Righi wrote:
> >> The objective of the i/o controller is to improve i/o performance
> >> predictability of different cgroups sharing the same block devices.
> >>
> >> Respect to other priority/weight-based solutions the approach used by this
> >> controller is to explicitly choke applications' requests that directly (or
> >> indirectly) generate i/o activity in the system.
> >>
> > 
> > Hi Andrea,
> > 
> > I was checking out the pass discussion on this topic and there seemed to
> > be two kind of people. One who wanted to control max bandwidth and other
> > who liked proportional bandwidth approach  (dm-ioband folks).
> > 
> > I was just wondering, is it possible to have both the approaches and let
> > users decide at run time which one do they want to use (something like
> > the way users can choose io schedulers).
> > 
> > Thanks
> > Vivek
> 
> Hi Vivek,
> 
> yes, sounds reasonable (adding the proportional bandwidth control to my
> TODO list).
> 
> Right now I've a totally experimental patch to add the ionice-like
> functionality (it's not the same but it's quite similar to the
> proportional bandwidth feature) on-top-of my IO controller. See below.
> 
> The patch is not very well tested, I don't even know if it applies
> cleanly to the latest io-throttle patch I posted, or if it have runtime
> failures, it needs more testing.
> 
> Anyway, this adds the file blockio.ionice that can be used to set
> per-cgroup IO priorities, just like ionice, the difference is that it
> works per-cgroup instead of per-task (it can be easily improved to
> also support per-device priority).
> 
> The solution I've used is really trivial: all the tasks belonging to a
> cgroup share the same io_context, so actually it means that they also
> share the same disk time given by the IO scheduler and the tasks'
> requests coming from a cgroup are considered as they were issued by a
> single task. This works only for CFQ and AS, because deadline and noop
> have no concept of IO contexts.
> 

Probably we don't want to share io contexts among the tasks of same cgroup
because then requests from all the tasks of the cgroup will be queued
on the same cfq queue and we will loose the notion of task priority.

(I think you already covered this point in next paragraph.)

Maybe we need to create cgroup ids (the way bio-cgroup patchset does).

> I would also like to merge the Satoshi's cfq-cgroup functionalities to
> provide "fairness" also within each cgroup, but the drawback is that it
> would work only for CFQ.
> 

I thought that implementation at generic layer can provide the fairness
between various cgroups (based on their weight/priority) and then fairness
within cgroup will be provided by respecitve IO scheduler (Depending on what
kind of fairness notion IO scheduler carries, for example task priority in
cfq.).

So at generic layer we probably need to just think about how to keep track
of various cgroups per device (probably in a rb tree like cpu scheduler)
and how to schedule these cgroups to submit request to IO scheduer, based
on cgroup weight/priority.

I will read up Satoshi's patches to understand better.

> So, in conclusion, I'd really like to implement a more generic
> weighted/priority cgroup-based policy to schedule bios like dm-ioband,
> maybe implementing the hook directly in submit_bio() or
> generic_make_request(), independent also of the dm infrastructure.
> 

I was wondering that why dm-ioband is creating another LVM driver
dm-ioband. Configuring an ioband device for every logical/physical device
we want to control looks little odd to me. Can't we achive the same thing
by implementing all the logic in generic block layer without any
additional LVM driver?

Thanks
Vivek
