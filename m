Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbZFMW16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbZFMW16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZFMW1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:27:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34978 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbZFMW1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:27:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: andi@lisas.de
Subject: Re: [PATCH] Make e100 suspend handler support PCI cards lacking PM capability
Date: Sun, 14 Jun 2009 00:28:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: akpm@linux-foundation.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081229102515.GA17171@rhlx01.hs-esslingen.de> <20090603063025.GA32600@rhlx01.hs-esslingen.de> <20090613191931.GA31019@rhlx01.hs-esslingen.de>
In-Reply-To: <20090613191931.GA31019@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906140028.16025.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, Andreas Mohr wrote:
> Hi all,
> 
> after having added non-MII PHY card support to e100, I noticed that
> the suspend handler rejects power-management non-capable PCI cards,

Well, that means we have a bug somewhere in the PCI PM core.

> causing a S2R request to immediately get back up to the desktop,
> losing network access in the process (rtnl mutex deadlock).

That's bad.

> 
> ChangeLog:
> Support PCI cards which are lacking power management capability
> in the e100 suspend handler.
> 
> 
> Frankly I was unsure how to best add this to the driver in a clean way.
> Usually drivers use pci_set_power_state(..., pci_choose_state(...))
> in order to avoid the rejection of an open-coded
> pci_set_power_state(..., PCI_D3hot) in case of a non-PM card,
> however pci_choose_state() depends on the _pm-internal_ pm_message_t type,
> which was doable in .suspend directly but not at the other e100
> driver locations where it was used.
> 
> Next attempt was to extend __e100_power_off() with a pci_power_t parameter,
> however since __e100_power_off() is called by two locations,
> that meant that I'd have to use pci_choose_state() at _both_ call sites.
> 
> Thus I simply resorted to do a brute-force yet most simple
> pci_find_capability() check in the __e100_power_off() function.
> 
> 
> Tested on 2.6.30-rc8 and suspending/resuming fine, checkpatch.pl:ed.
> Patch against 2.6.30-rc8 with my original non-MII support patch applied.
> (should apply fine in any case, I'd think).
> Intended for testing in -mmotm or so.
> 
> Thanks!
> 
> Signed-off-by: Andreas Mohr <andi@lisas.de>
> 
> 
> --- linux-2.6.30-rc8.e100/drivers/net/e100.c.my_patch_orig	2009-06-13 18:47:53.000000000 +0200
> +++ linux-2.6.30-rc8.e100/drivers/net/e100.c	2009-06-13 20:27:46.000000000 +0200
> @@ -2897,6 +2897,13 @@ static void __e100_shutdown(struct pci_d
>  
>  static int __e100_power_off(struct pci_dev *pdev, bool wake)
>  {
> +	/* some older devices don't support PCI PM
> +	 * (e.g. mac_82557_D100_B combo card with 80c24 PHY)
> +	 * - skip those! (they most likely won't support WoL either)
> +	 */
> +	if (!pci_find_capability(pdev, PCI_CAP_ID_PM))
> +		return 0;

Devices without PCI_CAP_ID_PM may still be power-manageable by ACPI, so
returning 0 at this point is not a general solution.

> +
>  	if (wake) {
>  		return pci_prepare_to_sleep(pdev);

pci_prepare_to_sleep() is supposed to return 0 for your device.  I'll have a
look at it.

Best,
Rafael
