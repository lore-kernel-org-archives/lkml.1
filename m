Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZF3VMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZF3VMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZF3VL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:11:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbZF3VL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:11:57 -0400
Date: Tue, 30 Jun 2009 14:10:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-input@vger.kernel.org, jbarnes@virtuousgeek.org,
       david@hardeman.nu, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/2] ACPI: reintroduce acpi_device_ops .shutdown method
Message-Id: <20090630141047.c8c79b0b.akpm@linux-foundation.org>
In-Reply-To: <1246079912-17619-2-git-send-email-david@hardeman.nu>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu>
	<1246079912-17619-2-git-send-email-david@hardeman.nu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jun 2009 07:18:31 +0200
David H__rdeman <david@hardeman.nu> wrote:

> This reintroduces the .shutdown method which is used by the
> winbond-cir driver. A normal revert wasn't possible since there
> had been other changes to include/acpi/acpi_bus.h since.
> 
> Signed-off-by: David H__rdeman <david@hardeman.nu>
> ---
>  drivers/acpi/scan.c     |   12 ++++++++++++
>  include/acpi/acpi_bus.h |    2 ++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 781435d..c94ab13 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -464,10 +464,22 @@ static int acpi_device_remove(struct device * dev)
>  	return 0;
>  }
>  
> +static void acpi_device_shutdown(struct device *dev)
> +{
> +	struct acpi_device *acpi_dev = to_acpi_device(dev);
> +	struct acpi_driver *acpi_drv = acpi_dev->driver;
> +
> +	if (acpi_drv && acpi_drv->ops.shutdown)
> +		acpi_drv->ops.shutdown(acpi_dev);
> +
> +	return ;
> +}
> +
>  struct bus_type acpi_bus_type = {
>  	.name		= "acpi",
>  	.suspend	= acpi_device_suspend,
>  	.resume		= acpi_device_resume,
> +	.shutdown	= acpi_device_shutdown,
>  	.match		= acpi_bus_match,
>  	.probe		= acpi_device_probe,
>  	.remove		= acpi_device_remove,
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index c65e4ce..52da89a 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -96,6 +96,7 @@ typedef int (*acpi_op_resume) (struct acpi_device * device);
>  typedef int (*acpi_op_bind) (struct acpi_device * device);
>  typedef int (*acpi_op_unbind) (struct acpi_device * device);
>  typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
> +typedef int (*acpi_op_shutdown) (struct acpi_device * device);
>  
>  struct acpi_bus_ops {
>  	u32 acpi_op_add:1;
> @@ -112,6 +113,7 @@ struct acpi_device_ops {
>  	acpi_op_bind bind;
>  	acpi_op_unbind unbind;
>  	acpi_op_notify notify;
> +	acpi_op_shutdown shutdown;
>  };
>  
>  #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */

Len, Bjorn: is this OK?  Or is there some other mechanism which the
driver should have used?

Thanks.
