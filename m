Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYJDXVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYJDXVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 19:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYJDXVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 19:21:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48003 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbYJDXVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 19:21:05 -0400
Date: Sat, 4 Oct 2008 19:21:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
 preemption
In-Reply-To: <20081004222713.GA1813@Krystal>
Message-ID: <alpine.DEB.1.10.0810041916390.11060@gandalf.stny.rr.com>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com> <20081004144423.GA14918@elte.hu> <20081004174121.GA1337@elte.hu> <20081004222713.GA1813@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 4 Oct 2008, Mathieu Desnoyers wrote:
> > 
> > there's a relatively simple method that would solve all these 
> > impact-size problems.
> > 
> > We cannot stop NMIs (and MCEs, etc.), but we can make kernel code 
> > modifications atomic, by adding the following thin layer ontop of it:
> > 
> >    #define MAX_CODE_SIZE 10
> > 
> >    int redo_len;
> >    u8 *redo_vaddr;
> > 
> >    u8 redo_buffer[MAX_CODE_SIZE];
> > 
> >    atomic_t __read_mostly redo_pending;
> > 
> > and use it in do_nmi():
> > 
> >    if (unlikely(atomic_read(&redo_pending)))
> > 	modify_code_redo();
> > 
> > i.e. when we modify code, we first fill in the redo_buffer[], redo_vaddr 
> > and redo_len[], then we set redo_pending flag. Then we modify the kernel 
> > code, and clear the redo_pending flag.
> > 
> > If an NMI (or MCE) handler intervenes, it will notice the pending 
> > 'transaction' and will copy redo_buffer[] to the (redo_vaddr,len) 
> > location and will continue.
> > 
> > So as far as non-maskable contexts are concerned, kernel code patching 
> > becomes an atomic operation. do_nmi() has to be marked notrace but 
> > that's all and easy to maintain.
> > 
> > Hm?
> > 
> 
> The comment at the beginning of 
> http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=blob;f=arch/x86/kernel/immediate.c;h=87a25db0efbd8f73d3d575e48541f2a179915da5;hb=b6148ea934f42e730571f41aa5a1a081a93995b5

Mathieu, please stop pointing to git tree comments (especially those that
are not in mainline).  If you have an actual technical PDF link, that 
would be much better.

> 
> explains that code modification on x86 SMP systems is not only a matter
> of atomicity, but also a matter of not changing the code underneath a
> running CPU which is making assumptions that it won't change underneath
> without issuing a synchronizing instruction before the new code is used
> by the CPU. The scheme you propose here takes care of atomicity, but
> does not take care of the synchronization problem. A sync_core() would
> probably be required when such modification is detected.
> 
> Also, speaking of plain atomicity, you scheme does not seem to protect
> against NMIs running on a different CPU, because the non-atomic change
> could race with such NMI.

Ingo,

Mathieu is correct in this regard. We do not neet to protect ourselves 
from NMIs on the CPU that we execute the code on. We need to protect 
ourselves from NMIs running on other CPUS.

-- Steve

