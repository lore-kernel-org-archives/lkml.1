Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbZEMSoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbZEMSoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760373AbZEMSnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:43:50 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58201 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbZEMSnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:43:49 -0400
Date: Wed, 13 May 2009 12:43:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI MSI: Yet another fix for MSI-X with NIU cards, v2
Message-ID: <20090513184349.GJ15360@parisc-linux.org>
References: <20090508131333.GV8112@parisc-linux.org> <4A0A5284.1000705@jp.fujitsu.com> <4A0A5556.9050209@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A5556.9050209@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 02:06:30PM +0900, Hidetoshi Seto wrote:
>  		entry->mask_base = base;
> -		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
> -					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> -		msix_mask_irq(entry, 1);
> +		entry->masked = 1;
>  

Why do you add the setting of entry->masked here?

>  
> +	/*
> +	 * The states of Reserved bits[31:01] of Vector Control for MSI-X
> +	 * Table Entries must be 0.  However, for potential future use,
> +	 * software must preserve the value of these reserved bits.
> +	 * Refer PCI spec 3.0, 6.8.2.9.
> +	 *
> +	 * Note that there are some device that refuses access to MSI-X
> +	 * Table Entries before MSI-X is enabled.  Therefore we do it here. 
> +	 */

I think you need to refer to PCIe 2.1 (or an ECN incorporated into it).
Some of these bits are now used.

> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		int vector = entry->msi_attrib.entry_nr;
> +		entry->masked = readl(base + vector * PCI_MSIX_ENTRY_SIZE +
> +					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> +		/* Make sure it is masked */
> +		msix_mask_irq(entry, 1);
> +	}
> +
>  	return 0;

This looks to be the same as the replacement patch I sent earlier.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
