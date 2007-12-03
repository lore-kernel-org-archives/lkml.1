Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXLCT51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXLCT51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXLCT5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:57:16 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:58760 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbXLCT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:57:15 -0500
Message-ID: <47545F88.6070609@nortel.com>
Date: Mon, 03 Dec 2007 13:56:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: davids@webmaster.com
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
References: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2007 19:57:00.0436 (UTC) FILETIME=[AACCD540:01C835E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
> Chris Friesen wrote:


> If CFS really can't support sched_yield's semantics, then it should just
> not, and that's that. Return ENOSYS and admit that the behavior sched_yield
> is documented to have simply can't be supported by the scheduler.

That's just it though...sched_yield() with SCHED_OTHER doesn't have well 
defined semantics, so we can do just about anything we want.

The issue is mostly how to work around existing apps that (invalidly) 
expect certain behaviour from sched_yield().

>>The problem is where do we insert the task that is yielding?  CFS is
>>based around a tree structure ordered by time.

> We put it exactly where we would have when its timeslice ran out. If we can
> reward it a little bit, that's great. But if not, we can live with that.
> Just imagine that the timer interrupt fired to indicate the end of the
> thread's run time when the thread called 'sched_yield'.

CFS doesn't really do "timeslice".  But in essence what you are 
describing is the default behaviour currently...it simply removes the 
task from the tree and reinserts it based on how much cpu time it used up.

> Then what does he do when the task runs out of run time? It's hard to
> imagine we can't do that when the task calls sched_yield.

It gets reinserted into the tree at a position based on how much cpu 
time it used.  This is exactly the current sched_yield() behaviour.

>>It just says to delay the task,
>>without specifying how long or what the task is waiting *for*.

> That is not true. The task is waiting for something that will be done by
> another thread that is ready-to-run and at the same priority level. The task
> does not need to wait until the thing is guaranteed done but wishes to wait
> until it is more likely to be done. This is an often-misused but sometimes
> sensible thing to do.

The scheduler still doesn't know specifically what the task is waiting for.

> Sure, if there is more information. But if all you really want to do is wait
> until other threads at the same static priority level have had a chance to
> run, then sched_yield is the right API.

Technically, all of SCHED_OTHER has static priority level zero.  Thus 
the "right" thing to do is to allow all SCHED_OTHER tasks to run, 
including the ones with the highst possible nice level.

This is the alternate implementation in the current code, but it has 
latency implications that may be unexpected by applications written for 
the previous 2.6 behaviour.

Chris

