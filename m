Return-Path: <linux-kernel-owner+w=401wt.eu-S932469Ab0AGIE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0AGIE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393Ab0AGIEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:04:55 -0500
Received: from smtp-out.google.com ([216.239.44.51]:54303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab0AGIEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:04:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=KHTkrR9JmtMeaxtTWpOxiMFpm7qHUgDJBY0kRmtccBcMSXgxy/0UvBfMuotUUfSVi
	klPmZ3lZx3TiuAuq5aqaA==
Date: Thu, 7 Jan 2010 00:04:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>
cc: Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
In-Reply-To: <201001071109.10362.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.1001062353570.15070@chino.kir.corp.google.com>
References: <20100106045509.245662398@samba.org> <20100106233151.GC12742@kryten> <alpine.DEB.2.00.1001061545210.19882@chino.kir.corp.google.com> <201001071109.10362.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Rusty Russell wrote:

> On Thu, 7 Jan 2010 10:21:06 am David Rientjes wrote:
> > On Thu, 7 Jan 2010, Anton Blanchard wrote:
> > 
> > > I don't like the use of -1 as a node, but it's much more widespread than
> > > x86; including sh, powerpc, sparc and the generic topology code. eg:
> > > 
> > > 
> > > #fdef CONFIG_PCI
> > > extern int pcibus_to_node(struct pci_bus *pbus);
> > > #else
> > > static inline int pcibus_to_node(struct pci_bus *pbus)
> > > {
> > >         return -1;
> > > }
> > 
> > This seems to be the same semantics that NUMA_NO_NODE was defined for, 
> > it's not necessarily a special case.
> 
> It's widespread, and we've just had another bug due to pcibus_to_node handling
> -1 and cpumask_of_node not.  (Search lkml for subject "[Regression] 2.6.33-rc2
>  - pci: Commit e0cd516 causes OOPS").
> 

That's similiar to the problem in cpumask_of_pcibus() that I fixed with 
7715a1e back in September.  The difference is that I isolated my fix to 
the pci bus implementation that defined the nid of -1 to mean no NUMA 
affinity, whereas generic kernel code can use that value for any (or no) 
definition and returning cpu_all_mask may not apply.  We know it does for 
pcibus, but not for generic NUMA node ids that happen to be invald.

The hope is that eventually we can remove many dependencies on node ids 
for these purposes; buses with no affinity are not actually members of any 
NUMA node.  I had a proposal for a generic kernel interface that is based 
on ACPI system localities that would define the proximity of any system 
entity (of which node is only a type defining "memory") to each other.  
I'm waiting for enough time to work on that project.

NUMA is special because a single cpu is always a member of a single node, 
so we're violating the bidirectional mapping by saying that node -1 maps 
to all cpus while all cpus don't map to node -1.  In other words, I think 
we should take this as an opportunity to find and fix broken callers as 
we've done both by my patch from September and by your aforementioned 
case.  In this particular case, it would be a matter of doing:

	mask = (nid != -1) ? cpumask_of_node(nid) : cpu_all_mask;

I'm hoping that Ingo will weigh in on this topic with his taste and vision 
for how we should decouple device locality information from entities that 
are not members of any NUMA node if we continue to "special case" these 
things.
