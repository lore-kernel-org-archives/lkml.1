Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYJDW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYJDW1X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYJDW1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:27:15 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:41678 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbYJDW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:27:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAEyH50hMQWq+/2dsb2JhbACBcbcagWg
Date: Sat, 4 Oct 2008 18:27:13 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
	preemption
Message-ID: <20081004222713.GA1813@Krystal>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com> <20081004144423.GA14918@elte.hu> <20081004174121.GA1337@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081004174121.GA1337@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:20:34 up 122 days,  3:00,  8 users,  load average: 0.22, 0.29,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > The dynamic function tracer is another issue. The problem with NMIs 
> > > has nothing to do with locking, or corrupting the buffers. It has to 
> > > do with the dynamic code modification.  Whenever we modify code, we 
> > > must guarantee that it will not be executed on another CPU.
> > > 
> > > Kstop_machine serves this purpose rather well. We can modify code 
> > > without worrying it will be executed on another CPU, except for NMIs. 
> > > The problem now comes where an NMI can come in and execute the code 
> > > being modified. That's why I put in all the notrace, lines. But it 
> > > gets difficult because of nmi_notifier can call all over the kernel.  
> > > Perhaps, we can simply disable the nmi-notifier when we are doing the 
> > > kstop_machine call?
> > 
> > that would definitely be one way to reduce the cross section, but not 
> > enough i'm afraid. For example in the nmi_watchdog=2 case we call into 
> > various lapic functions and paravirt lapic handlers which makes it all 
> > spread to 3-4 paravirtualization flavors ...
> > 
> > sched_clock()'s notrace aspects were pretty manageable, but this in 
> > its current form is not.
> 
> there's a relatively simple method that would solve all these 
> impact-size problems.
> 
> We cannot stop NMIs (and MCEs, etc.), but we can make kernel code 
> modifications atomic, by adding the following thin layer ontop of it:
> 
>    #define MAX_CODE_SIZE 10
> 
>    int redo_len;
>    u8 *redo_vaddr;
> 
>    u8 redo_buffer[MAX_CODE_SIZE];
> 
>    atomic_t __read_mostly redo_pending;
> 
> and use it in do_nmi():
> 
>    if (unlikely(atomic_read(&redo_pending)))
> 	modify_code_redo();
> 
> i.e. when we modify code, we first fill in the redo_buffer[], redo_vaddr 
> and redo_len[], then we set redo_pending flag. Then we modify the kernel 
> code, and clear the redo_pending flag.
> 
> If an NMI (or MCE) handler intervenes, it will notice the pending 
> 'transaction' and will copy redo_buffer[] to the (redo_vaddr,len) 
> location and will continue.
> 
> So as far as non-maskable contexts are concerned, kernel code patching 
> becomes an atomic operation. do_nmi() has to be marked notrace but 
> that's all and easy to maintain.
> 
> Hm?
> 

The comment at the beginning of 
http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=blob;f=arch/x86/kernel/immediate.c;h=87a25db0efbd8f73d3d575e48541f2a179915da5;hb=b6148ea934f42e730571f41aa5a1a081a93995b5

explains that code modification on x86 SMP systems is not only a matter
of atomicity, but also a matter of not changing the code underneath a
running CPU which is making assumptions that it won't change underneath
without issuing a synchronizing instruction before the new code is used
by the CPU. The scheme you propose here takes care of atomicity, but
does not take care of the synchronization problem. A sync_core() would
probably be required when such modification is detected.

Also, speaking of plain atomicity, you scheme does not seem to protect
against NMIs running on a different CPU, because the non-atomic change
could race with such NMI.

Mathieu

> 	Ingo
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
