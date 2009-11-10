Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZKJJlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZKJJlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZKJJlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:41:39 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:51317 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZKJJlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BY3cEhx4QTihwN44WeOc5Hftj51nPZvf+Bv6/mWTsUXIcpU1/hjsh6Zjl7sxyUzgpD
         2syYNXh6TMrEzQtXVlYG4QS/zavsKQ6My2sI0zAC7yU4tNDcfYSXNppcQbfSpuqr3LXO
         2YoVdZlrtcsR8v/jOHre1R9nL8WneOcTMkLOk=
Date: Tue, 10 Nov 2009 10:41:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] perf/core: Small event scheduling changes
Message-ID: <20091110094143.GB5255@nowhere>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com> <20091110051321.GE7897@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110051321.GE7897@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 06:13:21AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > This is an rfc patchset, only compile tested just to ensure I'm taking 
> > a good direction before going ahead.
> > 
> > This is intended to rework a bit the perf event scheduling to 
> > guarantee a real priority of the pinned events over the volatile ones. 
> > This patchset handles such priority on task tick time only. But if the 
> > idea is agreed, I could expand that to every task event sched-in calls 
> > to guarantee the priority in every event rescheduling time.
> > 
> > Thanks.
> > 
> > Frederic Weisbecker (4):
> >   perf/core: split context's event group list into pinned and
> >     non-pinned lists
> >   perf/core: Optimize a bit rotate_ctx()
> >   perf/core: Split up pinned and non pinned processing
> >   perf/core: Schedule every pinned events before the the non-pinned
> > 
> >  include/linux/perf_event.h |    3 +-
> >  kernel/perf_event.c        |  283 ++++++++++++++++++++++++++++++++-----------
> >  2 files changed, 212 insertions(+), 74 deletions(-)
> 
> Sans the small naming suggestions i had, the general principle looks 
> good to me - it's a nice restructuring of the various scheduling rules 
> we have for events.
> 
> 	Ingo


Thanks.

With this draft, it makes the pinned priority more consistent
with its purpose but it doesn't yet bring the full pinned over
flexible priority determinism.

It does apply the priority in tick time, while we round robin.
I did that there first so that it covers most of the events
rescheduling actions and also it doesn't bring much more
overhead over the previous layout (in theory), it just changes
the order.

I'll also try to expand the priority constraint each time we
sched in a task: when we schedule a new task that belongs to
a new context, we don't schedule out/in the cpu context but
that will be needed if we want the full priority determinism.

Anyway, I'll do that progressively.

	Frederic.

