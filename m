Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZBMGET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZBMGET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 01:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZBMGEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 01:04:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZBMGEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 01:04:04 -0500
Date: Fri, 13 Feb 2009 01:04:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Wenji Huang <wenji.huang@oracle.com>
cc: linux-kernel@vger.kernel.org, pq@iki.fi, mingo@elte.hu
Subject: Re: [PATCH 2/2] tracing: add checks for printing pci devices in
 mmiotrace.
In-Reply-To: <1234489341-18630-1-git-send-email-wenji.huang@oracle.com>
Message-ID: <alpine.DEB.1.10.0902130059570.15469@gandalf.stny.rr.com>
References: <1234489192-18594-1-git-send-email-wenji.huang@oracle.com> <1234489341-18630-1-git-send-email-wenji.huang@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Feb 2009, Wenji Huang wrote:

> This patch is to provide checking return value of trace_seq_printf
> so as to keep completeness of mmio_print_pcidev.
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  kernel/trace/trace_mmiotrace.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index c401b90..ebb0b61 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -56,17 +56,19 @@ static void mmio_trace_start(struct trace_array *tr)
>  	mmio_reset_data(tr);
>  }
>  
> -static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
> +static enum print_line_t mmio_print_pcidev(struct trace_seq *s,
> +					   const struct pci_dev *dev)
>  {
>  	int ret = 0;
>  	int i;
>  	resource_size_t start, end;
>  	const struct pci_driver *drv = pci_dev_driver(dev);
>  
> -	/* XXX: incomplete checks for trace_seq_printf() return value */
> -	ret += trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
> +	ret = trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
>  				dev->bus->number, dev->devfn,
>  				dev->vendor, dev->device, dev->irq);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
>  	/*
>  	 * XXX: is pci_resource_to_user() appropriate, since we are
>  	 * supposed to interpret the __ioremap() phys_addr argument based on
> @@ -74,21 +76,25 @@ static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
>  	 */
>  	for (i = 0; i < 7; i++) {
>  		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
> -		ret += trace_seq_printf(s, " %llx",
> +		ret = trace_seq_printf(s, " %llx",
>  			(unsigned long long)(start |
>  			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
> -	}
> -	for (i = 0; i < 7; i++) {
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;

The above looks like a change of logic to me. I'm a bit tired so I can be 
wrong. But it looks like the original was:

     for (i = 0; i < 7; i++) {
             pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
             ret += trace_seq_printf(s, " %llx",
                     (unsigned long long)(start |
                     (dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
     }
     for (i = 0; i < 7; i++) {
             pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
             ret += trace_seq_printf(s, " %llx",
                     dev->resource[i].start < dev->resource[i].end ?
                     (unsigned long long)(end - start) + 1 : 0);
     }

And the new is:

     for (i = 0; i < 7; i++) {
             pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
             ret = trace_seq_printf(s, " %llx",   
                     (unsigned long long)(start |
                     (dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
             if (!ret)
                     return TRACE_TYPE_PARTIAL_LINE;
             pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
             ret = trace_seq_printf(s, " %llx",
                     dev->resource[i].start < dev->resource[i].end ?
                     (unsigned long long)(end - start) + 1 : 0);
             if (!ret)
                     return TRACE_TYPE_PARTIAL_LINE;
     }

This changes the output format.

Pekka,

Is this OK?

-- Steve


>  		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
> -		ret += trace_seq_printf(s, " %llx",
> +		ret = trace_seq_printf(s, " %llx",
>  			dev->resource[i].start < dev->resource[i].end ?
>  			(unsigned long long)(end - start) + 1 : 0);
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
>  	}
>  	if (drv)
> -		ret += trace_seq_printf(s, " %s\n", drv->name);
> +		ret = trace_seq_printf(s, " %s\n", drv->name);
>  	else
> -		ret += trace_seq_printf(s, " \n");
> -	return ret;
> +		ret = trace_seq_printf(s, " \n");
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static void destroy_header_iter(struct header_iter *hiter)
> -- 
> 1.5.6
> 
> 
> 
