Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbZAIXYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbZAIXYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932751AbZAIXXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:23:21 -0500
Received: from outbound-mail-106.bluehost.com ([69.89.22.6]:36660 "HELO
	outbound-mail-106.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932276AbZAIXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:23:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=FYtQJa07sVn7YlV0qWm59aVaeGKLlcOTpj+Ckj64R4G0yg4d1+L7rmEhyRvr5wKZFAQ6qiDAjHmbTlNnekEDeLgoCsImhfqJ9rxDqp25aLfluuMo591jEuYz7z72AjKn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/8] PCI PCIe portdrv: Aviod using service devices with wrong interrupts
Date: Fri, 9 Jan 2009 15:23:17 -0800
User-Agent: KMail/1.9.10
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901042350.00158.rjw@sisk.pl>
In-Reply-To: <200901042350.00158.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091523.18308.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 4, 2009 2:49 pm Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The PCI Express port driver should not attempt to register service
> devices that require the ability to generate interrupts if generating
> interrupts is not possible.  Namely, if the port has no interrupt pin
> configured and we cannot set up MSI or MSI-X for it, there is no way
> it can generate interrupts and in such a case the port services that
> rely on interrupts (PME, PCIe HP, AER) should not be enabled for it.
>

>  /* Root/Upstream/Downstream Port's Interrupt Mode */
> +#define PCIE_PORT_NO_IRQ		(-1)
>  #define PCIE_PORT_INTx_MODE		0
>  #define PCIE_PORT_MSI_MODE		1
>  #define PCIE_PORT_MSIX_MODE		2
> Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
> +++ linux-2.6/drivers/pci/pcie/portdrv_core.c
> @@ -41,13 +41,15 @@ static void release_pcie_device(struct d
>  static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int
> mask) {
>  	int i, pos, nvec, status = -EINVAL;
> -	int interrupt_mode = PCIE_PORT_INTx_MODE;
> +	int interrupt_mode = PCIE_PORT_NO_IRQ;
>
>  	/* Set INTx as default */
>  	for (i = 0, nvec = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
>  		if (mask & (1 << i))
>  			nvec++;
>  		vectors[i] = dev->irq;
> +		if (dev->pin)
> +			interrupt_mode = PCIE_PORT_INTx_MODE;
>  	}


Looks like a good cleanup.  I didn't audit all the places PCIE_PORT_* stuff 
was used to see if != would be a problem though (probably isn't).

-- 
Jesse Barnes, Intel Open Source Technology Center
