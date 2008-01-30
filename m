Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYA3Cdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYA3Cdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYA3CdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:33:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbYA3CdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:33:19 -0500
Message-ID: <479FE157.6080606@redhat.com>
Date: Tue, 29 Jan 2008 21:30:47 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128190505.5f5b1ccc@laptopd505.fenrus.org> <20080129031804.GF20198@parisc-linux.org> <20080129131955.GC10761@kroah.com> <479F34E6.40806@redhat.com> <20080129064724.0f7e91e5@laptopd505.fenrus.org> <479F4321.6030106@redhat.com> <20080129072951.5c8af9a0@laptopd505.fenrus.org> <20080129235703.GC14088@parisc-linux.org>
In-Reply-To: <20080129235703.GC14088@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Jan 29, 2008 at 07:29:51AM -0800, Arjan van de Ven wrote:
>>> Right now, that isn't a lot of people in x86 land, but your patch
>>> encumbers drivers for non-x86 archs with an additional call to access
>>> space that they've never had a problem with.
>> lets say s/x86/x86, IA64 and architectures that use intel, amd or via chipsets/
> 
> Umm .. ia64 already does exactly what I'm proposing for x86.  It uses
> one SAL interface for bytes below 256 and a different SAL interface for
> bytes 256-4095.
> 

Not exactly.
:)

The interface is the same, ia64_sal_pci_config_write() and ia64_sal_pci_config_read(),
but a flag bit in the mode argument is used to tell the SAL interface whether to
translate the offset component of the config address as having 8 or 12 bits of
of displacement.

In my estimation, Ivan's patch, in his implementation of Loic's suggestion, is even
more elegant, since there is no need to flag whether the access is for offsets below
256. Ivan's code automatically uses Port IO (or equivalent with Matthew's patch) for
offsets below 256 and MMCONFIG for offsets from 256 to 4096.

And even better, it removes the bitmap that tracks MMCONFIG-unfriendly devices for
the first 16 buses, a solution that assumes systems with bus numbers higher than 16
will get MMCONFIG right, which turned out to be a very wrong assumption. Furthermore,
the config address is translated by the Northbridge. The delivery mechanism to
the Northbridge, whether Port IO or MMCONFIG, is utterly opaque to the devices on the
bus, since all they see is PCI config cycles, not Port IO or MMCONFIG cycles. The test
only needed to be made at the Northbridge level, not at the device level. Ivan's patch
removes all this cruft.
