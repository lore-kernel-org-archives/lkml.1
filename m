Return-Path: <linux-kernel-owner+w=401wt.eu-S1761814AbZE2TRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761814AbZE2TRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZE2TRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:17:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42715 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZE2TRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:17:30 -0400
Date: Fri, 29 May 2009 15:16:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: Fabio Checconi <fchecconi@gmail.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, Chad Talbott <ctalbott@google.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in
	elevaotor layer
Message-ID: <20090529191649.GH26962@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-3-git-send-email-vgoyal@redhat.com> <e98e18940905271353kc6890dbxa1ea63026c8faec1@mail.gmail.com> <20090528160003.GA4335@redhat.com> <e98e18940905281241v4aa24716j91f351a828af604a@mail.gmail.com> <20090529160610.GC26962@redhat.com> <20090529165716.GB18141@gandalf.sssup.it> <e98e18940905291206p2e05bc5cxf499479270e34074@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98e18940905291206p2e05bc5cxf499479270e34074@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 12:06:03PM -0700, Nauman Rafique wrote:
> On Fri, May 29, 2009 at 9:57 AM, Fabio Checconi <fchecconi@gmail.com> wrote:
> >> From: Vivek Goyal <vgoyal@redhat.com>
> >> Date: Fri, May 29, 2009 12:06:10PM -0400
> >>
> >> On Thu, May 28, 2009 at 12:41:27PM -0700, Nauman Rafique wrote:
> > ...
> >> > I have some concerns about the new preemption logic.
> >>
> >> Actually we need a more proper definition of in-class preemption. Across
> >> class preemption means that RT class always gets to run first.
> >>
> >> What does in-class preemption mean? If I look at the current CFQ code,
> >> it does look like that preempting process will gain share. It is always
> >> added to the front of the tree with "rb_key=0" and that means, this new
> >> queue will get fresh time slice (even if it got time slice very recently).
> >>
> >> Currently I have just tried to make the behavior same as CFQ to reduce
> >> the possiblility of regressions. That's a different thing that we can
> >> discuss what should be the exact behavior in case of in-class preemption
> >> and first it needs to be fixed in CFQ, if current behavior is an issue.
> >>
> >> On the other hand, I am not sure if previous bfq preemption logic was
> >> working. We were checking if the new request belonged to the queue which
> >> will be served next, then preempt the existing queue. While looking
> >> for the next queue, I think we did not consider the current active
> >> entity (as it was not on the tree). So after expiry of the current
> >> queue, it might get selected next if it has not got its share. So there
> >> was no point in preempting the queue. If queue already got its share, then
> >> anyway the next queue will be selected next and there is no point in
> >> preempting the current queue.
> >>
> >
> > BFQ had no preemption logic, as far as I know; it simply was not
> > preemptive, and the guarantees it provided took that into account.
> >
> > I don't know what is the best way to introduce a CFQ-like preemption logic
> > into the wf2q+ code; for sure anything that does not schedule according
> > to the algorithm's timestamps is a good candidate to break the guarantees
> > the scheduler can provide, making it an extremely complex way to get
> > the same worst-case delays of a (much simpler) round-robin scheduler.
> >
> 
> What you guys think of my suggestion of handling preemption?
> Basically, we don't modify the start/finish tags, so overall the
> fairness properties should not be broken. But in short term, we still
> allow preemption and let one queue jump another.

It sounded complicated from the description of it. I would prefer either
we get rid of in-class preemtion thing completely or do in-class preemtption
at the cost of gaining share, like cfq does.

In fact, to begin with, I prefer to be as close as possible to CFQ and then
change things selectively one piece at a time so that we can analyze the
impact well.

Thanks
Vivek
