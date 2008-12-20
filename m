Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYLTCsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYLTCsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 21:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYLTCr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 21:47:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYLTCr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 21:47:56 -0500
Date: Fri, 19 Dec 2008 21:47:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
In-Reply-To: <20081220041759.5a026f5a@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0812192140350.29275@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi>
 <alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com> <20081220041759.5a026f5a@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 20 Dec 2008, Pekka Paalanen wrote:
> > 
> > Note, this is the main reason why you need to check for NULL on return of 
> > a ring_buffer_lock_reserve. That will return NULL when the tracing_on is 0.
> > 
> > > The ring buffers are huge and eat a considerable chunk of precious RAM.
> > > How could distributors ever enable mmiotrace in their kernel
> > > configurations by default, if it eats lots of memory for nothing?
> > 
> > Hmm, good point. We could change the allocation to when it is first 
> > enabled. Something other than 'nop' being put into the current_tracer 
> > file.
> 
> I'm very much looking forward to this.

Unfortunately, this is not a trivial change. I'll have to look into it.

> 
> > > 
> > > If distributors do not enable mmiotrace by default, we are in a worse
> > > situation than with out-of-tree mmiotrace module (if it could work).
> > > Users need to reconfigure and recompile their kernels, which is
> > > something we wanted to avoid. This is the reality right now.
> > > 
> > > Unless you have an answer to this, I'd like to suggest we resurrect the
> > > "none" tracer. When "none" is the current tracer, there would be no
> > > buffers allocated at all, and you could request a new buffer size.
> > > "none" would be the default. Do you see any problems here?
> > > 
> > > AFAIK the "nop" tracer will not do, because it still allows text
> > > messages (markers) to be written, and hence the ring buffer must
> > > exist. Or am I wrong?
> > 
> > No, you are quite right. We could recreate the 'none' tracer again that
> > has no buffer. At boot up it would be the default tracer, unless something 
> > else changes that.
> 
> The "nop" having no buffers at boot would be enough, but this would be
> even better.

We would need something separate from nop, since nop can still record. If 
there is no buffers, its best not to record. Although, the ring buffers 
should just return NULL if the buffer is not allocated yet (I better make 
sure that is the case).

But just for accounting reasons, its best to have a "none" that does no 
tracing what-so-ever. This way, you can echo 'none' back into the current 
tracer, and have the buffers freed (?).


> 
> > > 
> > > > Now we have recently added /debug/tracing/tracing_on which can quickly 
> > > > stop tracing. I may be able to use that, and we can let the 
> > > > tracing_enable" reset it too.
> > > 
> > > Does this mean I have to implement yet another on/off hook?
> > 
> > Nope, the on/off hook is extremely fast, and the plugins do not even know 
> > when they happen. The on/off simply turns off writing to the ring buffer. 
> > The plugin functions will still be called, it is just that they will fail 
> > to write to the ring buffers. As stated above, the 
> > ring_buffer_reserve_lock will return a NULL.
> 
> Does this also increment the lost events counters?

Unfortunately no. The lost events are about overruns. But the calling 
tracer should easily be able to add these as well. They see the "NULL" 
returned from the function. This means it obviously did not record the 
event.  The overruns, on the otherhand, is not visible to the tracer, so 
the ring buffer keeps count.

> 
> > > IMHO it is starting to be confusing having all these
> > > current_tracer, tracing_enabled, tracing_on etc.
> 
> > 
> > The tracing_enabled is the way to start and stop a trace. I'm considering 
> > to implement Frederic's request to reset the buffer on enabled. This is 
> > quick but requires locks and mutexes to be taken. It calls a hook to the 
> > plugin because different plugins actually want to reset (the irq latency 
> > tracers reset with this).
> > 
> > The tracing_on is something that has been asked by developers to give a 
> > way to start and stop tracing fast as possible, with no mutexes or added 
> > locks. In fact, this option is local to the ring buffer code. Ftrace does 
> > not even use it directly.  It just a global flag to stop tracing. There's 
> > also an in-kernel equivalent tracing_on() and tracing_off(). This just 
> > sets or clears a global flag that will stop any more writes to the trace 
> > buffer.
> 
> Why not call tracing_on, say, logging_enabled?
> IMHO tracing_enabled vs. tracing_on is incomprehesible, but
> tracing_enabled vs. logging_enabled is a little more understandable.
> current_tracer is self-explanatory, and tracing_enabled used to be.

One of the hardest things about ftrace is coming up with good naming. This 
is not always so easy, as you can tell. I'm not sure "logging_enabled" is 
any better. That would confuse myself ;-)   The reason I chose "on" is 
because it is like an on/off switch, where as enabled/disabled is usually 
(in the kernel anyway) associated to nesting.

How about tracing_enabled_light? ;-)

-- Steve

