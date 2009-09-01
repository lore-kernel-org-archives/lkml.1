Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbZIAXFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbZIAXFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 19:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZIAXFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 19:05:13 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53467 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbZIAXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 19:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cmC4vBw/wzLYf5mIthrNqtErpngcsWYT7DW4YoojgwoboRP2SseldXDPneSEUxsnOV
         KnNsgIgbJGv031pDXpvrkj4v1HFfHtVK8pKuo3LDI66YJ0wk3cJ/1vxHMJuYmpkquunY
         5zJyPaDbnSrA0ur+aRNzW67AR297q4nff2vfY=
Date: Wed, 2 Sep 2009 01:05:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing: block-able ring_buffer consumer
Message-ID: <20090901230508.GC6108@nowhere>
References: <4A95F768.7070701@cn.fujitsu.com> <20090829102100.GB6418@nowhere> <4A9D192F.8080907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9D192F.8080907@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 08:53:03PM +0800, Lai Jiangshan wrote:
> >> @@ -1178,6 +1179,7 @@ void update_process_times(int user_tick)
> >>  	printk_tick();
> >>  	scheduler_tick();
> >>  	run_posix_cpu_timers(p);
> >> +	tracing_notify();
> > 
> > 
> > 
> > Hmm, that looks really not a good idea. The tracing shouldn't ever impact
> > the system when it is inactive.
> > Especially in such a fast path like the timer interrupt.
> 
> It do nothing at most time.
> It just calls tracing_notify() and then returns, but...
> it still has several mb()s, I can remove this mb()s in next patch.



The timer interrupt is one of the real fast path of the kernel.
Adding an extra call there plus some condition checks even when
the tracing is off is not a nice thing.

I bet we could even measure the overhead of this, especially
in a 1000 Hz kernel.

Also do we have a low latency requirement that justifies this check
on every tick? I don't think so. It's just about having tracing
results.

 
> We cannot call wake_up() and the tracing write side, so we delay
> the wake_up() until next timer interrupt.


Indeed we can't because of a random cpu rq lock that we may be
already holding.

May be try something similar to what we are doing for sensible tracers.

Normal tracers use default_wait_pipe() which uses a common wake up.
The others that may wake up while already holding a rq lock use
a polling wait:

void poll_wait_pipe(struct trace_iterator *iter)
{
	set_current_state(TASK_INTERRUPTIBLE);
	/* sleep for 100 msecs, and try again. */
	schedule_timeout(HZ / 10);
}

On the worst case the reader will wait for 1/100 secs
(the comment is wrong).

You can probably use the same thing for ring buffer splice
and poll waiters.

	Frederic.

