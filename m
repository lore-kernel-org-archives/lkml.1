Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbYKMSJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbYKMSJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYKMSJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:09:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49507 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYKMSJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:09:38 -0500
Date: Thu, 13 Nov 2008 13:08:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, "dpshah@google.com" <dpshah@google.com>,
       Mike Waychison <mikew@google.com>, rohitseth@google.com,
       Fabio Checconi <fchecconi@gmail.com>, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081113180821.GF7542@redhat.com>
References: <20081106163957.GB7461@redhat.com> <1225990327.7803.4776.camel@twins> <20081106170830.GD7461@redhat.com> <e98e18940811061507t3e19183byf2b8b291458ba81b@mail.gmail.com> <20081107141943.GC21884@redhat.com> <e98e18940811071336n58a073d8w2cbaeddd5657d1e9@mail.gmail.com> <20081110141143.GC26956@redhat.com> <e98e18940811111155q4bd73480pebe088fa1adbe2e4@mail.gmail.com> <20081111223024.GA31527@redhat.com> <e98e18940811121320w5f321302n13b526887cbb4012@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98e18940811121320w5f321302n13b526887cbb4012@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 01:20:13PM -0800, Nauman Rafique wrote:

[..]
> >> What do you think about elevator based solutions like 2 level cfq
> >> patches submitted by Satoshi and Vasily earlier?
> >
> > I have had a very high level look at Satoshi's patch. I will go into
> > details soon. I was thinking that this patch solves the problem only
> > for CFQ. Can we create a common layer which can be shared by all
> > the four IO schedulers.
> >
> > So this one common layer can take care of all the management w.r.t
> > per device per cgroup data structures and track all the groups, their
> > limits (either token based or time based scheme), and control the
> > dispatch of requests.
> >
> > This way we can enable IO controller not only for CFQ but for all the
> > IO schedulers without duplicating too much of code.
> >
> > This is what I am playing around with currently. At this point I am
> > not sure, how much of common ground I can have between all the IO
> > schedulers.
> 
> I see your point. But having some common code in different schedulers
> is not worse than what we have today (cfq, as, and deadline all have
> some common code). Besides, each lower level (elevator level)
> scheduler might impose certain requirements on higher level schedulers
> (e.g RT requests for cfq that we talked about earlier).
> 
> >
> >> CFQ can be trivially
> >> modified to do proportional division (i.e give time slices in
> >> proportion to weight instead of priority).
> >> And such a solution would
> >> avoid idleness problem like the one you mentioned above.
> >
> > Can you just elaborate a little on how do you get around idleness problem?
> > If you don't create idleness than if two tasks in two cgroups are doing
> > sequential IO, they might simply get into lockstep and we will not achieve
> > any differentiated service proportionate to their weight.
> 
> I was thinking of a more cfq-like solution for proportional division
> at the elevator level (i.e. not a token based solution). There are two
> options for proportional bandwidth division at elevator level: 1)
> change the size of the time slice in proportion to the weights or 2)
> allocate equal time slice each time but allocate more slices to cgroup
> with more weight. For (2), we can actually keep track of time taken to
> serve requests and allocate time slices in such a way that the actual
> disk time is proportional to the weight. We can adopt a fair-queuing
> (http://lkml.org/lkml/2008/4/1/234) like approach for this if we want
> to go that way.

Hi Nauman,

I think doing proportional weight division at elevator level will be
little difficult, because if we go for a full hierarchical solution then
we will be doing proportional weight division among tasks as well as
groups.

For example, consider this. Assume at root level there are three tasks
A, B, C and two cgroups D and E. Now for proportional weight division we
should consider A, B, C, D and E at same level and then try to divide
the BW (Thanks to peterz for clarifying this).

Other approach could be that consider A, B, C in root cgroup and then
consider root, D and E competing groups and try to divide the BW. But
this is not how cpu controller operates and this approach I think was
initially implemented for group scheduling in cpu controller and later
changed.

How the proportional weight division is done among tasks is a property
of IO scheduler. cfq decides to use time slices according to priority
and bfq decides to use tokens. So probably we can't move this to common
elevator layer.

I think Satoshi's cfq controller patches also do not seem to be considering
A, B, C, D and E to be at same level, instead it treats cgroup "/" , D and E
at same level and tries to do proportional BW division among these.
Satoshi, please correct me, if that's not the case.

Above example, raises another question and that is what to do wih IO
schedulers which do not differentiate between tasks. For example, noop. It
simply has got one single linked list and does not have the notion of
io context and does not differentiate between IO coming from different
tasks. In that case probably we have no choice but to group A, B, C's bio
in root cgroup and do proportional weight division among "root", D and E
groups. I have not looked at deadline and AS yet.

So at this point of time I think that probably porting BFQ's hierarchical
scheduling implementation to other IO schedulers might make sense. Thoughts?

While doing this may be we can try to keep some functionality like cgroup
interface common among various IO schedulers. 

Thanks
Vivek
