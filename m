Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbXKZWAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbXKZWAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXKZV76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:59:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38753 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbXKZV75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:59:57 -0500
Date: Mon, 26 Nov 2007 13:59:54 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Gary Hade <garyhade@us.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Subject: Re: Avoid creating P2P prefetch window for expansion ROMs
Message-ID: <20071126215953.GA23277@us.ibm.com>
References: <4742CB2C.76E4.0078.0@novell.com> <20071120174945.GA6024@us.ibm.com> <47440D1F.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47440D1F.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 09:49:03AM +0000, Jan Beulich wrote:
> >I will definitely take a look at this but due to holiday/vacation
> >I may not make any progress on it until next week.  I'm not sure
> >if I totally follow your description but I suspect it will
> >become more understandable when I look at the code.  BTW, what
> >system/PCI adapter combination are you seeing this with?  It
> >would be nice if I could figure out how to reproduce the problem
> >here.
> 
> The basic consideration to make is what happens if the bridge's
> non-prefetch window provides just enough space to cover all non-ROM
> non-prefetch regions.

Thanks.  I think I understand now.

A kernel without the patch always forced creation of a prefetch
window for expansion ROMs which was incorrect on systems where
insufficient memory resources are available for both non-prefetch
and prefetch windows.  On the systems I was dealing with, the
BIOS assumes (correctly, I believe) that expansion ROM memory
resource needs will be satisfied from the non-prefetch window.
On those same systems, the BIOS (via _CRS) does not provide
enough additional prefetch or non-prefetch memory for even a
minimum size prefetch window.  These systems limit the memory
resources provided for already installed PCI devices to the
bare minimum because of the large number of PCI devices in a
multi-node configuration that are competing for the available
resources.

A kernel with the patch forces expansion ROM resources to be
allocated from a non-prefetch window which, based on your
input, is apparently problematic on at least one system due to
the BIOS (via e820 hole?) not providing enough non-prefetch memory
to construct a large enough non-prefetch window to accommodate
the underlying expansion ROMs.

I think it would still be useful to know what system/PCI adapter
combination you are seeing the problem with so that I can try
to put together a setup that will reproduce the problem here.
Alternatively, it would good if you wouldn't mind providing
more information, testing possible fixes, etc.  As a start,
could you send me the following taken with and without the
patch?
  - /proc/iomem
  - /proc/ioports
  - `dmesg` output
  - `lspci -vt` output
  - `lspci -vvv` output

> 
> >Also, is it happening both with and without the 'pci=use_crs'
> >kernel option?
> 
> I have to admit I didn't even know about that option; 

It is quite new.  It was added with a separate patch that I
submitted at the same time as the "Avoid creating P2P prefetch
window for expansion ROMs" patch.

Prior to constraining PCI memory resource allocations to what
_CRS returned, the BIOS unassigned mem resources (including
that required for expansion ROMs) were being allocated from
often incorrect ranges in the e820 hole.  After adding the
_CRS constraint we encountered an expansion ROM allocation
problem that motivated the "Avoid creating P2P prefetch window
for expansion ROMs" change.  If I recall correctly, we ran 
into the expansion ROM allocation problem when using a PCIe
adapter which has an on-board P2P bridge (PCIe-to-PCI/PCI-X)
above a device with an expansion ROM.

> when using it the
> box doesn't find its root anymore (the fusion MPT driver reports that it
> can't map the adapter's memory), and /proc/iomem doesn't show any
> iomem regions apart from the frame buffer used by vesafb, ACPI memory
> and one single range fffa0000-fffabfff. Below is the relevant fragment
> of the kernel messages.

Interesting.  I actually anticipated that this sort of thing
might happen on some systems with BIOSes that export a _CRS
that does not correctly return all of the resources available
under the associated root bridge.  This is one reason why the
use _CRS feature is "off" by default.  You might want to make
sure that the BIOS on that system is up to date and, if so,
let the h/w vendor know about this.

Greg, 
Without a closer look at the code and the information I
requested above I am not 100% certain that my expansion ROM
allocation fix is incomplete but it seems pretty likely that
it is.  If you feel that the possible regression that Jan
reported is more important than the issue I was trying to solve
feel free to remove the change until I can come up with
something better.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

> 
> Jan
> 
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> PCI: Cannot allocate resource region 8 of bridge 0000:00:01.0
> PCI: Cannot allocate resource region 9 of bridge 0000:00:01.0
> PCI: Cannot allocate resource region 8 of bridge 0000:00:02.0
> PCI: Cannot allocate resource region 9 of bridge 0000:00:02.0
> PCI: Cannot allocate resource region 8 of bridge 0000:00:04.0
> PCI: Cannot allocate resource region 9 of bridge 0000:00:04.0
> PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0
> PCI: Cannot allocate resource region 9 of bridge 0000:00:05.0
> PCI: Cannot allocate resource region 8 of bridge 0000:00:06.0
> PCI: Cannot allocate resource region 8 of bridge 0000:0a:00.2
> PCI: Cannot allocate resource region 8 of bridge 0000:00:07.0
> PCI: Cannot allocate resource region 8 of bridge 0000:0d:00.0
> PCI: Cannot allocate resource region 8 of bridge 0000:00:1e.0
> PCI: Cannot allocate resource region 9 of bridge 0000:00:1e.0
> PCI: Cannot allocate resource region 0 of device 0000:00:1d.7
> PCI: Cannot allocate resource region 0 of device 0000:0a:00.0
> PCI: Cannot allocate resource region 0 of device 0000:0c:02.0
> PCI: Cannot allocate resource region 0 of device 0000:0c:02.1
> PCI: Cannot allocate resource region 1 of device 0000:0e:05.0
> PCI: Cannot allocate resource region 3 of device 0000:0e:05.0
> PCI: Cannot allocate resource region 1 of device 0000:0e:05.1
> PCI: Cannot allocate resource region 3 of device 0000:0e:05.1
> PCI: Cannot allocate resource region 0 of device 0000:10:00.0
> PCI: Cannot allocate resource region 2 of device 0000:10:00.0
> Setting up standard PCI resources
> pnp: 00:06: ioport range 0x400-0x4bf could not be reserved
> pnp: 00:06: ioport range 0x800-0x87f has been reserved
> pnp: 00:06: ioport range 0x3f0-0x3f5 has been reserved
> pnp: 00:06: ioport range 0x3f7-0x3f7 has been reserved
> pnp: 00:06: ioport range 0x880-0x883 has been reserved
> pnp: 00:06: ioport range 0xca4-0xca4 has been reserved
> pnp: 00:06: ioport range 0xca5-0xca5 has been reserved
> pnp: 00:0a: ioport range 0xca2-0xca2 has been reserved
> pnp: 00:0a: ioport range 0xca3-0xca3 has been reserved
> assign 0000:00:06.0#8 (cur=100000 min=80000000)
> PCI: Failed to allocate mem resource #8:200000@100000 for 0000:00:06.0
> assign 0000:00:07.0#8 (cur=100000 min=80000000)
> PCI: Failed to allocate mem resource #8:300000@100000 for 0000:00:07.0
> PCI: Failed to allocate mem resource #0:400@0 for 0000:00:1d.7
> PCI: Bridge: 0000:00:01.0
>   IO window: 7000-7fff
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:02.0
>   IO window: 6000-6fff
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:03.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:04.0
>   IO window: 5000-5fff
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:05.0
>   IO window: 4000-4fff
>   MEM window: disabled.
>   PREFETCH window: disabled.
> assign 0000:0a:00.2#8 (cur=100000 min=80000000)
> PCI: Failed to allocate mem resource #8:100000@100000 for 0000:0a:00.2
> PCI: Failed to allocate mem resource #0:1000@0 for 0000:0a:00.0
> PCI: Bridge: 0000:0a:00.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Failed to allocate mem resource #6:20000@0 for 0000:0c:02.0
> PCI: Failed to allocate mem resource #0:10000@0 for 0000:0c:02.0
> PCI: Failed to allocate mem resource #0:10000@0 for 0000:0c:02.1
> PCI: Bridge: 0000:0a:00.2
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:06.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> assign 0000:0d:00.0#8 (cur=100000 min=80000000)
> PCI: Failed to allocate mem resource #8:300000@100000 for 0000:0d:00.0
> PCI: Failed to allocate mem resource #6:100000@0 for 0000:0e:05.0
> PCI: Failed to allocate mem resource #6:100000@0 for 0000:0e:05.1
> PCI: Failed to allocate mem resource #1:10000@0 for 0000:0e:05.0
> PCI: Failed to allocate mem resource #3:10000@0 for 0000:0e:05.0
> PCI: Failed to allocate mem resource #1:10000@0 for 0000:0e:05.1
> PCI: Failed to allocate mem resource #3:10000@0 for 0000:0e:05.1
> PCI: Bridge: 0000:0d:00.0
>   IO window: 3000-3fff
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:0d:00.2
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:07.0
>   IO window: 3000-3fff
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Failed to allocate mem resource #0:8000000@0 for 0000:10:00.0
> PCI: Failed to allocate mem resource #6:20000@0 for 0000:10:00.0
> PCI: Failed to allocate mem resource #2:10000@0 for 0000:10:00.0
> PCI: Bridge: 0000:00:1e.0
>   IO window: 2000-2fff
>   MEM window: disabled.
>   PREFETCH window: disabled.
> 

