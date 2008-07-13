Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYGMRLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYGMRLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYGMRLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:11:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbYGMRLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:11:37 -0400
Date: Sun, 13 Jul 2008 10:10:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>  <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>  <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>  <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com> 
 <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org> <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Dmitry Adamushko wrote:
 
> And let me explain one last time why I opposed your 'cpu_active_map' approach.

And let me explain why you are totally off base.

> I do agree that there are likely ways to optimize the hotplug
> machinery [ .. deleted rambling .. ]

This has *NOTHING* to do with optimizing any hotplug machinery.

> The current way to synchronize with the load-balancer is to attach
> NULL domains [ .. deleted more ramblings .. ]

This has *NOTHING* to do even with cpusets and scheduler domains!

Until you can understand that, all your arguments are total and utter 
CRAP.

So Dmitry - please follow along, and think this through.

This is a *fundamental* scheduler issue. It has nothing what-so-ever to do 
with optimization, and it has nothing to do with cpusets. It's about the 
fact that we migrate threads from one CPU to another - and we do that 
whether cpusets are even enabled or not!

And anything that uses "cpu_active_map" to decide if the migration target 
is alive is simply _buggy_.

See? Not "un-optimized". Not "cpusets". Just pure scheduling and hotplug 
issues with taking a CPU down.

As long as you continue to only look at wake_idle() and scheduler domains, 
you are missing all the *other* cases of migration. Like the one we do at 
execve() time, or in balance_task.

The thing is, we should fix the top level code to never even _consider_ an 
invalid CPU as a target, and that in turn should mean that all the other 
code should be able to just totally ignore CPU hotplug events.

In other words, it vey fundamentally SHOULD NOT MATTER that somebody 
happened to call "try_to_wake_up()" during the cpu unplug sequence. We 
should fix the fundamental scheduler routines to simply make it impossible 
for that to ever balance something back to a CPU that is going down.

And we shouldn't _care_ about what crazy things the cpusets code does.

See?

THAT is the reason for my patch. I think the cpusets callbacks are totally 
insane, but I don't care. What I care about is that the scheduler got 
confused just because those insane callbacks happened to make timing be 
just subtle enough that (and I quote):

  "try_to_wake_up() is called for one of these tasks from another CPU ->
   the load-balancer (wake_idle()) picks up a "dead" CPU and places the 
   task on it. Then e.g. BUG_ON(rq->nr_running) detects this a bit later 
   -> oops."

IOW, we should never have had code that was that fragile in the first 
place! It's totally INSANE to depend on complex and fragile code, when 
we'd be much better off with simple code that always says: "I will not 
migrate a task to a CPU that is going down".

Depending on complex (and conditional) scheduler domains data structures 
is a *bug*. It's fragile, and it's a horrible design mistake.

			Linus

