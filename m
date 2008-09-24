Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYIXEMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYIXEMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 00:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYIXEM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 00:12:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbYIXEM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 00:12:27 -0400
Date: Tue, 23 Sep 2008 21:12:15 -0700 (PDT)
Message-Id: <20080923.211215.193696086.davem@davemloft.net>
To: jkosina@suse.cz
Cc: jeffrey.t.kirsher@intel.com, airlied@gmail.com, david.vrabel@csr.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
References: <20080923.150722.141587696.davem@davemloft.net>
	<9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
	<alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Wed, 24 Sep 2008 00:19:00 +0200 (CEST)

> On Tue, 23 Sep 2008, Jeff Kirsher wrote:
> 
> > >> I don't think OpenSUSE was shipping any of the GEM bits.
> > > Good data point, can someone confirm this?  Also, what X server version
> > > is the effected OpenSUSE shipping?
> > OpenSuSE 11 ships x server version 7.3.
> 
> Opensuse 11 is fine.
> 
> The problem can be reproduced [not only] on opensuse 11.1 beta1, which has
> 
> 	xorg-x11-7.4-1.6.x86_64.rpm

I did some snooping around, and while doing so I noticed that the PCI
mmap code for x86 doesn't do one bit of range checking on the size, or
any other aspect of the request, wrt. the MMIO regions actually mapped
in the BARs of the PCI device.

Yikes!

It just does a reserve_memtype() on the address range, and says "ok".

So if, for example, the X server tries to mmap() more than an MMIO bar
actually maps, the kernel lets the user do this.

It would be very interesting to add the appropriate checks to
pci_mmap_page_range() in arch/x86/pci/i386.c, anyone who wants to do
this can use the code in arch/sparc64/kernel/pci.c:
__pci_mmap_make_offset() as a guide, and see what happens.

If the MMIO space regions of the video cards sit right before the
E1000E ones on the effected systems, that would pretty much
convince me that this is the kind of problem we are having here.

This also reminds me that there was that whole set of issues that
had to get worked out wrt. write-caching of mappings on x86.
