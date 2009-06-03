Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbZFCQLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbZFCQLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZFCQLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:11:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825AbZFCQLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:11:03 -0400
Date: Wed, 3 Jun 2009 09:09:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <200906032208.28061.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <20090528061702.GB6920@wotan.suse.de> <20090530102330.GC16913@elte.hu> <200906032208.28061.rusty@rustcorp.com.au>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Rusty Russell wrote:
> 
> I took my standard config, and turned on AUDIT, CGROUP, all the sched options, 
> all the namespace options, profiling, markers, kprobes, relocatable kernel, 
> 1000Hz, preempt, support for every x86 variant (ie. PAE, NUMA, HIGHMEM64, 
> DISCONTIGMEM).  I turned off kernel debugging and paravirt.  Booted with 
> maxcpus=1.

Turn off HIGHMEM64G, please (and HIGHMEM4G too, for that matter - you 
can't compare it to a no-highmem case).

It's one of those options that we do to support crazy hardware, and it is 
EXTREMELY expensive (but mainly only if you actually have the hardware, ie 
you actually have more than 1GB of RAM for HIGHMEM4G - HIGHMEM64G is 
always expensive for forks, but nobody sane ever enables it).

IOW, it's not at all comparable to the other options. It's not a software 
option, it's a real hardware option that hits you not depending on whether 
you want some sw capability, but on whether you want to use memory.

Because depending on the CPU, some loads will have 25% of time spent in 
just kmap/kunmap due to TLB flushes. Yes, really. There's a reason 32-bit 
kernels are shit for 1GB+ memory.

After you've turned off HIGHMEM (or run on a sane architecture like x86-64 
that doesn't need it), re-run the benchmark, because it's interesting. But 
with HIGHMEM being different, your benchmark is totally invalid and 
pointless.

		Linus
