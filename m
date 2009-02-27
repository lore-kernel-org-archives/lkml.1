Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZB0MO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZB0MO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 07:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZB0MOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 07:14:46 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:51565 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbZB0MOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 07:14:45 -0500
Date: Fri, 27 Feb 2009 05:14:43 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/6] Rewrite MSI-HOWTO
Message-ID: <20090227121443.GL16891@parisc-linux.org>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <1235410082-5016-2-git-send-email-matthew@wil.cx> <20090227061525.GA9883@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227061525.GA9883@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 11:15:25PM -0700, Grant Grundler wrote:
> ...
> > +3. Why use MSIs?
> > +
> > +There are three reasons why using MSIs can give an advantage over
> > +traditional pin-based interrupts.
> ...
> > +PCI devices can only support a single pin-based interrupt per function.
> 
> Related to this is a 4th reason: distribute workload across CPUs
> and enables construction of efficient, multi-queue devices.
> Care to mention that?

That's true for MSI-X, but not for MSIs in general.  Workload is already
distributed across CPUs with round-robin interrupts.  I'm inclined to
leave out this level of detail.

> > +The MSI-X capability is much more flexible than the MSI capability.
> > +It supports up to 2048 interrupts, each of which can be separately
> > +assigned.
> 
> Nothing describes "assignment" below or what is meant by "assigned".
> My guess is you wanted to differentiate MSIX from MSI with:
>   ... and each MSIX can be directed at a different CPU.

I think 'each of which can be controlled separately' might work better.
For example, they're individually maskable which isn't (necessarily)
true of plain MSI.

> > +4.5 Considerations when using MSIs
> > +
> > +4.5.1 Choosing between MSI-X and MSI
> > +
> > +If your device supports both MSI-X and MSI capabilities, you should use
> > +the MSI-X facilities in preference to the MSI facilities.  As mentioned
> > +above, MSI-X supports any number of interrupts between 1 and 2048.
> > +In constrast, MSI is restricted to a maximum of 32 interrupts (and
> > +must be a power of two).  In addition, the MSI interrupt vectors must
> > +be allocated consecutively, so the system may not be able to allocate
> > +as many vectors for MSI as it could for MSI-X.  On some platforms, MSI
> > +interrupts must all be targetted at the same set of CPUs whereas MSI-X
> > +interrupts can all be targetted at different CPUs.
> 
> The description for MSI is correct. But Linux will only allocate one
> MSI as noted in an earlier section. This section implies more could
> be allocated when using MSI and that won't happen.
> 
> IIRC, for AHCI perf you were working on a patch to change that and
> it should probably update this text at the same time when the
> behavior changes.

Did you see this is patch 1/6?  ;-)  I removed the description of
pci_enable_msi_block() from this patch, but missed updating this
paragraph.  By patch 6/6, this paragraph is true.

> > +5. MSI quirks
> > +
> > +Several PCI chipsets or devices are known not to support MSIs.
> > +The PCI stack provides three ways to disable MSIs:
> > +
> > +1. globally
> > +2. on all devices behind a specific bridge
> > +3. on a single device
> ...
> > +5.3. Disabling MSIs on a single device
> > +
> > +Some devices are known to have faulty MSI implementations.  Usually this
> > +is handled in the individual device driver but occasionally it's necessary
> > +to handle this with a quirk.  Some drivers have an option to disable MSIs;
> > +this is deprecated.
> 
> "this" is ambiguous. My guess is "quirks to disable MSI for a device is
> deprecated" since recently some drivers have added module parameters to
> disable MSI.

Having an option to disable MSI is deprecated.  That doesn't mean that
individual driver authors aren't selfish and short-sighted.

> > +5.4. Finding why MSIs are disabled on a device
> > +
> > +From the above three sections, you can see that there are many reasons
> > +why MSIs may not be enabled for a given device.  Your first step should
> > +be to examine your dmesg carefully to determine whether MSIs are enabled
> > +for your machine.  You should also check your .config to be sure you
> > +have enabled CONFIG_PCI_MSI.
> 
> Should mention "fgrep MSI /proc/interrupts" to see if any devices have
> MSI in use?

Yes, you're right.

> > +Then, lspci -t gives the list of bridges above a device.  Reading
> > +/sys/bus/pci/devices/*/msi_bus will tell you whether MSI are enabled (1)
> > +or disabled (0).  If 0 is found in any of the msi_bus files belonging
> > +to bridges between the PCI root and the device, MSIs are disabled.
> > +
> > +It is also worth checking whether the device driver supports MSIs.
> 
> Suggestions on how to check?

'eg has calls to pci_enable_msi(), pci_enable_msix() or
pci_enable_msi_block()'?

> Conversely, one can easily check if the driver has MSI disabled by default
> and MSI can be enabled.  e.g. use "modinfo mvsas" to check driver parameters.

I'm not going to give examples of bad practise.

> Reviewed-by: Grant Grundler <grundler@parisc-linunx.org>

Thanks.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
