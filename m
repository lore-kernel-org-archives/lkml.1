Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYCQJ5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYCQJ5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYCQJ5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:57:07 -0400
Received: from n5a.bullet.mud.yahoo.com ([209.191.126.232]:22624 "HELO
	n5a.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752026AbYCQJ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:57:06 -0400
X-Yahoo-Newman-Id: 495177.41549.bm@omp401.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=ZT5kZJORSPCGkYpzLeI9972zeVtCBRhWVpEpzGulREl3Cvd0JK7yjZT+gQiPGe/ryYHY4cW/pNERKi5Yekw66j6vToVRFlbhpp7frwmIfDnZUZ4be6hruG7vtcqUaSXR6z/HIZmfDJ2mea6guEgknSFK94j0kr7kb6remigW+Qc=  ;
X-YMail-OSG: YzgzM0EVM1kluWpkoFohscSymVtCdyzqWEArJo5f4Hvj3d8WdWIBg35rhG9PfsLKL.RCzd2h2A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Date: Mon, 17 Mar 2008 20:56:39 +1100
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Ray Lee <ray-lk@madrabbit.org>,
       Ingo Molnar <mingo@elte.hu>, "LKML," <linux-kernel@vger.kernel.org>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <200803171954.01315.nickpiggin@yahoo.com.au> <1205746084.8514.301.camel@twins>
In-Reply-To: <1205746084.8514.301.camel@twins>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803172056.39393.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008 20:28, Peter Zijlstra wrote:
> Nick,
>
> We do grow the period as the load increases, and this keeps the slice
> constant - although it might not be big enough for your taste (but its
> tunable)
>
> Short running tasks will indeed be very likely to be run quickly after
> wakeup because wakeup's are placed left in the tree. (and when using
> sleeper fairness, can get up to a whole slice bonus).
>
> Interactivity is all about generating a scheduling pattern that is easy
> on the human brain - that means predictable and preferably with lags <
> 40ms - as long as the interval is predictable the human brain will patch
> up a lot, once it becomes erratic all is out the window. (human
> perception of lags is in the 10ms range, but up to 40ms seems to do
> acceptable patch up as long as its predictable).
>
> Due to current desktop bloat, its important cpu bound tasks are treated
> well too. Take for instance scrolling firefox - that utterly consumes
> the fastest cpus, still people expect a smooth experience. By ensuring
> the scheduler behaviour degrades in a predicatable fashion, and trying
> to keep the latency to a sane level.

Yeah, and firefox scrolling is in the class of workloads where they
adaptively reduce CPU consumption as they get less quota (ie. because
they just start skipping).

Still, for desktop workloads you shouldn't have to deal with lots of
CPU hog processes on the runqueue, so I don't see why this is needed?

I don't mind having the timeslice smallish, but it shouldn't be
reduced as load increases.


> The thing that seems to trip up this psql thing is the strict
> requirement to always run the leftmost task. If all tasks have very
> short runnable periods, we start interleaving between all contending
> tasks. The way we're looking to solve this by weakening this leftmost
> requirement so that a server/client pair can ping-pong for a while, then
> switch to another pair which gets to ping-pong for a while.
>
> This alternating pattern as opposed to the interleaving pattern is much
> more friendly to the cache. And we should do it in such a manner that we
> still ensure fairness and predictablilty and such.
>
> The latest sched code contains a few patches in this direction
> (.25-rc6), and they seem to have the desired effect on 1 socket single
> and dual core and 8 socket single core and dual core. On quad core we
> seem to have some load balance problems that destroy the workload in
> other interresting ways - looking into that now.

Yeah, thanks for looking at that. Wow, scheduler patches sure make
it upstream a lot quicker than when I used to work on the damn thing ;)

I did a quick run and it seems like the postgresql overload problem is
far better if not solved now on my 2x quad core. Haven't had time to
get some reportable results, but I hope to.

