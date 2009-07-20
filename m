Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZGTS1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZGTS1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZGTS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:27:34 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:27550 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZGTS1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:27:33 -0400
Date: Mon, 20 Jul 2009 11:27:32 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: len.brown@intel.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Isaacson <adi@vmware.com>,
       linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] tpm_tis: convert from pnp_driver to acpi_driver
Message-ID: <20090720182732.GL6370@hexapodia.org>
References: <1246410255-6839-1-git-send-email-adi@vmware.com> <1246410255-6839-6-git-send-email-adi@vmware.com> <20090701110136.576a1d14@lxorguk.ukuu.org.uk> <1246455920.9140.28.camel@blackbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246455920.9140.28.camel@blackbox>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 10:45:19AM -0300, Rajiv Andrade wrote:
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

Len,

Is this an acceptable change to pnpacpi?  It resolves an issue with
tpm_tis but I'm concerned that it might have far-reaching impact.

I've pasted in the problematic DSDT (manually fixing up whitespace to
make it more readable), and then a normal TPM simply has a _HID which
is matched by a pnp_device_id table in the driver
(drivers/char/tpm/tpm_tis.c).

T400:
        Device (TPM)
        {
            Method (_HID, 0, NotSerialized)
            {
                TPHY (0x00)
                If (LEqual (TPMV, 0x01)) { Return (0x0201D824) } 
                If (LEqual (TPMV, 0x02)) { Return (0x0435CF4D) } 
                If (LEqual (TPMV, 0x03)) { Return (0x02016D08) } 
                If (LEqual (TPMV, 0x04)) { Return (0x01016D08) } 
                If (LOr (LEqual (TPMV, 0x05), LEqual (TPMV, 0x06))) {
			Return (0x0010A35C)
		} 
                If (LEqual (TPMV, 0x08)) { Return (0x00128D06) } 
                If (LEqual (TPMV, 0x09)) { Return ("INTC0102") } 
                Return (0x310CD041)
            }

            Name (_CID, EisaId ("PNP0C31"))

standard TPM:
        Device (TPM)
        {
            Name (_HID, EisaId ("BCM0102"))
            Name (_CID, EisaId ("PNP0C31"))

The full thread is at
http://lkml.org/lkml/2009/7/1/265

Thanks for any insight.

-andy
