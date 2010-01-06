Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519Ab0AFXkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0AFXkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311Ab0AFXkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:40:19 -0500
Received: from ozlabs.org ([203.10.76.45]:42807 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab0AFXkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:40:18 -0500
Date: Thu, 7 Jan 2010 10:31:51 +1100
From: Anton Blanchard <anton@samba.org>
To: David Rientjes <rientjes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
Message-ID: <20100106233151.GC12742@kryten>
References: <20100106045509.245662398@samba.org>
 <20100106045509.245662398@samba.org>
 <20100106045525.476396870@samba.org>
 <201001061706.26845.rusty@rustcorp.com.au>
 <alpine.DEB.2.00.1001061454580.11653@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001061454580.11653@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

> Do we really want to do this?  A nid of -1 is undefined, so the result of 
> cpumask_of_node(-1) should be undefined; there's no formal definition that 
> a nid of -1 follows the semantics that we use for x86 pci buses, for 
> example, where it implies no NUMA locality in all cases.

I don't like the use of -1 as a node, but it's much more widespread than
x86; including sh, powerpc, sparc and the generic topology code. eg:


#fdef CONFIG_PCI
extern int pcibus_to_node(struct pci_bus *pbus);
#else
static inline int pcibus_to_node(struct pci_bus *pbus)
{
        return -1;
}


It would be nice to get rid of this special case but I suspect that's not
2.6.33 material.

Speaking of invalid node ids, I also noticed the scheduler isn't using
node iterators:

        for (i = 0; i < nr_node_ids; i++) {

which should be fixed at some stage too since it doesn't allow us to
allocate the node structures sparsely.

Anton
