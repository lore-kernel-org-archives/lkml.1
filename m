Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbXB0TEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbXB0TEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXB0TEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:04:49 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:54062 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbXB0TEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:04:48 -0500
Date: Tue, 27 Feb 2007 14:04:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, mbligh@google.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070227190442.GA11272@Krystal>
References: <1172525261.5517.69.camel@imap.mvista.com> <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com> <20070227035456.GA15444@Krystal> <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu> <20070227073815.GA25894@Krystal> <1172571535.5517.222.camel@imap.mvista.com> <20070227160206.GA2391@Krystal> <1172597055.5517.233.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1172597055.5517.233.camel@imap.mvista.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 13:47:09 up 25 days,  8:55,  4 users,  load average: 1.29, 1.19, 1.12
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker (dwalker@mvista.com) wrote:
> On Tue, 2007-02-27 at 11:02 -0500, Mathieu Desnoyers wrote:
> > * Daniel Walker (dwalker@mvista.com) wrote:
> > > On Tue, 2007-02-27 at 02:38 -0500, Mathieu Desnoyers wrote:
> > > 
> > > > 
> > > > I am concerned about the automatic fallback to the PIT when no other
> > > > clock source is available. A clocksource read would be atomic when TSC
> > > > or HPET are available, but would fall back on PIT otherwise. There
> > > > should be some way to specify that a caller is only interested in atomic
> > > > clock sources (if none are available, the call should simply return an
> > > > error, or 0).
> > > > 
> > > I'm not sure what you mean by using the RCU
> > 
> > The original proposal of this thread uses a RCU (read-copy-update) style
> > update of the previous 64 bits counter : it swaps a pointer (atomically)
> > upon update by incrementing a word-sized counter that is used, by the
> > reader, to get the offest in the array (with a modulo operation) for the
> > current readable data and as a way to detect incorrect reads of
> > overwritten information (we re-read the word-sized counter after having
> > read the data structure to make sure is has not been incremented. If we
> > detect an increment, we redo the whole operation).
> 
> I didn't see RCU at all in your original message, so I'm not sure how
> you propose to use it .. My understanding of the RCU was that it
> couldn't be used from interrupt context, that could be totally wrong so
> I'll let you explain how you planed to use it.
> 

1 - I do not plan to use the rcupdate.h API, because it is oriented
towards allowing/freeing data structures after a quiescent state. I
don't need that. I only want to have a 64 bits data structure valid for
reading, with atomic update. Therefore, I keep an array of 2 64 bits
structures. At all time, there is one used as "readable" value and the other
as "writeable". The role is exchanged at each update. The word-sized
counter is used to select the current read and write pointers through a
mask, and is also used to detect bad reads (is a read is preempted, and
then we have 2 updates, the reader could read a bad value without
knowing it). By keeping a word-sized counter of the number of updates,
we have 32 (or 64) bits (depending on the architecture) before the wrap
around, which should not happen even in a far future.



> > > > I still think that an RCU style update mechanism would be a good way  to
> > > > fix the current clocksource read issue. Another, slower and non NMI
> > > > safe way to do this would be with a read seqlock and with IRQ disabling.
> > > 
> > > , but the pit clocksource
> > > does disable interrupts with a spin_lock_irqsave().
> > > 
> > 
> > When I say "clocksource read issue", I am talking about
> > race between the function you proposed earlier, which you say is used in
> > -rt kernels for latency tracing (get_monotonic_cycles), and HPET and TSC
> > "last cycles" updates.
> 
> Right .. You said that regular interrupts would cause this non-atomic
> 64-bit update race , but the pit disabled interrupts, and the
> last_cycles update is done with interrupts off .. So I think we're back
> to only the NMI case ..
> 
> Did you have another scenario ?
> 

__get_nsec_offset : reads clock->cycle_last. Should be called with
xtime_lock held. (ok so far, but see below)

change_clocksource
clock->cycle_last = now; (non atomic 64 bits update. Not protected by
any lock ?) -> this would race with __get_nsec_offset ?

update_wall_time
Called from timer interrupt. Holds xtime_lock and has a priority higher
than other interrupts. Other clock->cycle_last protected by
write_seqlock_irqsave.

get_monotonic_cycles (as you proposed, in -rt kernels) :
reads clock->cycle_last. Not protected by any read seqlock and does not
disable interrupts. Races with change_clocksource, update_wall_time and
all other time update functions. For instance, is someone uses
get_monotonic_cycles in process context and the timer interrupt fires
update_wall_time right at the middle of the 2 32 bits read, the value
will be wrong.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
