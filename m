Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbZF2OQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbZF2OQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759372AbZF2OQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:16:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44070 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759720AbZF2OQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:16:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH] eeepc-laptop: fix hot-unplug on resume
Date: Mon, 29 Jun 2009 16:16:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Corentin Chary <corentincj@iksaif.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4A48A196.3060409@tuffmail.co.uk>
In-Reply-To: <4A48A196.3060409@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291616.57440.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Alan Jenkins wrote:
> The patch below fixes a regression introduced by the rfkill rewrite. 
> Please consider it for inclusion in 2.6.31 via the ACPI tree.

Is there a Bugzilla # for this regression?

Rafael

> -------------------->
> 
> From d0265f0bfe63086816d61c69ee4b2dc4cb491d06 Mon Sep 17 00:00:00 2001
> From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date: Mon, 29 Jun 2009 09:40:07 +0100
> Subject: [PATCH] eeepc-laptop: fix hot-unplug on resume
> 
> OOPS on resume when the wireless adaptor is disabled during suspend was
> introduced by "eeepc-laptop: read rfkill soft-blocked state on resume".
> 
> Unable to handle kernel NULL pointer dereference
> 
> Process s2disk
> Tainted: G W
> IP: klist_put
> 
> Call trace:
> ? klist_del
> ? device_del
> ? device_unregister
> ? pci_stop_dev
> ? pci_stop_bus
> ? pci_remove_device
> ? eeepc_rfkill_hotplug [eeepc_laptop]
> ? eeepc_hotk_resume [eeepc_laptop]
> ? acpi_device_resume
> ? device_resume
> ? hibernation_snapshot
> 
> It appears the PCI device is removed twice.  The eeepc_rfkill_hotplug()
> call from the resume handler is racing against the call from the ACPI
> notifier callback.  The ACPI notification is triggered by the resume
> handler when it refreshes the value of CM_ASL_WLAN.
> 
> The fix is to serialize hotplug calls using a workqueue.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
>  drivers/platform/x86/eeepc-laptop.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index ec560f1..222ffb8 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -143,6 +143,7 @@ struct eeepc_hotk {
>  	struct rfkill *bluetooth_rfkill;
>  	struct rfkill *wwan3g_rfkill;
>  	struct hotplug_slot *hotplug_slot;
> +	struct work_struct hotplug_work;
>  };
>  
>  /* The actual device the driver binds to */
> @@ -660,7 +661,7 @@ static int eeepc_get_adapter_status(struct hotplug_slot *hotplug_slot,
>  	return 0;
>  }
>  
> -static void eeepc_rfkill_hotplug(void)
> +static void eeepc_hotplug_work(struct work_struct *work)
>  {
>  	struct pci_dev *dev;
>  	struct pci_bus *bus = pci_find_bus(0, 1);
> @@ -701,7 +702,7 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
>  	if (event != ACPI_NOTIFY_BUS_CHECK)
>  		return;
>  
> -	eeepc_rfkill_hotplug();
> +	schedule_work(&ehotk->hotplug_work);
>  }
>  
>  static void eeepc_hotk_notify(struct acpi_device *device, u32 event)
> @@ -892,7 +893,7 @@ static int eeepc_hotk_resume(struct acpi_device *device)
>  
>  		rfkill_set_sw_state(ehotk->wlan_rfkill, wlan != 1);
>  
> -		eeepc_rfkill_hotplug();
> +		schedule_work(&ehotk->hotplug_work);
>  	}
>  
>  	if (ehotk->bluetooth_rfkill)
> @@ -1093,6 +1094,8 @@ static int eeepc_rfkill_init(struct device *dev)
>  {
>  	int result = 0;
>  
> +	INIT_WORK(&ehotk->hotplug_work, eeepc_hotplug_work);
> +
>  	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P6");
>  	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P7");
