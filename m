Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZFCMin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZFCMin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbZFCMif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:38:35 -0400
Received: from ozlabs.org ([203.10.76.45]:35248 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbZFCMie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:38:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Date: Wed, 3 Jun 2009 22:08:25 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Nick Piggin <npiggin@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <4A0B62F7.5030802@goop.org> <20090528061702.GB6920@wotan.suse.de> <20090530102330.GC16913@elte.hu>
In-Reply-To: <20090530102330.GC16913@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906032208.28061.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 07:53:30 pm Ingo Molnar wrote:
> Not so with CONFIG_PARAVIRT. That feature is almost fully parasitic
> to native environments: currently it brings no advantage on native
> hardware _at all_ (and 95% of the users dont care about Xen).

And VMI, and of course lguest.  And a little bit of KVM, though not the paths 
you're talking about.

Your complaints are a little unfocussed: anything Xen could do to make this 
overhead go away, we would be able to do ourselves.  Yet it's not clear where 
this 1% is going.  We're more aggressive with our patching right now than any 
other subsystem; which call is the problem?

But your entire rant is willfully ignorant; if you've only just discovered 
that all commonly enabled config options have a cost when unused, I am shocked.

I took my standard config, and turned on AUDIT, CGROUP, all the sched options, 
all the namespace options, profiling, markers, kprobes, relocatable kernel, 
1000Hz, preempt, support for every x86 variant (ie. PAE, NUMA, HIGHMEM64, 
DISCONTIGMEM).  I turned off kernel debugging and paravirt.  Booted with 
maxcpus=1.

I created another with SMP=n, and all that turned off.  No highmem. 100Hz.

Then I ran virtbench which I had lying around, in local mode (ie. between 
processes running locally, rather than between guest OSes)

Distro-style maximal config:
Time for one context switch via pipe: 2285 (2276 - 2290)
Time for one Copy-on-Write fault: 3415 (3264 - 4266)
Time to exec client once: 234656 (232906 - 253343)
Time for one fork/exit/wait: 82656 (82031 - 83218)
Time for gettimeofday(): 253 (253 - 254)
Time to send 4 MB from host: 6911750 (6901000 - 6925500)
Time for one int-0x80 syscall: 284 (284 - 369)
Time for one syscall via libc: 139 (139 - 140)
Time to walk linear 64 MB: 760375 (754750 - 868125)
Time to walk random 64 MB: 955500 (947250 - 990000)
Time for two PTE updates: 3173 (3143 - 3196)
Time to read from disk (256 kB): 2395000 (2319000 - 2434500)
Time for one disk read: 114156 (112906 - 114562)
Time to send 4 MB between guests: 7639000 (7568250 - 7739750)
Time for inter-guest pingpong: 13900 (13800 - 13931)
Time to sendfile 4 MB between guests: 7187000 (7129000 - 46349000)
Time to receive 1000 1k UDPs between guests: 6576000 (6500000 - 7232000)

Custom-style minimal config:
Time for one context switch via pipe: 1351 (1333 - 1405)
Time for one Copy-on-Write fault: 2754 (2610 - 3586)
Time to exec client once: 190625 (189812 - 207500)
Time for one fork/exit/wait: 60968 (60875 - 61218)
Time for gettimeofday(): 248 (248 - 249)
Time to send 4 MB from host: 6643250 (6583750 - 6880750)
Time for one int-0x80 syscall: 280 (280 - 334)
Time for one syscall via libc: 133 (133 - 144)
Time to walk linear 64 MB: 758750 (752375 - 835000)
Time to walk random 64 MB: 943500 (934500 - 1084000)
Time for two PTE updates: 1917 (1900 - 2401)
Time to read from disk (256 kB): 2390500 (2309000 - 2536000)
Time for one disk read: 113250 (112937 - 113875)
Time to send 4 MB between guests: 7830500 (7740500 - 7946000)
Time for inter-guest pingpong: 12566 (11621 - 13652)
Time to sendfile 4 MB between guests: 6533000 (5961000 - 76365000)
Time to receive 1000 1k UDPs between guests: 5278000 (5194000 - 5431000)

Average slowdown: 15%
Worst: context switch, 69% slowdown.
Best: 4MB inter-process. 2% speedup (maybe due to more mem, 4G machine)

So in fact CONFIG_PARAVIRT's 1% makes it a paragon.

We should be praising Jeremy for his efforts and asking him to look at some of 
these others!

Sorry for the facts,
Rusty.
