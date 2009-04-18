Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZDRHwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZDRHwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZDRHwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:52:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56233 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZDRHwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:52:39 -0400
Date: Sat, 18 Apr 2009 09:51:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] pci: keep pci device resource name pointer right.
Message-ID: <20090418075130.GK7678@elte.hu>
References: <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E96731.1000501@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix bug

i think this needs to be marked Cc: <stable@kernel.org> as well, for 
2.6.29.x, maybe even 2.6.28.x ?

( Please note a small commit log detail: a few days go we started 
  putting impact lines to the end of the commit as 'footers', in 
  square brackets - right before the signoff lines. We do this to 
  move them closer to other mechanic-looking tags and to not intrude 
  the flow of the natural-language story line of the commit.

  Also note that 'fix bug' is not a good impact line even if it was 
  a footer, because it does not really summarize the effects of a 
  patch specifically enough. A better variant would be:

     [ Impact: fix corrupted names in /proc/iomem ]

  I've inserted this impact line into your commit below, to show the 
  exact placement we started using. Note, this impact line would 
  also be a perfect summary line, if the 'pci: ' tag is added before 
  it:

     pci: fix corrupted names in /proc/iomem

  Jesse or Linus might opt to remove the impact line - it's a per 
  subsystem discretion thing. )

	Ingo

> notice one system /proc/iomem some entries missed the name for pci_devices
> 
> # cat /proc/iomem
> 00000000-000973ff : System RAM
> 00097400-0009ffff : reserved
> 000a0000-000bffff : PCI Bus #00
> 000c0000-000cffff : pnp 00:0c
> 000e0000-000fffff : reserved
> 00100000-b7f9ffff : System RAM
>  00200000-00c67b4b : Kernel code
>  00c67b4c-01331edf : Kernel data
>  015a5000-01fc9657 : Kernel bss
>  20000000-23ffffff : GART
> b7fae000-b7faffff : System RAM
> b7fb0000-b7fbdfff : ACPI Tables
> b7fbe000-b7feffff : ACPI Non-volatile Storage
> b7ff0000-b7ffffff : reserved
> b8000000-beffffff : PCI Bus #00
> bf000000-bfffffff : PCI Bus #80
>  bfe80000-bfebffff : pnp 00:0e
>  bfef9000-bfef9fff :
>    bfef9000-bfef9fff : forcedeth
>  bfefa000-bfefa00f :
>    bfefa000-bfefa00f : forcedeth
>  bfefa400-bfefa4ff :
>    bfefa400-bfefa4ff : forcedeth
>  bfefa800-bfefa80f :
>    bfefa800-bfefa80f : forcedeth
>  bfefac00-bfefacff :
>    bfefac00-bfefacff : forcedeth
>  bfefb000-bfefbfff :
>    bfefb000-bfefbfff : forcedeth
>  bfefc000-bfefcfff :
>    bfefc000-bfefcfff : sata_nv
>  bfefd000-bfefdfff :
>    bfefd000-bfefdfff : sata_nv
>  bfefe000-bfefefff :
>    bfefe000-bfefefff : sata_nv
>  bfeff000-bfefffff : IOAPIC 1
>    bfeff000-bfefffff :
> ...
> 
> it turns that we need to reget res->name because dev->dev.kobj name is changed
> after device_add.
> 
> [ Impact: fix corrupted names in /proc/iomem ]
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/bus.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> Index: linux-2.6/drivers/pci/bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/bus.c
> +++ linux-2.6/drivers/pci/bus.c
> @@ -70,6 +70,19 @@ pci_bus_alloc_resource(struct pci_bus *b
>  	return ret;
>  }
>  
> +static void pci_dev_update_res_name(struct pci_dev *dev)
> +{
> +	int idx;
> +
> +	/* after device_add will get new name, reget it */
> +	for (idx = 0; idx <= PCI_ROM_RESOURCE; idx++) {
> +		struct resource *res = &dev->resource[idx];
> +
> +		if (res->name)
> +			res->name = pci_name(dev);
> +	}
> +}
> +
>  /**
>   * pci_bus_add_device - add a single device
>   * @dev: device to add
> @@ -84,6 +97,7 @@ int pci_bus_add_device(struct pci_dev *d
>  	if (retval)
>  		return retval;
>  
> +	pci_dev_update_res_name(dev);
>  	dev->is_added = 1;
>  	pci_proc_attach_device(dev);
>  	pci_create_sysfs_dev_files(dev);
