Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZFOXYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZFOXYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZFOXYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:24:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbZFOXYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:24:36 -0400
Date: Mon, 15 Jun 2009 16:22:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
In-Reply-To: <20090615211209.GA27100@elte.hu>
Message-ID: <alpine.LFD.2.01.0906151617030.6276@localhost.localdomain>
References: <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain>
 <20090615194344.GA12554@elte.hu> <20090615200619.GA10632@Krystal> <20090615204715.GA24554@elte.hu> <20090615210225.GA12919@Krystal> <20090615211209.GA27100@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Ingo Molnar wrote:
> 
> See the numbers in the other mail: about 33 million pagefaults 
> happen in a typical kernel build - that's ~400K/sec - and that is 
> not a particularly really pagefault-heavy workload.

Did you do any function-level profiles?

Last I looked at it, the real cost of page faults were all in the memory 
copies and page clearing, and while it would be nice to speed up the 
kernel entry and exit, the few tens of cycles we might be able to get from 
there really aren't all that important.

38 million page faults may sound like a lot, but put it in other terms: if 
we get rid of 20 cycles for each page fault, that's still not a lot of 
actual time. Lookie here at your own numbers:

       38465628  page-faults          #      0.027 M/sec
  4374762924204  cycles               #   3029.025 M/sec

Now, if we shave 20 cycles off each page fault, that is still just, what, 
0.018% or something? Not really that impressive in the end.

So I'm all for optimizing the kernel entry/exit paths, but ..

		Linus
