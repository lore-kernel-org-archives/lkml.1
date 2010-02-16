Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab0BPRFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:05:44 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:44385 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab0BPRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:05:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIJfektGHl8d/2dsb2JhbACbGXW9f4RbBIMUGg
Date: Tue, 16 Feb 2010 12:05:40 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng0.158 Linux-2629-RT kernel BUG: sleeping
	function called from invalid context at kernel/rtmutex.c:685
Message-ID: <20100216170540.GA28039@Krystal>
References: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com> <1266337450.24271.140.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain> <20100216164744.GA25115@Krystal> <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:03:31 up 62 days,  1:21,  6 users,  load average: 0.42, 0.25,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Tue, 16 Feb 2010, Mathieu Desnoyers wrote:
> > > The function is called from an IPI. That's a LTTNG problem, not a RT one.
> > 
> > I use del_timer in IPI to delete lttng per-cpu timers on all CPUs. I
> > have to do this because timers created with add_timer_on are documented
> > to be incompatible with del_timer_sync():
> > 
> >  * Synchronization rules: Callers must prevent restarting of the timer,
> >  * otherwise this function is meaningless. It must not be called from
> >  * interrupt contexts. The caller must not hold locks which would prevent
> >  * completion of the timer's handler. The timer's handler must not call
> >  * add_timer_on(). Upon exit the timer is not queued and the handler is
> >  * not running on any CPU.
> 
> Errm. The documentation says: 
> 
>       "The timer's handler must not call add_timer_on()." 
> 
> It's not talking about a timer which was initialized with
> add_timer_on().
> 
>  And your per cpu timer handlers have no requirement to call
> add_timer_on() simply because add/mod_timer() is requeueing the timer
> on the same cpu on which the handler runs. 
> 
> So the IPI is just a solution for a non existing problem.

Oh, right. Thanks for the explanation. I'll look into moving LTTng to a
saner del_timer_sync() scheme to delete the timers.

Thanks,

Mathieu

> 
> Thanks,
> 
> 	tglx
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
