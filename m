Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZBWE3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZBWE3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 23:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZBWE3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 23:29:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZBWE3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 23:29:13 -0500
Date: Sun, 22 Feb 2009 23:29:09 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
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
In-Reply-To: <20090223023332.GA5430@Krystal>
Message-ID: <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com> <20090223023332.GA5430@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Feb 2009, Mathieu Desnoyers wrote:
> > 
> > We are changing over 19000 locations in the kernel. This touches almost 
> > all kernel text pages anyway. You want to map a page in and out for over 
> > 19000 locations?
> > 
> > -- Steve
> > 
> 
> Hi Steve,
> 
> Can you provide numbers to indicate why it's required to be so intrusive
> in the kernel mappings while doing these modifications ? I think opening
> such time window where standard code mapping is writeable globally in
> config RO_DATA kernels could open the door to unexpected side-effects,
> so ideally going through the "backdoor" page mapped by text_poke seems
> safer. Given similar performance, I would tend to use a text_poke-like
> approach.
> 

Not sure which numbers you are asking for. The dynamic function tracer 
modifies all mcount calls, which are done by practically every function in 
the kernel. With a normal Fedora kernel (and all its loaded modules), 
that's between 15 to 20 thousand functions, depending on what modules are 
loaded.

At boot up we convert them all to nops, but when we enable the function 
tracer, we convert them back to calls to the function tracer. This is done 
by a priviledge user, since the function tracer can add quite a bit of 
overhead when activated.

I do not really see how changing this for the short period of time is any 
different than making another mapping point to the kernel code. If you 
could find a way to break this security, you should be able to break it 
with another mapping as well.

Also note that this dynamic tracing code works for not only x86, it also 
works for PPC, ARM, superH and ia64. To use text_poke, that would require 
all of these to have text_poke ported.

How does text_poke solve the issue of executing code on another CPU that 
is changing?

-- Steve

