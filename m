Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZIRQfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZIRQfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZIRQfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:35:38 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:35968 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751585AbZIRQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:35:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NZPc3791hNQnaN1SRclcGoWsJ45nLKeZbyJ1GOLE3PERqd2+D+sHaQvlUgTwGOVbLqFY+UexxO8GFzFbhEWQmFDqoO2Q5xMVu2M3ijQc627bi2E6FUq2LAWBDEz4Ct1U;
Date: Fri, 18 Sep 2009 09:35:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>,
       Suresh Jayaram <sureshjayaram@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
Message-ID: <20090918093531.3c3cd6c0@jbarnes-g45>
In-Reply-To: <4AB3B4F5.6080809@kernel.org>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org>
	<38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com>
	<alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com>
	<38c3c4860909150320qc4a203eu7552294ef0aafd2c@mail.gmail.com>
	<alpine.DEB.1.00.0909151535150.17284@chino.kir.corp.google.com>
	<38c3c4860909180238x7c9f305dsbce1492e2018c5a5@mail.gmail.com>
	<alpine.DEB.1.00.0909180245030.24690@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0909180339200.6267@chino.kir.corp.google.com>
	<4AB3B4F5.6080809@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 09:27:33 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> David Rientjes wrote:
> > On Fri, 18 Sep 2009, David Rientjes wrote:
> > 
> >> This seems to be related to 2547089 "x86/PCI: initialize PCI bus
> >> node numbers early" since cpumask_of_pcibus() on x86 doesn't check
> >> for -1 pcibus_to_node() like most other architectures.  It'll
> >> simply index into cpumask_of_node for whatever the pci_sysdata's
> >> node is, and in this case that's -1.
> >>
> > 
> > Suresh, could you give this patch a try?  It turns out that the 
> > mp_bus_to_node map simply leaves all busses that don't have memory 
> > affinity to -1, so cpu_online_mask is actually the appropriate
> > cpumask to return and x86 doesn't catch this.
> > 
> > 
> > x86: default pcibus cpumask to all cpus if it lacks affinity
> > 
> > The early initialization of the pci bus to node mapping leaves all
> > busses with a node id of -1 if it lacks memory affinity.  Thus,
> > cpumask_of_pcibus must return all online cpus for such busses.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  arch/x86/include/asm/pci.h |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> > --- a/arch/x86/include/asm/pci.h
> > +++ b/arch/x86/include/asm/pci.h
> > @@ -143,7 +143,11 @@ static inline int __pcibus_to_node(const
> > struct pci_bus *bus) static inline const struct cpumask *
> >  cpumask_of_pcibus(const struct pci_bus *bus)
> >  {
> > -	return cpumask_of_node(__pcibus_to_node(bus));
> > +	int node;
> > +
> > +	node = __pcibus_to_node(bus);
> > +	return (node == -1) ? cpu_online_mask :
> > +			      cpumask_of_node(node);
> >  }
> >  #endif
> >  
> 
> looks right, but we should use nearby_node or local cpu node instead
> of cpu_online_mask...

There is no nearby node.  That's why node is -1.

-- 
Jesse Barnes, Intel Open Source Technology Center
