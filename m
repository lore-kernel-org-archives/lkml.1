Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYGLXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYGLXCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYGLXCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:02:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbYGLXCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:02:07 -0400
Date: Sat, 12 Jul 2008 16:01:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Max Krasnyansky <maxk@qualcomm.com>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <48793375.30607@qualcomm.com>
Message-ID: <alpine.LFD.1.10.0807121556290.2959@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org> <48793375.30607@qualcomm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Max Krasnyansky wrote:
> 
> My vote goes for Dmitry's patch. The one with the full switch() statement.
> Your simplified version with if() is correct (I think) but the switch() is
> more explicit about what events are being processed.

Well, I still haven't seen a combined patch+signoff+good explanation, so I 
can't really commit it.

> The cpu_active_map thing seems like an overkill. In a sense that we should not
> try to add a new map for every such case. Granter this migration case may be
> special enough to warrant the new map but in general I think it's not the
> right way to go.

Note how cpu_active_map has nothing to do with cpusets per se, and 
everything to do with the fact that CPU migration currently seems to be 
fundamentally flawed in the presense of a CPU hotunplug.

Can somebody tell me why some _other_ random wakeup cannot cause the same 
kind of migration at an inopportune time?

The fact is, Dmitry's patch fixed _one_ particular wakeup from happening 
(that just happened to be *guaranteed* to happen when it shouldn't!), but 
as far as I can tell, it's a totally generic problem, with any

	try_to_wake_up() -> load-balancer

chain being able to trigger it by causing a migration to a CPU that we 
are in the process of turning off.

IOW, I don't think that my patch is overkill at all. I think it fixes the 
real bug there.

(It's also true that the cpusets code calls rebuild_sched_domains() way 
too much, but that's a _stupidity_ issue, not the cause of the bug per se, 
if I follow the code!)

			Linus
