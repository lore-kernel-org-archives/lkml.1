Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZCNXU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZCNXU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 19:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZCNXUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 19:20:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:51815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZCNXUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 19:20:08 -0400
Subject: Re: VMI broken on tip/master...
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: akataria@vmware.com
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1236966968.14680.15.camel@alok-dev1>
References: <1236966968.14680.15.camel@alok-dev1>
Content-Type: text/plain
Date: Sun, 15 Mar 2009 00:20:00 +0100
Message-Id: <1237072800.8939.813.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 10:56 -0700, Alok Kataria wrote:
> Hi Peter, 
> 
> I was seeing a early fault when running tip/master with VMI enabled on
> VMware platform. 
> This early fault was in the vmi_patch code where we are applying
> paravirt_alternatives. After some trials i noticed that this is
> reproducible only with CONFIG_TRACING. With that disabled my VM boots
> again. 
> 
> I started a git bisect after that, and git pointed to this as the bad
> commit
> 
> commit 6cc3c6e12bb039047974ad2e7e2d46d15a1b762f
>     trace_clock: fix preemption bug
> 
> I then reverted that commit from tip/master and the system did boot. 
> But I fail to understand how this simple patch would be causing things
> to fail in VMI. Any ideas ?

Looking at arch/x86/include/asm/paravirt.h (god I wish paravirt would go
away, not only does it screw over ctags, it also hurts my brain), it
appears its playing icky games with primitives like
raw_local_irq_disable():

static inline void raw_local_irq_disable(void)
{
        asm volatile(paravirt_alt(PARAVIRT_CALL)
                     :
                     : paravirt_type(pv_irq_ops.irq_disable),
                       paravirt_clobber(CLBR_EAX)
                     : "memory", "eax", "cc");
}

So what was supposed to be a simple op, now gets expanded into god knows
what, and might lead to tracer recursion or something.

Maybe a simple notrace annotation somewhere in that paravirt code is all
it takes, who knows.

Steve, you've been known to work on virt stuff too, happen to have a
bright idea? :-)

