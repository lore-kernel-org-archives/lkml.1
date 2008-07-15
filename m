Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYGOENX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYGOENX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYGOENO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:13:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbYGOENN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:13:13 -0400
Date: Mon, 14 Jul 2008 21:12:38 -0700 (PDT)
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
In-Reply-To: <487C1374.8020404@qualcomm.com>
Message-ID: <alpine.LFD.1.10.0807142104250.3017@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>  <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>  <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>  <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com> 
 <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org> <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com> <487C1374.8020404@qualcomm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Max Krasnyansky wrote:
> 
> Did you guys an updated patch ? Dmitry pointed out several things that Linus
> missed in his original version. I guess I can go through the thread and
> reconstruct that but if you have a patch I can try let me know.

I didn't update it, and right now I'm just merging too much (and 
discussing the merges) to have time.

The patch really needs to have some scheduler person look at the use fo 
cpu_active_map - I was kind of hoping that Ingo would.

The other thing I wish somebody would at least double-check (and 
preferably just remove) is the !CPU_HOTPLUG special case. For that case, I 
literally did

	#define cpu_active_map cpu_online_map

and just depended on the fact that the few cases that touched 
cpu_online_map even when CPU_HOTPLUG was disabled would do

	if (cpu_online(cpu))
		set_cpu(cpu, cpu_active_map);

(or something - I ended up discaring the patch as I was doing the whole 
2.6.26 release, so I don't even have it in front of me right now, just in 
my email archives and in my memory).

And quite frankly, I don't think that was a good idea. It was exactly the 
sort of "subtle cleverness" that I myself argue against. So I think that 
aliasing of cpu_active/online_map was a mistake - it was kind of cute, but 
there's really no good reason to do it. It's not like that one CPU map 
wastes any memory, and the special-case simply isn't worth it.

			Linus
