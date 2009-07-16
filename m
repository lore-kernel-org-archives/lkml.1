Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbZGPR1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbZGPR1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbZGPR1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:27:04 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:56142 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbZGPR1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:27:02 -0400
Subject: Re: [PATCH 5/6] tpm_tis: convert from pnp_driver to acpi_driver
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, adi@hexapodia.org, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <1246455920.9140.28.camel@blackbox>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-6-git-send-email-adi@vmware.com>
	 <20090701110136.576a1d14@lxorguk.ukuu.org.uk>
	 <1246455920.9140.28.camel@blackbox>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 14:26:50 -0300
Message-Id: <1247765210.30736.3.camel@dyn531421.br.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Realized just now that this message was stuck in my outbox and was never
sent.. Anyway, here it is. The ones who own the chip, please let me know
if the patches here work OK.

Rajiv

On Wed, 2009-07-01 at 10:46 -0300, Rajiv Andrade wrote:
> On Wed, 2009-07-01 at 11:01 +0100, Alan Cox wrote:
> > On Tue, 30 Jun 2009 18:04:14 -0700
> > Andy Isaacson <adi@vmware.com> wrote:
> > 
> > > Not all TIS-compatible TPM chips have a _HID method in their ACPI entry,
> > > and the TPM spec says that the _CID method should be used to enumerate
> > > the TPM chip.
> > 
> > There are a number of systems with TPMs (older laptops) that don't work
> > very well if you enable ACPI.
> > 
> > This is therefore a regression - NAK
> > 
> > Probably the best thing to do is to provide both ACPI and PnP
> > registration according to what is configured into the kernel. (And I
> > guess spot duplicates although the resource should be busy anyway)
> > --
> David sent this earlier when I said that PNP didn't work with this chip:
>         
> <quote>
> The problem here is acpi pnp but the fix is really simple. The current
> pnpacpi/core.c routine that looks for isapnp devices enumerated in acpi
> enforces that the acpi hid be a valid isapnp id (the formats are
> slightly different). But that's broken: it shoudl be enforcing that
> either the acpi hid or any acpi cids be valid isapnp ids. It's a
> one-line change to do this, see patch 2. 
> 
> commit 7a553b4e7439ad0733da7da8663d32aa4865aa9e
> Author: David Smith <dds@google.com>
> Date:   Tue Apr 28 18:52:02 2009 +0900
> 
>     Update ACPI PNP to support devices with EISA PNP CIDs but non-PNP HIDs
>     
>     Signed-off-by: David Smith <dds@google.com>
> 
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index 9496494..8bfddfb 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -159,8 +159,8 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>  	 * driver should not be loaded.
>  	 */
>  	status = acpi_get_handle(device->handle, "_CRS", &temp);
> -	if (ACPI_FAILURE(status) || !ispnpidacpi(acpi_device_hid(device)) ||
> -	    is_exclusive_device(device) || (!device->status.present))
> +	if (ACPI_FAILURE(status) || is_exclusive_device(device) ||
> +            (!device->status.present))
>  		return 0;
>  
>  	dev = pnp_alloc_dev(&pnpacpi_protocol, num, acpi_device_hid(device));
> 
> </quote>
> 
> If so, we can just base our DATA_EXPECT bypass on the EISA PNP CID:
> 
> >From 47516ff6b63b81d1e806148dc5e3052a001e45d0 Mon Sep 17 00:00:00 2001
> From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> Date: Wed, 1 Jul 2009 09:59:55 -0300
> Subject: [PATCH] TPM: DATA_EXPECT bit check bypass
> 
> Since the iTPM doesn't set the DATA_EXPECT bit when it should, we bypass
> this bit check in case we're running the code over this specific TPM.
> 
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm.h     |    1 +
>  drivers/char/tpm/tpm_tis.c |   11 ++++++++++-
>  2 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 8e00b4d..ed4ecf0 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -109,6 +109,7 @@ struct tpm_chip {
>  
>  	struct list_head list;
>  	void (*release) (struct device *);
> +	bool is_itpm;
>  };
>  
>  #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index aec1931..74a60d7 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -27,6 +27,7 @@
>  #include "tpm.h"
>  
>  #define TPM_HEADER_SIZE 10
> +#define ITPM_ID "INTC0102"
>  
>  enum tis_access {
>  	TPM_ACCESS_VALID = 0x80,
> @@ -293,7 +294,9 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  		wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
>  			      &chip->vendor.int_queue);
>  		status = tpm_tis_status(chip);
> -		if ((status & TPM_STS_DATA_EXPECT) == 0) {
> +		/* iTPM never sets the DATA_EXPECT bit */
> +		if (((status & TPM_STS_DATA_EXPECT) == 0) &&
> +		     (!chip->is_itpm)) {
>  			rc = -EIO;
>  			goto out_err;
>  		}
> @@ -582,6 +585,12 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  	tpm_get_timeouts(chip);
>  	tpm_continue_selftest(chip);
>  
> +	for (i=0; i < 8; i++)
> +		if (ITPM_ID[i] != to_pnp_dev(dev)->id->id[i])
> +			break;
> +	if (i == 8)
> +		chip->is_itpm = 1;
> +
>  	return 0;
>  out_err:
>  	if (chip->vendor.iobase)

