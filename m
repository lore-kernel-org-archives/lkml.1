Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYE2DDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYE2DDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYE2DDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:03:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbYE2DDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:03:10 -0400
Date: Wed, 28 May 2008 20:02:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Holger Macht <hmacht@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-Id: <20080528200227.80f708cd.akpm@linux-foundation.org>
In-Reply-To: <20080528143857.GB5585@homac.suse.de>
References: <20080528143857.GB5585@homac.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 16:38:57 +0200 Holger Macht <hmacht@suse.de> wrote:

> * Differentiate between bay devices in dock stations and others:
> 
>  - When an ACPI_NOTIFY_EJECT_REQUEST appears, just signal uevent to
>    userspace (that is when the optional eject button on a bay device is
>    pressed/pulled) giving the possibility to unmount file systems and to
>    clean up. Also, only send uevent in case we get an EJECT_REQUEST
>    without doing anything else. In other cases, you'll get an add/remove
>    event because libata attaches/detaches the device.
> 
>  - In case of a dock event, which in turn signals an
>    ACPI_NOTIFY_EJECT_REQUEST, immediately detach the device, because it
>    may already have been gone
> 
> * In case of an ACPI_NOTIFY_DEVICE/BUS_CHECK, evaluate _STA to check if
>   the device has been plugged or unplugged. If plugged, hotplug it, if
>   unplugged, just signal event to userspace
>   (initial patch by Matthew Garrett <mjg59@srcf.ucam.org>)
> 
> * Call ACPI _EJ0 for detached devices
> 
> ...
> 
> +static void ata_acpi_eject_device(acpi_handle handle)
> +{
> +	struct acpi_object_list arg_list;
> +	union acpi_object arg;
> +
> +	arg_list.count = 1;
> +	arg_list.pointer = &arg;
> +	arg.type = ACPI_TYPE_INTEGER;
> +	arg.integer.value = 1;

This might look nicer (and safer) if it used the

	union acpi_object arg = {
		.foo = bar,
		...
	};

form.  However this can cause gcc to emit poor code.

> +	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_EJ0",
> +					      &arg_list, NULL)))
> +		printk(KERN_ERR "Failed to evaluate _EJ0!\n");
> +}

It would be better if the printk were to self-identify where it is
coming from.  If your kernel just blurts "Failed to evaluate _EJ0!"
it's a bit of a head-scratcher.

"libata-acpi: failed to evaluate _EJ0", perhaps?


> +static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
> +{
> +	if (dev)
> +		dev->flags |= ATA_DFLAG_DETACH;
> +	else {
> +		struct ata_link *tlink;
> +		struct ata_device *tdev;
> +
> +		ata_port_for_each_link(tlink, ap)
> +			ata_link_for_each_dev(tdev, tlink)
> +				tdev->flags |= ATA_DFLAG_DETACH;
> +	}
> +
> +	ata_port_freeze(ap);
> +	ata_port_schedule_eh(ap);
> +}

I guess the significance of `dev==0' is known to those who are steeped
in ata_acpi_handle_hotplug() knowledge, but it's pretty inscrutable to
the occasional visitor.  Some comments would help.


