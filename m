Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYKTISq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYKTISq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYKTISi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:18:38 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:52359 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbYKTISg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:18:36 -0500
Date: Thu, 20 Nov 2008 09:16:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: Nauman Rafique <nauman@google.com>, Fabio Checconi <fchecconi@gmail.com>,
       Vivek Goyal <vgoyal@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, taka@valinux.co.jp,
       righi.andrea@gmail.com, s-uchida@ap.jp.nec.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081120081640.GE26308@kernel.dk>
References: <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com> <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com> <20081118120508.GD15268@gandalf.sssup.it> <20081118140751.GA4283@redhat.com> <20081118144139.GE15268@gandalf.sssup.it> <20081118191208.GJ26308@kernel.dk> <e98e18940811181507t6b1473act2efa23df21dab270@mail.gmail.com> <20081119142446.GH26308@kernel.dk> <af41c7c40811191612v5db13ae7n3cfe537beb6a157c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af41c7c40811191612v5db13ae7n3cfe537beb6a157c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19 2008, Divyesh Shah wrote:
> On Wed, Nov 19, 2008 at 6:24 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Nov 18 2008, Nauman Rafique wrote:
> >> On Tue, Nov 18, 2008 at 11:12 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> > On Tue, Nov 18 2008, Fabio Checconi wrote:
> >> >> > From: Vivek Goyal <vgoyal@redhat.com>
> >> >> > Date: Tue, Nov 18, 2008 09:07:51AM -0500
> >> >> >
> >> >> > On Tue, Nov 18, 2008 at 01:05:08PM +0100, Fabio Checconi wrote:
> >> >> ...
> >> >> > > I have to think a little bit on how it would be possible to support
> >> >> > > an option for time-only budgets, coexisting with the current behavior,
> >> >> > > but I think it can be done.
> >> >> > >
> >> >> >
> >> >> > IIUC, bfq and cfq are different in following manner.
> >> >> >
> >> >> > a. BFQ employs WF2Q+ for fairness and CFQ employes weighted round robin.
> >> >> > b. BFQ uses the budget (sector count) as notion of service and CFQ uses
> >> >> >    time slices.
> >> >> > c. BFQ supports hierarchical fair queuing and CFQ does not.
> >> >> >
> >> >> > We are looking forward for implementation of point C. Fabio seems to
> >> >> > thinking of supporting time slice as a service (B). It seems like
> >> >> > convergence of CFQ and BFQ except the point A (WF2Q+ vs weighted round
> >> >> > robin).
> >> >> >
> >> >> > It looks like WF2Q+ provides tighter service bound and bfq guys mention
> >> >> > that they have been able to ensure throughput while ensuring tighter
> >> >> > bounds. If that's the case, does that mean BFQ is a replacement for CFQ
> >> >> > down the line?
> >> >> >
> >> >>
> >> >> BFQ started from CFQ, extending it in the way you correctly describe,
> >> >> so it is indeed very similar.  There are also some minor changes to
> >> >> locking, cic handling, hw_tag detection and to the CIC_SEEKY heuristic.
> >> >>
> >> >> The two schedulers share similar goals, and in my opinion BFQ can be
> >> >> considered, in the long term, a CFQ replacement; *but* before talking
> >> >> about replacing CFQ we have to consider that:
> >> >>
> >> >>   - it *needs* review and testing; we've done our best, but for sure
> >> >>     it's not enough; review and testing are never enough;
> >> >>   - the service domain fairness, which was one of our objectives, requires
> >> >>     some extra complexity; the mechanisms we used and the design choices
> >> >>     we've made may not fit all the needs, or may not be as generic as the
> >> >>     simpler CFQ's ones;
> >> >>   - CFQ has years of history behind and has been tuned for a wider
> >> >>     variety of environments than the ones we've been able to test.
> >> >>
> >> >> If time-based fairness is considered more robust and the loss of
> >> >> service-domain fairness is not a problem, then the two schedulers can
> >> >> be made even more similar.
> >> >
> >> > My preferred approach here would be, in order or TODO:
> >> >
> >> > - Create and test the smallish patches for seekiness, hw_tag checking,
> >> >  and so on for CFQ.
> >> > - Create and test a WF2Q+ service dispatching patch for CFQ.
> >> >
> >> > and if there are leftovers after that, we could even conditionally
> >> > enable some of those if appropriate. I think the WF2Q+ is quite cool and
> >> > could be easily usable as the default, so it's definitely a viable
> >> > alternative.
> >>
> >> 1 Merge BFQ into CFQ (Jens and Fabio). I am assuming that this would
> >> result in time slices being scheduled using WF2Q+
> >
> > Yep, at least that is my preference.
> >
> >> 2 Do the following to support proportional division:
> >>  a) Expose the per device weight interface to user, instead of calculating
> >>  from priority.
> >>  b) Add support for scheduling bandwidth among a hierarchy of cgroups
> >> (besides threads)
> >> 3 Do the following to support the goals of 2 level schedulers:
> >>  a) Limit the request descriptors allocated to each cgroup by adding
> >>  functionality to elv_may_queue()
> >>  b) Add support for putting an absolute limit on IO consumed by a
> >>  cgroup. Such support is provided by Andrea
> >>  Righi's patches too.
> >>  c) Add support (configurable option) to keep track of total disk
> >> time/sectors/count
> >>  consumed at each device, and factor that into scheduling decision
> >>  (more discussion needed here)
> >> 6 Incorporate an IO tracking approach which can allow tracking cgroups
> >> for asynchronous reads/writes.
> >> 7 Start an offline email thread to keep track of progress on the above
> >> goals.
> >>
> >> Jens, what is your opinion everything beyond (1) in the above list?
> >>
> >> It would be great if work on (1) and (2)-(7) can happen in parallel so
> >> that we can see "proportional division of IO bandwidth to cgroups" in
> >> tree sooner than later.
> >
> > Sounds feasible, I'd like to see the cgroups approach get more traction.
> > My primary concern is just that I don't want to merge it into specific
> > IO schedulers.
> 
> Jens,
>      So are you saying you don't prefer cgroups based proportional IO
> division solutions in the IO scheduler but at a layer above so it can
> be shared with all IO schedulers?
> 
>      If yes, then in that case, what do you think about Vivek Goyal's
> patch or dm-ioband that achieve that. Of course, both solutions don't
> meet all the requirements in the list above, but we can work on that
> once we know which direction we should be heading in. In fact, it
> would help if you could express the reservations (if you have any)
> about these approaches. That would help in coming up with a plan that
> everyone agrees on.

The dm approach has some merrits, the major one being that it'll fit
directly into existing setups that use dm and can be controlled with
familiar tools. That is a bonus. The draw back is partially the same -
it'll require dm. So it's still not a fit-all approach, unfortunately.

So I'd prefer an approach that doesn't force you to use dm.

-- 
Jens Axboe

