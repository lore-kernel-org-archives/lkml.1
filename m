Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYI2Qgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYI2Qgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYI2QgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:36:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYI2QgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:36:21 -0400
Date: Mon, 29 Sep 2008 09:34:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, Rene Herman <rene.herman@keyaccess.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in
 quirk_system_pci_resources()
In-Reply-To: <200809290957.59813.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org>
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Sep 2008, Bjorn Helgaas wrote:
>  
> +			if (!pci_resource_enabled(pdev, i))
> +				continue;

I really don't think this is the right approach.

Maybe the PCI device has been turned off, but the *resource* may still be 
valid.

Wouldn't it be much better to just check whether the resource is inserted 
in the resource tree or not? 

Quite frankly, it looks like your change will basically cause us to look 
over *every* system PnP resource, and for each of them, it will look at 
*every* PCI device, and for each PCI device it will look at *every* BAR, 
and for each BAR it finds it will read the PCI status register, over and 
over and over again.

Now, I doubt you'll be able to wear out the PCI bus, but doesn't this just 
make you go "umm, that's not pretty, and it doesn't make much sense".

If we've detected the PCI resource as being valid by the PCI layer, why 
not just use that information? And afaik, the easy way to check that is 
just whether it's inserted into the resource tree, which in turn is most 
trivially done by just checking whether the resource has a parent.

IOW, why isn't it just doing

	struct resource *res = dev->resource[bar];

	if (!res->parent)
		continue;

or something? Or what was wrong with just checking the res->start for 
being zero? Wherever PnP is relevant, resources that start at zero are 
disabled, no? 

			Linus


