Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbYH0GmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbYH0GmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYH0Gly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:41:54 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:35856 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752412AbYH0Glx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:41:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XNt8nMONruiHGF4skXYIpGN7TtZ9EOoCyXi2mupe100w8jEXUpAX6hE/M5bFu8hhy3nxGG9UVtwxk1RzcLrX+vwr3Ft0rXSxZxhRlw+EignS5+if/axFxFW0uelTbyP3L0Dr1w7DJ6L1aLy5KSERdwfknPWLa4XyBJrssn6vDHQ=  ;
X-YMail-OSG: mwxWsYAVM1nGwuuCO9qw3lc8D.gzhzIeZmHvgJCQBbNMXOnDFnZODj4vab4oXPtaogXfDQFh9XqxoihcgSP.ZLJUvTnTB67b5.43v9BmirD9mpcg9YGL9AlRo92I6mthUlaAiOwiMp_tz2s216HmFtPy
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 2/5] sched: pull only one task during NEWIDLE balancing to limit critical section
Date: Wed, 27 Aug 2008 16:41:46 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <200808261621.33810.nickpiggin@yahoo.com.au> <48B3EAD9.60609@novell.com>
In-Reply-To: <48B3EAD9.60609@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271641.46359.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 21:36, Gregory Haskins wrote:
> Nick Piggin wrote:
> > On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
> >> git-id c4acb2c0669c5c5c9b28e9d02a34b5c67edf7092 attempted to limit
> >> newidle critical section length by stopping after at least one task
> >> was moved.  Further investigation has shown that there are other
> >> paths nested further inside the algorithm which still remain that allow
> >> long latencies to occur with newidle balancing.  This patch applies
> >> the same technique inside balance_tasks() to limit the duration of
> >> this optional balancing operation.
> >>
> >> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> >> CC: Nick Piggin <npiggin@suse.de>
> >
> > Hmm, this (andc4acb2c0669c5c5c9b28e9d02a34b5c67edf7092) still could
> > increase the amount of work to do significantly for workloads where
> > the CPU is going idle and pulling tasks over frequently. I don't
> > really like either of them too much.
>
> I had a feeling you may object to this patch based on your comments on
> the first one.  Thats why I CC'd you so you wouldnt think I was trying
> to sneak something past ;)

Appreciated.


> > Maybe increasing the limit would effectively amortize most of the
> > problem (say, limit to move 16 tasks at most).
>
> The problem I was seeing was that even moving 2 was too many in the
> ftraces traces I looked at.  I think the idea of making a variable limit
> (set via a sysctl, etc) here is a good one, but I would recommend we
> have the default be "1" for CONFIG_PREEMPT (or at least
> CONFIG_PREEMPT_RT) based on what I know right now.   I know last time
> you objected to any kind of special cases for the preemptible kernels,
> but I think this is a good compromise.  Would this be acceptable?

Well I _prefer_ not to have a special case for preemptible kernels, but
we already have similar arbitrary kind of changes like in tlb flushing,
so...

I understand and accept there are some places where fundamentally you
have to trade latency for throughput, so at some point we have to have a
config and/or sysctl for that.

I'm surprised 2 is too much but 1 is OK. Seems pretty fragile to me. Are
you just running insane tests that load up the runqueues heaps and tests
latency? -rt users will have to understand that some algorithms scale
linearly or so with the number of a particular resource allocated, so
they aren't going to get a constant low latency under arbitrary
conditions.

FWIW, if you haven't already, then for -rt you might want to look at a
more advanced data structure than simple run ordered list for moving tasks
from one rq to the other. A simple one I was looking at is a time ordered
list to pull the most cache cold tasks (and thus we can stop searching
when we encounter the first cache hot task, in situations where it is
appropriate, etc).

Anyway... yeah I'm OK with this if it is under a config option.
