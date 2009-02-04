Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZBDCYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZBDCYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZBDCYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:24:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbZBDCYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:24:13 -0500
Date: Tue, 3 Feb 2009 18:23:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: [PATCH 1/7] PCI PM: Fix handling of devices without drivers
In-Reply-To: <200902040156.15200.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902031815550.3247@localhost.localdomain>
References: <200902040154.36018.rjw@sisk.pl> <200902040156.15200.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> 
> Suspend to RAM is reported to break on some machines as a result of
> attempting to put one of driverless PCI devices into a low power
> state.  Avoid that by not attepmting to power manage driverless
> devices during suspend.
> 
> Fix up pci_pm_poweroff() after a previous incomplete fix for the same
> thing during hibernation.

Ok, I really don't like this patch, because:

> -static void pci_pm_default_suspend(struct pci_dev *pci_dev)
> +static void pci_pm_default_suspend(struct pci_dev *pci_dev, bool prepare)
>  {
>  	pci_pm_default_suspend_generic(pci_dev);
>  
> -	if (!pci_is_bridge(pci_dev))
> +	if (prepare && !pci_is_bridge(pci_dev))
>  		pci_prepare_to_sleep(pci_dev);
>  
>  	pci_fixup_device(pci_fixup_suspend, pci_dev);

This "helper" function really isn't helping anything at all any more. It's 
really just confusing things.

Now that was true even before this all; mostly because your naming in this 
area _really_ sucks. I mean, what the heck is the difference between 
"pci_pm_default_suspend_generic()" and "pci_pm_default_suspend()", and 
what do they do?

But you just made it worse. This trivial function that doesn't do anything 
interesting, and isn't well-named enough to actually explain what it is 
doing now became EVEN WORSE.  Now it's a trivial function that does two 
things, except it does one of those things only if the magic flag (that is 
also not helpfully named) is set.

Argh.

To make it worse, it's not at all obvious what the logic is:

> +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +		pci_pm_default_suspend(pci_dev, !!pm);

Whaa? This is basically totally obfuscated code both in the caller _and_ 
in the callee.

Now, it looks like this all then goes away in PATCH 7/7, so I guess I 
shouldn't complain too much, but I just don't see much point in carrying 
this broken patch around in the series, since it's then going away and 
rewritten almost immediately again.

Apart from that complaints, Acked-by: for the series. 

			Linus
