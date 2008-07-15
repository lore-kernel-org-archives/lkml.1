Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbYGODDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbYGODDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYGODD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:03:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17375 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYGODD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:03:27 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5338"; a="4710930"
Message-ID: <487C1374.8020404@qualcomm.com>
Date: Mon, 14 Jul 2008 20:03:16 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <20080712031736.GA3040@damson.getinternet.no>	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>	 <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>	 <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>	 <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com>	 <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org> <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com>
In-Reply-To: <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> 2008/7/15 Linus Torvalds <torvalds@linux-foundation.org>:
>>
>> On Tue, 15 Jul 2008, Dmitry Adamushko wrote:
>>> The 'synchronization' point occurs even earlier - when cpu_down() ->
>>> __stop_machine_run() gets called (as I described in my previous mail).
>>>
>>> My point was that if it's ok to have a _delayed_ synchronization
>>> point, having it not immediately after cpu_clear(cpu, cpu_active_map)
>>> but when the "runqueue lock" is taken a bit later (as you pointed out
>>> above) or __stop_machine_run() gets executed (which is a sync point,
>>> scheduling-wise),
>>>
>>> then we can implement the proper synchronization (hotplugging vs.
>>> task-migration) with cpu_online_map (no need for cpu_active_map).
>> [ ... ]
>>
>> In particular, it should tell you that the code is too hard to follow, and
>> too fragile, and a total mess.
>>
>> I do NOT understand why you seem to argue for being "subtle" and "clever",
>> considering the history of this whole setup. Subtle and clever and complex
>> is what got us to the crap situation.
> 
> Fair enough, agreed.

Ok. Sounds like the consensus is to try and do this cpu_active_map thing, and
it sounds like it will lets us get rid of the "destroy domains / rebuild
domains" logic, which would be a good thing. I've spent a good part of the
weekend chasing circular locking dependencies in calling
rebuild_sched_domains() from cpu hotplug handler path. Which we'll still need
(to update domains on CPU UP and DOWN events) but not having to blow away the
domains as often as we do now will simplify things, and probably make hotplug
events a bit less disruptive.

Did you guys an updated patch ? Dmitry pointed out several things that Linus
missed in his original version. I guess I can go through the thread and
reconstruct that but if you have a patch I can try let me know.

Max
