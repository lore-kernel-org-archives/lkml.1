Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbYHNQRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbYHNQRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYHNQQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:16:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbYHNQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:16:54 -0400
Date: Thu, 14 Aug 2008 09:10:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
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
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with
 preemptible kernel and CPU hotplug
In-Reply-To: <20080814151805.GA29507@Krystal>
Message-ID: <alpine.LFD.1.10.0808140901390.3324@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal>
 <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Aug 2008, Mathieu Desnoyers wrote:
> 
> I can't argue about the benefit of using VM CPU pinning to manage
> resources because I don't use it myself, but I ran some tests out of
> curiosity to find if uncontended locks were that cheap, and it turns out
> they aren't.

Absolutely. 

Locked ops show up not just in microbenchmarks looping over the 
instruction, they show up in "real" benchmarks too. We added a single 
locked instruction (maybe it was two) to the page fault handling code some 
time ago, and the reason I noticed it was that it actually made the page 
fault cost visibly more expensive in lmbench. That was a _single_ 
instruction in the hot path (or maybe two).

And the page fault path is some of the most timing critical in the whole 
kernel - if you have everything cached, the cost of doing the page faults 
to populate new processes for some fork/exec-heavy workload (and compiling 
the kernel is just one of those - any traditional unix behaviour will show 
this) is critical.

This is one of the things AMD does a _lot_ better than Intel. Intel tends 
to have a 30-50 cycle cost (with later P4s being *much* worse), while AMD 
tends to have a cost of around 10-15 cycles.

It's one of the things Intel promises to have improved in the next-gen 
uarch (Nehalem), an while I am not supposed to give out any benchmarks, I 
can confirm that Intel is getting much better at it. But it's going to be 
visible still, and it's really a _big_ issue on P4.

(Of course, on P4, the page fault exception cost itself is so high that 
the cost of atomics may be _relatively_ less noticeable in that particular 
path)

		Linus
