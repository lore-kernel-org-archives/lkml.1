Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXHFOlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXHFOlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXHFOlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:41:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbXHFOlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:41:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Subject: Re: [PATCH] kexec: fix pci device initialization fail after kexec (2.6.23-rc2). (Related to e1000 doesn't resume properly from standby)
Date: Mon, 6 Aug 2007 16:50:15 +0200
User-Agent: KMail/1.9.5
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Simon Arlott" <simon@fire.lp0.eu>, "Pavel Machek" <pavel@ucw.cz>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       linux-pm@lists.linux-foundation.org
References: <b25c3fa70708060642w1b3a326q792a81fdaa3036c5@mail.gmail.com>
In-Reply-To: <b25c3fa70708060642w1b3a326q792a81fdaa3036c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061650.16555.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 15:42, Joonwoo Park wrote:
> Hi.
> I think that the pci_set_power_state() has bug.
> The specification says that some delays is required.

And they are in place, AFAICS (from drivers/pci/pci.c):

	/* Mandatory power management transition delays */
	/* see PCI PM 1.1 5.6.1 table 18 */
	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
		msleep(pci_pm_d3_delay);
	else if (state == PCI_D2 || dev->current_state == PCI_D2)
		udelay(200);

> Simon, please can I know whether it works to you?
> It is seems to the things are related.
> 
> Joonwoo Park.
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 37c00f6..9f78064 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -493,8 +493,14 @@ pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>    * restore at least the BARs so that the device will be
>    * accessible to its driver.
>    */
> - if (need_restore)
> + if (need_restore) {
> +   /* The specification also says that "Must ensure that all of
> +    * its PCI signal drivers remain disabled for the duration of
> +    * the D3hot to D0 Uninitialized state transition".
> +    */
> +   msleep(10);

It's too late for the delay.

>     pci_restore_bars(dev);
> + }
> 
>   return 0;
>  }

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
