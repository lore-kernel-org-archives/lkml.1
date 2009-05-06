Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbZEFWXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbZEFWXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763304AbZEFWTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:19:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762261AbZEFWTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:19:42 -0400
Date: Wed, 6 May 2009 18:17:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com,
       m-ikeda@ds.jp.nec.com, peterz@infradead.org
Subject: Re: IO scheduler based IO Controller V2
Message-ID: <20090506221741.GL8180@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org> <20090506023332.GA1212@redhat.com> <20090506200751.GA4282@linux> <20090506212121.GI8180@redhat.com> <20090506220250.GD4282@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506220250.GD4282@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 12:02:51AM +0200, Andrea Righi wrote:
> On Wed, May 06, 2009 at 05:21:21PM -0400, Vivek Goyal wrote:
> > > Well, IMHO the big concern is at which level we want to implement the
> > > logic of control: IO scheduler, when the IO requests are already
> > > submitted and need to be dispatched, or at high level when the
> > > applications generates IO requests (or maybe both).
> > > 
> > > And, as pointed by Andrew, do everything by a cgroup-based controller.
> > 
> > I am not sure what's the rationale behind that. Why to do it at higher
> > layer? Doing it at IO scheduler layer will make sure that one does not
> > breaks the IO scheduler's properties with-in cgroup. (See my other mail
> > with some io-throttling test results).
> > 
> > The advantage of higher layer mechanism is that it can also cover software
> > RAID devices well. 
> > 
> > > 
> > > The other features, proportional BW, throttling, take the current ioprio
> > > model in account, etc. are implementation details and any of the
> > > proposed solutions can be extended to support all these features. I
> > > mean, io-throttle can be extended to support proportional BW (for a
> > > certain perspective it is already provided by the throttling water mark
> > > in v16), as well as the IO scheduler based controller can be extended to
> > > support absolute BW limits. The same for dm-ioband. I don't think
> > > there're huge obstacle to merge the functionalities in this sense.
> > 
> > Yes, from technical point of view, one can implement a proportional BW
> > controller at higher layer also. But that would practically mean almost
> > re-implementing the CFQ logic at higher layer. Now why to get into all
> > that complexity. Why not simply make CFQ hiearchical to also handle the
> > groups?
> 
> Make CFQ aware of cgroups is very important also. I could be wrong, but
> I don't think we shouldn't re-implement the same exact CFQ logic at
> higher layers. CFQ dispatches IO requests, at higher layers applications
> submit IO requests. We're talking about different things and applying
> different logic doesn't sound too strange IMHO. I mean, at least we
> should consider/test also this different approach before deciding drop
> it.
> 

Lot of CFQ code is all about maintaining per io context queues, for
different classes and different prio level, about anticipation for
reads etc. Anybody who wants to get classes and ioprio within cgroup
right will end up duplicating all that logic (to cover all the cases).
So I did not mean that you will end up copying the whole code but
logically a lot of it.

Secondly, there will be mismatch in anticipation logic. CFQ gives
preference to reads and for dependent readers it idles and waits for
next request to come. A higher level throttling can interefere with IO
pattern of application and can lead CFQ to think that average thinktime
of this application is high and disable the anticipation on that
application. Which should result in high latencies for simple commands
like "ls", in presence of competing applications. 

> This solution also guarantee no changes in the IO schedulers for those
> who are not interested in using the cgroup IO controller. What is the
> impact of the IO scheduler based controller for those users?
> 

IO scheduler based solution is highly customizable. First of all there
are compile time switches to either completely remove fair queuing code
(for noop, deadline and AS only) or to disable group scheduling only. If
that's the case one would expect same behavior as old scheduler.

Secondly, even if everything is compiled in and customer is not using
cgroups, I would expect almost same behavior (because we will have only
root group). There will be extra code in the way and we will need some
optimizations to detect that there is only one group and bypass as much
code as possible bringing the overhead of the new code to the minimum. 

So if customer is not using IO controller, he should get the same behavior
as old system. Can't prove it right now because my patches are not in that
matured but there are no fundamental design limitations.

Thanks
Vivek
