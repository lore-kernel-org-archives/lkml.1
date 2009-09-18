Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZIRPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZIRPjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZIRPjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:39:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbZIRPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:39:23 -0400
Date: Fri, 18 Sep 2009 08:38:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at (null), last sysfs file:
 /sys/devices/pci0000:00/0000:00:01.0/local_cpus
In-Reply-To: <20090918075952.GA29026@elte.hu>
Message-ID: <alpine.LFD.2.01.0909180755530.4950@localhost.localdomain>
References: <20090915132105.2fdd1d45@jbarnes-g45> <20090917173012.GA11155@elte.hu> <20090917103614.6ab1385f@jbarnes-g45> <20090917175944.GA17304@elte.hu> <20090917114614.35aeb6b8@jbarnes-g45> <20090918075952.GA29026@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, Ingo Molnar wrote:
> 
> [  158.058140] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
> [  159.370562] BUG: unable to handle kernel NULL pointer dereference at (null)
> [  159.372694] IP: [<ffffffff8143b722>] bitmap_scnprintf+0x72/0xd0

Hmm. The code is

   a:	49 63 fc             	movslq %r12d,%rdi
   d:	0f 49 d3             	cmovns %ebx,%edx
  10:	c1 f8 1f             	sar    $0x1f,%eax
  13:	4c 01 ff             	add    %r15,%rdi
  16:	c1 e8 1a             	shr    $0x1a,%eax
  19:	c1 fa 06             	sar    $0x6,%edx
  1c:	41 c1 e8 02          	shr    $0x2,%r8d
  20:	8d 0c 03             	lea    (%rbx,%rax,1),%ecx
  23:	48 63 d2             	movslq %edx,%rdx
  26:	83 e1 3f             	and    $0x3f,%ecx
  29:	29 c1                	sub    %eax,%ecx
  2b:*	49 8b 44 d5 00       	mov    0x0(%r13,%rdx,8),%rax     <-- trapping instruction
  30:	48 c7 c2 8c 37 16 82 	mov    $0xffffffff8216378c,%rdx
  37:	48 d3 e8             	shr    %cl,%rax
  3a:	89 f1                	mov    %esi,%ecx
  3c:	44 89 f6             	mov    %r14d,%esi

and the obvious reason seems to be that 'maskp' is NULL (that faulting 
thing is the code for "val = (maskp[word] >> bit) & chunkmask;" with the 
actual fault being the access of "maskp[word]".

Now, the caller does

	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);

and then uses cpumask_scnprintf() that is just a wrapper that does

	bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpumask_bits);

So clearly we have "cpumask_of_pcibus()" being NULL (cpumask_bits() would 
not change it).

I assume this is the NUMA case? The non-NUMA case has just

	static inline const struct cpumask *cpumask_of_node(int node)
	{
	        return cpu_online_mask;
	}

so I don't think you can ever get NULL (if we have a NULL cpu_online_mask 
we have bigger problems). 

[ Side note: looking closer, I think our headers are buggy, and I _know_ 
  they are confusing. The above inline declaration of cpumask_of_node() 
  seems to be then later overridden in <asm-generic/topology.h> by a 
  #define! 

  And if I read that right, that will also override the debugging 
  versions that we declared if CONFIG_DEBUG_PER_CPU_MAPS is on. Ingo? 
  Rusty? Am I missing something?

  That said, those overrides should only happen for non-NUMA ]

The NUMA version of 'cpumask_of_node()' has all the debug code for show 
it's not returning NULL, but only when CONFIG_DEBUG_PER_CPU_MAPS is 
enabled. Otherwise it all seems to boil down to (through cpumask_of_pcibus 
and __pcibus_to_node):

	node_to_cpumask_map[bus->sysdata->node]

and it can fail either because "node" isn't initialized, or 
node_to_cpumask_map[] isn't.

Probably 'node' is still -1, and it gets the NULL by going off the array 
into la-la-land.

			Linus
