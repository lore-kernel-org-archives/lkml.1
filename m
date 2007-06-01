Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbXFASF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbXFASF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760530AbXFASFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:05:19 -0400
Received: from ns2.suse.de ([195.135.220.15]:34957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653AbXFASFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:05:17 -0400
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, andrew.vasquez@qlogic.com
Subject: Re: [PATCH] quiet down swiotlb warnings
References: <466057B1.9090309@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Jun 2007 21:01:45 +0200
In-Reply-To: <466057B1.9090309@redhat.com>
Message-ID: <p73odjzbism.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel <riel@redhat.com> writes:

> It turns out that the qla2xxx driver sometimes fills up the iotlb
> on purpose and throttles itself when pci_map_sg() fails.  In the
> case of a driver that expects and handles pci_map_sg() failures,
> we should not spam the user's console with swiotlb full messages.

Why does it do that? Could we supply a better interface
for whatever it is trying to do here?

>  	 */
> -	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
> -	       "device %s\n", size, dev ? dev->bus_id : "?");
> +	if (++warnings < 5)
> +		printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
> +		       "device %s\n", size, dev ? dev->bus_id : "?");

Bad idea imho. swiotlb mappings should always lead to printk by default
because it is pretty dangerous.

One possible solution for this I could think of would be to define a
new pci_map_sg_couldfail() or similar that doesn't warn and use a weak
fallback just calling pci_map_sg on other IOMMU implementations. 

 -Andi
