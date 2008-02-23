Return-Path: <linux-kernel-owner+w=401wt.eu-S936944AbYBWBBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936944AbYBWBBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760006AbYBWBBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:01:13 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756585AbYBWBBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:01:10 -0500
Date: Fri, 22 Feb 2008 17:00:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: i915 hibernation patch (was: Re: [Suspend-devel] 2.6.25-rc2
 System no longer powers off aftersuspend-to-disk. Screen becomes green.)
In-Reply-To: <200802230031.20292.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802221653000.21332@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211713.20713.jesse.barnes@intel.com> <200802211744.35563.jesse.barnes@intel.com> <200802230031.20292.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:

> --- linux-2.6.orig/drivers/char/drm/i915_drv.c
> +++ linux-2.6/drivers/char/drm/i915_drv.c
> @@ -222,6 +222,7 @@ static void i915_restore_vga(struct drm_
>  			   dev_priv->saveGR[0x18]);
>  
>  	/* Attribute controller registers */
> +	inb(st01);
>  	for (i = 0; i < 20; i++)
>  		i915_write_ar(st01, i, dev_priv->saveAR[i], 0);
>  	inb(st01); /* switch back to index mode */

I'm doing this part separately, please drop it - it has nothing to do with 
the rest of the patch.

I'd also suggest that you just add a helper function like

	int pm_event_powerdown(struct pm_message mesg)
	{
		return mesg.event >= PM_EVENT_SUSPEND;
	}

or something, so that you can have code like

	if (pm_event_powerdown(mesg))
		pci_set_power_state(pdev, PCI_D3hot);

instead of the test for EVENT_SUSPEND/HIBERNATE explicitly.

Of course, the places that already do a switch-statement are much better 
kept that way and just add PM_EVENT_HIBERNATE to the list.

> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -554,6 +554,7 @@ pci_power_t pci_choose_state(struct pci_
>  	case PM_EVENT_PRETHAW:
>  		/* REVISIT both freeze and pre-thaw "should" use D0 */
>  	case PM_EVENT_SUSPEND:
> +	case PM_EVENT_HIBERNATE:
>  		return PCI_D3hot;

Didn't you miss the apci_pci_choose_state() thing that also needs this 
extension?

> Index: linux-2.6/drivers/usb/host/u132-hcd.c
> ===================================================================
> --- linux-2.6.orig/drivers/usb/host/u132-hcd.c
> +++ linux-2.6/drivers/usb/host/u132-hcd.c
> @@ -3214,14 +3214,18 @@ static int u132_suspend(struct platform_
>                  return -ESHUTDOWN;
>          } else {
>                  int retval = 0;
> -                if (state.event == PM_EVENT_FREEZE) {
> +
> +		switch (state.event) {
> +		case PM_EVENT_FREEZE:
>                          retval = u132_bus_suspend(hcd);
> -                } else if (state.event == PM_EVENT_SUSPEND) {
> +			break;
> +		case PM_EVENT_SUSPEND:
> +		case PM_EVENT_HIBERNATE:
>                          int ports = MAX_U132_PORTS;
>                          while (ports-- > 0) {
>                                  port_power(u132, ports, 0);
>                          }
> -                }
> +			break;
>                  if (retval == 0)
>                          pdev->dev.power.power_state = state;
>                  return retval;

Looks like a missing close-brace to me there - you removed the final '}'.

Or am I blind?

Apart from those issues it looks fine to me.

			Linus
