Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbYDYXFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbYDYXFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYDYXFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:05:33 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:64605 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754988AbYDYXFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:05:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAD8AEkhMROPA/2dsb2JhbACBU6p5
Date: Fri, 25 Apr 2008 19:00:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, systemtap@sources.redhat.com
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080425230028.GC31226@Krystal>
References: <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:34:20 up 56 days, 18:45,  7 users,  load average: 0.52, 0.68,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Fri, 25 Apr 2008, Mathieu Desnoyers wrote:
> > 
> > The point is to provide a way to dynamically enable code at runtime
> > without noticeable performance impact on the system.
> 
> Quite frankly, maybe I'm a bit dense, but why don't you just recompile the 
> whole original function (at run-time), load that new version of a function 
> as a mini-module, and then insert a marker at the top of the old function 
> that just does a "jmp replacementfunction".
> 
> That has _zero_ cost for the non-marker case, and allows you to do pretty 
> much any arbitrary code changes for the marker case.
> 
> It's also a much simpler replacement.
> 

This idea has been considered a few years ago at OLS in the tracing BOF
if I remember well.  The results were this : First, there is no way to
guarantee that no code path, nor any return address from any function,
interrupt, sleeping thread, will return to the "old" version of the
function. Nor is it possible to determine when a quiescent state is
reached. Therefore, we couldn't see how we can do the teardown.

The second point is dependency between execution flow and variables. If
we don't do a complete copy of the variables (which I don't see how we
can do atomically), we will have to share the variables between the old
and the new copies of the functions. However, some variables might
encode information about the execution flow of the program and depend on
the actual address at which the code is linked (function pointers for
instance). Stuff like "goto *addr" would also break.


> Yeah, that "jmp replacementfunction" is five or more bytes, but you can 
> trivially do the actual _replacement_ write by writing it first as a 
> single-byte debug trap, and after that has been written, write the target 
> address after it, and then write the first byte of the "jmp" instruction 
> last. In the (very unlikely) case that another CPU hits that debug trap, 
> you just fix it up in the debug handler - you only need a single datum of 
> "this is where that debug trap should relocate", because you simply create 
> a triial spinlock around the code-sequence that does the instruction 
> rewrite.
> 

That's actually what I do in my immediate values implementation.

> When undoing it, just do the same thing in reverse.
> 
> Yeah, this requires you to basically recompile some function snippet when 
> you insert a probe, but if that scares people, you could basically do it 
> using the old code and inserting the markers and "relinking" it - avoiding 
> the C compiler, and just basically have an "assembly recompiler".
> 
> And yeah, maybe you want to do without the use of modules, and you'd just 
> have a memory area that is kept free for these kinds of code replacement 
> issues. And you can optimize it to not recompile the whole function, but 
> do it on a finer granularity if you want.
> 

Then dealing with multiple code patching infrastructures (kprobes,
alternatives, paravirt) would become hellish. If a kprobe is planted in
the original version of the function, we have to insert it in the new
version... and the teardown of the old function is still a problem.

> And sure, you want to really make sure that there is security in place so 
> that this isn't used for rootkits, but isn't that true of pretty much 
> *any* trace facility?
> 

Yep.

The discussion I refer to took place at OLS a few years ago. Other
participants might remember some other details I forgot.

Mathieu

> 			Linus

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
