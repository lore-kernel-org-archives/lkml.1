Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbYFPXNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYFPXNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYFPXNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:13:42 -0400
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:37386 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751586AbYFPXNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:13:41 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH 0/2] PCI 2.1 VPD support
Date: Mon, 16 Jun 2008 16:13:31 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080613212743.GZ11300@solarflare.com>
In-Reply-To: <20080613212743.GZ11300@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161613.31410.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 13, 2008 2:27 pm Ben Hutchings wrote:
> PCI 2.1 specifies a way to provide VPD in the expansion ROM.  This patch
> series exposes that in the same way as PCI 2.2 VPD.
>
> I do not have any production devices with VPD in ROM so I reflashed a NIC
> with an image including it.  This code should be tested against some
> production ROMs since I may have misinterpreted the specification both
> when reading and writing!

I'll have to dig around to see if I can find any here for testing.

> There are two remaining aspects of this that I'm not quite happy about:
>
> 1. I understand that the expansion ROM may share a decoder with BAR 0,
> which makes expansion ROM access dangerous when a driver is loaded.  The
> sysfs "rom" attribute must be specifically read-enabled by writing to it,
> which I assume is intended to protect against this.  Perhaps
> pci_vpd_pci21_read() should test pdev->rom_attr_enabled?

Right, that can get a little ugly...  In the case of 2.1 VPD, it does make 
sense to require that the ROM be enabled before poking at it, and is 
definitely safer.

> 2. PCI resource allocation may fail during pci_scan_device() and
> therefore I could not insert the call to pci_vpd_pci21_init() there.
> Instead I added it to pci_create_sysfs_dev_files() - but I don't really
> think this function should be probing.  Is there a better place to add
> the call?

Well, one thing we could do is try to either use the allocated ROM or assign 
it later on, then cache the VPD data.  That way we wouldn't have to worry 
about accessing it with the rom enabled later on.  But that would eat up 
memory.

You could also just make the pci_vpd_pci21_init a device_initcall so it can 
fill in the dev->vpd before the PCI sysfs late_initcall.  Or we could just 
stuff it into pci_init in the same loop that calls the final fixups.

Other than that, things look pretty good to me.  I'd definitely like to get 
this tested on at least one PCI 2.1 device w/VPD before pushing though.  You 
know what they say about untested code. :)

Thanks,
Jesse
