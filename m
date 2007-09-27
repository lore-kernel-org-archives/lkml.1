Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbXI0Obf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbXI0Obf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbXI0Ob2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:31:28 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:35873 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbXI0Ob1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:31:27 -0400
Date: Thu, 27 Sep 2007 18:31:29 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI: Fix boot-time hang on G31/G33 PC
Message-ID: <20070927183129.A17565@jurassic.park.msu.ru>
References: <20070826015556.GC14130@parisc-linux.org> <200709261455.56165.jesse.barnes@intel.com> <20070926215648.GA24505@kroah.com> <200709261520.40859.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <200709261520.40859.jesse.barnes@intel.com>; from jesse.barnes@intel.com on Wed, Sep 26, 2007 at 03:20:40PM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 03:20:40PM -0700, Jesse Barnes wrote:
> Ivan, your concern is about disabling things like interrupt controllers 
> and power management chips during probe right?  You're right that doing 
> that could cause problems if we get and interrupt or PMU event at just 
> the wrong time, but that could just as easily happen if decode was 
> still enabled but the BAR had a bogus address programmed (as it would 
> during probing).

Yes, nobody is arguing that moving the BAR around is unsafe, but generally
it's the less of two evils.

The major problem here is that with IO and MEM bits cleared in the command
register you disable *all* address decoders on the device, not just ranges
that have respective BARs. At least this behaviour is required by PCI spec.
Examples:
- legacy VGA IO and memory (no corresponding BARs);
- base/limit registers of P2P bridge;
- PMU and SMBus registers (sort of normal BARs, but hidden elsewhere
  in the config space);
- IDE legacy mode registers;
- IO-APIC registers (typically sort of read-only BAR).

For all of these address ranges our current BAR probe is effectively
a no-op, but disable/re-enable clearly isn't.

> Ultimately, I don't care much one way or another as long as we can get 
> the desktop platforms fixed somehow.  I think disabling decode is the 
> most correct way of doing this, but I'm open to other solutions (this 
> is the only patch I've seen though that's been tested to solve the 
> problem).

There are two other solutions: one is to disable decode selectively,
only on devices or systems where it's necessary and known to be safe.
I've posted a patch which introduces "disable_while_probe" pci_dev field
for that purpose.
Another one is to delay mmconfig probe until after the PCI probe is done,
as Matthew suggested, and Robert confirmed that it's feasible.

Ivan.
