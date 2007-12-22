Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbXLVJNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbXLVJNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 04:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXLVJN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 04:13:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXLVJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 04:13:27 -0500
Date: Sat, 22 Dec 2007 01:12:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-Id: <20071222011218.0a5cfa42.akpm@linux-foundation.org>
In-Reply-To: <20071220084616.GA28578@jurassic.park.msu.ru>
References: <47671377.6000405@redhat.com>
	<alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
	<47680489.6040809@redhat.com>
	<alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
	<20071218202234.GA24525@twiddle.net>
	<20071219002349.A12278@jurassic.park.msu.ru>
	<alpine.LFD.0.9999.0712181338150.21557@woody.linux-foundation.org>
	<20071220084616.GA28578@jurassic.park.msu.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 11:46:16 +0300 Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> PCI: do respect full 64-bit address for bridge prefetch window
> 
> Prevent the prefetch window from being programmed with a bogus address
> when its respective resource gets allocated above the 4G mark.
> 
> Note that we cannot yet guarantee correct resource allocations
> above 4G, though it might work in some simple cases.
> 

So.. did we agree that this patch is good to go?

> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -208,8 +208,11 @@ pci_setup_bridge(struct pci_bus *bus)
>  	}
>  	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
>  
> -	/* Clear out the upper 32 bits of PREF base. */
> -	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, 0);
> +	/* Set up the upper 32 bits of PREF base/limit. */
> +	l = region.start >> 16 >> 16;

We have the little upper_32_bits() helper for this.

> +	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, l);
> +	l = region.end >> 16 >> 16;
> +	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, l);
>  
>  	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
>  }

