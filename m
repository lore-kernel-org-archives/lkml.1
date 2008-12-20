Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbYLTA3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbYLTA3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 19:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYLTA3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 19:29:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34069 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYLTA3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 19:29:33 -0500
Date: Fri, 19 Dec 2008 19:29:30 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Paalanen <pq@iki.fi>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
In-Reply-To: <20081219233443.GC17984@elte.hu>
Message-ID: <alpine.DEB.1.10.0812191912280.26234@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi> <20081219225717.GK13409@elte.hu>
 <alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com> <20081219233443.GC17984@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 20 Dec 2008, Ingo Molnar wrote:
> 
> uhm, the user just resized the buffer - he will not be wondering about any 
> impact.

I can imagine some users that would ;-)

> 
> And that's why we should do a full reset: that makes it abundantly clear 
> what happened. We shouldnt pretend to be able to do something (seemless, 
> lightweight buffer size change with no visible impact) which we obviously 
> cannot reliably offer.

Some tracers, namely the latency ones (irqsoff and friends, as well as the 
sched wakeup) need to resize two buffers, and if this is done while 
tracing is enabled, the special "switch" operation can cause problems.
Keeping tracing on while resizing can be done, but it needs to done 
carefully.

> 
> Buffer resize is a slow op, and everyone realizes that. Most people will 
> in fact say: "hey, I didnt even need to reboot to change the trace buffer 
> size, cool!".

Exactly! Currently they will be happy that they do not need to reboot.

> 
> The current "only allow resizing while tracing is disabled" is an 
> unintuitive and counterproductive restriction - a borderline bug in fact.

Having to disable tracing to resize is much better than having to reboot.

I'm not defending that this is the way to go. I never planned on keeping 
this the defacto standard. I've been setting up infrastructure to allow 
for a seamless resize. If you think we should reset the buffers on resize, 
then that would be a great way for the user to know why they are missing 
**all** their data.

What I'm trying to say is that the more we allow during resize, the more 
likely there will be a critical bug that might lock up the system. The 
whole point about writing the ring buffer was to do it incrementally. 
Start out with being straight forward and simple, then we could add 
features as we understand things better.

IOW, I totally agree that we should make it as intuitive as possible. But 
this needs to be done step by step. I wrote 10 different versions of the 
ring buffer in a week. Most of them were complete rewrites. I want this to 
be as robust and powerful as you do, but I also want to be cautious about 
doing things that might crash the system.

Ftrace already had the infrastructure in place to protect against resize. 
I just used it to give me time to do other things with the ring buffer. 
I always planned on having the resize protection back inside the ring 
buffer code when I got around to it.

-- Steve



