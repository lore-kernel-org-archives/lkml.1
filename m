Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZJEXii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZJEXii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZJEXii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:38:38 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36231 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZJEXih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:38:37 -0400
Date: Mon, 5 Oct 2009 17:37:59 -0600
From: Alex Chiang <achiang@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Danny Feng <dfeng@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>, chepioq@gmail.com
Subject: Re: [PATCH] ACPI / PCI: Fix NULL pointer dereference in
	acpi_get_pci_dev()
Message-ID: <20091005233759.GB14394@ldl.fc.hp.com>
References: <200910060130.43246.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910060130.43246.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl>:
> 
> Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14129, which is a
> regression from 2.6.30.

Thanks for doing this.

One small comment below (not major), but other than that:

Reviewed-by: Alex Chiang <achiang@hp.com>

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Danny Feng <dfeng@redhat.com>
> Tested-by: chepioq <chepioq@gmail.com>
> ---
>  drivers/acpi/pci_root.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -389,6 +389,18 @@ struct pci_dev *acpi_get_pci_dev(acpi_ha
>  
>  		pbus = pdev->subordinate;
>  		pci_dev_put(pdev);
> +
> +		/*
> +		 * During resume from a sleep state we can get a dock
> +		 * notification for a device that is present in ACPI tables,
> +		 * but not physically accessible at the moment, so tell the
> +		 * caller it's not present in that case.
> +		 */
> +		if (!pbus) {
> +			dev_info(&pdev->dev, "Secondary bus not present\n");

Should this be dev_dbg() or maybe even strike it completely?

> +			pdev = NULL;
> +			break;
> +		}
>  	}
>  out:
>  	list_for_each_entry_safe(node, tmp, &device_list, node)
> 
