Return-Path: <linux-kernel-owner+w=401wt.eu-S933126Ab0AFXvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab0AFXvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548Ab0AFXvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:51:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:1715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab0AFXvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:51:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cutl+Z4mY74C8dT1yRXThyjTHsI9mXD6Qnf1pYHhQ2U9NlMn+oVR7u+XmqTU065ZO
	9z8jxbErHyymQOwAqceDw==
Date: Wed, 6 Jan 2010 15:51:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Blanchard <anton@samba.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
In-Reply-To: <20100106233151.GC12742@kryten>
Message-ID: <alpine.DEB.2.00.1001061545210.19882@chino.kir.corp.google.com>
References: <20100106045509.245662398@samba.org> <20100106045509.245662398@samba.org> <20100106045525.476396870@samba.org> <201001061706.26845.rusty@rustcorp.com.au> <alpine.DEB.2.00.1001061454580.11653@chino.kir.corp.google.com>
 <20100106233151.GC12742@kryten>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Anton Blanchard wrote:

> I don't like the use of -1 as a node, but it's much more widespread than
> x86; including sh, powerpc, sparc and the generic topology code. eg:
> 
> 
> #fdef CONFIG_PCI
> extern int pcibus_to_node(struct pci_bus *pbus);
> #else
> static inline int pcibus_to_node(struct pci_bus *pbus)
> {
>         return -1;
> }

This seems to be the same semantics that NUMA_NO_NODE was defined for, 
it's not necessarily a special case.

Regardless, the result of cpumask_of_node(NUMA_NO_NODE) should be 
undefined as it currently is unless you want to obsolete NUMA_NO_NODE 
entirely which is much more work.  In other words, special-casing a nid of 
-1 to mean no affinity is inappropriate if NUMA_NO_NODE represents an 
invalid nid.

If x86 pci buses want to use -1 to imply that meaning, that's fine, but it 
shouldn't be coded in a generic interface such as cpumask_of_node().  Does 
that make sense?

> Speaking of invalid node ids, I also noticed the scheduler isn't using
> node iterators:
> 
>         for (i = 0; i < nr_node_ids; i++) {
> 
> which should be fixed at some stage too since it doesn't allow us to
> allocate the node structures sparsely.
> 

That loop has nothing to do with the allocation of a node structure, it's 
quite plausible that it checks for various states such as node_online(i) 
while looping and doing something else interesting for those that are 
offline.  Keep in mind that this isn't equivalent to using for_each_node() 
since that only iterates over N_POSSIBLE which is architecture specific.
