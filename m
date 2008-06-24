Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYFXB0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYFXB0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYFXB0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:26:44 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:45071 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751484AbYFXB0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:26:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gs1S6a8qgm9tgSsGolcWr6i0tDVHJqZJtyjXs7Y/NofkIMmSTX0wYe/3oTZ7eu+doIYQoyqmLALElyOSx5NS4YtA8+zuS+jDyRCDGSZj5HWkgMRvGqJU+G0TaTYQSvCJHhXSpGtOoxhyO+noN390V3pcL4DC/ytBQU/Q5B44q54=  ;
X-YMail-OSG: SQCDf3gVM1nl89jxQ1w.RNMqdyiuxP4txwrLMMhVx__gbmU6x5iXskQZ9lV46fECM52jaqMKSWxYsejatFSCkevGLVW08tdY0HcTw6MyHw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3] sched: terminate newidle balancing once at least one task has moved over
Date: Tue, 24 Jun 2008 11:26:28 +1000
User-Agent: KMail/1.9.5
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, dbahi@novell.com
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com> <200806241050.12028.nickpiggin@yahoo.com.au> <Pine.LNX.4.58.0806232104460.8540@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0806232104460.8540@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241126.28296.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 11:07, Steven Rostedt wrote:
> On Tue, 24 Jun 2008, Nick Piggin wrote:
> > On Tuesday 24 June 2008 09:04, Gregory Haskins wrote:
> > > Inspired by Peter Zijlstra.
> >
> > Is this really getting tested well? Because at least for SCHED_OTHER
> > tasks, the newidle balancer is still supposed to be relatively
> > conservative and not over balance too much. By the time you have
> > done all this calculation and reached here, it will be a loss to only
> > move one task if you could have moved two and halved your newidle
> > balance rate...
>
> We've been finding a lot of our high latencies have been coming from the
> balancing code. And the newidle balance is a large offender. I don't think

Measurements and results weren't in the changelog.

> it's much wasted work for what you want. Even if we wasted the work done,
> it was during "idle" time.

It is idle because it has gone idle. If we pulled more tasks in the last
newidle balance, it wouldn't have gone idle so early.

> But now we have a task to run, why not run it 
> now. Especially if that task is an RT task and doesn't like to wait.

Maybe I would agree if you check for an -rt task rather than generally.
At this level, throughput is the major concern for many more Linux users
than latency.


> The newidle balance should really just get a task to run, the balancing
> code should be done at a later time. Ideally when no RT tasks need to run.

I disagree. All balancing should be minimised, but if it has to run
then it should do as much balancing as it can. We already have checked
several other runqueues and calculated the busiest one  etc etc.
