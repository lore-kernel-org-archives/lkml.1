Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZKUQM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZKUQM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZKUQM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:12:27 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:55829 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbZKUQM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:12:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EALeeB0tGGN1W/2dsb2JhbACBTNF/hDwEgXA
Date: Sat, 21 Nov 2009 11:12:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20091121161231.GC12100@Krystal>
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <4B071000.9080408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B071000.9080408@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:39:10 up 95 days,  2:28,  3 users,  load average: 0.27, 0.29,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 11/18/2009 02:43 PM, Jason Baron wrote:
> > Add text_poke_fixup() which takes a fixup address to where a processor
> > jumps if it hits the modifying address while code modifying.
> > text_poke_fixup() does following steps for this purpose.
> > 
> >  1. Setup int3 handler for fixup.
> >  2. Put a breakpoint (int3) on the first byte of modifying region,
> >     and synchronize code on all CPUs.
> >  3. Modify other bytes of modifying region, and synchronize code on all CPUs.
> >  4. Modify the first byte of modifying region, and synchronize code
> >     on all CPUs.
> >  5. Clear int3 handler.
> > 
> > Thus, if some other processor execute modifying address when step2 to step4,
> > it will be jumped to fixup code.
> > 
> > This still has many limitations for modifying multi-instructions at once.
> > However, it is enough for 'a 5 bytes nop replacing with a jump' patching,
> > because;
> >  - Replaced instruction is just one instruction, which is executed atomically.
> >  - Replacing instruction is a jump, so we can set fixup address where the jump
> >    goes to.
> > 
> 
> I just had a thought about this... regardless of if this is safe or not
> (which still remains to be determined)... I have a bit more of a
> fundamental question about it:
> 
> This code ends up taking *two* global IPIs for each instruction
> modification.  Each of those requires whole-system synchronization.  How
> is this better than taking one IPI and having the other CPUs wait until
> the modification is complete before returning?

Hi Peter,

There are two main benefit for int3 vs stop_machine() I can think of:

1. Diminish the "whole system interrupt off" latency.
2. Support NMIs, MCEs and traps without adding complexity to the NMI,
   MCE nor trap handler.

Also, code update execution time is not performance-critical in terms of
execution time, although the more important aspect is the effect on the
irq latency characteristics of the kernel, as explained below.


1. Latency

* Let's say we have a worse-case interrupt latency of 15ms in our
  kernel on CPU A (e.g. induced by printk to a serial console) (yeah,
  that's bad, but these exist).

* Concurrently, CPU B performs code modification with stop_machine().
  stop_machine() spawns a worker thread on eacu CPU, waiting for all
  CPUs to respond to the IPI.

* CPU A is still in its worse-case interrupt latency. All other CPUs
  are running in stop_cpu() waiting for CPU A to join the game.

So, basically, we just transformed a single-cpu worse-case latency to an
even worse, longer, whole-system worse case latency.


2. NMIs, MCEs and traps

Currently, the approach Ingo proposes targets NMIs only. Other
non-maskables interrupt sources should also be treated. I think everyone
assumes that stop_cpu never generates any trap. Is it a documented
requirement, or is it just wishful thinking ? Because if it is not, it
could be possible for an architecture to choose a design that would let
stop_cpu generate a trap, and therefore we would have to fiddle with the
trap handlers too. Should we add the fixup test to trap handlers too ?

NMIs can be dealt with using the scheme where the NMI does the
modification itself if it nests over the code modification code, as
proposed by Ingo. However, I'm concerned about adding any bit of
complexity to a code path like the nmi handler. Basically, it has always
been a mechanism meant to do a task with the minimal delay and with
minimal interaction with the system. Adding fixup code to these go
against this idea. If someone really need to hook his device on a NMI
handler, I am certain that they will not see these extra checks and this
extra NMI-response latency as welcome.

MCEs are yet another code path that could be useful to use for system
diagnostic, yet cannot be disabled, just like NMIs. Should we start
auditing all handlers which are not dealt with and add the fixup test
there too ?


So, in comparison (+ is for int3, - for stop machine):

+ Lower system-wide interrupt latency.
+ Lower NMI response-time.
+ Lower complexity in the NMI handler.
+ Handles all nested execution in one spot, without adding complexity
  elsewhere. Therefore deals with MCEs and traps.
+ Easier to test that _all_ nested executions are appropriately dealt
  with, because the solution is not case-specific.

- Two IPIs instead of one. I'm not even sure it's slower than the worker
  thread creation currently done in stop_machine.
- Execution of a breakpoint in the case a remote CPU (or local
  NMI, MCE, trap) hits the breakpoint.

Mathieu


> 
> 	-hpa

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
