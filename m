Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZBWEyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZBWEyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 23:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZBWEyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 23:54:04 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:41425 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbZBWEyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 23:54:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMFAI+1oUlMQWXi/2dsb2JhbACBbtI+hA8G
Date: Sun, 22 Feb 2009 23:53:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090223045357.GA9158@Krystal>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com> <20090223023332.GA5430@Krystal> <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:41:22 up 1 day, 20:15,  2 users,  load average: 0.59, 0.50,
	0.46
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Sun, 22 Feb 2009, Mathieu Desnoyers wrote:
> > > 
> > > We are changing over 19000 locations in the kernel. This touches almost 
> > > all kernel text pages anyway. You want to map a page in and out for over 
> > > 19000 locations?
> > > 
> > > -- Steve
> > > 
> > 
> > Hi Steve,
> > 
> > Can you provide numbers to indicate why it's required to be so intrusive
> > in the kernel mappings while doing these modifications ? I think opening
> > such time window where standard code mapping is writeable globally in
> > config RO_DATA kernels could open the door to unexpected side-effects,
> > so ideally going through the "backdoor" page mapped by text_poke seems
> > safer. Given similar performance, I would tend to use a text_poke-like
> > approach.
> > 
> 
> Not sure which numbers you are asking for. The dynamic function tracer 
> modifies all mcount calls, which are done by practically every function in 
> the kernel. With a normal Fedora kernel (and all its loaded modules), 
> that's between 15 to 20 thousand functions, depending on what modules are 
> loaded.
> 

I mean comparing the cost of changing the kernel mappings and doing the
edits (as you do) vs doing it through a text-poke-like mapping.

> At boot up we convert them all to nops, but when we enable the function 
> tracer, we convert them back to calls to the function tracer. This is done 
> by a priviledge user, since the function tracer can add quite a bit of 
> overhead when activated.
> 
> I do not really see how changing this for the short period of time is any 
> different than making another mapping point to the kernel code. If you 
> could find a way to break this security, you should be able to break it 
> with another mapping as well.

It's not only about breaking the security. It's mostly to insure
internal kernel consistency. While you are changing these mappings, you
could possibly have a window where other kernel code is running (irq,
other cpus threads). That code could itself be buggy and use the
writeable window to overwrite some kernel code or RO data. This
side-effect would go undetected while users think the RO data *is* is,
but it wouldn't. You also bring a good point about security : if someone
ever rely on CONFIG_DEBUG_RODATA for some security reasons, then we give
a big window where kernel text and ro data is writeable at *known*
addresses, while we can randomize the address used for text_poke.

> 
> Also note that this dynamic tracing code works for not only x86, it also 
> works for PPC, ARM, superH and ia64. To use text_poke, that would require 
> all of these to have text_poke ported.
> 

Do these architecture have DEBUG_RODATA config ? If not, then a simple
memcpy is ok.

> How does text_poke solve the issue of executing code on another CPU that 
> is changing?
> 

text_poke itself does not provide that. This must be insured by the
user on a case-by-case basis. For instance, kprobes is changing code
atomically _and_ just inserting/removing breakpoints. Doing this is fine
with cross-cpu code modification (XMC). alternative code is only
changing code when the CPU is UP, so it's also ok. However, changing
multi-bytes instructions without changing those for a trap-generating
instruction when the CPUs are up (SMP) falls into the erratas, and the
code that uses text_poke must carefully perform this modification, e.g.
by doing like I do in my immediate values patchset in the lttng git
tree (using a temporary breakpoint while doing the modification). This
would apply directly to the function tracer, and you could get rid of
this ugly latency-inducing stop_machine() call.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
