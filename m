Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZLTXvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZLTXvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 18:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZLTXvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 18:51:08 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:18000 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZLTXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 18:51:06 -0500
Subject: Re: [PATCH 4/12] pci: add failed_list to record failed one for
	pci_bus_assign_resources -v2
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <4B2BEC2C.7030503@kernel.org>
References: <4B2BE9DD.3040504@kernel.org>  <4B2BEC2C.7030503@kernel.org>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 16:45:11 -0700
Message-Id: <1261352711.26429.43.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 12:55 -0800, Yinghai Lu wrote:
> 
> so later we can do sth with those failed one
> 
> -v2: store start, end, flags aside. so could keep res cleared when assign
>      failed. and make following assignment of its children do not go wild
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   66 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 62 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -27,7 +27,52 @@
>  #include <linux/slab.h>
>  #include "pci.h"
>  
> -static void pbus_assign_resources_sorted(const struct pci_bus *bus)
> +struct resource_list_x {
> +	struct resource_list_x *next;
> +	struct resource *res;
> +	struct pci_dev *dev;
> +	resource_size_t start;
> +	resource_size_t end;
> +	unsigned long flags;
> +};
> +
> +static void add_to_failed_list(struct resource_list_x *head,
> +				 struct pci_dev *dev, struct resource *res)
> +{
> +	struct resource_list_x *list = head;
> +	struct resource_list_x *ln = list->next;
> +	struct resource_list_x *tmp;
> +
> +	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +	if (!tmp) {
> +		pr_warning("add_to_failed_list: kmalloc() failed!\n");
> +		return;
> +	}
> +
> +	tmp->next = ln;
> +	tmp->res = res;
> +	tmp->dev = dev;
> +	tmp->start = res->start;
> +	tmp->end = res->end;
> +	tmp->flags = res->flags;
> +	list->next = tmp;
> +}
> +
> +static void free_failed_list(struct resource_list_x *head)
> +{
> +	struct resource_list_x *list, *tmp;
> +
> +	for (list = head->next; list;) {
> +		tmp = list;
> +		list = list->next;
> +		kfree(tmp);
> +	}
> +
> +	head->next = NULL;
> +}

This patch adds a call to add_to_failed_list(), but no call to
free_failed_list(), so at first glance, this patch appears to introduce
a leak.  I see that it actually doesn't because you pass around a NULL
'fail_head', so you never actually call add_to_failed_list(), but it
would make more sense if you added the alloc and matching free in a
single patch.

> +static void pbus_assign_resources_sorted(const struct pci_bus *bus,
> +					 struct resource_list_x *fail_head)
>  {
>  	struct pci_dev *dev;
>  	struct resource *res;
> @@ -58,6 +103,13 @@ static void pbus_assign_resources_sorted
>  		res = list->res;
>  		idx = res - &list->dev->resource[0];
>  		if (pci_assign_resource(list->dev, idx)) {
> +			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
> +				/*
> +				 * device need to keep flags and size
> +				 * for next try
> +				 */
> +				add_to_failed_list(fail_head, list->dev, res);
> +			}
>  			res->start = 0;
>  			res->end = 0;
>  			res->flags = 0;
> @@ -575,19 +627,20 @@ void __ref pci_bus_size_bridges(struct p
>  }
>  EXPORT_SYMBOL(pci_bus_size_bridges);
>  
> -void __ref pci_bus_assign_resources(const struct pci_bus *bus)
> +static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
> +					 struct resource_list_x *fail_head)
>  {
>  	struct pci_bus *b;
>  	struct pci_dev *dev;
>  
> -	pbus_assign_resources_sorted(bus);
> +	pbus_assign_resources_sorted(bus, fail_head);
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		b = dev->subordinate;
>  		if (!b)
>  			continue;
>  
> -		pci_bus_assign_resources(b);
> +		__pci_bus_assign_resources(b, fail_head);
>  
>  		switch (dev->class >> 8) {
>  		case PCI_CLASS_BRIDGE_PCI:
> @@ -605,6 +658,11 @@ void __ref pci_bus_assign_resources(cons
>  		}
>  	}
>  }
> +
> +void __ref pci_bus_assign_resources(const struct pci_bus *bus)
> +{
> +	__pci_bus_assign_resources(bus, NULL);
> +}
>  EXPORT_SYMBOL(pci_bus_assign_resources);
>  
>  static void release_child_resources(struct resource *r)
> 
> 

