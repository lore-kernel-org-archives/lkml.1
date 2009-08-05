Return-Path: <linux-kernel-owner+w=401wt.eu-S934051AbZHEPvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbZHEPvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933992AbZHEPvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:51:11 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:42615 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbZHEPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:51:10 -0400
Date: Wed, 5 Aug 2009 17:51:02 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Message-ID: <20090805155102.GA31646@roarinelk.homelinux.net>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Tue, Aug 04, 2009 at 04:04:16PM -0700, Linus Torvalds wrote:
> On Mon, 3 Aug 2009, Manuel Lauss wrote:
> > 
> > This patch introduces a warning on my system:
> > 
> > pci 0000:02:03.0: BAR 6: address space collision on of device [0xff680000-0xff69ffff]
> 
> Heh, that's funny. I suspect you have always had the error, it's just that 
> back before the commit that started using "pci_claim_resource()", we did 
> that "find_parent_resource()+request_resource()" by hand.
> 
> So before commit a76117dfd687ec4be0a9a05214f3009cc5f73a42, the ROM 
> resources were done with:
> 
> 	pr = pci_find_parent_resource(dev, r);
> 	if (!pr || request_resource(pr, r) < 0) {
> 		r->end -= r->start;
> 		r->start = 0;
> 	}
> 
> inside pcibios_assign_resources(), and it would never warn about it, it 
> would just silently mark the resource unregistered (and then we'd 
> re-allocate it later).
> 
> So I _think_ that you actually are getting the same layout as with 2.6.30, 
> but with a warning that didn't exist in 2.6.30. Can you verify?

You're absolutely correct: /proc/iomem on 2.6.30 and 31-rc5+ are identical,
the only difference being 2.6.30 not complaining about any collisions.

 
> With the change to use "pci_claim_resource()", it initially changed things 
> to use "insert_resource()", and that shouldn't have even succeeded, but 
> apparently did! That's a bit scary. The patch to make it use 
> pci_request_resource() should have made it have the same behavior as we 
> had in 2.6.30 - albeit with the warning (that we didn't use to have).
> 
> I do wonder why the insert_resource() seems to have worked, though, so 
> maybe I'm misdiagnosing this. Can you post your /proc/iomem from 2.6.30?

Here it is.

00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3ff3ffff : System RAM
  01000000-013a071a : Kernel code
  013a071b-0155cc57 : Kernel data
  0159d000-015f070b : Kernel bss
3ff40000-3ff4ffff : ACPI Tables
3ff50000-3fffffff : ACPI Non-volatile Storage
50000000-500003ff : 0000:00:1f.1
54000000-57ffffff : PCI CardBus 0000:03
58000000-5bffffff : PCI CardBus 0000:03
ce900000-de9fffff : PCI Bus 0000:01
  d0000000-d7ffffff : 0000:01:00.0
dea00000-deafffff : PCI Bus 0000:02
  dea00000-dea1ffff : 0000:02:03.0
e0000000-efffffff : 0000:00:00.0
fec00000-fec00fff : pnp 00:09
fee00000-fee00fff : pnp 00:09
ff500000-ff5fffff : PCI Bus 0000:01
  ff5c0000-ff5dffff : 0000:01:00.0
  ff5f0000-ff5fffff : 0000:01:00.0
ff600000-ff6fffff : PCI Bus 0000:02
  ff600000-ff600fff : 0000:02:01.0
    ff600000-ff600fff : yenta_socket
  ff6a0000-ff6bffff : 0000:02:03.0
    ff6a0000-ff6bffff : e1000
  ff6c0000-ff6dffff : 0000:02:03.0
    ff6c0000-ff6dffff : e1000
  ff6f7000-ff6f7fff : 0000:02:04.0
    ff6f7000-ff6f7fff : ohci_hcd
  ff6f8000-ff6fbfff : 0000:02:01.2
  ff6fc000-ff6fcfff : 0000:02:04.1
    ff6fc000-ff6fcfff : ohci_hcd
  ff6fd000-ff6fdfff : 0000:02:02.0
    ff6fd000-ff6fdfff : ipw2200
  ff6fe400-ff6fe4ff : 0000:02:04.2
    ff6fe400-ff6fe4ff : ehci_hcd
  ff6fe800-ff6fefff : 0000:02:01.2
    ff6fe800-ff6fefff : firewire_ohci
  ff6ff000-ff6fffff : 0000:02:01.3
ff7ff400-ff7ff4ff : 0000:00:1f.5
  ff7ff400-ff7ff4ff : Intel 82801DB-ICH4
ff7ff800-ff7ff9ff : 0000:00:1f.5
  ff7ff800-ff7ff9ff : Intel 82801DB-ICH4
ff7ffc00-ff7fffff : 0000:00:1d.7
  ff7ffc00-ff7fffff : ehci_hcd
ff800000-ffbfffff : pnp 00:08
ffc00000-ffffffff : pnp 00:08


Thank you!
	Manuel Lauss
