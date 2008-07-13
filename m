Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYGMRro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYGMRro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYGMRrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:47:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbYGMRrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:47:35 -0400
Date: Sun, 13 Jul 2008 10:46:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807131041240.2959@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>  <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>  <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>  <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com> 
 <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org> <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com> <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Linus Torvalds wrote:
> 
> The thing is, we should fix the top level code to never even _consider_ an 
> invalid CPU as a target, and that in turn should mean that all the other 
> code should be able to just totally ignore CPU hotplug events.

IOW, I think we should totally remove the whole "update_sched_domains()" 
thing too. Any logic that needs it is broken. We shouldn't detach the 
scheduler domains in DOWN_PREPARE (much less UP_PREPARE), we should just 
leave them damn well alone.

As the comment says, "The domains and groups cannot be updated in place 
without racing with the balancing code". The thing is, we shouldn't even 
try. The correct way to handle all this is to make the balancing code use 
the domains regardless, but protect against CPU's going down with 
_another_ data structure that is much easier to update.

Namely something like 'cpu_active_map'.

Then we just get rid of all the crap in update_sched_domains() entirely, 
and then we can make the cpusets code do the *sane* thing, which is to 
rebuild the scheduler domains only when the CPU up/down has completed.

So instead of this illogical and crazy mess:

	+       switch (phase) {
	+       case CPU_UP_CANCELED:
	+       case CPU_UP_CANCELED_FROZEN:
	+       case CPU_DOWN_FAILED:
	+       case CPU_DOWN_FAILED_FROZEN:
	+       case CPU_ONLINE:
	+       case CPU_ONLINE_FROZEN:
	+       case CPU_DEAD:
	+       case CPU_DEAD_FROZEN:
	+               common_cpu_mem_hotplug_unplug(1);

it should just say

	+       switch (phase) {
	+       case CPU_ONLINE:
	+       case CPU_ONLINE_FROZEN:
	+       case CPU_DEAD:
	+       case CPU_DEAD_FROZEN:
	+               common_cpu_mem_hotplug_unplug(1);

because it only makes sense to rebuild the scheduler domains when the 
thing SUCCEEDS. 

See? By having a sane design, the code is not just more robust and easy to 
follow, you can also simplify it and make it more logical.

The current design is not sane.

			Linus
