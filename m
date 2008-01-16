Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYAPRtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYAPRtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYAPRt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:49:26 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:38389 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861AbYAPRtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:49:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KANLSjUdMROHU/2dsb2JhbACBWKxe
Date: Wed, 16 Jan 2008 12:49:23 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080116174923.GA7233@Krystal>
References: <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com> <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com> <20080116170011.GA3651@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080116170011.GA3651@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:30:22 up 73 days, 22:35,  5 users,  load average: 3.65, 1.09,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
....
> > 
 > 
> > One thing I want to clear up. The major difference between this
> > latency_tracer and LTTng is what we consider fast paths.  The latency
> > tracer is recording things like enabling and disabling interrupts, preempt
> > count changes, or simply profiling all function calls.  Those are what I
> > consider fast paths.  The slow path WRT the latency_tracer are things like
> > context switches.  This is why I don't have a problem with copying the
> > comm at context switch time. Because that _is_ a slow path for the latency
> > tracer.
> 
> LTTng hooks in the lockdep tracer to trace irq on/off, spinlocks, etc..
> in flight recorder mode, we have nothing to write to disk and therefore
> we can handle very frequent events. We then do the analysis off-line
> using the last MB written in the buffers. The advantage is that the
> kernel dumbly writes data to a buffer : we therefore move the complexity
> to user-space.
> 
> I agree that some kind of tracing, like the one you are doing, might be
> done more efficiently if you do a first clever analysis phase directly
> in the kernel without writing the raw high event rate data in memory
> buffers. However, I believe that it would be more powerful if we combine
> the two approaches rather than trying to do everything in or out of the
> kernel.  LTTng could provide the comm names, priorities, etc, and your
> tracer could provide the top X list of processes that had a bad
> behavior. It would mean that the complete overall information would be
> made available after a post-processing phase done in an analysis tool
> like LTTV, but I don't see any problem with it.
> 

Just to expand a bit on the design-side of my proposal :

Your module would create "profiles" based on the hooks called. If we
take the interrupt on/off for example, it would be called by lockdep and
could keep a table of the top X instructions that disables interrupts
for a long time. (it's just an example, you could want to save the pid
instead...)

Then, whenever a "profile dump" is triggered, you would simply have to
send the current state of your profile to lttng with something like :


struct irq_latency_table {
  void *ip;
  cycles_t time;
};

/*
 * Make sure only one profile at a time is written to the trace for the
 * whole system.
 */
static DECLARE_MUTEX(latency_profile_mutex);
static struct irq_latency_table latency_table[NR_ENTRIES];


void irq_latency_dump_profile(void)
{
  int i;
  char namebuf[KSYM_NAME_LEN];

  mutex_lock(&latency_profile_mutex);
  trace_mark(irq_latency_dump_begin, MARK_NOARGS);
  for (i = 0; i < NR_ENTRIES; i++) {
    sprint_symbol(namebuf, (unsigned long)latency_table[i].ip);
    trace_mark(irq_latency_entry, "ip %p symbol %s time %llu",
      latency_table[i].ip, namebuf,
      (unsigned long long)latency_table[i].time);
  }
  trace_mark(irq_latency_dump_end, MARK_NOARGS);
  mutex_unlock(&latency_profile_mutex);
}

You can then create a LTTV module that will format your nice output each
time a profile dump is encountered.

By doing this, your specialized profile generator would only have to
hook into the irq on/off events to gather the information it needs,
nothing more. I think that would trim the code size and the complexity
of your module by an interesting factor.

Note that I could optimize the way I currently deal with symbols by not
having to dump them in the trace, but since it's only for low rate
events, this optimization has a low priority on my todo list.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
