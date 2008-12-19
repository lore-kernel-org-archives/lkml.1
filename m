Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYLSX1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYLSX1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbYLSX12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:27:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50093 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbYLSX11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:27:27 -0500
Date: Fri, 19 Dec 2008 18:27:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Paalanen <pq@iki.fi>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
In-Reply-To: <20081219225717.GK13409@elte.hu>
Message-ID: <alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi>
 <20081219225717.GK13409@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Dec 2008, Ingo Molnar wrote:

> 
> * Pekka Paalanen <pq@iki.fi> wrote:
> 
> > > I'm actually against the idea of reseting a trace everytime we enable it.
> > > That is:
> > > 
> > > echo 1 > /debug/tracing/tracing_enabled
> > > 
> > > This should not reset the tracer. I actually do tracing where I disable 
> > > and enable it around areas I am interested in. I want all tracing, not 
> > > just the last one.
> > 
> > But doesn't this go against the fact, that you need to write 0 there to 
> > be able to change the ring buffer size?
> 
> hm, that ftrace behavior is silly. Steve, i think i mentioned this a long 
> time ago and i thought it got fixed? Changing the ring buffer size is a 
> slow op, it should include an implicit reset and should be plug-and-play 
> with no dependencies of having to stop the trace or something.

I think you are referencing a different issue, where we passed in a NULL 
buffer pointer and expected it to be resized. I still think that should 
not return a success, but that's a different issue altogether.

Before the ring buffer, the only safe way to resize the buffer was to 
switch the tracer to none (aka nop).  Now, the only thing you need to do 
is disable tracing. This is probably a good thing since it forces the user 
to stop tracing, otherwise the tracing will stop during the resize anyway, 
and the user will wonder why they lost data.

Resizing is a dangerous operation to do while tracing. Right now ftrace 
enforces the the protection of writes to the ring buffer during resize 
(the ftrace infrastructure does, the plugins do not need to worry about 
it).

Now that we have other ways to disable writing to the ring buffer, we can 
move that down to the ring buffer layer. When the ring buffer was 
originaly written, there was no such method to stop writing. What would 
need to be done now, is the ring buffers would disable writing to all CPU 
buffers, do a synchronize sched, since writing requires preemption 
disabled. Then we would need to grab all the reader spin locks for each 
cpu buffer (that will be ugly :-( ), and then we could safely change the 
size of the buffers.

I could easily write this up. I'll see if I can get to it after I release 
the -rt trees. But like I said, there will be time when tracing will be 
stopped, and it would be a good idea to make the user stop it so they do 
not get confused about why they are missing trace output after they did a 
resize.

-- Steve

