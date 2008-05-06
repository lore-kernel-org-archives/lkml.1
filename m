Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYEFOed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYEFOed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYEFOeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:34:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbYEFOeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:34:23 -0400
Date: Tue, 6 May 2008 16:34:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, zdenek.kabelac@gmail.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH REPOST^3] Run IST traps from user mode preemptive on
	process stack
Message-ID: <20080506143400.GA26162@elte.hu>
References: <20080502091948.GA26099@basil.nowhere.org> <alpine.LFD.1.10.0805061305460.3318@apollo.tec.linutronix.de> <87skwvbn4m.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skwvbn4m.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > This introduces two security bugs in one go:
> >
> > 1.) The IST stack pointer is elevated unconditionaly and with your 
> > change we can now schedule away in the handler.
> 
> Yes, but that's fine.

no, your patch is not fine at all. It introduces a security hole, as 
Thomas pointed it out to you.

The IST pointer in the _TSS_ can go out of bounds by your patch! That 
corruption can be controlled by malicious userspace. Read the analysis 
from Thomas.

That percpu_tss.ist[] location is not just a random pointer. It is the 
TSS that is read by the CPU on every trap. It is a security-critical 
structure and every modification to it has to be treated very, very 
carefully. If it goes out of bounds that leads to very nasty problems.

This is a pretty bad security bug, and your reply shows ignorance about 
the code your patch is modifying - _after_ Thomas has pointed it out to 
you.

> > this same CPU triggers the same trap and elevates it again.
> 
> That's not possible generally. None of these interrupts can nest in a 
> normal kernel.

read the analysis from Thomas. Here is a sample buggy sequence:

  task #1 runs, does int3, goes on DEBUG_STACK IST stack,
      we do -= 4096 of the tss.ist[DEBUG_STACK-1] pointer, handler schedules
  task #2 runs, does int3, goes on DEBUG_STACK IST stack, handler schedules
      we do -= 4096 of the tss.ist[DEBUG_STACK-1] pointer, handler schedules
  task #3 runs, does int3, goes on DEBUG_STACK IST

  => poof, stack underflow, memory corruption of nearby data structures,
     because the DEBUG_STACK is only 8KB...

this can be triggered in almost arbitrary depth, from user-space.

> Do you refer to the DEBUG_STACK ist add/dec? That is not needed for 
> anything in tree to my knowledge.

Wrong. The pointer the subq/addq instructions modify are in fact used by 
_EVERY SINGLE_ IST trap sequence that the 64-bit kernel executes (!).

This is the modification that the paranoidentry macro does to the TSS in 
entry_64.S:

  subq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
  ...
  addq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)

that modifies the TSS _directly_. The TSS is directly read by the CPU on 
every trap entry. The percpu_tss.ist[] array of pointers is then used by 
the CPU for every single IST trap. (hw-debug, NMI, int3, double-fault, 
stacksegment-overflow, MCE)

This is nothing new or unexpected, it is basic x86-64 IST architectural 
behavior implemented in the CPU.

The bug you introduce is that if the handler schedules away (it blocks 
or gets preempted on CONFIG_PREEMPT), it would keep the per-CPU IST 
offset for that IST type decreased by 4096 => if done enough times the 
pointer goes out of bounds and it's kaboom.

> > 2.) The IST stack pointer is unbalanced in the other direction as 
> > well: it is incremented on CPUn then the handler is scheduled away 
> > and migrated to CPUm. After return from the handler the IST stacks 
> > of both CPUs are corrupted. Exploitable by unprivileged user-space 
> > code as well.
> 
> The IST is restored again after the handler. [...]

yes but it is restored on the wrong CPU, after the task has scheduled 
and migrated - moving the IST pointer in the TSS out of bounds, so the 
next IST trap (which user-space can trigger arbitrarily - just generate 
a stream of INT3 breakpoints) will corrupt memory!

> [...] You're right that strictly wouldn't be needed and could be 
> avoided, but i don't think it's exploitable in any ways.
> 
> Regarding user controlled pt_regs: I think you're forgetting that 
> x86-64 doesn't have vm86 mode and that we can always trust pt_regs 
> segment indexes. On i386 you would be right, but not here.

Thomas is not forgetting anything.
 
Thomas is doing security analysis about how the hole in your patch can 
be exploited: the wrong IST offsets are used to corrupt nearby data 
structures - a malicious nonprivileged user task can modify a good 
portion of the ~64 bytes of pt_regs at the end of every page near the 
IST stack address (and randomly corrupt some bytes below that) - just by 
virtue of generating an int3 (or hw-debug) trap with prepared register 
contents.

You first need to understand the hole you are introducing to understand 
the finer aspects of his security analysis though...

	Ingo
