Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZKWPVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZKWPVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZKWPVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:21:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:43082 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbZKWPVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:21:44 -0500
Subject: Re: newidle balancing in NUMA domain?
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091123151152.GA19175@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de>
	 <1258987059.6193.73.camel@marge.simson.net>
	 <20091123151152.GA19175@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 16:21:44 +0100
Message-ID: <1258989704.4531.574.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 16:11 +0100, Nick Piggin wrote:

> Wait, you say it was activated to improve fork/exec CPU utilization?
> For the x264 load? What do you mean by this? Do you mean it is doing
> a lot of fork/exec/exits and load is not being spread quickly enough?
> Or that NUMA allocations get screwed up because tasks don't get spread
> out quickly enough before running?
> 
> In either case, I think newidle balancing is maybe not the right solution.
> newidle balancing only checks the system state when the destination
> CPU goes idle. fork events increase load at the source CPU. So for
> example if you find newidle helps to pick up forks, then if the
> newidle event happens to come in before the fork, we'll have to wait
> for the next rebalance event.
> 
> So possibly making fork/exec balancing more aggressive might be a
> better approach. This can be done by reducing the damping idx, or
> perhaps some other conditions to reduce eg imbalance_pct or something
> for forkexec balancing. Probably needs some studying of the workload
> to work out why forkexec is failing.

>From what I can remember from that workload it basically spawns tons of
very short lived threads, waits for a bunch to complete, goto 1.

Fork balancing only works until all cpus are active. But once a core
goes idle it's left idle until we hit a general load-balance cycle.
Newidle helps because it picks up these threads from other cpus,
completing the current batch sooner, allowing the program to continue
with the next.

There's just not much you can do from the fork() side of things once
you've got them all running.

> OK. This would be great if fixing up involves making things closer
> to what they were rather than adding more complex behaviour on top
> of other changes that broke stuff. And doing it in 2.6.32 would be
> kind of nice...

.32 is kind of closed, with us being at -rc8.

