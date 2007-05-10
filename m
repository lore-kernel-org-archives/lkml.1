Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbXEJQ7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbXEJQ7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760476AbXEJQ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:59:22 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:61476 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756164AbXEJQ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:59:19 -0400
Date: Thu, 10 May 2007 12:59:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@muc.de>, systemtap@sources.redhat.com, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070510165918.GK22424@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.508519573@polymtl.ca> <20070510090656.GA57297@muc.de> <20070510155501.GI22424@Krystal> <20070510172843.7aa72237@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070510172843.7aa72237@the-village.bc.nu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 12:40:38 up 97 days,  6:47,  4 users,  load average: 2.68, 2.43, 2.27
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > * First issue : Impact on the system. If we try to make this system
> >   scale, we will create very long irq disable sections. The expected
> >   duration is the worse case IPI latency plus the time it takes to CPU A
> >   to change the variable. We therefore directly grow the worse case
> >   system's interrupt latency.
> 
> Not a huge problem. It doesn't scale in really horrible ways and the IPI
> latency on a PIV or later is actually very good. Also the impact is less
> than you might think as on huge huge boxes you want multiple copies of
> the kernel text pages to reduce NUMA traffic, so you only have to sync
> the group of processors involved 
> 
> > * Second issue : irq disabling does not protect us from NMI and traps.
> >   We cannot use this algorithm to mark these code segments.
> 
> If you synchronize all the other processors and disable local interrupts
> then the only traps you have to worry about are those you cause, and the
> only person taking the trap will be you so you're ok.
> 
> NMI is hard but NMI is a special case not worth solving IMHO.
> 

Not caring about NMIs may have more impact than one could expect. You
have to be aware that (at least) the following code is executed in NMI
context. Trying to patch any of these functions could result in a dying
CPU :

default_do_nmi
  notify_die
  nmi_watchdog_tick
    printk
    die_nmi (should cause a OOPS, not kill the cpu..)
  do_nmi_callback
    unknown_nmi_panic_callback
      sprintf
  unknown_nmi_error
    panic
  reassert_nmi

In entry.S, there is also a call to local_irq_enable(), which falls into
lockdep code.

Tracing those core kernel functions is a fundamental need of crash
tracing. So, in my point of view, it is not "just" about tracing NMIs,
but it's about tracing code that can be touched by NMIs.

> > * Third issue : Scalability. Changing code will stop every CPU on the
> >   system for a while. Compared to this, the int3-based approach will run
> >   through the breakpoint handler "if" one of the CPU happens to execute
> >   this code at the wrong time. The standard case is just an IPI (to
> 
> If I read the errata right then patching in an int3 will itself trigger
> the errata so anything could happen.
> 
> I believe there are other safe sequences for doing code patching - perhaps
> one of the Intel folk can advise ?
> 

I'll let the Intel guys confirm this, I don't have the reference nearby
(I got this information by talking with the kprobe team members, and
they got this information directly from Intel developers) but the
int3 is the one special case to which the errata does not apply.
Otherwise, kprobes and gdb would have a big, big issue.

Mathieu


> Alan

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
