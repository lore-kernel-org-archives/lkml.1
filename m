Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZFCQsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZFCQsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbZFCQsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:48:15 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:10469 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbZFCQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:48:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 04/10] ACPI: Introduce acpi_get_pci_dev()
Date: Wed, 3 Jun 2009 10:46:35 -0600
User-Agent: KMail/1.9.10
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20090602152351.7346.48697.stgit@bob.kio> <20090602152456.7346.64853.stgit@bob.kio>
In-Reply-To: <20090602152456.7346.64853.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031046.36158.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009 09:24:56 am Alex Chiang wrote:
> Convert an ACPI CA handle to a struct pci_dev.
> 
> Performing this lookup dynamically allows us to get rid of the
> ACPI-PCI binding code, which:
> 
> 	- eliminates struct acpi_device vs struct pci_dev lifetime issues
> 	- lays more groundwork for eliminating .start from acpi_device_ops
> 	  and thus simplifying ACPI drivers
> 	- whacks out a lot of code
> 
> This change also changes the time-space tradeoff ever so slightly.
> 
> Looking up the ACPI-PCI binding is never in the performance path, and by
> eliminating this caching, we save 24 bytes for each _ADR device in the
> ACPI namespace.

Just for future changelog readers, I think this space savings actually
occurs in the "eviscerate pci_bind.c" patch where you remove the struct
acpi_pci_data.

I definitely agree that you're making the right time/space tradeoff.

> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/acpi/pci_bind.c     |   83 +++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/acpi_drivers.h |    1 +
>  2 files changed, 84 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
> index 236765c..584fa30 100644
> --- a/drivers/acpi/pci_bind.c
> +++ b/drivers/acpi/pci_bind.c
> @@ -56,6 +56,89 @@ static void acpi_pci_data_handler(acpi_handle handle, u32 function,
>  	return;
>  }
>  
> +struct acpi_handle_node {
> +	struct list_head node;
> +	acpi_handle handle;
> +};
> +
> +/**
> + * acpi_get_pci_dev - convert ACPI CA handle to struct pci_dev
> + * @handle: the handle in question
> + *
> + * Given an ACPI CA handle, the desired PCI device is located in the
> + * list of PCI devices.
> + *
> + * If the device is found, its reference count is increased and this
> + * function returns a pointer to its data structure.  The caller must
> + * decrement the reference count by calling pci_dev_put().
> + * If no device is found, %NULL is returned.
> + */
> +struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
> +{
> +	int dev, fn;
> +	unsigned long long adr;
> +	acpi_status status;
> +	acpi_handle phandle;
> +	struct pci_bus *pbus;
> +	struct pci_dev *pdev = NULL;
> +	struct acpi_handle_node *node, *tmp;
> +	struct acpi_pci_root *root;
> +	LIST_HEAD(device_list);
> +
> +	/*
> +	 * Walk up the ACPI CA namespace until we reach a PCI root bridge.
> +	 */
> +	phandle = handle;
> +	while (!acpi_is_root_bridge(phandle)) {
> +		node = kzalloc(sizeof(struct acpi_handle_node), GFP_KERNEL);
> +		if (!node)
> +			goto out;

Since there's no cleanup to do at "out", a simple "return NULL"
here is a bit more obvious.  Whoops, I think there actually *is*
a little cleanup to do -- I think we leak the list if we take
these early error exits.

> +
> +		INIT_LIST_HEAD(&node->node);
> +		node->handle = phandle;
> +		list_add(&node->node, &device_list);
> +
> +		status = acpi_get_parent(phandle, &phandle);
> +		if (ACPI_FAILURE(status))
> +			goto out;
> +	}
> +
> +	root = acpi_pci_find_root(phandle);
> +	if (!root)
> +		goto out;
> +
> +	pbus = pci_find_bus(root->id.segment, root->id.bus);
> +	if (!pbus)
> +		goto out;

Isn't this simply "root->bus"?

> +	/*
> +	 * Now, walk back down the PCI device tree until we return to our
> +	 * original handle. Assumes that everything between the PCI root
> +	 * bridge and the device we're looking for must be a P2P bridge.
> +	 */
> +	list_for_each_entry_safe(node, tmp, &device_list, node) {
> +		acpi_handle hnd = node->handle;
> +		status = acpi_evaluate_integer(hnd, "_ADR", NULL, &adr);
> +		if (ACPI_FAILURE(status))
> +			goto out;
> +		dev = (adr >> 16) & 0xffff;
> +		fn  = adr & 0xffff;
> +
> +		list_del(&node->node);
> +		kfree(node);
> +
> +		pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
> +		if (hnd == handle)
> +			break;
> +
> +		pbus = pdev->subordinate;
> +		pci_dev_put(pdev);
> +	}
> +out:
> +	return pdev;
> +}
> +EXPORT_SYMBOL_GPL(acpi_get_pci_dev);
> +
>  /**
>   * acpi_get_pci_id
>   * ------------------
> diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
> index bbe9207..1ef529b 100644
> --- a/include/acpi/acpi_drivers.h
> +++ b/include/acpi/acpi_drivers.h
> @@ -97,6 +97,7 @@ void acpi_pci_irq_del_prt(int segment, int bus);
>  
>  struct pci_bus;
>  
> +struct pci_dev *acpi_get_pci_dev(acpi_handle);
>  acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id);
>  int acpi_pci_bind_root(struct acpi_device *device, struct acpi_pci_id *id,
>  		       struct pci_bus *bus);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


