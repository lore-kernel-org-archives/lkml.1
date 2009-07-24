Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbZGXQfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbZGXQfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZGXQfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:35:43 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:35225 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZGXQfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:35:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH v3 1/2] ACPI: export acpi_pci_root and friends
Date: Fri, 24 Jul 2009 10:35:39 -0600
User-Agent: KMail/1.9.10
Cc: jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20090723230026.4247.12759.stgit@bob.kio> <20090723230300.4247.75347.stgit@bob.kio>
In-Reply-To: <20090723230300.4247.75347.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907241035.40074.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 July 2009 05:03:00 pm Alex Chiang wrote:
> We can simplify ACPI drivers if we can tell whether a handle is an
> ACPI PCI root or not.
> 
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>

Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

> ---
> 
>  drivers/acpi/pci_root.c |   17 ++---------------
>  include/acpi/acpi_bus.h |   16 ++++++++++++++++
>  2 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 55b5b90..31b961c 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -61,20 +61,6 @@ static struct acpi_driver acpi_pci_root_driver = {
>  		},
>  };
>  
> -struct acpi_pci_root {
> -	struct list_head node;
> -	struct acpi_device *device;
> -	struct pci_bus *bus;
> -	u16 segment;
> -	u8 bus_nr;
> -
> -	u32 osc_support_set;	/* _OSC state of support bits */
> -	u32 osc_control_set;	/* _OSC state of control bits */
> -	u32 osc_control_qry;	/* the latest _OSC query result */
> -
> -	u32 osc_queried:1;	/* has _OSC control been queried? */
> -};
> -
>  static LIST_HEAD(acpi_pci_roots);
>  
>  static struct acpi_pci_driver *sub_driver;
> @@ -317,7 +303,7 @@ static acpi_status acpi_pci_osc_support(struct acpi_pci_root *root, u32 flags)
>  	return status;
>  }
>  
> -static struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
> +struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
>  {
>  	struct acpi_pci_root *root;
>  
> @@ -327,6 +313,7 @@ static struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
>  	}
>  	return NULL;
>  }
> +EXPORT_SYMBOL_GPL(acpi_pci_find_root);
>  
>  struct acpi_handle_node {
>  	struct list_head node;
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index c65e4ce..c3ace75 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -369,10 +369,26 @@ int register_acpi_bus_type(struct acpi_bus_type *);
>  int unregister_acpi_bus_type(struct acpi_bus_type *);
>  struct device *acpi_get_physical_device(acpi_handle);
>  
> +struct acpi_pci_root {
> +	struct list_head node;
> +	struct acpi_device * device;
> +	struct acpi_pci_id id;
> +	struct pci_bus *bus;
> +	u16 segment;
> +	u8 bus_nr;
> +
> +	u32 osc_support_set;	/* _OSC state of support bits */
> +	u32 osc_control_set;	/* _OSC state of control bits */
> +	u32 osc_control_qry;	/* the latest _OSC query result */
> +
> +	u32 osc_queried:1;	/* has _OSC control been queried? */
> +};
> +
>  /* helper */
>  acpi_handle acpi_get_child(acpi_handle, acpi_integer);
>  int acpi_is_root_bridge(acpi_handle);
>  acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
> +struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
>  #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
>  
>  #ifdef CONFIG_PM_SLEEP
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


