Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYGLWnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYGLWnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYGLWnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:43:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15677 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYGLWnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:43:02 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5337"; a="4493816"
Message-ID: <48793375.30607@qualcomm.com>
Date: Sat, 12 Jul 2008 15:43:01 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Linus Torvalds wrote:
> 
> On Sat, 12 Jul 2008, Linus Torvalds wrote:
>> This patch almost certainly doesn't work, but let me explain:
> 
> Well, I decided to just take the plunge and test it. It WorksForMe(tm), so 
> it's no _totally_ broken. But I really didn't test it except to see that 
> it still booted, and I don't use cpusets and never saw the original bug, 
> of course.
> 
> But considering how simple it is, if it works for people as a way to work 
> around stupid CPU migration issues due to subtle wakeup calls, I'd almost 
> prefer to really solve this whole issue with that cpu_active_map thing. 
> 
> It's so simple it should be really _robust_ in the presense of problems 
> elsewhere (like the whole cpusets scheduling domain mess).
> 
> Assuming I didn't do anythign stupid, of course, which is why it would 
> definitely need much more testing. And especially if Vegard can test it 
> with the case that oopsed for him due to the bad migration..

My vote goes for Dmitry's patch. The one with the full switch() statement.
Your simplified version with if() is correct (I think) but the switch() is
more explicit about what events are being processed.

The cpu_active_map thing seems like an overkill. In a sense that we should not
try to add a new map for every such case. Granter this migration case may be
special enough to warrant the new map but in general I think it's not the
right way to go.

btw Dmitry's patch should go in anyway. It makes no sense to kill and then
immediately rebuild domains during hotplug sequence.  Actually I might have a
bit better patch. I'm thinking we should just call rebuild_sched_domains() (or
some wrapper) from the sched hotplug handler. That way it'll be clear when
domains are supposed to be created/destroyed. ie We won't have to coordinate
cpu hotplug handling events between scheduler and cpusets. I'll send a patch a
bit later.

Max


