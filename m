Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbXEKGEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbXEKGEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXEKGEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:04:47 -0400
Received: from colin.muc.de ([193.149.48.1]:4220 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbXEKGEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:04:47 -0400
Date: 11 May 2007 08:04:44 +0200
Date: Fri, 11 May 2007 08:04:44 +0200
From: Andi Kleen <ak@muc.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, systemtap@sources.redhat.com,
       prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070511060444.GA35262@muc.de>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.508519573@polymtl.ca> <20070510090656.GA57297@muc.de> <20070510155501.GI22424@Krystal> <20070510172843.7aa72237@the-village.bc.nu> <20070510165918.GK22424@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510165918.GK22424@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:59:18PM -0400, Mathieu Desnoyers wrote:
> * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > * First issue : Impact on the system. If we try to make this system
> > >   scale, we will create very long irq disable sections. The expected
> > >   duration is the worse case IPI latency plus the time it takes to CPU A
> > >   to change the variable. We therefore directly grow the worse case
> > >   system's interrupt latency.
> > 
> > Not a huge problem. It doesn't scale in really horrible ways and the IPI
> > latency on a PIV or later is actually very good. Also the impact is less
> > than you might think as on huge huge boxes you want multiple copies of
> > the kernel text pages to reduce NUMA traffic, so you only have to sync
> > the group of processors involved 

I agree with Alan and disagree with you on the impact on the system.

> > 
> > > * Second issue : irq disabling does not protect us from NMI and traps.
> > >   We cannot use this algorithm to mark these code segments.
> > 
> > If you synchronize all the other processors and disable local interrupts
> > then the only traps you have to worry about are those you cause, and the
> > only person taking the trap will be you so you're ok.
> > 
> > NMI is hard but NMI is a special case not worth solving IMHO.
> > 
> 
> Not caring about NMIs may have more impact than one could expect. You
> have to be aware that (at least) the following code is executed in NMI
> context. Trying to patch any of these functions could result in a dying
> CPU :

There is a function to disable the nmi watchdog temporarily now


> In entry.S, there is also a call to local_irq_enable(), which falls into
> lockdep code.

??

> 
> Tracing those core kernel functions is a fundamental need of crash
> tracing. So, in my point of view, it is not "just" about tracing NMIs,
> but it's about tracing code that can be touched by NMIs.

You only need to handle the erratas during the modification, not during
the whole lifetime of the marker. 

The only frequent NMIs are watchdog and oprofile which both can
be stopped. Other NMIs are very infrequent.

BTW if you worry about NMI you would need to worry about machine
check and SMI too.

-Andi
