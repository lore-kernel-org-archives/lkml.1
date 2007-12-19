Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbXLSXQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbXLSXQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:16:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbXLSXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:15:34 -0500
Received: from ns.suse.de ([195.135.220.2]:35342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032AbXLSXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:15:33 -0500
Date: Wed, 19 Dec 2007 15:06:15 -0800
From: Greg KH <gregkh@suse.de>
To: tcamuso@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       prarit@redhat.com
Subject: Re: [PATCH 2/5]PCI: x86 MMCONFIG: add legacy pci conf functions
Message-ID: <20071219230615.GB24219@suse.de>
References: <20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com> <20071219221756.20362.84805.sendpatchset@dhcp83-188.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219221756.20362.84805.sendpatchset@dhcp83-188.boston.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 05:17:56PM -0500, tcamuso@redhat.com wrote:
> commit 307e3aecde8060af3802590f8c5bffb5456fe22b
> Author: Tony Camuso <tony.camuso@hp.com>
> Date:   Wed Dec 19 15:38:31 2007 -0500
> 
>     Modifies arch/x86/pci/direct.c to add the Legacy PCI Config routines
>     that will be made available, even when MMCONFIG is the platform default
>     PCI Config access mechanism. It also provides logic for selecting the
>     correct Legacy PCI Config access mechanism and the corresponding boot log
>     messages.
>     
>     Signed-off-by: Tony Camuso tony.camuso@hp.com
> 
> diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
> index 431c9a5..4e78002 100644
> --- a/arch/x86/pci/direct.c
> +++ b/arch/x86/pci/direct.c
> @@ -175,6 +175,32 @@ static struct pci_raw_ops pci_direct_conf2 = {
>  	.write =	pci_conf2_write,
>  };
>  
> +/*
> + * Legacy PCI Config read and write routines for buses that can't use
> + * MMCONFIG accesses in systems where MMCONFIG is the default PCI config
> + * access mechanism.
> + */
> +static struct pci_raw_ops *pci_legacy_conf;
> +
> +static int pci_ops_legacy_read(struct pci_bus *bus, unsigned int devfn,
> +			      int where, int size, u32 *value)
> +{
> +	return pci_legacy_conf->read(0, bus->number, devfn, where,
> +				     size, value);
> +}
> +
> +static int pci_ops_legacy_write(struct pci_bus *bus, unsigned int devfn,
> +			       int where, int size, u32 value)
> +{
> +	return pci_legacy_conf->write(0, bus->number, devfn, where,
> +				      size, value);
> +}
> +
> +struct pci_ops pci_legacy_ops = {
> +	.read =		pci_ops_legacy_read,
> +	.write =	pci_ops_legacy_write,
> +};

This whole structure is never used in this patch, why add it now?

>  /*
>   * Before we decide to use direct hardware access mechanisms, we try to do some
> @@ -258,18 +284,28 @@ void __init pci_direct_init(int type)
>  {
>  	if (type == 0)
>  		return;
> -	printk(KERN_INFO "PCI: Using configuration type %d\n", type);
> -	if (type == 1)
> +	if (type == 1) {
>  		raw_pci_ops = &pci_direct_conf1;
> -	else
> +		pci_legacy_conf = &pci_direct_conf1;
> +	} else {
>  		raw_pci_ops = &pci_direct_conf2;
> +		pci_legacy_conf = &pci_direct_conf2;

Why have two pointers to the same thing?  What is pci_legacy_conf going
to be used for?  Why not just use raw_pci_ops?

thanks,

greg k-h
