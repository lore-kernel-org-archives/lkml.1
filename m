Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYJFRKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYJFRKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYJFRKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:10:34 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:46652 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbYJFRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:10:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsEAJPi6UhMQWq+/2dsb2JhbACBcbppgWo
Date: Mon, 6 Oct 2008 13:10:31 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
	preemption
Message-ID: <20081006171031.GA9345@Krystal>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com> <20081004144423.GA14918@elte.hu> <20081004174121.GA1337@elte.hu> <20081004222713.GA1813@Krystal> <alpine.DEB.1.10.0810041916390.11060@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810041916390.11060@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:56:56 up 123 days, 21:37,  8 users,  load average: 1.11, 0.76,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Sat, 4 Oct 2008, Mathieu Desnoyers wrote:
> > > 
> > > there's a relatively simple method that would solve all these 
> > > impact-size problems.
> > > 
> > > We cannot stop NMIs (and MCEs, etc.), but we can make kernel code 
> > > modifications atomic, by adding the following thin layer ontop of it:
> > > 
> > >    #define MAX_CODE_SIZE 10
> > > 
> > >    int redo_len;
> > >    u8 *redo_vaddr;
> > > 
> > >    u8 redo_buffer[MAX_CODE_SIZE];
> > > 
> > >    atomic_t __read_mostly redo_pending;
> > > 
> > > and use it in do_nmi():
> > > 
> > >    if (unlikely(atomic_read(&redo_pending)))
> > > 	modify_code_redo();
> > > 
> > > i.e. when we modify code, we first fill in the redo_buffer[], redo_vaddr 
> > > and redo_len[], then we set redo_pending flag. Then we modify the kernel 
> > > code, and clear the redo_pending flag.
> > > 
> > > If an NMI (or MCE) handler intervenes, it will notice the pending 
> > > 'transaction' and will copy redo_buffer[] to the (redo_vaddr,len) 
> > > location and will continue.
> > > 
> > > So as far as non-maskable contexts are concerned, kernel code patching 
> > > becomes an atomic operation. do_nmi() has to be marked notrace but 
> > > that's all and easy to maintain.
> > > 
> > > Hm?
> > > 
> > 
> > The comment at the beginning of 
> > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=blob;f=arch/x86/kernel/immediate.c;h=87a25db0efbd8f73d3d575e48541f2a179915da5;hb=b6148ea934f42e730571f41aa5a1a081a93995b5
> 
> Mathieu, please stop pointing to git tree comments (especially those that
> are not in mainline).  If you have an actual technical PDF link, that 
> would be much better.
> 

Hi Steven,

The top 10 lines of the comment the URL points to :

Intel Core 2 Duo Processor for Intel Centrino Duo Processor Technology
Specification Update, AH33

(direct link :
ftp://download.intel.com/design/mobile/SPECUPDT/31407918.pdf)

AH33 -> Page 48

<Quote>
Problem :

The act of one processor, or system bus master, writing data into a
currently executing code segment of a second processor with the intent
of having the second processor execute that data as code is called
cross-modifying code (XMC). XMC that does not force the second processor
to execute a synchronizing instruction, prior to execution of the new
code, is called unsynchronized XMC. Software using unsynchronized XMC to
modify the instruction byte stream of a processor can see unexpected or
unpredictable execution behavior from the processor that is executing
the modified code.
</Quote>

What my patch does is exactly this : it forces the second CPU to issue a
synchronizing instruction (either iret from the breakpoint or cpuid)
before the new instruction is reachable by any CPU. It therefore turns
what would otherwise be an unsynchronized XMC into a synchronized XMC.

And yes patching 20000 sites can be made increadibly fast for the
5-bytes call/nop code-patching case because all the breakpoint handlers
have to do is to increment the return IP of 4 bytes (1 byte for
breakpoint, 4 bytes must be skipped). However, we would have to keep a
hash table of the modified instruction pointers around so the breakpoint
handler can know why the breakpoint happened. After the moment the
breakpoint is removed, given interrupts are disabled in the int3 gate,
this hash table have to be kept around until all the currently running
IRQ handlers have finished their execution.

Mathieu

> > 
> > explains that code modification on x86 SMP systems is not only a matter
> > of atomicity, but also a matter of not changing the code underneath a
> > running CPU which is making assumptions that it won't change underneath
> > without issuing a synchronizing instruction before the new code is used
> > by the CPU. The scheme you propose here takes care of atomicity, but
> > does not take care of the synchronization problem. A sync_core() would
> > probably be required when such modification is detected.
> > 
> > Also, speaking of plain atomicity, you scheme does not seem to protect
> > against NMIs running on a different CPU, because the non-atomic change
> > could race with such NMI.
> 
> Ingo,
> 
> Mathieu is correct in this regard. We do not neet to protect ourselves 
> from NMIs on the CPU that we execute the code on. We need to protect 
> ourselves from NMIs running on other CPUS.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
