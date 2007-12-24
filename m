Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbXLXPrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbXLXPrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbXLXPrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:47:16 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:55294 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXLXPrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:47:15 -0500
Date: Mon, 24 Dec 2007 18:47:26 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: Loic Prylli <loic@myri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
Message-ID: <20071224154726.GA2505@jurassic.park.msu.ru>
References: <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org> <20071223110337.GA25441@jurassic.park.msu.ru> <476F5E22.3060007@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476F5E22.3060007@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2007 at 02:22:10AM -0500, Jeff Garzik wrote:
> The phrase "all or none" specifically describes the current practice in 
> arch/x86/pci/mmconfig_{32,64}.c whereby a PCI bus always has one, and only 
> one, access method.
>
> So the problems you describe are unrelated to "all or none" as I was 
> describing it.

Ok. So a correct description would be "one or another but not both".

>> The mixed access that Loic proposes allows to avoid these boot problems
>> just for free.
>
> False.  If you have overlapping areas, then clearly it is board-dependent 
> (undefined) what happens -- you might trigger an mmconfig access by 
> writel() to your PCI device's MMIO BAR space.

You're not allowed to access MMIO defined by BARs before the PCI setup
process is finished because a) decode of the BAR might be disabled for
a number of reasons and b) the BAR may contain any random value.
So you never know *what* you're accessing until after
pci_assign_unassigned_resources() and without pci_enable_device().

> Consider, too, what the current code in arch/x86/pci/mmconfig_{32,64}.c 
> does:  it uses the range BIOS told to use for mmconfig, no more no less.

Incorrect. It does reads mcfg info directly from hardware for two Intel
bridges (should be much more - mmconfig BAR is well documented for all
Intel (and AMD, I guess) chipsets.

> Clearly many early mmconfig BIOSes have buggy resource allocation... Thus 
> if mmconfig is not known working on a system, turn it off 100% for all 
> buses.  End of story.

Direct hardware support for more chipsets would certainly help here.

>> Systems that have both non-mmconf PCI(X) and mmconf PCI-E
>> domains could be handled almost for free as well.
>
> The existing code in arch/x86/pci/mmconfig_{32,64}.c today handles mixing 
> of PCI-E and PCI-X just fine.  As noted above, its done on a per-bus and 
> per-segment basis today.

With mixed access unreachable_devices() and related stuff could have gone.

> The proposed API adds code, so I don't see how it simplifies things.

See above.

> The current approach is quite clean anyway:
>
> 1) "raw_pci_ops" points to a single set of PCI config accessors.
> 2) For mmconfig, if the BIOS did not tell us to use mmconfig with a given 
> PCI bus, fall back to type1 accesses.

But it doesn't work on systems where [basically working] mmconfig causes
boot problems because it's enabled too early.

> I agree with the function as noted in response to Linus's "Sound ok with 
> this plan?" email.  But note -- users and developers also need to access 
> extended config space, even if driver did not request it.  Even if there is 
> no driver at all.

There *is* a driver - pci-sysfs.c.

> Otherwise the value of "lspci -vvvxxx" debugging reports from users is 
> diminished.

Not at all. I don't see any reason to change the userspace API -
just make pci-sysfs.c:pci_{read,write}_config to request extended space
if (off + count > 256).

Ivan.
