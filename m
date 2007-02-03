Return-Path: <linux-kernel-owner+w=401wt.eu-S1945995AbXBCQRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945995AbXBCQRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 11:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946457AbXBCQRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 11:17:15 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:33805 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945995AbXBCQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 11:17:15 -0500
In-Reply-To: <20070203024013.737331000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org> <20070203024013.737331000@sous-sol.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5EFB4FBE-A880-4078-A5A1-74F4C22FF93A@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [patch 17/59] PCI: prevent down_read when pci_devices is empty
Date: Sat, 3 Feb 2007 10:16:20 -0600
To: Chris Wright <chrisw@sous-sol.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 2, 2007, at 8:35 PM, Chris Wright wrote:

> -stable review patch.  If anyone has any objections, please let us  
> know.
> ------------------

We just updated this for mainline to remove the printks.  I'd prefer  
to see that version of this patch go in.

- k

>
> From: Ard van Breemen <ard@telegraafnet.nl>
>
> The pci_find_subsys gets called very early by obsolete ide setup  
> parameters.
> This is a bogus call since pci is not initialized yet, so the list  
> is empty.
> But in the mean time, interrupts get enabled by down_read.  This  
> can result in
> a kernel panic when the irq controller gets initialized.
>
> This patch checks if the device list is empty before taking the  
> semaphore, and
> hence will not enable irq's.  Furthermore it will inform that it is  
> called
> while pci_devices is empty as a reminder that the ide code needs to  
> be fixed.
>
> The pci_get_subsys can get called in the same manner, and as such  
> is patched
> in the same manner.
>
> [akpm@osdl.org: cleanups]
> Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
> This is the other half of the fix for bug #7505
>
>  drivers/pci/search.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> --- linux-2.6.19.2.orig/drivers/pci/search.c
> +++ linux-2.6.19.2/drivers/pci/search.c
> @@ -193,6 +193,18 @@ static struct pci_dev * pci_find_subsys(
>  	struct pci_dev *dev;
>
>  	WARN_ON(in_interrupt());
> +
> +	/*
> +	 * pci_find_subsys() can be called on the ide_setup() path, super- 
> early
> +	 * in boot.  But the down_read() will enable local interrupts, which
> +	 * can cause some machines to crash.  So here we detect and flag  
> that
> +	 * situation and bail out early.
> +	 */
> +	if (unlikely(list_empty(&pci_devices))) {
> +		printk(KERN_INFO "pci_find_subsys() called while pci_devices "
> +				"is still empty\n");
> +		return NULL;
> +	}
>  	down_read(&pci_bus_sem);
>  	n = from ? from->global_list.next : pci_devices.next;
>
> @@ -259,6 +271,18 @@ pci_get_subsys(unsigned int vendor, unsi
>  	struct pci_dev *dev;
>
>  	WARN_ON(in_interrupt());
> +
> +	/*
> +	 * pci_get_subsys() can potentially be called by drivers super-early
> +	 * in boot.  But the down_read() will enable local interrupts, which
> +	 * can cause some machines to crash.  So here we detect and flag  
> that
> +	 * situation and bail out early.
> +	 */
> +	if (unlikely(list_empty(&pci_devices))) {
> +		printk(KERN_NOTICE "pci_get_subsys() called while pci_devices "
> +				"is still empty\n");
> +		return NULL;
> +	}
>  	down_read(&pci_bus_sem);
>  	n = from ? from->global_list.next : pci_devices.next;
>
>
> --
> -
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

