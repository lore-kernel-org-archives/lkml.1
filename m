Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbXGJIBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbXGJIBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbXGJIBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:01:35 -0400
Received: from ozlabs.org ([203.10.76.45]:56580 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbXGJIBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:01:34 -0400
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <469332F3.1000808@qumranet.com>
References: <11838994974161-git-send-email-avi@qumranet.com>
	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>
	 <20070708134850.GB22911@elte.hu>
	 <1183937563.6005.365.camel@localhost.localdomain>
	 <4691D82F.3030401@qumranet.com>
	 <1184029745.6005.402.camel@localhost.localdomain>
	 <46931ECB.2060601@qumranet.com>
	 <1184050055.6005.523.camel@localhost.localdomain>
	 <469332F3.1000808@qumranet.com>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 18:01:18 +1000
Message-Id: <1184054478.6005.555.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 10:19 +0300, Avi Kivity wrote:
> Rusty Russell wrote:
> > Exactly, if we have two at the same time, they need to know about each
> > other.  Providing infrastructure which lets them avoid thinking about it
> > is the wrong direction.
> >   
> 
> With a kvm-specific hook, they can't stop on each other (there can only 
> be one).
> With a list, they don't stomp on each other.
> With a struct preempt_ops but no list, as you propose, they can and will 
> stomp on each other.

I'm not talking about the actual overwriting of someone else's hook.
I'm talking about semantic conflicts involving the actual CPU state.

If I'm lazily restoring some CPU state because I know I don't use it,
and you're lazily restoring some CPU state because you don't use it, we
need to make sure that state doesn't intersect: ie. we need to be aware
of each other.  Only providing a single hook per task forces the second
user to think about it (maybe that lazy state saving needs to be
extracted into common code).

> I guess I can put it in arch specific code, but that means both i386 and 
> x86_64.
> 
> Once we have another user we can try to generalize it.

The problem is that the arch hooks are in the wrong place: 

> > Which brings us to the question: why do you want interrupts enabled?
> 
> The sched in hook (vcpu_load) sometimes needs to issue an IPI in order 
> to flush the VT registers from another cpu into memory.

OK, I'll have to go away and read the code for this.

BTW, I have no problem with #ifdef KVM-style code in arch-specifics.
It's kernel/sched.c which is jarring...

Thanks,
Rusty.

