Return-Path: <linux-kernel-owner+w=401wt.eu-S935857AbXFFVWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935857AbXFFVWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934915AbXFFVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:21:53 -0400
Received: from havoc.gtf.org ([69.61.125.42]:50586 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934634AbXFFVVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:21:53 -0400
Date: Wed, 6 Jun 2007 17:21:51 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop x86 ->sysdata abuse; introduce pci_sysdata
Message-ID: <20070606212151.GA3304@havoc.gtf.org>
References: <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <20070604113344.0e71ca8c.akpm@linux-foundation.org> <20070604190654.GA20299@havoc.gtf.org> <20070604191346.GL4556@rhun.ibm.com> <20070604210551.GH20299@havoc.gtf.org> <20070605102905.GA3305@rhun.haifa.ibm.com> <20070606210329.GQ8541@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606210329.GQ8541@rhun.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, patch fixed, works for me with Calgary. Andi, it looks like you
> added the acpi.c NUMA bits originally, perhaps you could test and/or
> ack them?

Just so there is no misunderstanding, I added the allocation bits.

No idea who added the direct usage of ->sysdata for NUMA info.


> diff -r 05804111dbee arch/i386/pci/common.c
> --- a/arch/i386/pci/common.c	Tue Jun 05 11:34:51 2007 +0300
> +++ b/arch/i386/pci/common.c	Wed Jun 06 22:36:53 2007 +0300
> @@ -29,12 +29,14 @@ struct pci_raw_ops *raw_pci_ops;
>  
>  static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
>  {
> -	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
> +	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
> +				 devfn, where, size, value);
>  }
>  
>  static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
>  {
> -	return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
> +	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
> +				  devfn, where, size, value);
>  }
>  
>  struct pci_ops pci_root_ops = {

Patch leakage?  I thought I had removed this portion, as being specific
to PCI domains.

No objection, obviously, and it's obviously safe given that
CONFIG_PCI_DOMAINS is not defined on x86/x86-64.

Nonetheless, it appears "off-topic" for NUMA/Calgary purposes.

ACK everything, but IMO the pci_domain_nr() bits should be in a separate
patch.

	Jeff





