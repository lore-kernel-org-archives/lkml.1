Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbXEMQVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbXEMQVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbXEMQVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:21:01 -0400
Received: from tomts1.bellnexxia.net ([209.226.175.113]:36938 "EHLO
	tomts1-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbXEMQVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:21:00 -0400
Date: Sun, 13 May 2007 11:20:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@muc.de>, systemtap@sources.redhat.com, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070513152019.GA25236@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.508519573@polymtl.ca> <20070510090656.GA57297@muc.de> <20070510155501.GI22424@Krystal> <20070510172843.7aa72237@the-village.bc.nu> <20070510165918.GK22424@Krystal> <20070511060444.GA35262@muc.de> <20070511180207.GA25516@Krystal> <20070511225645.1e256ea5@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070511225645.1e256ea5@the-village.bc.nu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 10:44:03 up 100 days,  4:51,  4 users,  load average: 2.10, 2.16, 2.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > The IPI might be fast, but I have seen interrupts being disabled for
> > quite a long time in some kernel code paths. Having interrupts disabled
> > on _each cpu_ while running an IPI handler waiting to be synchronized
> > with other CPUs has this side-effect. Therefore, if I understand well,
> 
> This can already occur worst case when we spin on an IPI (eg a cross CPU
> TLB shootdown)
> 

Hrm, maybe am I understanding something incorrectly there :

arch/i386/kernel/smp.c: native_flush_tlb_others() takes a spinlock, but
does not disable interrupts, while spinning waiting for other CPUs.
smp_invalidate_interrupt(), in the same file, does not spin waiting for
other CPUs. Therefore, I understand that none of these functions spin
with interrupts disabled, so this TLB flush does not show the same
behavior.


> If the INT3 is acknowledged as safe by intel either as is or by some
> specific usage like lock mov then great. If not it isn't too bad a
> problem.
> 

Another mail in this thread explains that the main issue is not the
atomicity of the code modification operation (although it must be atomic
for the CPU to see a correct instruction), but to the fact that the CPU
expects the pre-fetched instruction and the executed instruction to be
the same, except for the int3 case.

> And to be real about this - how many benchmarks do you know that care
> about mega-kernel-debugs per second ?

For users with real-time needs, the overall IRQ latency of the system
gives an upper-bound to  what can be executed by the application in a
given time-frame. People doing audio/video acquisition should be quite
interested in this metric.

So this is mostly a matter of how this action (enabling a marker) can
influence the overall system's latency. One of my goals is to provide
tracing in the Linux kernel with minimal performance and behavioral
impact on the system so it does not make the system flakyer than normal
and can be activated on a bogus system and still reproduce the original
problem.


Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
