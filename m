Return-Path: <linux-kernel-owner+w=401wt.eu-S1763202AbXFASRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbXFASRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbXFASRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:17:07 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:37397 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762167AbXFASRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:17:06 -0400
Date: Fri, 1 Jun 2007 11:16:59 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070601181659.GG12143@andrew-vasquezs-computer.local>
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73odjzbism.fsf@bingen.suse.de>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 01 Jun 2007 18:16:27.0600 (UTC) FILETIME=[F8875D00:01C7A478]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007, Andi Kleen wrote:

> Rik van Riel <riel@redhat.com> writes:
> 
> > It turns out that the qla2xxx driver sometimes fills up the iotlb
> > on purpose and throttles itself when pci_map_sg() fails.  In the
> > case of a driver that expects and handles pci_map_sg() failures,
> > we should not spam the user's console with swiotlb full messages.
> 
> Why does it do that? Could we supply a better interface
> for whatever it is trying to do here?

The driver only calls pci_map_sg() once it's insured that all local
driver resources are available to submit an I/O to the hardware.

> > -	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
> > -	       "device %s\n", size, dev ? dev->bus_id : "?");
> > +	if (++warnings < 5)
> > +		printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
> > +		       "device %s\n", size, dev ? dev->bus_id : "?");
> 
> Bad idea imho. swiotlb mappings should always lead to printk by default
> because it is pretty dangerous.

Why?  It's just another resource which is consumed -- the qla2xxx
driver is the final consumer before I/O is submitted out on the wire.
The mappings are held for the shorted time required -- as such, are
released as soon as the I/O completes.

> One possible solution for this I could think of would be to define a
> new pci_map_sg_couldfail() or similar that doesn't warn and use a weak
> fallback just calling pci_map_sg on other IOMMU implementations. 
