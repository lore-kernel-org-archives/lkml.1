Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbXCOTaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbXCOTaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933078AbXCOTaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:30:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:47368 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbXCOTaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:30:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,289,1170662400"; 
   d="scan'208"; a="197114256:sNHT26166476"
Date: Thu, 15 Mar 2007 12:26:54 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Chris Wedgwood <cw@f00f.org>,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH] ACPI: ibm-acpi: allow module to load when acpi
 notifiers can't be set
Message-Id: <20070315122654.468bdd39.kristen.c.accardi@intel.com>
In-Reply-To: <20070315175113.GA6596@khazad-dum.debian.net>
References: <20070315071019.GA22613@tuatara.stupidest.org>
	<20070315175113.GA6596@khazad-dum.debian.net>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 14:51:14 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> This patch allows for ibm-acpi to coexist (with diminished functionality) with
> other drivers like ACPI_BAY.  ibm-acpi will simply disable the functions it is
> not able to register ACPI notifiers for.


this patch gives me the following compile error:

drivers/acpi/ibm_acpi.c: In function ‘ibm_init’:
drivers/acpi/ibm_acpi.c:2605: warning: implicit declaration of function ‘ibm_exit’
drivers/acpi/ibm_acpi.c: At top level:
drivers/acpi/ibm_acpi.c:2616: warning: conflicting types for ‘ibm_exit’
drivers/acpi/ibm_acpi.c:2616: error: static declaration of ‘ibm_exit’ follows non-static declaration
drivers/acpi/ibm_acpi.c:2605: error: previous implicit declaration of ‘ibm_exit’ was here



> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Chris Wedgwood <cw@f00f.org>
> Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
> 
>  Len, you can pull this patch from:
>  git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
>  branch for-upstream/acpi-release
> 
>  Please send it to Linus for merge in 2.6.21.
> 
>  It will clash with the patches in acpi-test that are waiting for 2.6.22.
>  I will rediff those, and send you a pull request when this patch
>  gets accepted in mainline.
> 
>  drivers/acpi/ibm_acpi.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
> index 3690136..f9f36f9 100644
> --- a/drivers/acpi/ibm_acpi.c
> +++ b/drivers/acpi/ibm_acpi.c
> @@ -2507,7 +2507,7 @@ static int __init setup_notify(struct ibm_struct *ibm)
>  	ret = acpi_bus_get_device(*ibm->handle, &ibm->device);
>  	if (ret < 0) {
>  		printk(IBM_ERR "%s device not present\n", ibm->name);
> -		return 0;
> +		return -ENODEV;
>  	}
>  
>  	acpi_driver_data(ibm->device) = ibm;
> @@ -2516,8 +2516,13 @@ static int __init setup_notify(struct ibm_struct *ibm)
>  	status = acpi_install_notify_handler(*ibm->handle, ibm->type,
>  					     dispatch_notify, ibm);
>  	if (ACPI_FAILURE(status)) {
> -		printk(IBM_ERR "acpi_install_notify_handler(%s) failed: %d\n",
> -		       ibm->name, status);
> +		if (status == AE_ALREADY_EXISTS) {
> +			printk(IBM_NOTICE "another device driver is already handling %s events\n",
> +				ibm->name);
> +		} else {
> +			printk(IBM_ERR "acpi_install_notify_handler(%s) failed: %d\n",
> +				ibm->name, status);
> +		}
>  		return -ENODEV;
>  	}
>  	ibm->notify_installed = 1;
> @@ -2594,6 +2599,12 @@ static int __init ibm_init(struct ibm_struct *ibm)
>  
>  	if (ibm->notify) {
>  		ret = setup_notify(ibm);
> +		if (ret == -ENODEV) {
> +			printk(IBM_NOTICE "disabling subdriver %s\n",
> +				ibm->name);
> +			ibm_exit(ibm);
> +			return 0;
> +		}
>  		if (ret < 0)
>  			return ret;
>  	}
> -- 
> 1.5.0.3
> 
> 
> -- 
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
> 
