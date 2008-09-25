Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYIYA1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYIYA1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYIYA10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:27:26 -0400
Received: from outbound-mail-134.bluehost.com ([67.222.39.24]:55902 "HELO
	outbound-mail-134.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752853AbYIYA1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:27:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=bHO5zCle1lk7jCFOCwengBsvmkwkDXniG/hPiTGH/aCpPqPsKIaUNT5oPrCCeIp0tOzwRZmQ7GNjsOK0xfeLJ/arh9FzHjpRrZQQJUYaVbOvC20REA21YHW9d2fdTW+5;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Date: Wed, 24 Sep 2008 17:26:57 -0700
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       airlied@gmail.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>
References: <20080923.150722.141587696.davem@davemloft.net> <20080923.211215.193696086.davem@davemloft.net> <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241726.58628.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 24, 2008 4:15 pm Jiri Kosina wrote:
> On Tue, 23 Sep 2008, David Miller wrote:
> > I did some snooping around, and while doing so I noticed that the PCI
> > mmap code for x86 doesn't do one bit of range checking on the size, or
> > any other aspect of the request, wrt. the MMIO regions actually mapped
> > in the BARs of the PCI device.
>
> Ugh, indeed. Added Ingo and Jesse to CC.
>
> > Yikes!
> >
> > It just does a reserve_memtype() on the address range, and says "ok".
> >
> > So if, for example, the X server tries to mmap() more than an MMIO bar
> > actually maps, the kernel lets the user do this.
> >
> > It would be very interesting to add the appropriate checks to
> > pci_mmap_page_range() in arch/x86/pci/i386.c, anyone who wants to do
> > this can use the code in arch/sparc64/kernel/pci.c:
> > __pci_mmap_make_offset() as a guide, and see what happens.
>
> Absolutely. Or we can even do some dirty hackery in userspace, like
> LD_PRELOADing X server and checking mmaps() that are close to MMIO regions
> of affected devices.
>
> > If the MMIO space regions of the video cards sit right before the
> > E1000E ones on the effected systems, that would pretty much
> > convince me that this is the kind of problem we are having here.
>
> Unfortunately, looking at the lspci outputs that are in
> https://bugzilla.novell.com/show_bug.cgi?id=425480 it seems to me that the
> MMIO regions are quite far away from each other.

Moreover, we don't actually do any writing (that I know of) of the ROM image 
from the X drivers or the kernel.  In fact, in many cases X should be 
accessing the RAM copy of the ROM at 0xc0000 rather than via the ROM BAR.

That said, adding a check to the x86 code would be a good thing to do; I'll 
hack up a patch tomorrow unless someone beats me to it.

-- 
Jesse Barnes, Intel Open Source Technology Center
