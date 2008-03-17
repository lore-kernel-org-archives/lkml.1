Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbYCQJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbYCQJ2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYCQJ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:28:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40175 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbYCQJ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:28:43 -0400
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Willy Tarreau <w@1wt.eu>, Ray Lee <ray-lk@madrabbit.org>,
       Ingo Molnar <mingo@elte.hu>, "LKML," <linux-kernel@vger.kernel.org>
In-Reply-To: <200803171954.01315.nickpiggin@yahoo.com.au>
References: <200803111749.29143.nickpiggin@yahoo.com.au>
	 <200803171819.38892.nickpiggin@yahoo.com.au>
	 <20080317082638.GB18229@1wt.eu>
	 <200803171954.01315.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 10:28:04 +0100
Message-Id: <1205746084.8514.301.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick,

We do grow the period as the load increases, and this keeps the slice
constant - although it might not be big enough for your taste (but its
tunable)

Short running tasks will indeed be very likely to be run quickly after
wakeup because wakeup's are placed left in the tree. (and when using
sleeper fairness, can get up to a whole slice bonus).

Interactivity is all about generating a scheduling pattern that is easy
on the human brain - that means predictable and preferably with lags <
40ms - as long as the interval is predictable the human brain will patch
up a lot, once it becomes erratic all is out the window. (human
perception of lags is in the 10ms range, but up to 40ms seems to do
acceptable patch up as long as its predictable).

Due to current desktop bloat, its important cpu bound tasks are treated
well too. Take for instance scrolling firefox - that utterly consumes
the fastest cpus, still people expect a smooth experience. By ensuring
the scheduler behaviour degrades in a predicatable fashion, and trying
to keep the latency to a sane level.


The thing that seems to trip up this psql thing is the strict
requirement to always run the leftmost task. If all tasks have very
short runnable periods, we start interleaving between all contending
tasks. The way we're looking to solve this by weakening this leftmost
requirement so that a server/client pair can ping-pong for a while, then
switch to another pair which gets to ping-pong for a while.

This alternating pattern as opposed to the interleaving pattern is much
more friendly to the cache. And we should do it in such a manner that we
still ensure fairness and predictablilty and such.

The latest sched code contains a few patches in this direction
(.25-rc6), and they seem to have the desired effect on 1 socket single
and dual core and 8 socket single core and dual core. On quad core we
seem to have some load balance problems that destroy the workload in
other interresting ways - looking into that now.

- Peter

