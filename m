Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYAPP2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYAPP2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYAPP2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:28:41 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:61647 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263AbYAPP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:28:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAMaxjUdMROHU/2dsb2JhbACBWJAQnEY
Date: Wed, 16 Jan 2008 10:28:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
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
Message-ID: <20080116152838.GA970@Krystal>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org> <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:12:05 up 73 days, 20:17,  5 users,  load average: 0.24, 0.52,
	0.64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> > Hrm, I will reply to the rest of this email in a separate mail, but
> > there is another concern, simpler than memory ordering, that just hit
> > me :
> >
> > If we have CPU A calling clocksource_accumulate while CPU B is calling
> > get_monotonic_cycles, but events happens in the following order (because
> > of preemption or interrupts). Here, to make things worse, we would be on
> > x86 where cycle_t is not an atomic write (64 bits) :
> >
> >
> > CPU A                  CPU B
> >
> > clocksource read
> > update cycle_mono (1st 32 bits)
> >                        read cycle_mono
> >                        read cycle_last
> >                        clocksource read
> >                        read cycle_mono
> >                        read cycle_last
> > update cycle_mono (2nd 32 bits)
> > update cycle_last
> > update cycle_acc
> >
> > Therefore, we have :
> > - an inconsistant cycle_monotonic value
> > - inconsistant cycle_monotonic and cycle_last values.
> >
> > Or is there something I have missed ?
> 
> No, there's probably issues there too, but no need to worry about it,
> since I already showed that allowing for clocksource_accumulate to happen
> inside the get_monotonic_cycles loop is already flawed.
> 

Yep, I just re-read through your previous email, and totally agree that
the algorithm is flawed in the way you pointed out.


> >
> > If you really want an seqlock free algorithm (I _do_ want this for
> > tracing!) :) maybe going in the RCU direction could help (I refer to my
> > RCU-based 32-to-64 bits lockless timestamp counter extension, which
> > could be turned into the clocksource updater).
> 
> I know you pointed me the code, but lets assume that I'm still ignorant
> ;-)
> 
> do you actually use the RCU internals? or do you just reimplement an RCU
> algorithm?
> 

Nope, I don't use RCU internals in this code. Preempt disable seemed
like the best way to handle this utterly short code path and I wanted
the write side to be fast enough to be called periodically. What I do is:

- Disable preemption at the read-side :
  it makes sure the pointer I get will point to a data structure that
  will never change while I am in the preempt disabled code. (see *)
- I use per-cpu data to allow the read-side to be as fast as possible
  (only need to disable preemption, does not race against other CPUs and
  won't generate cache line bouncing). It also allows dealing with
  unsynchronized TSCs if needed.
- Periodical write side : it's called from an IPI running on each CPU.

(*) We expect the read-side (preempt off region) to last shorter than
the interval between IPI updates so we can guarantee the data structure
it uses won't be modified underneath it. Since the IPI update is
launched each seconds or so (depends on the frequency of the counter we
are trying to extend), it's more than ok.

Mathieu

> -- Steve

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
