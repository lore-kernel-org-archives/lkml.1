Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0BBEPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 23:15:06 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45375 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0BBEPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 23:15:02 -0500
Date: Tue, 2 Feb 2010 09:44:48 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v5 PATCH 0/8] CFS Hard limits - v5
Message-ID: <20100202041448.GA17333@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com> <loom.20100108T214459-933@post.gmane.org> <344eb09a1001281949p37cd6d1awbc561937fc8f04f5@mail.gmail.com> <ed628a921001282026p2f8d64c7u416e55e48a21ea79@mail.gmail.com> <20100201082150.GB686@in.ibm.com> <ed628a921002010304p40397558lf45f53daca97e879@mail.gmail.com> <ed628a921002011025i432465acl166b845607546a64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed628a921002011025i432465acl166b845607546a64@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 10:25:11AM -0800, Paul Turner wrote:
> On Mon, Feb 1, 2010 at 3:04 AM, Paul Turner <pjt@google.com> wrote:
> > On Mon, Feb 1, 2010 at 12:21 AM, Bharata B Rao
> > <bharata@linux.vnet.ibm.com> wrote:
> >> On Thu, Jan 28, 2010 at 08:26:08PM -0800, Paul Turner wrote:
> >>> On Thu, Jan 28, 2010 at 7:49 PM, Bharata B Rao <bharata.rao@gmail.com> wrote:
> >>> > On Sat, Jan 9, 2010 at 2:15 AM, Paul Turner <pjt@google.com> wrote:
> >>> >>
> >>> >> What are your thoughts on using a separate mechanism for the general case.  A
> >>> >> draft proposal follows:
> >>> >>
> >>> >> - Maintain a global run-time pool for each tg.  The runtime specified by the
> >>> >>  user represents the value that this pool will be refilled to each period.
> >>> >> - We continue to maintain the local notion of runtime/period in each cfs_rq,
> >>> >>  continue to accumulate locally here.
> >>> >>
> >>> >> Upon locally exceeding the period acquire new credit from the global pool
> >>> >> (either under lock or more likely using atomic ops).  This can either be in
> >>> >> fixed steppings (e.g. 10ms, could be tunable) or following some quasi-curve
> >>> >> variant with historical demand.
> >>> >>
> >>> >> One caveat here is that there is some over-commit in the system, the local
> >>> >> differences of runtime vs period represent additional over the global pool.
> >>> >> However it should not be possible to consistently exceed limits since the rate
> >>> >> of refill is gated by the runtime being input into the system via the per-tg
> >>> >> pool.
> >>> >>
> >>> >
> >>> > We borrow from what is actually available as spare (spare = unused or
> >>> > remaining). With global pool, I see that would be difficult.
> >>> > Inability/difficulty in keeping the global pool in sync with the
> >>> > actual available spare time is the reason for over-commit ?
> >>> >
> >>>
> >>> We maintain two pools, a global pool (new) and a per-cfs_rq pool
> >>> (similar to existing rt_bw).
> >>>
> >>> When consuming time you charge vs your local bandwidth until it is
> >>> expired, at this point you must either refill from the global pool, or
> >>> throttle.
> >>>
> >>> The "slack" in the system is the sum of unconsumed time in local pools
> >>> from the *previous* global pool refill.  This is bounded above by the
> >>> size of time you refill a local pool at each expiry.  We call the size
> >>> of refill a 'slice'.
> >>>
> >>> e.g.
> >>>
> >>> Task limit of 50ms, slice=10ms, 4cpus, period of 500ms
> >>>
> >>> Task A runs on cpus 0 and 1 for 5ms each, then blocks.
> >>>
> >>> When A first executes on each cpu we take slice=10ms from the global
> >>> pool of 50ms and apply it to the local rq.  Execution then proceeds vs
> >>> local pool.
> >>>
> >>> Current state is: 5 ms in local pools on {0,1}, 30ms remaining in global pool
> >>>
> >>> Upon period expiration we issue a global pool refill.  At this point we have:
> >>> 5 ms in local pools on {0,1}, 50ms remaining in global pool.
> >>>
> >>> That 10ms of slack time is over-commit in the system.  However it
> >>> should be clear that this can only be a local effect since over any
> >>> period of time the rate of input into the system is limited by global
> >>> pool refill rate.
> >>
> >> With the same setup as above consider 5 such tasks which block after
> >> consuming 5ms each. So now we have 25ms slack time. In the next bandwidth
> >> period if 5 cpu hogs start running and they would consume this 25ms and the
> >> 50ms from this period. So we gave 50% extra to a group in a bandwidth period.
> >> Just wondering how common such scenarious could be.
> >>
> >
> > Yes within a single given period you may exceed your reservation due
> > to slack.  However, of note is that across any 2 successive periods
> > you are guaranteed to be within your reservation, i.e. 2*usage <=
> > 2*period, as slack available means that you under-consumed your
> > previous period.
> >
> > For those needing a hard guarantee (independent of amelioration
> > strategies) halving the period provided would then provide this across
> > their target period with the basic v1 implementation.
> >
> 
> Actually now that I think about it, this observation only holds when
> the slack is consumed within the second of the two periods.  It should
> be restated something like:
> 
> for any n contiguous periods your maximum usage is n*runtime +
> nr_cpus*slice, note the slack term is constant and is dominated for
> any observation window involving several periods

Ok. We are talking about 'hard limits' here and looks like there is
a theoritical possibility of exceeding the limit often. Need to understand
how good/bad this is in real life.

Regards,
Bharata.
