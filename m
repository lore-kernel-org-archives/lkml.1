Return-Path: <linux-kernel-owner+w=401wt.eu-S965057AbXBVD05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057AbXBVD05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965034AbXBVD05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:26:57 -0500
Received: from mail.suse.de ([195.135.220.2]:40492 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965057AbXBVD04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:26:56 -0500
Date: Thu, 22 Feb 2007 04:26:54 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [patch 2/2] sched: dynticks idle load balancing - v2
Message-ID: <20070222032654.GD12137@wotan.suse.de>
References: <20061213231316.GA13849@elte.hu> <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com> <20070216180335.A8744@unix-os.sc.intel.com> <20070216180842.B8744@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216180842.B8744@unix-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 06:08:42PM -0800, Suresh B wrote:
> Changes since v1:
> 
>   - Move the idle load balancer selection from schedule()
>     to the first busy scheduler_tick() after restarting the tick.
>     This will avoid the unnecessay ownership changes when 
>     softirq's(which are run in softirqd context in certain -rt
>     configurations) like timer, sched are invoked for every idle tick
>     that happens.
> 
>   - Misc cleanups.
> 
> ---
> Fix the process idle load balancing in the presence of dynticks.
> cpus for which ticks are stopped will sleep till the next event wakes it up.
> Potentially these sleeps can be for large durations and during which today,
> there is no periodic idle load balancing being done.
> 
> This patch nominates an owner among the idle cpus, which does the idle load
> balancing on behalf of the other idle cpus. And once all the cpus are
> completely idle, then we can stop this idle load balancing too. Checks added
> in fast path are minimized.  Whenever there are busy cpus in the system, there
> will be an owner(idle cpu) doing the system wide idle load balancing.

This is really ugly, sorry :(

My suggestion for handling this was to increase the maximum balance
interval for an idle CPU, and just implement a global shutdown when
the entire system goes idle.

The former should take care of the power savings issues for bare metal
hardware, and the latter should solve performance problems for many idle
SMP guests. It should take very little code to implement.

If that approach doesn't cut it, then at least we can have some numbers
to see how much better yours is so we can justify including it.

If you are against my approach, then I can have a try at coding it up
if you like?
