Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYKZI2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYKZI2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYKZI20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:28:26 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:1605 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYKZI2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:28:25 -0500
Date: Wed, 26 Nov 2008 09:28:08 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: jbarnes@virtuousgeek.org, greg@kroah.com, miltonm@bga.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, allen.m.kay@intel.com, jun.nakajima@intel.com
Subject: Re: [PATCH 1/2] PCI: allow pci driver to support only dynids
Message-ID: <20081126092808.48519dcb@hyperion.delvare>
In-Reply-To: <20081126033610.GB19881@sequoia.sous-sol.org>
References: <20081126033610.GB19881@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Tue, 25 Nov 2008 19:36:10 -0800, Chris Wright wrote:
> commit b41d6cf38e27 (PCI: Check dynids driver_data value for validity)
> requires all drivers to include an id table to try and match
> driver_data.  Before validating driver_data check driver has an id
> table.

Sorry for missing this case.

> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Milton Miller <miltonm@bga.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  drivers/pci/pci-driver.c |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index b4cdd69..0a5edbe 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -48,7 +48,7 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
>  		subdevice=PCI_ANY_ID, class=0, class_mask=0;
>  	unsigned long driver_data=0;
>  	int fields=0;
> -	int retval;
> +	int retval=0;
>  
>  	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
>  			&vendor, &device, &subvendor, &subdevice,
> @@ -58,16 +58,18 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
>  
>  	/* Only accept driver_data values that match an existing id_table
>  	   entry */
> -	retval = -EINVAL;
> -	while (ids->vendor || ids->subvendor || ids->class_mask) {
> -		if (driver_data == ids->driver_data) {
> -			retval = 0;
> -			break;
> +	if (ids) {
> +		retval = -EINVAL;
> +		while (ids->vendor || ids->subvendor || ids->class_mask) {
> +			if (driver_data == ids->driver_data) {
> +				retval = 0;
> +				break;
> +			}
> +			ids++;
>  		}
> -		ids++;
> +		if (retval)	/* No match */
> +			return retval;
>  	}
> -	if (retval)	/* No match */
> -		return retval;
>  
>  	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
>  	if (!dynid)

Do we really want to let the user add a new id to a driver which didn't
have any? Wouldn't it be safer to simply not create the new_id sysfs
file if driver->id_table is NULL? That's a one-line change:

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/pci/pci-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.28-rc6.orig/drivers/pci/pci-driver.c	2008-10-24 09:28:14.000000000 +0200
+++ linux-2.6.28-rc6/drivers/pci/pci-driver.c	2008-11-26 09:23:46.000000000 +0100
@@ -113,7 +113,7 @@ static int
 pci_create_newid_file(struct pci_driver *drv)
 {
 	int error = 0;
-	if (drv->probe != NULL)
+	if (drv->probe != NULL && drv->id_table != NULL)
 		error = driver_create_file(&drv->driver, &driver_attr_new_id);
 	return error;
 }

As a side note, I am curious what PCI driver we do have which has
driver->probe defined but no driver->id_table. Did you hit an actual
issue or are you fixing a theoretical one?

Thanks,
-- 
Jean Delvare
