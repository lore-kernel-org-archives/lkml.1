Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYCNFXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYCNFXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbYCNFWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:22:11 -0400
Received: from colo.lackof.org ([198.49.126.79]:58678 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545AbYCNFWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:22:10 -0400
Date: Thu, 13 Mar 2008 23:21:58 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: akepner@sgi.com, James Bottomley <James.Bottomley@HansenPartnership.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Mark Nelson <mdnelson@au1.ibm.com>
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs()
	interface
Message-ID: <20080314052158.GG24794@colo.lackof.org>
References: <20080228032448.GS11012@sgi.com> <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com> <20080229182504.GA18102@colo.lackof.org> <1204310276.4003.48.camel@localhost.localdomain> <20080305181307.GR17802@sgi.com> <1204783306.14874.37.camel@concordia.ozlabs.ibm.com> <20080312011954.GN12370@sgi.com> <1205469029.7414.18.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205469029.7414.18.camel@concordia.ozlabs.ibm.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 03:30:29PM +1100, Michael Ellerman wrote:
...
> > +DMA_ATTR_BARRIER is a barrier attribute for DMA.  DMA to a memory 
> > +region with the DMA_ATTR_BARRIER attribute forces all pending DMA 
> > +writes to complete, and thus provides a mechanism to strictly order 
> > +DMA from a device across all intervening busses and bridges.  This 
> > +barrier is not specific to a particular type of interconnect, it 
> > +applies to the system as a whole, and so its implementation must 
> > +account for the idiosyncracies of the system all the way from the 
> > +DMA device to memory. 
> 
> You say a "DMA to a memory region with the DMA_ATTR_BARRIER attribute
> forces all pending DMA writes to complete". Does it force _all_ DMA
> writes to complete, or just writes to the region, or just writes coming
> from devices?

Yes to "_all_ DMA writes". re-read the second sentence.

> What if something is writing to a device?

aka MMIO writes. Not defined and in general unrelated. AFAIK, no
version of PCI has ordering rules for traffic going in opposite
directions. I'm 99% sure about this but haven't reviewed any
PCI docs in about 2 years.

Note I think it's possible for DMA READs to complete out of order
given PCI-x (IIRC) and PCI-e (I'm certain) support split transactions.
This means a device can have multiple DMA reads in flight and the
chipset/system firmware (aka BIOS) have to enable and support this
functionality as well. I _believe_ those split transactions can
complete out of order (since they are tagged like SCSI/SATA are)
and I expect it's up to the device to deal with that already.

Devices which do not support or use more than one split transaction
obviously won't have any DMA READ ordering issues.

On a related note, I always think of MSI/MSI-X as DMA Writes.
Michael's got me thinking we need to explicitly state that.
In "normal" use, the device will not issue an MSI until after
the "completion DMA write" has been issued and thus the MSI/MSI-X
transactions are NOT subject to the ordering requirement...but
that's not exactly true. We don't want the MSI to ever
pass the "completion DMA write".

Do we need to state the platform interconnect can NOT allow
successive DMA writes to pass the ordered DMA writes?
Or state MSI DMA writes are implied to be to an "ordered DMA region"?
Both statements?


> Does DMA_ATTR_BARRIER have any effect on reads?

It could but it's not defined to. :)
I thought about this before but wanted to keep the document short.

Perhaps two things should be done to address this:
1) rename this to DMA_ATTR_WRITE_BARRIER
2) state it has no explicit effect on DMA Reads.

If someone needs that changed in the future, we can then
define how reading from a region will trigger ordering rules.

thanks,
grant

> 
> cheers
> 
> -- 
> Michael Ellerman
> OzLabs, IBM Australia Development Lab
> 
> wwweb: http://michael.ellerman.id.au
> phone: +61 2 6212 1183 (tie line 70 21183)
> 
> We do not inherit the earth from our ancestors,
> we borrow it from our children. - S.M.A.R.T Person


