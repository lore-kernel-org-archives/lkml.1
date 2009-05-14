Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbZENBLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbZENBLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 21:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZENBLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 21:11:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZENBLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 21:11:10 -0400
Message-ID: <4A0B6F9C.4060405@zytor.com>
Date: Wed, 13 May 2009 18:10:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "Li, Xin" <xin.li@intel.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org>
In-Reply-To: <4A0B62F7.5030802@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> So, what's the fix?
> 
> Paravirt patching turns all the pvops calls into direct calls, so
> _spin_lock etc do end up having direct calls.  For example, the compiler
> generated code for paravirtualized _spin_lock is:
> 
> <_spin_lock+0>:		mov    %gs:0xb4c8,%rax
> <_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
> <_spin_lock+15>:	callq  *0xffffffff805a5b30
> <_spin_lock+22>:	retq
> 
> The indirect call will get patched to:
> <_spin_lock+0>:		mov    %gs:0xb4c8,%rax
> <_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
> <_spin_lock+15>:	callq <__ticket_spin_lock>
> <_spin_lock+20>:	nop; nop		/* or whatever 2-byte nop */
> <_spin_lock+22>:	retq
> 
> One possibility is to inline _spin_lock, etc, when building an
> optimised kernel (ie, when there's no spinlock/preempt
> instrumentation/debugging enabled).  That will remove the outer
> call/return pair, returning the instruction stream to a single
> call/return, which will presumably execute the same as the non-pvops
> case.  The downsides arel 1) it will replicate the
> preempt_disable/enable code at eack lock/unlock callsite; this code is
> fairly small, but not nothing; and 2) the spinlock definitions are
> already a very heavily tangled mass of #ifdefs and other preprocessor
> magic, and making any changes will be non-trivial.
> 

The other obvious option, it would seem to me, would be to eliminate the
*inner* call/return pair, i.e. merging the _spin_lock setup code in with
the internals of each available implementation (in the case above,
__ticket_spin_lock).  This is effectively what happens on native.  The
one problem with that is that every callsite now becomes a patching target.

That brings me to a somewhat half-arsed thought I have been walking
around with for a while.

Consider a paravirt -- or for that matter any other call which is
runtime-static; this isn't just limited to paravirt -- function which
looks to the C compiler just like any other external function -- no
indirection.  We can point it by default to a function which is really
just an indirect jump to the appropriate handler, that handles the
prepatching case.  However, a linktime pass over vmlinux.o can find all
the points where this function is called, and turn it into a list of
patch sites(*).  The advantages are:

1. [minor] no additional nop padding due to indirect function calls.
2. [major] no need for a ton of wrapper macros manifest in the code.

paravirt_ops that turn into pure inline code in the native case is
obviously another ball of wax entirely; there inline assembly wrappers
are simply unavoidable.

	-hpa

(*) if patching code on SMP was cheaper, we could actually do this
lazily, and wouldn't have to store a list of patch sites.  I don't feel
brave enough to go down that route.

