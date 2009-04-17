Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZDQVvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZDQVvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZDQVvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:51:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:39673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZDQVvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:51:12 -0400
Subject: Re: dma-debug: add a check dma memory leaks
From: David Woodhouse <dwmw2@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, reinette.chatre@intel.com,
       benh@kernel.crashing.org, greg@kroah.com
In-Reply-To: <200903302101.n2UL1O1n011970@hera.kernel.org>
References: <200903302101.n2UL1O1n011970@hera.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 22:51:05 +0100
Message-Id: <1240005065.19059.19.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 21:01 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/41531c8f5f05aba5ec645d9770557eedbf75b422
> Commit:     41531c8f5f05aba5ec645d9770557eedbf75b422

>     dma-debug: add a check dma memory leaks
>     
>     Impact: allow architectures to monitor busses for dma mem leakage
>     
>     This patch adds checking code to detect if a device has pending DMA
>     operations when it is about to be unbound from its device driver.
>     
>     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>


> +static int dma_debug_device_change(struct notifier_block *nb,
> +				    unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +	int count;
> +
> +
> +	switch (action) {
> +	case BUS_NOTIFY_UNBIND_DRIVER:
> +		count = device_dma_allocations(dev);
> +		if (count == 0)
> +			break;
> +		err_printk(dev, NULL, "DMA-API: device driver has pending "
> +				"DMA allocations while released from device "
> +				"[count=%d]\n", count);

Hm, cute... but not quite functioning as you intended. If you look at
__device_release_driver() in drivers/base/dd.c you'll see it actually
calls the notifier _before_ calling into the driver's ->remove() method.
So it's hardly surprising that not everything has been freed yet...

Reported by Reinette when it bit iwlwifi.

Ben, can we get away with changing the order so that the ->remove() is
called before the notifier, in this case? 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

