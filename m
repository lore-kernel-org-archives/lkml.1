Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYHRRNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYHRRNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYHRRNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:13:32 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:42090 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752891AbYHRRNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:13:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=L82sCeYJSV7zqMwNyN3Z+zwbv4Cn2DV5AfTuCQQ4OJ+x1sIeJrAaOkOWe4QWAqdNFELBjgzErHHbWc5Sz6rOTdQTbTlBtwU+OEDQQ7gyvkzu3LrHYsFuFhPaaViSwFdH;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Mon, 18 Aug 2008 10:13:17 -0700
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
References: <for-27-patch1-0@bga.com> <20080816062259.GB20541@kroah.com> <20080817210659.06601a3b@hyperion.delvare>
In-Reply-To: <20080817210659.06601a3b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181013.18189.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 17, 2008 12:06 pm Jean Delvare wrote:
> Hi all,
> From: Jean Delvare <khali@linux-fr.org>
> Subject: PCI: Check dynids driver_data value for validity
>
> Only accept dynids those driver_data value matches one of the driver's
> pci_driver_id entry. This prevents the user from accidentally passing
> values the drivers do not expect.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Milton Miller <miltonm@bga.com>
> Cc: Greg KH <greg@kroah.com>
> ---
>  Documentation/PCI/pci.txt       |    4 ++++
>  drivers/i2c/busses/i2c-amd756.c |    4 ----
>  drivers/i2c/busses/i2c-viapro.c |    4 ----
>  drivers/pci/pci-driver.c        |   18 ++++++++++++++++--
>  4 files changed, 20 insertions(+), 10 deletions(-)
>
> --- linux-2.6.27-rc3.orig/Documentation/PCI/pci.txt	2008-08-17
> 18:24:33.000000000 +0200 +++
> linux-2.6.27-rc3/Documentation/PCI/pci.txt	2008-08-17 18:24:38.000000000
> +0200 @@ -163,6 +163,10 @@ need pass only as many optional fields a
>  	o class and classmask fields default to 0
>  	o driver_data defaults to 0UL.
>
> +Note that driver_data must match the value used by any of the
> pci_device_id +entries defined in the driver. This makes the driver_data
> field mandatory +if all the pci_device_id entries have a non-zero
> driver_data value. +
>  Once added, the driver probe routine will be invoked for any unclaimed
>  PCI devices listed in its (newly updated) pci_ids list.
>
> --- linux-2.6.27-rc3.orig/drivers/i2c/busses/i2c-amd756.c	2008-08-17
> 17:15:57.000000000 +0200 +++
> linux-2.6.27-rc3/drivers/i2c/busses/i2c-amd756.c	2008-08-17
> 19:42:14.000000000 +0200 @@ -332,10 +332,6 @@ static int __devinit
> amd756_probe(struct
>  	int error;
>  	u8 temp;
>
> -	/* driver_data might come from user-space, so check it */
> -	if (id->driver_data >= ARRAY_SIZE(chipname))
> -		return -EINVAL;
> -
>  	if (amd756_ioport) {
>  		dev_err(&pdev->dev, "Only one device supported "
>  		       "(you have a strange motherboard, btw)\n");
> --- linux-2.6.27-rc3.orig/drivers/i2c/busses/i2c-viapro.c	2008-08-17
> 17:15:57.000000000 +0200 +++
> linux-2.6.27-rc3/drivers/i2c/busses/i2c-viapro.c	2008-08-17
> 19:42:24.000000000 +0200 @@ -320,10 +320,6 @@ static int __devinit
> vt596_probe(struct
>  	unsigned char temp;
>  	int error = -ENODEV;
>
> -	/* driver_data might come from user-space, so check it */
> -	if (id->driver_data & 1 || id->driver_data > 0xff)
> -		return -EINVAL;
> -
>  	/* Determine the address of the SMBus areas */
>  	if (force_addr) {
>  		vt596_smba = force_addr & 0xfff0;
> --- linux-2.6.27-rc3.orig/drivers/pci/pci-driver.c	2008-08-17
> 17:15:57.000000000 +0200 +++
> linux-2.6.27-rc3/drivers/pci/pci-driver.c	2008-08-17 19:17:55.000000000
> +0200 @@ -43,18 +43,32 @@ store_new_id(struct device_driver *drive
>  {
>  	struct pci_dynid *dynid;
>  	struct pci_driver *pdrv = to_pci_driver(driver);
> +	const struct pci_device_id *ids = pdrv->id_table;
>  	__u32 vendor, device, subvendor=PCI_ANY_ID,
>  		subdevice=PCI_ANY_ID, class=0, class_mask=0;
>  	unsigned long driver_data=0;
>  	int fields=0;
> -	int retval = 0;
> +	int retval;
>
> -	fields = sscanf(buf, "%x %x %x %x %x %x %lux",
> +	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
>  			&vendor, &device, &subvendor, &subdevice,
>  			&class, &class_mask, &driver_data);
>  	if (fields < 2)
>  		return -EINVAL;
>
> +	/* Only accept driver_data values that match an existing id_table
> +	   entry */
> +	retval = -EINVAL;
> +	while (ids->vendor || ids->subvendor || ids->class_mask) {
> +		if (driver_data == ids->driver_data) {
> +			retval = 0;
> +			break;
> +		}
> +		ids++;
> +	}
> +	if (retval)	/* No match */
> +		return retval;
> +
>  	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
>  	if (!dynid)
>  		return -ENOMEM;
>
>
> * * * * *
>
> The patch above applies on top of Milton's patch removing
> dynids.use_driver_data.

Looks good; I think we'll want to put this into linux-next along with Milton's 
change.  I'll push them out after a quick smoke test.

Thanks,
Jesse
