Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXLEWsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXLEWsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 17:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXLEWr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 17:47:57 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43641 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbXLEWr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 17:47:56 -0500
Date: Wed, 5 Dec 2007 14:47:23 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <gregkh@suse.de>,
       jbeulich@novell.com
Subject: Re: [PATCH] pci: Omit error message for benign allocation failure
Message-ID: <20071205224723.GC5964@us.ibm.com>
References: <4755AC14.20605@ce.jp.nec.com> <20071204214907.GB9194@us.ibm.com> <4755E174.7040106@ce.jp.nec.com> <20071205014506.GA6034@us.ibm.com> <4756C140.6040601@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756C140.6040601@ce.jp.nec.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 10:18:24AM -0500, Jun'ichi Nomura wrote:
> Gary Hade wrote:
> > On Tue, Dec 04, 2007 at 06:23:32PM -0500, Jun'ichi Nomura wrote:
> >> Kernel always tries to. But it's best effort basis, IMO.
> >> (Maybe your patch is going to fix that?)
> > 
> > If you are seeing the allocation failures both with and
> > without my original patch I doubt that an improved version
> > would work.  In my case, the BIOS had allowed sufficient
> > resource for the expansion ROMs but was expecting the kernel
> > to get it from the non-prefetch instead of prefetch window.
> 
> OK. Then it's different from mine.
> Thanks for the info.

No problem.  Since our goals (eliminate confusing PCI memory
allocation failure messages) are the same and since your patch
would partially (see below) fix the issue that my patch was
attempting to address, I am _very_ interested to see how others
who are more expansion ROM knowledgeable than myself react to
your proposal.  In fact, if what you are saying is correct,
I'm wondering why the kernel even needs to attempt (by default)
to obtain space for expansion ROMS that on some systems could
be better utilized elsewhere.  Perhaps the default behavior
could be changed to exclude the expansion ROM allocation
attempts with a new kernel option added to enable the current
behavior for those that might want it.  I think this would
solve both of our problems.

I will now bore you with my story and how it relates
to your change.

The issue that my patch was attempting to address involves
a PCIe adapter that contains a p2p bridge above a SCSI storage
controller:
  [root@elm3a9 ~]# lspci -s 0b:00.0
  0b:00.0 PCI bridge: PLX Technology, Inc. PEX 8114 PCI Express-to-PCI/PCI-X Bridge (rev bc)
  [root@elm3a9 ~]# lspci -ts 0b:00.0
  -+-[0000:0b]---00.0-[0000:0c]--
   \-[0000:00]-
  [root@elm3a9 ~]# lspci -s 0c:04.0
  0c:04.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)

Case 1: (non-hotplug)
Without my patch and in non-hotplug context (adapter
installed at boot time) we see an allocation failure for
the prefetch window that was created due to the BIOS
unassigned expansion ROM BAR on the SCSI controller:
  PCI: Failed to allocate mem resource #9:100000@f2800000 for 0000:0b:00.0
This is happening because the BIOS allowed space in the
non-prefetch window for the expansion ROM and provided
no extra space for the unexpected kernel created prefetch
window.

Case 2: (hotplug)
Without my patch and in hotplug context (same adapter
hotplugged to the same slot that it was in at boot time)
we see an allocation failure for BAR 0 of the bridge:
  PCI: Failed to allocate mem resource #0:2000@f2800000 for 0000:0b:00.0
This is happening because allocations for both the
non-prefetch window and expansion ROM motivated prefetch 
window succeeded consuming all of the memory that the BIOS
had provided for the adapter.  This left no memory for
bridge BAR 0.

Your patch eliminates Case 1 by hiding the prefetch 
window allocation failure.  Case 2 is unfortunately
still alive and well because the expansion ROM motivated
prefetch window is still consuming the memory that the
BIOS provided for bridge BAR 0.

After seeing Jan's report it became obvious that expansion
ROMs cannot always be directed to a single type (prefetch
or non-prefetch) of window.  I know of no direct way of
determining where the BIOS expects expansion ROMs to land
so some sort of intelligent choice based on other information
needs to be made.  This is what I have been struggling with.
I can handle a simple case where expansion ROM(s) are
directed to the non-prefetch window if the calculated
non-prefetch window size both with and without expansion
ROM(s) is the same.  I haven't yet figured out how to handle
cases where the with/without expansion ROM non-prefetch
window sizes differ.  In these cases the BIOS's intention
does not appear to be clear.  This is why I really like the
"skip the default expansion ROM allocation attempts" idea
that your proposal has spawned. :)

Thanks for your excellent idea.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

