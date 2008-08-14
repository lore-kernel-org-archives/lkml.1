Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYHNAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYHNAJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYHNAJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:09:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYHNAJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:09:05 -0400
Message-ID: <48A375E3.9090609@zytor.com>
Date: Wed, 13 Aug 2008 17:01:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
References: <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal>
In-Reply-To: <20080813234156.GA25775@Krystal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> If a kernel thread is preempted in single-cpu mode right after the NOP (nop
> about to be turned into a lock prefix), then we CPU hotplug a CPU, and then the
> thread is scheduled back again, a SMP-unsafe atomic operation will be used on
> shared SMP variables, leading to corruption. No corruption would happen in the
> reverse case : going from SMP to UP is ok because we split a bit instruction
> into tiny pieces, which does not present this condition.
> 
> Changing the 0x90 (single-byte nop) currently used into a 0x3E DS segment
> override prefix should fix this issue. Since the default of the atomic
> instructions is to use the DS segment anyway, it should not affect the
> behavior.

I believe this should be okay.  In 32-bit mode some of the security and 
hypervisor frameworks want to set segment limits, but I don't believe 
they ever would set DS and SS inconsistently, or that we'd handle a #GP 
versus an #SS differently (segment violations on the stack segment are 
#SS, not #GP.)  To be 100% sure we'd have to pick apart the modr/m byte 
to figure out what the base register is but I think that's total overkill.

I have a vague notion that DS: prefixes came with a penalty on older 
CPUs, so we may want to do this only when CPU hotplug is enabled, to 
avoid penalizing older embedded systems.

	-hpa
