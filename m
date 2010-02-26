Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935787Ab0BZJsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:48:06 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45156 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935768Ab0BZJsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CNnRLzqVULKbgJixYRYHXpmucJZI7rRNyMagGgHwL+czxtxaWTU2aun/jF0PcAeWGc
         yyv734kJ2tJDdt4Ujelt7sBRllPOjIXte5Z0Vm0KL15vo/1DWi9an1QRB4dLIFwyIg0A
         HG6Y8UlIc6A4o1NRLeWCJAyvAsq7OgugQSU+4=
MIME-Version: 1.0
In-Reply-To: <20100226004646.GA31483@kroah.com>
References: <20100225164436.GA3310@kroah.com>
	 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
	 <20100225173611.GA14124@kroah.com>
	 <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
	 <20100225230639.GB20900@kroah.com>
	 <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
	 <20100226004646.GA31483@kroah.com>
Date: Fri, 26 Feb 2010 11:47:58 +0200
Message-ID: <269694c01002260147rb519956i676e6b352e9028f4@mail.gmail.com>
Subject: Re: Problem with auto-detecting a HV environment from within Linux
From: Ameya Palande <2ameya@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Feb 26, 2010 at 2:46 AM, Greg KH <greg@kroah.com> wrote:
>
> On Thu, Feb 25, 2010 at 11:40:52PM +0000, Haiyang Zhang wrote:
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Thursday, February 25, 2010 6:07 PM
> > > If so, what is the vendor and product id of this device?
> >
> > The Vendor:Device Id is: 1414:5353
> > 00:08.0 VGA compatible controller [0300]: Microsoft Corporation Device [1414:5353]
> >
> > This hasn't been changed since the first release of HyperV. I will ask
> > around about the future stability of the VGA card (and the DMI).
>
> Ok, below are 2 patches that I will queue up in my tree.
>
> Can you test them to verify that they work properly?
>
> thanks,
>
> greg k-h
>
> From: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: Staging: hv: add a pci device table
>
> This allows the HV core to be properly found and autoloaded
> by the system tools.
>
> It uses the Microsoft virtual VGA device to trigger this.
>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/hv/vmbus_drv.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -24,6 +24,7 @@
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/sysctl.h>
> +#include <linux/pci.h>
>  #include "VersionInfo.h"
>  #include "osd.h"
>  #include "logging.h"
> @@ -974,6 +975,22 @@ static void __exit vmbus_exit(void)
>        return;
>  }
>
> +/*
> + * We use a PCI table to determine if we should autoload this driver  This is
> + * needed by distro tools to determine if the hyperv drivers should be
> + * installed and/or configured.  We don't do anything else with the table, but
> + * it needs to be present.
> + *
> + * We might consider triggering off of DMI table info as well, as that does
> + * decribe the virtual machine being run on, but not all configuration tools
> + * seem to be able to handle DMI device ids properly.
> + */
> +const static struct pci_device_id microsoft_hv_pci_table[] = {

You can have:
const static DEFINE_PCI_DEVICE_TABLE(microsoft_hv_pci_table) = {

> +       { PCI_DEVICE(0x1414, 0x5353) }, /* VGA compatible controller */
> +       { 0 }
> +};
> +MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
> +

Cheers,
Ameya.
