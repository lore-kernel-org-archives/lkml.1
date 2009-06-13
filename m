Return-Path: <linux-kernel-owner+w=401wt.eu-S1761836AbZFMWep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836AbZFMWep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZFMWei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:34:38 -0400
Received: from www.tglx.de ([62.245.132.106]:41440 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbZFMWeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:34:37 -0400
Date: Sun, 14 Jun 2009 00:27:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC][GIT PULL][PATCH 0/10 -tip] cpu_debug patches 20090613
In-Reply-To: <1244910436.11733.14.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0906132056540.2800@localhost.localdomain>
References: <1244910436.11733.14.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009, Jaswinder Singh Rajput wrote:

> Please let me know how we can improve it and add more features so it
> becomes more useful.

I really have to ask, why this is useful at all.

> 1. Standard Registers

What's the point of printing task_pt_regs(current) ? 

We dump info of "cat debug/.../tss". Where is the value of this ? Just
because we can ?

> 2. Control Registers

I can see some value in dumping CR0 and CR4, but the rest is pretty useless

CR2 is the pagefault address, which is uninteresting as there is no
context

CR3 is the pagedir, which is pretty uninteresting as well. If we
read it on the current CPU we read the pagedir of "cat ..../cr3" and
if we read it on some other CPU its completely out of context. We
see a pagedir entry and have no information about the context.

CR8 is unused in Linux and always 0

> 3. Debug Registers

Again, where is the point? These registers are only interesting when
we know about the context. This interface just provides the access to
random information.

We already have debuggers which use that and they know the context
they are operating in.

> 4. Descriptor Tables

What's the value of pointers to IDT, GDT tables ? The interesting
information is in the tables, where IDT is static and uninteresting
though GDT table contents can change

Again, LDT and TR are task context dependent values. Where is the
information at which context we are looking ?

> 5. APIC Registers

Dunno, what we gain from that information.

> 6. Model specific Register (MSRs)

Where is the difference of poking in

/sys/kernel/debug/x86/cpu/cpu0/msr/MSR_c0010006/value

and

rdmsr,wrmsr poking on the same MSR ?

There is no difference at all. The information difference is
_ZERO_. The only difference is memory consumption in the kernel and a
even more horrible user interface than we have with mrs-tools.

7. PCI configuration registers (for AMD)

What's the value add over lspci ?

> 8. Basic cpuinfo

Why do we need another incarnation of /proc/cpuinfo ? 

Also cpuid provides more useful decoded information than this.

> 9. CPUID Functions

Again, cpuid can do this already w/o a single line of kernel code.


Can we please get some coherent explanation why we need this in the
kernel? 

Granted there are about 4 interesting registers where we have no
interface yet and where user space tools can not look into, but 99% of
the information exposed by this module is either useless or redundant
or both.

The worst stuff is the reinvention of exising and _useful_ userspace
tools. Just one example:

AMD specific PCI registers

   Current solution:

   Ask user to run lscpi -vvv and lspci -xxx[x] and provide the
   output, which is for -vvv very well decoded and for -xxxx the same
   raw data as we get from cpu_debug (except for the line count)

   Single point of failure: lspci is not installed, which is unlikely,
   but easy to solve and users/bugreporters usually know how to do
   that. Worst case you have to tell him how to do it.

   cpu_debug solution:

   Ask user to compile the module, load the module, mount debugfs and
   provide the output of debug/..... The output is a HEX dump of the
   PCI configuration space and has no more information than the lscpi
   -xxxx dump, indeed it has less:

   lspci -xxxx tells me at which device it is looking in clear text
   with a useful description while this tells me:

   PCI configuration regsiters :
   function : 0
   000  : 13001022
   
   So i need to look at the code to see at which pci config space this
   is looking and what "function 0" is all about. How useful.

   Multiple points of failure:
   	    user can not compile the module
	    user fails to load the module
	    user fails to mount debugfs

Same applies for cpuid and msr access. This cpu_debug stuff is harder
to use and provides the same of mostly less information. What's the
gain ?
 

I'm a full supporter of _useful_ debug interfaces, but this is
definitely not what I call useful and useable.

The reinvention of useful tools like lspci, cpuid, rdmsr, wrmsr inside
of the kernel with a worse user interface and less information
provided is just a waste of time and resources.

Dumping random information out of any context is not helping us to
debug problems. There is no value to look at debug registers, context
registers and tss->regs without the context of the task we look at.

Can we please stop adding more random features to this?

This needs to be done the other way round. First we need to remove all
redundant and useless interfaces from cpu_debug and then think
carefully about in which way we want to expose the few really missing
interesting things either by extending existing user space tools or by
providing context aware and debug relevant interfaces in the kernel.

Thanks,

	tglx
