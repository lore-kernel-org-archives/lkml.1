Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYFKUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYFKUoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYFKUoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:44:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38554 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYFKUoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:44:01 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5315"; a="3854540"
Message-ID: <48503931.3050600@qualcomm.com>
Date: Wed, 11 Jun 2008 13:44:33 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       menage@google.com, linux-kernel@vger.kernel.org,
       Mark Hounschell <dmarkh@cfl.rr.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: workqueue cpu affinity
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins> <484E9FE8.9040504@qualcomm.com> <20080610170005.GA6038@tv-sign.ru> <1213118386.19005.9.camel@lappy.programming.kicks-ass.net> <484EE303.9070007@qualcomm.com> <20080611160815.GA150@tv-sign.ru>
In-Reply-To: <20080611160815.GA150@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous emails were very long :). So here is an executive summary of the
discussions so far:

----
Workqueue kthread starvation by non-blocking user RT threads.

Starving workqueue threads on the isolated cpus does not seems like a big
deal. All current mainline users of schedule_on_cpu() kind of api can live
with it. Starvation of the workqueue threads is an issue for the -rt kernels.
See http://marc.info/?l=linux-kernel&m=121316707117552&w=2 for more info.

If absolutely necessary moving workqueue threads from the isolated cpus is
also not a big deal, even for cpu hotplug. It's certainly _not_ encouraged in
general but at the same time is not strictly prohibited either, because
nothing fundamental brakes (that's what my current isolation solution does).

----
Optimize workqueue flush.

Current flush_work_queue() implementation is an issue for the starvation case
mentioned above and in general it's not very efficient because it has to
schedule in each online cpu.

Peter suggested rewriting flush logic to avoid scheduling on each online cpu.

Oleg suggested converting existing users of flush_queued_work() to
cancel_work_sync(work) which will provide fine grained flushing and will not
schedule on each cpu.

Both of the suggestions would improve overall performance and address the case
when machine gets stuck due work queue thread starvation.

----
Timer or IPI based Oprofile.

Currently oprofile collects samples by using schedule_work_on_cpu(). Which
means that if workqueue threads are starved on, or moved from cpuX oprofile
fails to collect samples on that cpuX.

It seems that it can be easily converted to use per-CPU timer or IPI.
This might be useful in general (ie less expensive) and will take care of the
issue described above.

----
Optimize pagevec drain.

Current pavevec drain logic on the NUMA boxes schedules a workqueue on each
online cpu. It's not an issue for the CPU isolation per se but can be improved
in general.
Peter suggested keeping a cpumask of cpus with non-emppty pagevecs which will
not require scheduling work on each cpu.
I wonder if there is something on that front in the Nick's latest patches.
CC'ing Nick.

----

Did I miss anything ?


Max
