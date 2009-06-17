Return-Path: <linux-kernel-owner+w=401wt.eu-S1761480AbZFQVlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480AbZFQVlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZFQVlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:41:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:35329 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZFQVlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:41:14 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
In-Reply-To: <alpine.LFD.2.01.0906170853580.16802@localhost.localdomain>
References: <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <1245059859.23207.16.camel@penberg-laptop>
	 <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop>
	 <20090615112355.GB6012@wotan.suse.de> <1245101498.12400.37.camel@pasglop>
	 <20090616044601.GB28596@wotan.suse.de>
	 <alpine.LFD.2.01.0906161141290.3282@localhost.localdomain>
	 <20090617074719.GB26664@wotan.suse.de>
	 <alpine.LFD.2.01.0906170853580.16802@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 07:39:35 +1000
Message-Id: <1245274775.21602.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 09:01 -0700, Linus Torvalds wrote:
> 
> On Wed, 17 Jun 2009, Nick Piggin wrote:
> > 
> > In some cases perhaps it is difficult. In others it should be
> > pretty natural. Lots of memory allocating paths pass gfp
> > a long way down the stack.
> 
> I agree that some cases would be pretty natural. In fact, that's what we 
> started out doing. On the x86 side, we didn't have a lot of issues in 
> testing, and we fixed them up by using GFP_NOWAIT (see for example 
> cpupri_init() in kernel/sched_cpupri.c, or init_irq_default_affinity() in 
> kernel/irq/handle.c - both of which were fixed up in that phase).
> 
> Those paths, in fact, in general already had "bootmem" flags etc. And x86 
> doesn't need to initialize a lot of state at bootup. 
> 
> Then Ben happened, and crazy PPC ioremap crap. 

 :-)

Are you sure that none of the kmalloc's you turned into NOWAIT on x86
can be called after boot by things like CPU hotplug etc... ? In which
case, they just become much more prone to failure in the later case ...

How do you get away without ioremap in time_init(), init_IRQ() etc... ?
It's all IO ports and magic registers on x86 ?

So yeah, early ioremap is a problem, but it's also very useful to have
and will be hard to get rid of. I suspect most non-x86 platforms will
need something like that. Even if I end up managing to kill the callers
in setup_arch(), I will probably never get rid of ioremaps after the new
mm_init() and before interrupts are on.

There's a few other things in PPC land, like PCI stuffs, data structures
related to interrupt routing, etc... that can be allocated both at boot
and non boot, some of them we could probably push out to later but not
all and not without great care.

Cheers,
Ben.


