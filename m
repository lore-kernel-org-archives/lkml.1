Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYAIVAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYAIVAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYAIVAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:00:45 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:17933 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYAIVAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:00:44 -0500
X-IronPort-AV: E=Sophos;i="4.24,264,1196668800"; 
   d="scan'208";a="19063009"
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akepner@sgi.com, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
X-Message-Flag: Warning: May contain useful information
References: <20080108023222.GP23661@sgi.com>
	<1199809628.3534.34.camel@localhost.localdomain>
	<ada63y4kycs.fsf@cisco.com>
	<1199814853.3534.39.camel@localhost.localdomain>
	<adawsqkjipz.fsf@cisco.com>
	<1199816504.3534.59.camel@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 09 Jan 2008 13:00:38 -0800
In-Reply-To: <1199816504.3534.59.camel@localhost.localdomain> (James Bottomley's message of "Tue, 08 Jan 2008 12:21:44 -0600")
Message-ID: <adaprwa7lzd.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jan 2008 21:00:39.0037 (UTC) FILETIME=[B025DAD0:01C85302]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What it wants to do is set strict ordering for the bus ... well, that is
 > an attribute in the PCIe standard (it just happens to be the default one
 > for a standard bus, whereas relaxed is the default for altix).  However,
 > set bus attribute strict would be a simple no-op for a standard bus (and
 > set attribute relaxed a no-op for altix).

I don't think that this can work.  As Arthur and I have said several
times, the Altix issue is within the system NUMA interconnect --
nothing to do with the PCI bus.  And as I understand things, to get
good performance, we have to allow reordering within the NUMA
interconnect except that certain transactions need to flush all
earlier writes.  So this attribute needs to be set per-mapping, not
per-bus.

If you have a cleaner way to specify this attribute that Arthur's
idea, then it would be very useful to share that.  If we were starting
from scratch, then probably adding another "flags" parameter to the
DMA mapping functions would be the way to go, but given the number of
calls to dma_map_xxx all around, changing the signature now doesn't
look very appealing.

The reason this hasn't been an issue until now is that almost all
drivers work correctly if the Altix code just sets the "flush" bit for
memory allocated via the consistent/coherent allocators.  However, if
we want the device to write to userspace memory, this doesn't work
(and mapping coherent memory allocated in the kernel into userspace is
a mess on other platforms, because it unnecessarily consumes lowmem
and/or kernel address space).

Also, all of this is quite separate from the PCIe "loose ordering"
stuff.  In fact, it's quite conceivable that SGI could hook up a PCIe
3.0 host bridge to the Altix NUMA interconnect, so that you could have
a PCI bus that supported loose ordering and also a system interconnect
that allowed a different type of reordering too.

 - R.

