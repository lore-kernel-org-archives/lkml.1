Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYFXBrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYFXBrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbYFXBqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:46:49 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:30359 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757767AbYFXBqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:46:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BLqkIf31hZCkW630hUQBqXeEjkT3pcReei3dNeTRvyHUjrESevSoIldUjUrZkUPfuoGd4GgTATVcMayOXBAukE+6oylhKrclXIOkOodTqE7IxHh2tOe5Pep/WMAv+NMejSemaTcjcKeGXPdALekxFYLRlADe2L/1636/hGAWvQk=  ;
X-YMail-OSG: c2YvAZsVM1lnYZCkBs2nJZldwTPusUUF5BszBUob7Fn0vEDac6kLIAgRj2ax8XxcLrtge5LQo51oj0QQUNB4RpdjH1_KOSDqwUUkpJYFnXxd1XMlt8WsTf5rZ1VBWyfHMWU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH 3/3] sched: terminate newidle balancing once at least one task has moved over
Date: Tue, 24 Jun 2008 11:46:34 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, "David Bahi" <DBahi@novell.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com> <200806241050.12028.nickpiggin@yahoo.com.au> <4860261A.BA47.005A.0@novell.com>
In-Reply-To: <4860261A.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241146.35112.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 12:39, Gregory Haskins wrote:
> Hi Nick,
>
> >>> On Mon, Jun 23, 2008 at  8:50 PM, in message
>
> <200806241050.12028.nickpiggin@yahoo.com.au>, Nick Piggin
>
> <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 24 June 2008 09:04, Gregory Haskins wrote:
> >> Inspired by Peter Zijlstra.
> >
> > Is this really getting tested well?   Because at least for SCHED_OTHER
> > tasks,
>
> Note that this only affects SCHED_OTHER.  RT tasks are handled with a
> different algorithm.
>
> > the newidle balancer is still supposed to be relatively
> > conservative and not over balance too much.
>
> In our testing, newidle is degrading the system (at least for certain
> workloads).  Oprofile was showing that newidle can account for 60-80% of
> the CPU during our benchmark runs. Turning off newidle *completely* by
> commenting out idle_balance() boosts netperf performance by 200% for our
> 8-core to 8-core UDP transaction test. Obviously neutering it is not
> sustainable as a general solution, so we are trying to reduce its negative
> impact.

Hmm. I'd like to see an attempt to be made to tuning the algorithm
so that newidle actually won't cause any tasks to be balanced in
this case. That seems like the right thing to do, doesn't it?

Of course... tuning the whole balancer on the basis of a crazy
netperf benchmark is... dangerous :)


> It is not clear whether the problem is that newidle is over-balancing the
> system, or that newidle is simply running too frequently as a symptom of a
> system that has a high frequency of context switching (such as -rt).  I 
> suspected the latter, so I was attracted to Peter's idea based on the
> concept of shortening the time we execute this function.  But I have to
> admit, unlike 1/3 and 2/3 which I have carefully benchmarked individually
> and know make a positive performance impact, I pulled this in more on
> theory.  I will try to benchmark this individually as well.
>
> > By the time you have
> > done all this calculation and reached here, it will be a loss to only
> > move one task if you could have moved two and halved your newidle
> > balance rate...
>
> Thats an interesting point that I did not consider, but note that a very
> significant chunk of the overhead I believe comes from the
> double_lock/move_tasks code after the algorithmic complexity is completed.

And that double lock will be amortized if you can move 2 tasks at once,
rather than 1 task each 2 times.


> I believe the primary motivation of this patch is related to reducing the
> overall latency in the schedule() critical section.  Currently this
> operation can perform an unbounded move_task operation in a
> preempt-disabled region (which, as an aside, is always SCHED_OTHER
> related).

Maybe putting some upper cap on it, I could live with. Cutting off at
one task I think needs a lot more thought and testing.
