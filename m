Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYLTAD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYLTAD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 19:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYLTADt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 19:03:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYLTADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 19:03:49 -0500
Date: Fri, 19 Dec 2008 19:03:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
In-Reply-To: <20081220004453.50aec846@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008, Pekka Paalanen wrote:

> Steven,
> 
> I have some critique on where the tracing infrastructure has been going
> to lately. Please, let me know if I am just out-of-date on the current
> state or misunderstood something.

I could always use a critique ;-)

> 
> On Fri, 19 Dec 2008 12:20:18 -0500 (EST)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Fri, 19 Dec 2008, Fr?d?ric Weisbecker wrote:
> > > 
> > > 
> > > That's looks good.
> 
> The mmiotrace part looks good, too.
> 
> > > By the past, I also suggested Steven to automatically reset the traces
> > > buffer each time a tracer is started, that
> > > would factor out the code a bit more. I don't think one tracer would
> > > avoid to reset the buffer once it is started, and
> > > I don't think it is needed to reset twice on tracer switching: on stop
> > > of the old tracer and on start on the new. Only
> > > on start should be enough.
> > 
> > I'm actually against the idea of reseting a trace everytime we enable it.
> > That is:
> > 
> > echo 1 > /debug/tracing/tracing_enabled
> > 
> > This should not reset the tracer. I actually do tracing where I disable 
> > and enable it around areas I am interested in. I want all tracing, not 
> > just the last one.
> 
> But doesn't this go against the fact, that you need to write 0 there to
> be able to change the ring buffer size?
> 
> I mean, is tracing_enabled a "pause button" as I recall you explaining
> a long time ago, and again now, or "kill it all" as required for changing
> the ring buffer size?

It is more now a pause than kill it all. Although it never really did
kill it all. Before the ring buffer, we needed to echo in 'none' to
the current tracer before resizing. Now we can just get by with echoing 0 
to the tracing_enabled.

I'm starting to like the idea that tracing_enabled is a lighter weight 
version of echoing the the tracer into the current_tracer file. Perhaps it 
should reset the buffer on a echo 1 > tracing_enabled. We now have a 
tracing_on that we can "pause" tracing with. The only thing that the 
tracing_on does is to stop writes to the ring buffer. It does not stop any 
of the infrastructure that does the tracing.

Note, this is the main reason why you need to check for NULL on return of 
a ring_buffer_lock_reserve. That will return NULL when the tracing_on is 0.

> 
> Or has something changed that I don't know about?
> 
> Also another important but not so related question:
> are the ring buffers allocated always on boot, whenever any tracer
> (say, only mmiotrace) is enabled in the kernel configuration?

Currently all tracer plugins share the same buffer. I've been thinking 
about changing this so that each plugin has its own buffer. Then it could 
allocate its buffer when it is enabled. This way, we could have 
simultaneous traces. This is currently the reason why we only allow 
one plugin at a time. But changing this would be a 2.6.30 feature ;-)


> 
> The ring buffers are huge and eat a considerable chunk of precious RAM.
> How could distributors ever enable mmiotrace in their kernel
> configurations by default, if it eats lots of memory for nothing?

Hmm, good point. We could change the allocation to when it is first 
enabled. Something other than 'nop' being put into the current_tracer 
file.

> 
> If distributors do not enable mmiotrace by default, we are in a worse
> situation than with out-of-tree mmiotrace module (if it could work).
> Users need to reconfigure and recompile their kernels, which is
> something we wanted to avoid. This is the reality right now.
> 
> Unless you have an answer to this, I'd like to suggest we resurrect the
> "none" tracer. When "none" is the current tracer, there would be no
> buffers allocated at all, and you could request a new buffer size.
> "none" would be the default. Do you see any problems here?
> 
> AFAIK the "nop" tracer will not do, because it still allows text
> messages (markers) to be written, and hence the ring buffer must
> exist. Or am I wrong?

No, you are quite right. We could recreate the 'none' tracer again that
has no buffer. At boot up it would be the default tracer, unless something 
else changes that.

> 
> > Now we have recently added /debug/tracing/tracing_on which can quickly 
> > stop tracing. I may be able to use that, and we can let the 
> > tracing_enable" reset it too.
> 
> Does this mean I have to implement yet another on/off hook?

Nope, the on/off hook is extremely fast, and the plugins do not even know 
when they happen. The on/off simply turns off writing to the ring buffer. 
The plugin functions will still be called, it is just that they will fail 
to write to the ring buffers. As stated above, the 
ring_buffer_reserve_lock will return a NULL.

> 
> IMHO it is starting to be confusing having all these
> current_tracer, tracing_enabled, tracing_on etc.

The problem with giving people the power of what they want, is that it 
makes it complex ;-)  Switching tracers is the slowest function, and 
causes the full work of any initializations. This is where we could 
allocate a separate ring buffer (in the future).

The tracing_enabled is the way to start and stop a trace. I'm considering 
to implement Frederic's request to reset the buffer on enabled. This is 
quick but requires locks and mutexes to be taken. It calls a hook to the 
plugin because different plugins actually want to reset (the irq latency 
tracers reset with this).

The tracing_on is something that has been asked by developers to give a 
way to start and stop tracing fast as possible, with no mutexes or added 
locks. In fact, this option is local to the ring buffer code. Ftrace does 
not even use it directly.  It just a global flag to stop tracing. There's 
also an in-kernel equivalent tracing_on() and tracing_off(). This just 
sets or clears a global flag that will stop any more writes to the trace 
buffer.

Note, we also have an in-kernel version of tracing_enabled which is 
tracing_start() and tracing_stop(). These are nested. That is, every 
tracing_stop() must be accompanied by a tracing_start() otherwise you 
leave the tracing disabled, and not even user space can start it.  This 
side effect is the way I disable tracing when a problem is detected.

The tracing_on() and tracing_off() is not nested. It is just like a light 
switch. Two processes can call tracing_off() and one can call tracing_on() 
and tracing will be enabled again. The kernel can call tracing_off() and 
userspace can enable it by 'echo 1 > tracing_on'. This is actually a very 
useful feature in debugging. When an anomaly happens, the kernel can call 
tracing_off(), the user could examine the trace, and then enable tracing 
again if they want to continue testing.

-- Steve

