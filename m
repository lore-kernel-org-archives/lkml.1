Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZDXPHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZDXPHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZDXPHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:07:41 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:38836 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753078AbZDXPHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:07:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQFABtw8UlMQW1W/2dsb2JhbACBUM9Vg3QF
Date: Fri, 24 Apr 2009 11:07:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [BUG] 2.6.29.1 debugobjects warning
Message-ID: <20090424150724.GA23568@Krystal>
References: <20090423140002.GA12852@Krystal> <20090423164638.3b5769c6.akpm@linux-foundation.org> <20090424064937.GD21739@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090424064937.GD21739@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:00:45 up 55 days, 11:26,  1 user,  load average: 0.88, 0.50,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 23 Apr 2009 10:00:02 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > ODEBUG: init active object type: timer_list
> 
> > It seems to be complaining that cpufreq_governor_dbs() is running 
> > init_timer() against a timer which has already been initialised 
> > once.
> 
> Not just already initialized - but also active. There's these states 
> for an object:
> 
>         ODEBUG_STATE_NONE,
>         ODEBUG_STATE_INIT,
>         ODEBUG_STATE_INACTIVE,
>         ODEBUG_STATE_ACTIVE,
>         ODEBUG_STATE_DESTROYED,
> 
> So the 'init active object type' warning above suggests that an 
> init_timer() has been done on an already running timer. If true then 
> that is a bad bug - can corrupt timer state, etc.
> 
> Thomas, do you agree?
> 

This would fit with the behavior I've noticed and submitted a patch for
later in this thread. Basically, the incorrect use of
"cancel_delayed_work()" instead of "cancel_delayed_work_sync()" may
leave the timer active if the race explained in the mail below happen.

http://lkml.org/lkml/2009/4/24/19

Maybe we should audit other users of
schedule_delayed_work/cancel_delayed_work that are re-arming themselves
in the workqueue handler without any proper cancel_delayed_work_sync()
nor flush_workqueue() calls on teardown.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
