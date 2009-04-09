Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZDIFnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZDIFnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbZDIFiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:38:11 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:37910 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761451AbZDIFiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OBvK/uLkEsW2lFW6BjvjNPw0RkuxIy0b8faRAMqqdIJpH6UMQFrSnm3fW+Qi3RXg0P
         SWVS/XJ6d5w/6ruGvnBVuM0A7x7h701+VXNBVAm5rBMH0QrSgjDBak3Id8KXBW/0sD8Y
         sa9m7iN7M+VYdpSRrqr6eYPJjLNgTJbgYNpXs=
Subject: Re: Multiple Tracers
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       axboe@kernel.dk
In-Reply-To: <20090408142413.GF12931@elte.hu>
References: <1239197703.3359.25.camel@localhost.localdomain>
	 <20090408135312.GR18581@elte.hu>
	 <1239199899.3359.39.camel@localhost.localdomain>
	 <20090408142413.GF12931@elte.hu>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 00:37:58 -0500
Message-Id: <1239255478.6839.64.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-04-08 at 16:24 +0200, Ingo Molnar wrote:
> * Steven Whitehouse <swhiteho@redhat.com> wrote:
> 
> > Hi,
> > 
> > On Wed, 2009-04-08 at 15:53 +0200, Ingo Molnar wrote:
> > > * Steven Whitehouse <swhiteho@redhat.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > A little while back I posted a RFC patch which added gfs2 glock 
> > > > tracing to blktrace. There was a suggestion that I should look 
> > > > instead at the generic tracing code and add a new tracer, but I've 
> > > > come up with a couple of issues along the way.
> > > > 
> > > > I think from what I can see that its only possible to run a single 
> > > > tracer at once, so running blktrace (for example) would preclude 
> > > > me from also tracing gfs2's glocks at the same time. Also, I can 
> > > > see no mechanism by which I could ensure the sequencing between 
> > > > the blktrace and glock traces other than exporting the blktrace 
> > > > sequence number, even if running multiple tracers at the same time 
> > > > was possible.
> > > 
> > > There's a recent addition: the EVENT_TRACE() facility. Would that 
> > > suit your purposes?
> > > 
> > > 	Ingo
> > 
> > If I can get both blktrace and glock trace info from it, then yes. 
> > I thought that the blktrace output went either via the original 
> > relayfs path, or via its own tracer so that it wasn't possible to 
> > use it and the event trace facility at the same time, unless I use 
> > blktrace via relayfs. From what I've read I thought that probably 
> > the relayfs interface for blktrace might eventually be removed in 
> > favour of the generic tracing interface, but I'm not 100% sure of 
> > that, so perhaps someone can confirm the plans in that area?
> 
> Tom Zanussi (Cc:-ed) recently converted the blktrace tracepoints to 
> a tracing framework - and i think much of that could be reused to 
> add EVENT_TRACE() tracepoints to blktrace too.
> 
> Tom, what's your take on this?
> 
> In general, this is the direction we want to take: EVENT_TRACE() 
> tracepoints that can be used in a generic way, in any tracer.
> 

Yeah, the EVENT_TRACE() tracepoints can be mixed any way you want by
just enabling the ones you want to see:

# echo nop > /sys/kernel/debug/tracing/current_tracer
# echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_fork/enable
# echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_fork/enable
# cat /sys/kernel/debug/tracing/trace

          <idle>-0     [001]  9100.344901: sched_signal_send: sig: 29  task Xorg:5899
          <idle>-0     [001]  9100.344906: sched_signal_send: sig: 29  task Xorg:5899
            bash-6938  [000]  9100.346222: sched_process_fork: parent bash:6938  child bash:7120
           <...>-7120  [000]  9100.409853: sched_signal_send: sig: 17  task bash:6938
          <idle>-0     [001]  9100.433021: sched_signal_send: sig: 29  task Xorg:5899

But you can also mix those EVENT_TRACE() events with another tracer that
uses the global trace buffer (see the EVENT_TRACE() events mixed in with
the sched_switch tracer output):

# echo sched_switch > /sys/kernel/debug/tracing/current_tracer

          <idle>-0     [001]  9405.386800:      0:140:R   + [001]  5899:120:S Xorg
          <idle>-0     [001]  9405.386803:      0:140:R   + [001]  5798:120:S hald-addon-inpu
          <idle>-0     [001]  9405.386807: sched_signal_send: sig: 29  task Xorg:5899
          <idle>-0     [001]  9405.386811: sched_signal_send: sig: 29  task Xorg:5899
          <idle>-0     [001]  9405.386819:      0:140:R ==> [001]  5798:120:R hald-addon-inpu
 hald-addon-inpu-5798  [001]  9405.386824:   5798:120:S ==> [001]  5899:120:R Xorg
            Xorg-5899  [001]  9405.386957:   5899:120:R   + [001]  6301:120:S gnome-screensav
            Xorg-5899  [001]  9405.386961:   5899:120:R ==> [001]  6301:120:R gnome-screensav
 gnome-screensav-6301  [001]  9405.387049:   6301:120:S ==> [001]  5899:120:R Xorg
            Xorg-5899  [001]  9405.387062:   5899:120:R   + [001]  6386:120:S wterm
            Xorg-5899  [001]  9405.387065:   5899:120:R ==> [001]  6386:120:R wterm
           wterm-6386  [001]  9405.387112:   6386:120:S   + [000]  6938:120:S bash
           wterm-6386  [001]  9405.387142:   6386:120:S ==> [001]  5899:120:R Xorg
            Xorg-5899  [001]  9405.387156:   5899:120:R ==> [001]  6386:120:R wterm
           wterm-6386  [001]  9405.387197:   6386:120:S ==> [001]  5899:120:R Xorg
            Xorg-5899  [001]  9405.387250:   5899:120:S ==> [001]     0:140:R <idle>
          <idle>-0     [000]  9405.387633:      0:140:R ==> [000]  6938:120:R bash
            bash-6938  [000]  9405.387640:   6938:120:R   + [001]  6386:120:S wterm
            bash-6938  [000]  9405.387657:   6938:120:S   + [001]  6386:120:S wterm
          <idle>-0     [001]  9405.387703:      0:140:R ==> [001]  7144:120:R cat
             cat-7144  [001]  9405.387909:   7144:120:S ==> [001]     0:140:R <idle>
            bash-6938  [000]  9405.388195: sched_process_fork: parent bash:6938  child bash:7144
            bash-6938  [000]  9405.388202:   6938:120:R   + [001]  7144:120:R cat

There aren't currently any blktrace TRACE_EVENTS(), but if there were,
and you also added a set of glock TRACE_EVENTS(), you'd be able to
enable any or all of those events, along with e.g the sched
TRACE_EVENTS() or even some other tracer, and see all of those outputs
together in the output.  I did something similar for blktrace in the
zedtrace tracer - those could probably be converted to TRACE_EVENTS(),
but I haven't really looked into it since then.

I haven't done anything myself with it yet, but if you define
TRACE_EVENTS() for those things, you should also be able to get the
event data as binary too using the per_cpu files.  At that point, you'd
need some generic userspace to sort things out using the exported event
formats, which I also did something similar for in zedtrace or you could
modify blktrace/blkparse themselves to understand the new glock events. 

As far as sequencing, that's already part of the tracing infrastructure,
so you shouldn't have to worry about it.

If you wanted to write your own special-purpose tracer such as the
current sched_switch tracer that would add something or change the
output of the TRACE_EVENTS() you define, I think it should be possible,
but I don't know that part of the tracing system well enough to say how
to do it; maybe someone else can be more helpful there.  I think there
may be a little more infrastructure work needed to do that, since e.g. I
notice that currently the sched_switch tracer uses different but almost
identical code to the sched and wakeup TRACE_EVENTS(), which isn't
surprising since the event tracing code is a lot newer than the
sched_switch code.  Converting the sched_switch tracer over to re-using
the TRACE_EVENTS() might be a good exercise and show the way for other
tracers...

Hope that helps,

Tom

> 	Ingo

