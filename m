Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXFOQSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXFOQSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXFOQSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:18:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:49718 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbXFOQSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E+7wzpRbc/UECUC7TJVshuMl3IR3CUKvEa60ZqvSWpEeNnT5Eg0TqsGZ0RX92CIIpH8lusdY9YYqKgludl3nykHV4tFi3NGHJljeoPoRlfg8uaTcZWoGz5UevmyXcqf5Zvzn79nAUTzEmIvR5LzpMTxGwwlxxgwVOyG4BkFhTrM=
Message-ID: <4104961b0706150918me1d809fu66ee07738284c21c@mail.gmail.com>
Date: Sat, 16 Jun 2007 00:18:09 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: How to printk unsigned long long variable?
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <adaabv1i49q.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
	 <19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com>
	 <20070615083355.f5bdb784.randy.dunlap@oracle.com>
	 <4104961b0706150839t1a54ccdaq4ddc747d04538a19@mail.gmail.com>
	 <adaabv1i49q.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dma_mask should be a pointer, I mean, the element in struct device, see below,

struct device {
	struct list_head node;		/* node in sibling list */
	struct list_head bus_list;	/* node in bus's list */
	struct list_head driver_list;
	struct list_head children;
	struct device 	* parent;

	struct kobject kobj;
	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */

	struct bus_type	* bus;		/* type of bus device is on */
	struct device_driver *driver;	/* which driver has allocated this
					   device */
	void		*driver_data;	/* data private to the driver */
	void		*platform_data;	/* Platform specific data (e.g. ACPI,
					   BIOS data relevant to device) */
	struct dev_pm_info	power;

	u32		detach_state;	/* State to enter when device is
					   detached from its driver. */

	u64		*dma_mask;	/* dma mask (if dma'able device) */
	u64		coherent_dma_mask;/* Like dma_mask, but for
					     alloc_coherent mappings as
					     not all hardware supports
					     64 bit addresses for consistent
					     allocations such descriptors. */

	struct list_head	dma_pools;	/* dma pools (if dma'ble) */

	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
					     override */

	void	(*release)(struct device * dev);
};


Regards
Jason Xiao

On 6/16/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > Is this right?
>
>  >        dev->dev.dma_mask = bus->controller->dma_mask;
>  >        printk(KERN_ERR "hey,jason,see,dma_mask is
>  > %llu\n",*(dev->dev.dma_mask));
>
> No, why do you have the '*' -- dma_mask isn't a pointer, is it?
>
> You probably want:
>
>        printk(KERN_ERR "hey,jason,see,dma_mask is %llx\n",
>               (unsigned long long) dev->dev.dma_mask);
>
> (I would use a "%llx" format because masks are much clearer in hex).
> The cast to unsigned long long is there because u64 is just unsigned
> long on some 64-bit platforms, so you get a warning about the format
> not matching on some architectures without the cast.
>
>  - R.
>
