Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbYGOAY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbYGOAY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbYGOAYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:24:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758944AbYGOAYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:24:11 -0400
Date: Mon, 14 Jul 2008 17:23:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>  <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>  <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org> <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Dmitry Adamushko wrote:
> 
> The 'synchronization' point occurs even earlier - when cpu_down() ->
> __stop_machine_run() gets called (as I described in my previous mail).
> 
> My point was that if it's ok to have a _delayed_ synchronization
> point, having it not immediately after cpu_clear(cpu, cpu_active_map)
> but when the "runqueue lock" is taken a bit later (as you pointed out
> above) or __stop_machine_run() gets executed (which is a sync point,
> scheduling-wise),
> 
> then we can implement the proper synchronization (hotplugging vs.
> task-migration) with cpu_online_map (no need for cpu_active_map).

Maybe. But what is the point? And more importantly, I think it's wrong.

There's really a *difference* between "this CPU is still running, but 
going down" and "this CPU is running".

And it's a valid difference. For example, a process should be able to 
absolutely DEPEND on being able to depend on cpu_online(current_cpu()) 
*always* being true. 

I also don't understand why people are arguing against a single new CPU 
map (it's _global_ to the whole kernel, for crissake!) when it clearly 
makes the rules much simpler. Look at the patch I sent out, and tell me it 
isn't 100% obvious what cpu_active_map does, and what the logic is.

In contrast, try to follow the same for cpu_online_map. I dare you. You 
have to already know that code really really well in order to understand 
what happens to it, both at bootup _and_ at hotplug events.

Dmitry, THIS CODE WAS BUGGY. Not just once. Multiple f*cking times!

That should tell you something.

In particular, it should tell you that the code is too hard to follow, and 
too fragile, and a total mess.

I do NOT understand why you seem to argue for being "subtle" and "clever", 
considering the history of this whole setup. Subtle and clever and complex 
is what got us to the crap situation.

So here's the code-word of today: KISS - Keep It Simple Stupid.

And I _guarantee_ that the "cpu_active_map" approach is a hell of a lot 
simpler than the alternatives. Partly because it really matches what we 
want much more closely: it gives a clear new state for "this CPU is going 
down, even though things are still running on it".

And then it's 100% logical to say: "ok, if it's going down, we agree to 
not add new processes to it".

THAT is the kind of logic we should strive for. Not "let's avoid the 
obvious and simple code because we can re-use the existing messy code for 
yet another thing".

Dammit, this code should be easier to understand, not harder!

		Linus
