Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZKWXcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZKWXcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbZKWXcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:32:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:64352 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbZKWXcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:32:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,274,1257148800"; 
   d="scan'208";a="516706482"
Date: Mon, 23 Nov 2009 15:32:36 -0800 (Pacific Standard Time)
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       Yong Zhang <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance
 hints
In-Reply-To: <1258995923.4531.715.camel@laptop>
Message-ID: <Pine.WNT.4.64.0911231529240.10056@ppwaskie-MOBL2.amr.corp.intel.com>
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com> 
 <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com> 
 <1258968980.2697.9.camel@ppwaskie-mobl2> <1258995923.4531.715.camel@laptop>
ReplyTo: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
X-X-Sender: amrppwaskie@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Peter Zijlstra wrote:

> On Mon, 2009-11-23 at 01:36 -0800, Peter P Waskiewicz Jr wrote:
> 
> > This mechanism isn't going to be used by any internal kernel mechanism
> > for determining interrupt placement or operation.  It's purely something
> > that either a driver can modify, or external script (through /proc),
> > that irqbalance will make use of.  If irqbalance isn't running, or the
> > current version of irqbalance doesn't support reading node_affinity,
> > then it won't affect the system's operation.
> > 
> > If irqbalance does support it, it'll read whatever the supplied mask is,
> > and then will try and balance interrupts within that mask.  It will bail
> > if the mask is invalid, or won't apply to the running system, just like
> > how putting a bogus mask into smp_affinity is ignored.
> > 
> > If there's something I'm missing beyond this with the two suggestions
> > you've made (I looked into those two parameters and tried to draw
> > conclusions), please let me know.
> 
> I don't see the point in adding it, if the driver wants to set a node
> cpu mask it can already do that using the regular smp affinity settings.

Unfortunately, a driver can't.  The irq_set_affinity() function isn't 
exported.  I proposed a patch on netdev to export it, and then to tie down 
an interrupt using IRQF_NOBALANCING, so irqbalance won't touch it.  That 
was rejected, since the driver is enforcing policy of the interrupt 
balancing, not irqbalance.

I and Jesse Brandeburg had a meeting with Arjan about this.  What we came 
up with was this interface, so drivers can set what they'd like to see, if 
irqbalance decides to honor it.  That way interrupt affinity policies are 
set only by irqbalance, but this interface gives us a mechanism to hint to 
irqbalance what we'd like it to do.

Also, if you use the /proc interface to change smp_affinity on an 
interrupt without any of these changes, irqbalance will override it on its 
next poll interval.  This also is not desirable.

Cheers,
-PJ
