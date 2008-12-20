Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYLTCST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYLTCST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 21:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYLTCSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 21:18:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:61133 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYLTCSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 21:18:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=u3uVAqiRQdHXgVjmai5dXTooRWEHWZ6TvFHKQJMfvZKz8WKJrxaqOHSADtDdeC5/Gc
         s2zC1VKmwByMmN2GQsZyQxgQ6S4DGxCJ5TVGx83nJXFX9xDIm6qbOOpPqDAoZfMSg6AG
         9Mj/Uj1IQKzVAkhfwEBlJW6s1MiuwaGW7KcV8=
Date: Sat, 20 Dec 2008 04:17:59 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>, pq@iki.fi
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
Message-ID: <20081220041759.5a026f5a@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	<c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	<alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
	<20081220004453.50aec846@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

thank you for a complete reply. Few comments below.

On Fri, 19 Dec 2008 19:03:42 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 20 Dec 2008, Pekka Paalanen wrote:
> 
> > But doesn't this go against the fact, that you need to write 0 there to
> > be able to change the ring buffer size?
> > 
> > I mean, is tracing_enabled a "pause button" as I recall you explaining
> > a long time ago, and again now, or "kill it all" as required for changing
> > the ring buffer size?
> 
> It is more now a pause than kill it all. Although it never really did
> kill it all. Before the ring buffer, we needed to echo in 'none' to
> the current tracer before resizing. Now we can just get by with echoing 0 
> to the tracing_enabled.

I guess I don't really see what was so bad about switching to the "none"
tracer, as the resize operation is expected wipe everything anyway.
Likely because for mmiotrace, toggling tracing_enabled is the same as
switching tracers.

> I'm starting to like the idea that tracing_enabled is a lighter weight 
> version of echoing the the tracer into the current_tracer file. Perhaps it 
> should reset the buffer on a echo 1 > tracing_enabled. We now have a 
> tracing_on that we can "pause" tracing with. The only thing that the 
> tracing_on does is to stop writes to the ring buffer. It does not stop any 
> of the infrastructure that does the tracing.
> 
> Note, this is the main reason why you need to check for NULL on return of 
> a ring_buffer_lock_reserve. That will return NULL when the tracing_on is 0.
> 
> > The ring buffers are huge and eat a considerable chunk of precious RAM.
> > How could distributors ever enable mmiotrace in their kernel
> > configurations by default, if it eats lots of memory for nothing?
> 
> Hmm, good point. We could change the allocation to when it is first 
> enabled. Something other than 'nop' being put into the current_tracer 
> file.

I'm very much looking forward to this.

> > 
> > If distributors do not enable mmiotrace by default, we are in a worse
> > situation than with out-of-tree mmiotrace module (if it could work).
> > Users need to reconfigure and recompile their kernels, which is
> > something we wanted to avoid. This is the reality right now.
> > 
> > Unless you have an answer to this, I'd like to suggest we resurrect the
> > "none" tracer. When "none" is the current tracer, there would be no
> > buffers allocated at all, and you could request a new buffer size.
> > "none" would be the default. Do you see any problems here?
> > 
> > AFAIK the "nop" tracer will not do, because it still allows text
> > messages (markers) to be written, and hence the ring buffer must
> > exist. Or am I wrong?
> 
> No, you are quite right. We could recreate the 'none' tracer again that
> has no buffer. At boot up it would be the default tracer, unless something 
> else changes that.

The "nop" having no buffers at boot would be enough, but this would be
even better.

> > 
> > > Now we have recently added /debug/tracing/tracing_on which can quickly 
> > > stop tracing. I may be able to use that, and we can let the 
> > > tracing_enable" reset it too.
> > 
> > Does this mean I have to implement yet another on/off hook?
> 
> Nope, the on/off hook is extremely fast, and the plugins do not even know 
> when they happen. The on/off simply turns off writing to the ring buffer. 
> The plugin functions will still be called, it is just that they will fail 
> to write to the ring buffers. As stated above, the 
> ring_buffer_reserve_lock will return a NULL.

Does this also increment the lost events counters?

> > IMHO it is starting to be confusing having all these
> > current_tracer, tracing_enabled, tracing_on etc.

> 
> The tracing_enabled is the way to start and stop a trace. I'm considering 
> to implement Frederic's request to reset the buffer on enabled. This is 
> quick but requires locks and mutexes to be taken. It calls a hook to the 
> plugin because different plugins actually want to reset (the irq latency 
> tracers reset with this).
> 
> The tracing_on is something that has been asked by developers to give a 
> way to start and stop tracing fast as possible, with no mutexes or added 
> locks. In fact, this option is local to the ring buffer code. Ftrace does 
> not even use it directly.  It just a global flag to stop tracing. There's 
> also an in-kernel equivalent tracing_on() and tracing_off(). This just 
> sets or clears a global flag that will stop any more writes to the trace 
> buffer.

Why not call tracing_on, say, logging_enabled?
IMHO tracing_enabled vs. tracing_on is incomprehesible, but
tracing_enabled vs. logging_enabled is a little more understandable.
current_tracer is self-explanatory, and tracing_enabled used to be.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
