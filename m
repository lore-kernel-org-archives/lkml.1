Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZB0GPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZB0GPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZB0GPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:15:40 -0500
Received: from colo.lackof.org ([198.49.126.79]:38027 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbZB0GPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:15:40 -0500
Date: Thu, 26 Feb 2009 23:15:25 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/6] Rewrite MSI-HOWTO
Message-ID: <20090227061525.GA9883@colo.lackof.org>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <1235410082-5016-2-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235410082-5016-2-git-send-email-matthew@wil.cx>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy,
Some suggestions/comments below.

On Mon, Feb 23, 2009 at 12:27:57PM -0500, Matthew Wilcox wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> I didn't find the previous version very useful, so I rewrote it.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  Documentation/PCI/MSI-HOWTO.txt |  756 ++++++++++++++-------------------------
>  1 files changed, 275 insertions(+), 481 deletions(-)
> 
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> index 256defd..f1b9f09 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt

...
> +3. Why use MSIs?
> +
> +There are three reasons why using MSIs can give an advantage over
> +traditional pin-based interrupts.
...
> +PCI devices can only support a single pin-based interrupt per function.

Related to this is a 4th reason: distribute workload across CPUs
and enables construction of efficient, multi-queue devices.
Care to mention that?

...
> +The MSI-X capability is much more flexible than the MSI capability.
> +It supports up to 2048 interrupts, each of which can be separately
> +assigned.

Nothing describes "assignment" below or what is meant by "assigned".
My guess is you wanted to differentiate MSIX from MSI with:
  ... and each MSIX can be directed at a different CPU.


> +4.5 Considerations when using MSIs
> +
> +4.5.1 Choosing between MSI-X and MSI
> +
> +If your device supports both MSI-X and MSI capabilities, you should use
> +the MSI-X facilities in preference to the MSI facilities.  As mentioned
> +above, MSI-X supports any number of interrupts between 1 and 2048.
> +In constrast, MSI is restricted to a maximum of 32 interrupts (and
> +must be a power of two).  In addition, the MSI interrupt vectors must
> +be allocated consecutively, so the system may not be able to allocate
> +as many vectors for MSI as it could for MSI-X.  On some platforms, MSI
> +interrupts must all be targetted at the same set of CPUs whereas MSI-X
> +interrupts can all be targetted at different CPUs.

The description for MSI is correct. But Linux will only allocate one
MSI as noted in an earlier section. This section implies more could
be allocated when using MSI and that won't happen.

IIRC, for AHCI perf you were working on a patch to change that and
it should probably update this text at the same time when the
behavior changes.


> +5. MSI quirks
> +
> +Several PCI chipsets or devices are known not to support MSIs.
> +The PCI stack provides three ways to disable MSIs:
> +
> +1. globally
> +2. on all devices behind a specific bridge
> +3. on a single device
...
> +5.3. Disabling MSIs on a single device
> +
> +Some devices are known to have faulty MSI implementations.  Usually this
> +is handled in the individual device driver but occasionally it's necessary
> +to handle this with a quirk.  Some drivers have an option to disable MSIs;
> +this is deprecated.

"this" is ambiguous. My guess is "quirks to disable MSI for a device is
deprecated" since recently some drivers have added module parameters to
disable MSI.


> +5.4. Finding why MSIs are disabled on a device
> +
> +From the above three sections, you can see that there are many reasons
> +why MSIs may not be enabled for a given device.  Your first step should
> +be to examine your dmesg carefully to determine whether MSIs are enabled
> +for your machine.  You should also check your .config to be sure you
> +have enabled CONFIG_PCI_MSI.

Should mention "fgrep MSI /proc/interrupts" to see if any devices have
MSI in use?

> +
> +Then, lspci -t gives the list of bridges above a device.  Reading
> +/sys/bus/pci/devices/*/msi_bus will tell you whether MSI are enabled (1)
> +or disabled (0).  If 0 is found in any of the msi_bus files belonging
> +to bridges between the PCI root and the device, MSIs are disabled.
> +
> +It is also worth checking whether the device driver supports MSIs.

Suggestions on how to check?

Conversely, one can easily check if the driver has MSI disabled by default
and MSI can be enabled.  e.g. use "modinfo mvsas" to check driver parameters.


The parts I deleted look good.

Reviewed-by: Grant Grundler <grundler@parisc-linunx.org>

thanks,
grant
