Return-Path: <linux-kernel-owner+w=401wt.eu-S940960AbXGSRke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940960AbXGSRke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759604AbXGSRkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:40:21 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:36907 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761322AbXGSRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:40:19 -0400
Date: Thu, 19 Jul 2007 13:35:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: jbeulich@novell.com, "S. P. Prasanna" <prasanna@in.ibm.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: new text patching for review
Message-ID: <20070719173502.GB12955@Krystal>
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal> <200707191546.08919.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707191546.08919.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:57:25 up 2 days, 10:31,  3 users,  load average: 0.25, 0.17, 0.32
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> 
> > Ewwwwwwwwwww.... you plan to run this in SMP ? So you actually go byte
> > by byte changing pieces of instructions non atomically and doing
> > non-Intel's errata friendly XMC. You are really looking for trouble
> > there :) Two distinct errors can occur: 
> 
> In this case it is ok because this only happens when transitioning
> from 1 CPU to 2 CPUs or vice versa and in both cases the other CPUs
> are essentially stopped.
> 

I agree that it's ok with SMP, but another problem arises: it's not only
a matter of being protected from SMP access, but also a matter of
reentrancy wrt interrupt handlers.

i.e.: if, as we are patching nops non atomically, we have a non maskable
interrupt coming which calls get_cycles_sync() which uses the
alternatives for cpuid when the NOP instructions are not in a correct
state, we can end up doing an illegal instruction.

I see that IRQs are disabled in alternative_instructions(), but it does
not protect against NMIs, which could come at a very inappropriate
moment. MCE and SMIs would potentially cause the same kind of trouble.

So unless you can guarantee that any code from NMI handler won't call
basic things such as get_cycles() (nor MCE, nor SMIs), you can't insure
it won't execute an illegal instruction. Also, the option of temporarily
disabling the NMI for the duration of the update simply adds unwanted
latency to the NMI handler which could be unacceptable in some setups.

Another potential problem comes from preemption: if a thread is
preempted in the middle of the instructions you are modifying, let's say
we originally have 4 * 1 byte instructions that we replace with 1 * 4
byte instruction, a thread could iret in the middle of the new
instruction when it will be scheduled again, thus executing an illegal
instruction. This problem could be overcomed by putting the threads in
the freezer. See the djprobe project for details about this.

In the end, I think the safest solution would be to limit ourselves to
one of these 2 solutions:
- If the update can be done atomically and leaves the site in a coherent
  state after each atomic modification, while keeping the same
  instruction size, it could be done on the spot.
- If not, care should be taken to first do a copy of the code to modify
  into a "bypass", making sure that instructions can be relocated, so
  that any context that would try to execute the site during the
  modification would execute a breakpoint which would execute the bypass
  while we modify the instructions. Care should be taken to make sure
  that threads are in the freezer while we do this. This is basically
  what djprobes does. You case is only a bit simpler because you don't
  worry about SMP.


> All the other manipulations currently are single byte.
> 

For breakpoint, yes, this one is easy.


> I suppose for your immediate value patches something stronger is needed,
> but we can worry about that post .23.
> 
> > What I don't like about this particular implementation is that it does
> > not support "poking" more than 1 byte. In order to support this, you
> > would have to deal with the case where the address range spans over more
> > than one page.
> 
> I considered it, but the function would have been at least twice as big
> to handle all the corner cases. And for the current callers it's all fine.
> 
> > Also, doing the copy in the same interface seems a bit awkward.
> 
> Splitting it would also seem quite awkward.
>  

Because of the tricks that must be done to do code modification on a
live system (as explained above), I don't think it makes sense to
provide a falsely-safe infrastructure that would allow code modification
in a non-atomic manner.

> > 
> > I would much prefer something like:
> > 
> > void *map_shadow_write(void *addr, size_t len);
> > (returns a pointer to the shadow writable pages, at the same page offset
> > as "addr")
> > 
> > int unmap_shadow_write(void *shadow_addr, size_t len);
> > (unmap the shadow pages)
> > 
> > Then, the in-kernel user is free to modify their pages as they like.
> > Since we cannot foresee each modification pattern, I think that leaving
> > this kind of flexibility is useful.
> 
> You could as well call vmap directly then; it's not that much
> more complicated.  I don't really see much value in complicating
> it right now.
> 

Right about the direct vmap call, it is quite simple and elegant, I
guess I'll use it in my next version of kernel text lock.

Mathieu

> -Andi
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
