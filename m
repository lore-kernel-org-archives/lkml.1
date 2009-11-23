Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZKWJgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZKWJgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbZKWJgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:36:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:31992 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145AbZKWJgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:36:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,268,1257148800"; 
   d="scan'208";a="749538472"
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>
	 <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 01:36:19 -0800
Message-Id: <1258968980.2697.9.camel@ppwaskie-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 23:32 -0800, Yong Zhang wrote:
> On Mon, Nov 23, 2009 at 2:46 PM, Peter P Waskiewicz Jr
> <peter.p.waskiewicz.jr@intel.com> wrote:
> > This patchset adds a new CPU mask for SMP systems to the irq_desc
> > struct.  It also exposes an API for underlying device drivers to
> > assist irqbalance in making smarter decisions when balancing, especially
> > in a NUMA environment.  For example, an ethernet driver with MSI-X may
> > wish to limit the CPUs that an interrupt can be balanced within to
> > stay on a single NUMA node.  Current irqbalance operation can move the
> > interrupt off the node, resulting in cross-node memory accesses and
> > locks.
> >
> > The API is a get/set API within the kernel, along with a /proc entry
> > for the interrupt.
> >
> > Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> > ---
> 
> 1) I think you should consider CONFIG_CPUMASK_OFFSTACK which will affect
>    node_affinity.
> 2) It seems like this patch can't work with SPARSE_IRQ.

This mechanism isn't going to be used by any internal kernel mechanism
for determining interrupt placement or operation.  It's purely something
that either a driver can modify, or external script (through /proc),
that irqbalance will make use of.  If irqbalance isn't running, or the
current version of irqbalance doesn't support reading node_affinity,
then it won't affect the system's operation.

If irqbalance does support it, it'll read whatever the supplied mask is,
and then will try and balance interrupts within that mask.  It will bail
if the mask is invalid, or won't apply to the running system, just like
how putting a bogus mask into smp_affinity is ignored.

If there's something I'm missing beyond this with the two suggestions
you've made (I looked into those two parameters and tried to draw
conclusions), please let me know.

Cheers,
-PJ Waskiewicz

