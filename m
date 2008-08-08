Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbYHHRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbYHHRXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYHHRXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:23:04 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:39808 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYHHRXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:23:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkFAGAZnEhMRKxB/2dsb2JhbACBWap5
Date: Fri, 8 Aug 2008 13:22:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Message-ID: <20080808172259.GB8244@Krystal>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:20:07 up 64 days, 22:01,  6 users,  load average: 0.30, 0.47,
	1.03
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 7 Aug 2008, Mathieu Desnoyers wrote:
> 
> > 
> > Hi Steven,
> > 
> > If you really want to stop using stop_machine, I think you should have a
> > look at my immediate values infrastructure :
> > 
> > see:
> > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=blob;f=arch/x86/kernel/immediate.c;h=0958c02b49eed3bbc00bdc5aceeee17a6d0c7ab4;hb=HEAD
> > 
> > particularly replace_instruction_safe(), which uses a temporary
> > breakpoint to safely replace an instruction on a live SMP system without
> > using stop_machine. Feel free to try it in ftrace. :)
> > 
> > You may need to tweak the imv_notifier(), which is responsible for
> > executing the breakpoint. The only special thing this handler has to
> > know is the non-relocatable instructions you might want to insert (it
> > only cares about the new instructions, not the old ones being replaced).
> > The current code deals with 5-bytes jumps. Note that the instruction is
> > executed in the breakpoint handler with preemption disabled, which might
> > not be well suited for a call instruction.
> > 
> > I would recommend to patch in a 5-bytes jmp with 0 offset
> > (e9 00 00 00 00) when disabled (this makes a single 5-bytes instruction
> > and thus makes sure no instruction pointer can iret in the middle).
> > 
> > When enabling the site, you could patch-in the original call, but you
> > should tweak the imv_notifier() so that it uses the jmp offset 0 in the
> > bypass instead of the function call, because preemption would otherwise
> > be disabled around the call when executed in the breakpoint bypass.
> > 
> > Therefore, simply statically forcing the bypass code to e9 00 00 00 00
> > in all the cases (a nop) would do the job for your needs.
> 
> I originally used jumps instead of nops, but unfortunately, they actually 
> hurt performance more than adding nops. Ingo told me it was probably due
> to using up the jump predictions of the CPU.
> 

Hrm, are you sure you use a single 5-bytes nop instruction then, or do
you use a mix of various nop sizes (add_nops) on some architectures ?

You can consume the branch prediction buffers for conditional branches,
but I doubt static jumps have this impact ? I don't see what "jump
predictions" you are referring to here exactly.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
