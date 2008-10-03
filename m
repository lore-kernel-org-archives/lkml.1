Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbYJCOar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbYJCOar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYJCOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:30:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbYJCOaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:30:39 -0400
Date: Fri, 3 Oct 2008 10:29:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jan Kasprzak <kas@fi.muni.cz>, linux-kernel@vger.kernel.org
Subject: Re: IRQ balancing on a router
Message-ID: <20081003142941.GC3167@redhat.com>
References: <20081003132117.GM16624@fi.muni.cz> <20081003063857.76b7b61a@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003063857.76b7b61a@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 06:38:57AM -0700, Arjan van de Ven wrote:
> > 	Hello,
> > 
> > I have a dual-CPU router/firewall with five gigabit NICs. Recently I
> > have found that irqbalance (0.55 from Fedora 9/x86_64) gives a
> > suboptimal IRQ to CPU mapping on this box:
> > 
> > 	During traffic spikes, it assings two NICs to one CPU, and the
> > other three to the second CPU. However, this does not account for
> > the fact that packets coming from the uplink interface are way more
> > expensive to handle than the rest of the traffic: most iptables rules
> > apply to the packets received from the uplink interface. The result is
> > that the CPU which receives IRQs for the uplink interface
> > is 100 % busy (softirq mostly), while the other one is 90% idle.
> > 
> > 	Setting the IRQ mapping by hand (uplink to one CPU, all the
> > other NICs to the other CPU) makes a well balanced system (both CPUs
> > 30-60 % busy). I am not sure whether my configuration is too special,
> > but it might be worth trying to make irqbalance daemon cope also with
> > this usage pattern.
> > 
> 
> one of the hard cases for irqbalance is that irqbalance doesn't have a
> way to find out the actual cpu time spend in the handlers. For
> networking it makes an estimate just based on the number of packets
> (which is better than nothing)... but that breaks down if you have an
> non-symmetry in CPU costs per packet like you have.
> 
> The good news is that irqthreads at least have the potential to solve
> this "lack of information"; if not, we could consider doing a form of
> microaccounting for irq handlers....
> 
> 

perhaps, this could be addressed using tracepoints. The currently
proposed ones are at the beginning and end of 'handle_IRQ_event()'. See:
http://marc.info/?l=linux-kernel&m=121616099830280&w=2

thanks,

-Jason
