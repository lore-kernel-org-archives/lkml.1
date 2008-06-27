Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbYF0Rf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbYF0Rf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYF0RfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:35:11 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:33948 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753544AbYF0RfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:35:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gz7PkUigHvpfiRNKifp/WFfAnC/pEoP6Xn3C3MN3DfP+mhO9sXQou99phRnGb8n+CzrXNpmkieanLsbIqyQ4Ka5ZhCvGTIPMBAlpVWdsbM9hxq0IWJMVjvjIC2R2cmKMcxC4JryoBT1jdOKFZWoXMgLvjkOGryvS1ukjzga6rDA=  ;
X-YMail-OSG: KfKPR7cVM1nYo6xYgNA_3Acsy1Xr0E3UISgc_GfD7pl3DhosvjWu22S1OMWFWBoEemXOQZcOXoM_xMhdUgwtTt49qPvInLmJYk08VCaiG0_H3Tj1u7nQGSZMuJMMURMi._7HPyXRass13jAIsvQNYmzP
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for AVR32 users
Date: Fri, 27 Jun 2008 09:37:21 -0700
User-Agent: KMail/1.9.9
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Adrian Bunk <bunk@kernel.org>, Pierre Ossman <drzeus-list@drzeus.cx>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       kernel@avr32linux.org, "Nelson, Shannon" <shannon.nelson@intel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com> <20080626164601.712bf048@hskinnemo-gx745.norway.atmel.com> <1214528379.32709.51.camel@dwillia2-linux.ch.intel.com>
In-Reply-To: <1214528379.32709.51.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806270937.21850.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Dan Williams wrote:
> I agree with removing the arch dependency, and I do not think we
> necessarily need to add HAVE_DMA_ENGINE.

I think a HAVE_DMA_ENGINE would be better than what you're doing
below:  moving the arch dependency into the network code, and
adding this !HIGHMEM64G thing (which is really just a more subtle
arch dependency).

Note that HAS_DMA is very different from having DMA engine support...
one is a specific interface, the other is the generic mechanism with
any of its numerous (and often peripheral-specific) interfaces.


> Taking an example from libata 
> the SATA_FSL driver depends on FSL_SOC but the menuconfig for ATA does
> not.  We can use "depends on HAS_DMA" to make the menu disappear on
> archs that will never have a dmaegine.  So I propose the following:
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 6239c3d..e4dd006 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -4,13 +4,14 @@
>  
>  menuconfig DMADEVICES
>  	bool "DMA Engine support"
> -	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || PPC
> -	depends on !HIGHMEM64G
> +	depends on !HIGHMEM64G && HAS_DMA
>  	help
>  	  DMA engines can do asynchronous data transfers without
>  	  involving the host CPU.  Currently, this framework can be
>  	  used to offload memory copies in the network stack and
> -	  RAID operations in the MD driver.
> +	  RAID operations in the MD driver.  This menu only presents
> +	  DMA Device drivers supported by the configured arch, it may
> +	  be empty in some cases.
>  
>  if DMADEVICES
>  
> @@ -55,10 +56,12 @@ comment "DMA Clients"
>  config NET_DMA
>  	bool "Network: TCP receive copy offload"
>  	depends on DMA_ENGINE && NET
> +	default (INTEL_IOATDMA || FSL_DMA)
>  	help
>  	  This enables the use of DMA engines in the network stack to
>  	  offload receive copy-to-user operations, freeing CPU cycles.
> -	  Since this is the main user of the DMA engine, it should be enabled;
> -	  say Y here.
> +
> +	  Say Y here if you enabled INTEL_IOATDMA or FSL_DMA, otherwise
> +	  say N.
>  
>  endif
> 
> 
> 


