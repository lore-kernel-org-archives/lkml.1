Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZKSV4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZKSV4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZKSV4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:56:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723AbZKSV4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:56:53 -0500
Date: Thu, 19 Nov 2009 16:55:58 -0500
From: Jason Baron <jbaron@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, rth@redhat.com, mhiramat@redhat.com
Subject: Re: [RFC PATCH 0/6] jump label v3
Message-ID: <20091119215558.GD2625@redhat.com>
References: <cover.1258580048.git.jbaron@redhat.com> <20091119035424.B3E8B1E2C@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119035424.B3E8B1E2C@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 07:54:24PM -0800, Roland McGrath wrote:
> 2. optimal compiled hot path code
> 
>    You and Richard have been working on this in gcc and we know the state
>    of it now.  When we get the cold labels feature done, it will be ideal
>    for -O(2?).  But people mostly use -Os and there no block reordering
>    gets done now (I think perhaps this even means likely/unlikely don't
>    really change which path is the straight line, just the source order
>    of the blocks still determines it).  So we hope for more incremental
>    improvements here, and maybe even really optimal code for -O2 soon.
>    But at least for -Os it may not be better than "unconditional jump
>    around" as the "straight line" path in the foreseeable future.  As
>    noted, that alone is still a nice savings over the status quo for the
>    disabled case.  (You gave an "average cycles saved" for this vs a load
>    and test, but do you have any comparisons of how those two compare to
>    no tracepoint at all?)
> 

i've run that in the past, and for the nop + jump sequence its between
2 - 4 cycles on average vs. no tracepoint.


> 3. bookkeeping magic to find all the jumps to enable for a given tracepoint
> 
>    Here you have a working first draft, but it looks pretty clunky.
>    That strcmp just makes me gag.  For a first version that's still
>    pretty simple, I think it should be trivial to use a pointer
>    comparison there.  For tracepoints, it can be the address of the
>    struct tracepoint.  For the general case, it can be the address of
>    the global that would be flag variable in case of no asm goto support.
> 
>    For more incremental improvements, we could cut down on running
>    through the entire table for every switch.  If there are many
>    different switches (as there are already for many different
>    tracepoints), then you really just want to run through the
>    insn-patch list for the particular switch when you toggle it.  
> 
>    It's possible to group this all statically at link time, but all
>    the linker magic hacking required to get that to go is probably
>    more trouble than it's worth.  
> 
>    A simple hack is to run through the big unsorted table at boot time
>    and turn it into a contiguous table for each switch.  Then
>    e.g. hang each table off the per-switch global variable by the same
>    name that in a no-asm-goto build would be the simple global flag.
> 

that probably makes the most sense. Do a sort of the jump table and then
store an offset,length pair with each switch. I was thinking of this as follow
on optimization (the tracepoint code is already O(N) per switch toggle, where
is N = total number of all tracepoint site locations, and not O(n), where
n = number of sites per tracepoint). Certainly, if this is a gating issue for
this patchset, I can fix it now.

> 
> Finally, for using this for general purposes unrelated to tracepoints,
> I envision something like:
> 
> 	DECLARE_MOSTLY_NOT(foobar);
> 
> 	foo(int x, int y)
> 	{
> 		if (x > y && mostly_not(foobar))
> 			do_foobar(x - y);
> 	}
> 
> 	... set_mostly_not(foobar, onoff);
> 
> where it's:
> 
> #define DECLARE_MOSTLY_NOT(name) ... __something_##name
> #define mostly_not(name) ({ int _doit = 0; __label__ _yes; \
> 			    JUMP_LABEL(name, _yes, __something_##name); \
> 			    if (0) _yes: __cold _doit = 1; \
> 			    unlikely (_doit); })
> 
> I don't think we've tried to figure out how well this compiles yet.
> But it shows the sort of thing that we can do to expose this feature
> in a way that's simple and unrestrictive for kernel code to use casually.
> 
> 

cool. the assembly output would be interesting here...

thanks,

-Jason
