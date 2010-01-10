Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926Ab0AJX6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0AJX6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346Ab0AJX6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:58:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:37536 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0AJX6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:58:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iM1IfigDp3qMUFB0kDAjFL6XHVgBOa+wism9f/qPxYD+tSwj2Dfw1J4SGnsU9mLqM6
         ZtDqtHlgCl4q9j0bLnDV+CU897NmmhT6VlzpLNsSIXwyyMdN+3Sn/TfNvJk1acb2iSHG
         EsxN+eaOmaEwCJYg43dYgDXDxAZgs2ttBJi6M=
Date: Mon, 11 Jan 2010 00:57:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 6/6] perf: Increase round-robin fairness of flexible
	events
Message-ID: <20100110235758.GC5039@nowhere>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com> <1263087500-14215-7-git-send-regression-fweisbec@gmail.com> <20100110220440.GA4595@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110220440.GA4595@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 09:04:40AM +1100, Paul Mackerras wrote:
> Frederic,
> 
> Nice to see someone working on the event scheduling in perf.
> 
> But I don't think this patch makes sense:
> 
> > Group of flexible events are round-robined in each tick so that
> > each group has its chance to be scheduled. But the fairness
> > per group granularity doesn't propagate inside the groups
> > themselves.
> > 
> > If only the first events of each groups have a chance to make
> > their way, the remaining ones will never be scheduled.
> > 
> > Hence this patch propagates the round-robin to the events
> > inside the groups.
> 
> The semantic of a group is that either all of the events in the group
> are scheduled in, or none of them are.  So it doesn't make sense to
> talk about fairness within a group, and I don't see any point to
> rotating the elements of the sibling_list.  Or have I misunderstood
> what you're aiming at?


You're right. I forgot that a group that is only partially scheduled will
have its scheduled events cancelled.

But is it a sane behaviour considering the nature on non-pinned events?

Let's take an example. In x86 we have 4 breakpoint registers available.

We have 3 pinned breakpoint events in one group, and say, 2 groups
of flexible breakpoints:


 Pinned          Flexible0         Flexible1
   |                |                 |
  Bp1              Bp4               Bp6
  Bp2              Bp5               Bp7
  Bp3


The flexible ones will never get scheduled because
we only have 4 available slots and we need 5. And if
we try to schedule Flexible0, Bp4 will make it, but
not Bp5, so Bp4 get cancelled, and so on.

But the semantics of non-pinned counters is about
time-sharing them.

If we don't cancel partially-only scheduled flexible
groups and if we round robin inside flexible groups,
then these will all make it.

I think the constraint of "either every or none get
scheduled in a group" makes a lot of sense for pinned
groups.

But I don't see the point in applying this
rule inside flexible groups because the nature
of flexible events implies these have been created to
fight against a limited resource. So if this fight
is done only between groups, this is like raising
a voluntary starvation.

Or..or..May be I just realize too late that the semantic
of a group implies that all events inside must be always
counted simultaneously? In which case I agree with you,
this patch makes no sense and must be dropped.

