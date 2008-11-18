Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYKRTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYKRTOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 14:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYKRTOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 14:14:01 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56719 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbYKRTOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:14:00 -0500
Date: Tue, 18 Nov 2008 20:12:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Nauman Rafique <nauman@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Divyesh Shah <dpshah@google.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, taka@valinux.co.jp,
       righi.andrea@gmail.com, s-uchida@ap.jp.nec.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081118191208.GJ26308@kernel.dk>
References: <20081113214642.GG7542@redhat.com> <af41c7c40811131457w472e4a86tb5344cc1d3d366fb@mail.gmail.com> <20081114160525.GE24624@redhat.com> <e98e18940811141444u5947b806v27fac453ed1e8a5@mail.gmail.com> <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com> <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com> <20081118120508.GD15268@gandalf.sssup.it> <20081118140751.GA4283@redhat.com> <20081118144139.GE15268@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118144139.GE15268@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18 2008, Fabio Checconi wrote:
> > From: Vivek Goyal <vgoyal@redhat.com>
> > Date: Tue, Nov 18, 2008 09:07:51AM -0500
> >
> > On Tue, Nov 18, 2008 at 01:05:08PM +0100, Fabio Checconi wrote:
> ...
> > > I have to think a little bit on how it would be possible to support
> > > an option for time-only budgets, coexisting with the current behavior,
> > > but I think it can be done.
> > > 
> > 
> > IIUC, bfq and cfq are different in following manner.
> > 
> > a. BFQ employs WF2Q+ for fairness and CFQ employes weighted round robin.
> > b. BFQ uses the budget (sector count) as notion of service and CFQ uses
> >    time slices.
> > c. BFQ supports hierarchical fair queuing and CFQ does not.  
> > 
> > We are looking forward for implementation of point C. Fabio seems to
> > thinking of supporting time slice as a service (B). It seems like
> > convergence of CFQ and BFQ except the point A (WF2Q+ vs weighted round
> > robin). 
> > 
> > It looks like WF2Q+ provides tighter service bound and bfq guys mention
> > that they have been able to ensure throughput while ensuring tighter 
> > bounds. If that's the case, does that mean BFQ is a replacement for CFQ
> > down the line?
> >   
> 
> BFQ started from CFQ, extending it in the way you correctly describe,
> so it is indeed very similar.  There are also some minor changes to
> locking, cic handling, hw_tag detection and to the CIC_SEEKY heuristic.
> 
> The two schedulers share similar goals, and in my opinion BFQ can be
> considered, in the long term, a CFQ replacement; *but* before talking
> about replacing CFQ we have to consider that:
> 
>   - it *needs* review and testing; we've done our best, but for sure
>     it's not enough; review and testing are never enough;
>   - the service domain fairness, which was one of our objectives, requires
>     some extra complexity; the mechanisms we used and the design choices
>     we've made may not fit all the needs, or may not be as generic as the
>     simpler CFQ's ones;
>   - CFQ has years of history behind and has been tuned for a wider
>     variety of environments than the ones we've been able to test.
> 
> If time-based fairness is considered more robust and the loss of
> service-domain fairness is not a problem, then the two schedulers can
> be made even more similar.

My preferred approach here would be, in order or TODO:

- Create and test the smallish patches for seekiness, hw_tag checking,
  and so on for CFQ.
- Create and test a WF2Q+ service dispatching patch for CFQ.

and if there are leftovers after that, we could even conditionally
enable some of those if appropriate. I think the WF2Q+ is quite cool and
could be easily usable as the default, so it's definitely a viable
alternative.

My main goal here is basically avoiding addition of Yet Another IO
scheduler, especially one that is so closely tied to CFQ already.

I'll start things off by splitting cfq into a few files similar to what
bfq has done, as I think it makes a lot of sense. Fabio, if you could
create patches for the small behavioural changes you made, we can
discuss and hopefully merge those next.

-- 
Jens Axboe

