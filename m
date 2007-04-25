Return-Path: <linux-kernel-owner+w=401wt.eu-S2992987AbXDYTX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992987AbXDYTX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992985AbXDYTX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:23:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:40728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992980AbXDYTXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:23:25 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Wed, 25 Apr 2007 15:22:04 -0400
User-Agent: KMail/1.9.5
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linux ACPI list <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200704031741.42273.david-b@pacbell.net>
In-Reply-To: <200704031741.42273.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251522.04303.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied,
and thanks for turning over the rocks in sysfs to see what wiggled out:-)

thanks,
-Len

On Tuesday 03 April 2007 20:41, David Brownell wrote:
> This updates /proc/acpi/wakeup to be more informative, primarily by showing
> the sysfs node associated with each wakeup-enabled device.  Example:
> 
> 	Device	S-state	  Status   Sysfs node
> 	PCI0	  S4	 disabled  no-bus:pci0000:00
> 	PS2M	  S4	 disabled  pnp:00:05
> 	PS2K	  S4	 disabled  pnp:00:06
> 	UAR1	  S4	 disabled  pnp:00:08
> 	USB1	  S3	 disabled  pci:0000:00:03.0
> 	USB2	  S3	 disabled  pci:0000:00:03.1
> 	USB3	  S3	 disabled  
> 	USB4	  S3	 disabled  pci:0000:00:03.3
> 	S139	  S4	 disabled  
> 	LAN	  S4	 disabled  pci:0000:00:04.0
> 	MDM	  S4	 disabled  
> 	AUD	  S4	 disabled  pci:0000:00:02.7
> 	SLPB	  S4	*enabled   
> 
> Eventually this file should be removed, but until then it's almost the only
> way we have to tell how the relevant ACPI tables are broken (and cope).  In
> that example, two devices don't actually exist (USB3, S139), one can't issue
> wakeup events (PCI0), and two seem harmlessly (?) confused (MDM and AUD are
> the same PCI device, but it's the _modem_ that does wake-on-ring).  
> 
> In particular, we need to be sure driver model nodes are properly hooked
> up before we can get rid of this ACPI-only interface for wakeup events.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> --- g26.orig/drivers/acpi/sleep/proc.c	2007-04-03 16:27:22.000000000 -0700
> +++ g26/drivers/acpi/sleep/proc.c	2007-04-03 16:43:26.000000000 -0700
> @@ -360,21 +360,31 @@ acpi_system_wakeup_device_seq_show(struc
>  {
>  	struct list_head *node, *next;
>  
> -	seq_printf(seq, "Device	Sleep state	Status\n");
> +	seq_printf(seq, "Device\tS-state\t  Status   Sysfs node\n");
>  
>  	spin_lock(&acpi_device_lock);
>  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
>  		struct acpi_device *dev =
>  		    container_of(node, struct acpi_device, wakeup_list);
> +		struct device *ldev;
>  
>  		if (!dev->wakeup.flags.valid)
>  			continue;
>  		spin_unlock(&acpi_device_lock);
> -		seq_printf(seq, "%4s	%4d		%s%8s\n",
> +
> +		ldev = acpi_get_physical_device(dev->handle);
> +		seq_printf(seq, "%s\t  S%d\t%c%-8s  ",
>  			   dev->pnp.bus_id,
>  			   (u32) dev->wakeup.sleep_state,
> -			   dev->wakeup.flags.run_wake ? "*" : "",
> +			   dev->wakeup.flags.run_wake ? '*' : ' ',
>  			   dev->wakeup.state.enabled ? "enabled" : "disabled");
> +		if (ldev)
> +			seq_printf(seq, "%s:%s",
> +				ldev->bus ? ldev->bus->name : "no-bus",
> +				ldev->bus_id);
> +		seq_printf(seq, "\n");
> +		put_device(ldev);
> +
>  		spin_lock(&acpi_device_lock);
>  	}
>  	spin_unlock(&acpi_device_lock);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
