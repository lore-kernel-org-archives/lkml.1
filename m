Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYJBNQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYJBNQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYJBNQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:16:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbYJBNQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:16:21 -0400
Date: Thu, 2 Oct 2008 09:16:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [boot crash] Re: [PATCH] ring-buffer: fix build error
In-Reply-To: <20081002093835.GA17699@elte.hu>
Message-ID: <alpine.DEB.1.10.0810020910040.19018@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
 <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Oct 2008, Ingo Molnar wrote:
> [    0.332002] Kernel panic - not syncing: Fatal exception
> 
> full serial log and config attached. I'm excluding these latest commits 
> from tip/master for now:

Thanks I'll take a look at this.

> 
>  339ce9a: ring-buffer: fix build error
>  b6eeea4: ftrace: preempt disable over interrupt disable

The above "preempt disable" is the most likely culprit.  I'm trying to get 
towards an interrupt disabled free and lockless code path. But in doing 
so, one must be extra careful. This is why I'm taking baby steps towards 
this approach. Any little error in one of these steps, and you have race 
conditions biting you.

The above replaces interrupt disables with preempt disables, uses the
atomic data disable to protect against reentrancy. But this could also 
have opened up a bug that was not present with the interrupts disabled 
version.


>  52abc82: ring_buffer: allocate buffer page pointer
>  da78331: ftrace: type cast filter+verifier

> 
> i'm quite sure 52abc82 causes this problem.

Hmm, that was a trivial patch. Perhaps the trivial ones are the ones that 
are most likely to be error prone. A developer will take much more care in 
developing a patch that is complex than something he sees as trivial ;-)

-- Steve

> 
> Another 64-bit testbox crashed too meanwhile.
> 
> 	Ingo
> 
