Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbZCPQEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbZCPQEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZCPQEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:04:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53721 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbZCPQEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:04:14 -0400
Date: Mon, 16 Mar 2009 12:04:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: akataria@vmware.com, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMI broken on tip/master...
In-Reply-To: <1237072800.8939.813.camel@laptop>
Message-ID: <alpine.DEB.2.00.0903161200320.26431@gandalf.stny.rr.com>
References: <1236966968.14680.15.camel@alok-dev1> <1237072800.8939.813.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 15 Mar 2009, Peter Zijlstra wrote:
> 
> Looking at arch/x86/include/asm/paravirt.h (god I wish paravirt would go
> away, not only does it screw over ctags, it also hurts my brain), it
> appears its playing icky games with primitives like
> raw_local_irq_disable():
> 
> static inline void raw_local_irq_disable(void)
> {
>         asm volatile(paravirt_alt(PARAVIRT_CALL)
>                      :
>                      : paravirt_type(pv_irq_ops.irq_disable),
>                        paravirt_clobber(CLBR_EAX)
>                      : "memory", "eax", "cc");
> }
> 
> So what was supposed to be a simple op, now gets expanded into god knows
> what, and might lead to tracer recursion or something.

It should only blow up if a guest is using tracing, and the code to call
the hypervisor is also being traced.

> 
> Maybe a simple notrace annotation somewhere in that paravirt code is all
> it takes, who knows.
> 
> Steve, you've been known to work on virt stuff too, happen to have a
> bright idea? :-)

I have noticed that some paravirt ops calls (like this 
raw_local_irq_disable) does not get inlined. It sometimes gets made into a 
function.  This would cause raw_local_irq_disable to actually be traced!

One answer is to use "always_inline" or I can dig out a patch that makes 
inline also include "notrace".

-- Steve

