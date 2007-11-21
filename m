Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbXKUTB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbXKUTB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXKUTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:01:52 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35804 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbXKUTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:01:51 -0500
Date: Wed, 21 Nov 2007 11:01:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <200711211408.17078.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711211051230.2468@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <200711210236.33460.ak@suse.de>
 <Pine.LNX.4.64.0711201758350.30224@schroedinger.engr.sgi.com>
 <200711211408.17078.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Andi Kleen wrote:

> The whole mapping for all CPUs cannot fit into 2GB of course, but the reference 
> linker managed range can.

Ok so you favor the solution where we subtract smp_processor_id() << 
shift?

> > The offset relative to %gs cannot be used if you have a loop and are 
> > calculating the addresses for all instances. That is what we are talking 
> > about. The CPU_xxx operations that are using the %gs register are fine and 
> > are not affected by the changes we are discussing.
> 
> Sure it can -- you just get the base address from a global array
> and then add the offset

Ok so generalize the data_offset for that case? I noted that other arches 
and i386 have a similar solution there. I fiddled around some more and 
found that the overhead that the subtraction introduces is equivalent to 
loading an 8 byte constant of the base.

Keeping the usage of data_offset can avoid the shift and the add for the 
__get_cpu_var case that needs CPU_PTR( ..., smp_processor_id()) because 
the load from data_offset avoid the shifting and adding of 
smp_processor_id().

For the loops this is not useful since the compiler can move the 
loading of the base pointer outside of the loop )if CPU_PTR needs to load 
an 8 byte constant pointers).

With loading the 8 byte base the loops actually become:

sum = 0
ptr = CPU_AREA_BASE
while base < NR_CPUS << shift {
	sum = *ptr
	ptr += 1 << shift
}

So I think we need to go with the implementation where CPU_PTR(var, cpu) 
is

CPU_AREA_BASE + cpu << shift + var_offset

The CPU_AREA_BASE will be loaded into a register. The var_offset usually 
ends up being an offset in a mov instruction.

> > 
> > > Then the reference data would be initdata and eventually freed.
> > > That is similar to how the current per cpu data works.
> > 
> > Yes that is also how the current patchset works. I just do not understand 
> > what you want changed.
> 
> Anyways i think your current scheme cannot work (too much VM, placed at the wrong 
> place; some wrong assumptions).

The constant pointer solution fixes that. No need to despair.

