Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYDRVsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYDRVsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYDRVsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:48:38 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:44286 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYDRVsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:48:37 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: pnpacpi: reduce printk severity for "pnpacpi: exceeded the max number of ..."
Date: Fri, 18 Apr 2008 15:48:33 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linux-acpi@vger.kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>
References: <20080417010122.148289106@sous-sol.org> <20080417010359.629397865@sous-sol.org>
In-Reply-To: <20080417010359.629397865@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804181548.33872.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008 07:02:20 pm Chris Wright wrote:
> -stable review patch.  If anyone has any objections, please let us know.

I don't object to the point of the patch (changing KERN_ERR to
KERN_WARNING), but there is a more serious bug lurking here that
corrupts memory, and if we're doing a -stable patch, we should
fix it.

The test is:

	if (i >= PNP_MAX_IRQ && !warned) {
		printk(...);
		warned = 1;
		return;
	}

But it should be:

	if (i >= PNP_MAX_IRQ) {
		if (!warned) {
			printk(...);
			warned = 1;
		}
		return;
	}

> --- a/drivers/pnp/pnpacpi/rsparser.c
> +++ b/drivers/pnp/pnpacpi/rsparser.c
> @@ -85,7 +85,7 @@ static void pnpacpi_parse_allocated_irqr
>  	       i < PNP_MAX_IRQ)
>  		i++;
>  	if (i >= PNP_MAX_IRQ && !warned) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
> +		printk(KERN_WARNING "pnpacpi: exceeded the max number of IRQ "
>  				"resources: %d \n", PNP_MAX_IRQ);
>  		warned = 1;
>  		return;
> @@ -187,7 +187,7 @@ static void pnpacpi_parse_allocated_dmar
>  		res->dma_resource[i].start = dma;
>  		res->dma_resource[i].end = dma;
>  	} else if (!warned) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
> +		printk(KERN_WARNING "pnpacpi: exceeded the max number of DMA "
>  				"resources: %d \n", PNP_MAX_DMA);
>  		warned = 1;
>  	}
> @@ -213,7 +213,7 @@ static void pnpacpi_parse_allocated_iore
>  		res->port_resource[i].start = io;
>  		res->port_resource[i].end = io + len - 1;
>  	} else if (!warned) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
> +		printk(KERN_WARNING "pnpacpi: exceeded the max number of IO "
>  				"resources: %d \n", PNP_MAX_PORT);
>  		warned = 1;
>  	}
> @@ -241,7 +241,7 @@ static void pnpacpi_parse_allocated_memr
>  		res->mem_resource[i].start = mem;
>  		res->mem_resource[i].end = mem + len - 1;
>  	} else if (!warned) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
> +		printk(KERN_WARNING "pnpacpi: exceeded the max number of mem "
>  				"resources: %d\n", PNP_MAX_MEM);
>  		warned = 1;
>  	}
> 


