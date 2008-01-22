Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbYAVTE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbYAVTE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYAVTEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:04:50 -0500
Received: from mga07.intel.com ([143.182.124.22]:61528 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbYAVTEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:04:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,234,1199692800"; 
   d="scan'208";a="370083248"
Message-ID: <47963E2E.9020501@linux.intel.com>
Date: Tue, 22 Jan 2008 11:04:14 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange interaction between latencytop and the scheduler
References: <47962DD1.9050800@gmail.com>
In-Reply-To: <47962DD1.9050800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin wrote:
> Hi Arjan, Ingo,

> [for minor latencytop userspace specific issues see at end of mail]
> 
> * if I compile with CONFIG_SCHED_DEBUG I see a 30-40msec latency from
> the scheduler, always (Scheduler: waiting for cpu).
> There is also a constant ~5% user, ~2% sys CPU usage on an idle system,
> regardless  if latencytop sysctl is on or off.
> Is this normal? (is overhead really 40msec?)

I'm seeing similar, I would not rule out that this is actual scheduler behavior ;(
at least it seems consistent.
I also made a patch (to lkml yesterday) that counts the total and count of scheduler latencies
to also show the cumulative effect of these latencies

> I was also seeing an unusually high number of context switches (as shown
> by vmstat), I usually have 400-800 with non-patched kernels (while
> running mplayer too), but I was getting steadily over 1100 with the
> patch (on idle system).

that's weird; there's nothing blocking in the entire patch at all.
(the only lock is a spinlock)

The performance aspect... collecting the data isn't cheap (which is why it's made a sysctl),
I still plan to look at optimizing it but it won't ever be free.

> * I compile without CONFIG_SCHED_DEBUG, I no longer get *any* latency
> from the scheduler, even if I run multi-threaded programs, etc. Is this
> to be expected? (i.e. is this feature available only when enabling
> CONFIG_SCHED_DEBUG?)

afaik yes.


> Some minor latencytop userspace issues:
> * percentages: new feature (nice!), but the values seem all wrong
> (global perc. are always wrong, per app perc. are usually ok, but see
> second example below)

note that the percentages are percentage this entry had compared the total sum of latencies.
The maximum entry is only loosely related to that; say you have 1 latency in "foo" for 100ms
but 900 of 1ms in "bar", "foo" will show 10% and "bar" will show 90%

> * I miss the Average latency column. If it is too costly to keep account
> of an overall average, can we have last N second average?

it's not costly to calculate, it's the screen space versus the value of the information :(

> * unknown reasons show a backtrace, but backtrace doesn't have enough
> room on screen

still working on that; you can pass the --unknown option to dump these so that I can add them
to the translation table.
