Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXCPGox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXCPGox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 02:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXCPGow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 02:44:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:56036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbXCPGos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 02:44:48 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] ACPI: ibm-acpi: allow module to load when acpi notifiers can't be set (v2)
Date: Fri, 16 Mar 2007 01:24:18 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Chris Wedgwood <cw@f00f.org>, ibm-acpi-devel@lists.sourceforge.net,
       kristen.c.accardi@intel.com
References: <20070315071019.GA22613@tuatara.stupidest.org> <20070315175113.GA6596@khazad-dum.debian.net> <20070315191506.GA14394@khazad-dum.debian.net>
In-Reply-To: <20070315191506.GA14394@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703160124.18942.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.


On Thursday 15 March 2007 15:15, Henrique de Moraes Holschuh wrote:
> This patch allows for ibm-acpi to coexist (with diminished functionality) with
> other drivers like ACPI_BAY.  ibm-acpi will simply disable the functions it is
> not able to register ACPI notifiers for.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Chris Wedgwood <cw@f00f.org>
> Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
> 
>  There was a minor problem in the first version of the patch, which I didn't
>  notice when backporting from acpi-test.  This is a fixed version.  Sorry
>  about this.
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

ok

thanks Henrique,
-Len


>  drivers/acpi/ibm_acpi.c |   19 ++++++++++++++++---
>  1 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
> index 3690136..dc10966 100644
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
> @@ -2553,6 +2558,8 @@ static int __init register_driver(struct ibm_struct *ibm)
>  	return ret;
>  }
>  
> +static void ibm_exit(struct ibm_struct *ibm);
> +
>  static int __init ibm_init(struct ibm_struct *ibm)
>  {
>  	int ret;
> @@ -2594,6 +2601,12 @@ static int __init ibm_init(struct ibm_struct *ibm)
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
