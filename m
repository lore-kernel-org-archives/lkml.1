Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZHaQ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZHaQ73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 12:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZHaQ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 12:59:29 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60500 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZHaQ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 12:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K6tQQwfLSdmHmZxMzIRpRkasgJ2TH3u3pZImzr8iNkm//S5Zqgv5DoFUUyZEFMfXzR
         Moy/xQ25WsBa6BwbALf1Pkr9/Pgllw6qqn0S0CUpo9h9tmDC874ZXePm3xRo77sRZnNT
         3wRaD3CjUGUaPXNH4KQEaTOFBBEh4VPfi1Trs=
Date: Mon, 31 Aug 2009 18:59:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] perf tools: Complete support for dynamic strings
Message-ID: <20090831165924.GA6048@nowhere>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com> <1251693921-6579-4-git-send-email-fweisbec@gmail.com> <20090831081133.GA15619@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831081133.GA15619@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 10:11:33AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Complete support for __str_loc type strings of ftrace events which
> > have dynamic offsets values set for each of them inside their sammples.
> > 
> > Before:
> >         geany-5759  [000]     0.000000: lock_release: name
> >         geany-5759  [000]     0.000000: lock_release: name
> >         geany-5759  [000]     0.000000: lock_release: name
> >   kondemand/0-362   [000]     0.000000: lock_release: name
> >       pdflush-421   [000]     0.000000: lock_release: name
> > 
> > After:
> >         geany-5759  [000]     0.000000: lock_release: &u->lock
> >         geany-5759  [000]     0.000000: lock_release: key
> >         geany-5759  [000]     0.000000: lock_release: &group->notification_mutex
> >   kondemand/0-362   [000]     0.000000: lock_release: &rq->lock
> >       pdflush-421   [000]     0.000000: lock_release: &rq->lock
> 
> I've applied all five patches, thanks Frederic!
> 
> Also, i think this makes perf trace quite functional already so i 
> merged that topic (and these commits) into tracing/core, for v2.6.32 
> merging.



Ok.


 
> One thing that i noticed which is still quite quirky are the 
> parameters to perf record. (needing -R and the :r postfix to events) 
> Could something more intuitive be done here?


I hope. It's not that easy, at least for me, to find something intuitive
there.

I've thought about

  -e *sys:event  (because the * suggests a deref that takes the content)
                 But that's a bit convoluted. And moreover we may want
                 to support basic regex later for event selection.

If someone has an idea, please tell me.

Another thing. We could, by default display a small comment while
selecting an event without its content:

"Opening counter sys:event. Type -R if you want raw sampling."

The user could shut that up with a -q option.

> Also, i think people would like to use wildcards in event 
> specifiers, such as:
> 
>   perf record -e timer/*
> 
> To capture all timer events:
> 
>  hrtimer_cancel
>  hrtimer_expire_entry
>  hrtimer_expire_exit
>  hrtimer_init
>  hrtimer_start
>  itimer_expire
>  itimer_state
>  timer_cancel
>  timer_expire_entry
>  timer_expire_exit
>  timer_init
>  timer_start
>
> Instead of having to type:
> 
> perf record -e hrtimer_cancel -e hrtimer_expire_entry \
>  -e hrtimer_expire_exit -e hrtimer_init -e hrtimer_start \
>  -e itimer_expire -e itimer_state -e timer_cancel \
>  -e timer_expire_entry -e timer_expire_exit -e timer_init \
>  -e timer_start
> 
> which is not quite realistic.


Totally agreed, it was in my todo list.

But don't you think
	perf record -e timer:*
is more intuitive and follows the current logic?

