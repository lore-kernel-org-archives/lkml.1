Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbXK0TSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbXK0TSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbXK0TS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:18:27 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58323 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264AbXK0TS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:18:26 -0500
Date: Tue, 27 Nov 2007 11:17:34 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Gary Hade <garyhade@us.ibm.com>, gregkh@suse.de, lcm@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Avoid creating P2P prefetch window for expansion ROMs
Message-ID: <20071127191734.GA8174@us.ibm.com>
References: <4742CB2C.76E4.0078.0@novell.com> <20071120174945.GA6024@us.ibm.com> <47440D1F.76E4.0078.0@novell.com> <20071126215953.GA23277@us.ibm.com> <474BF149.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474BF149.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Tue, Nov 27, 2007 at 09:28:25AM +0000, Jan Beulich wrote:
> >A kernel without the patch always forced creation of a prefetch
> >window for expansion ROMs which was incorrect on systems where
> >insufficient memory resources are available for both non-prefetch
> >and prefetch windows.  On the systems I was dealing with, the
> >BIOS assumes (correctly, I believe) that expansion ROM memory
> >resource needs will be satisfied from the non-prefetch window.
> 
> Why would ROM space generally need to be non-prefetchable? I can
> see that special cases might require this, but as long as ROM space
> really is just normal code and data, there's nothing wrong with
> prefetching from it I would think. Of course I realize there's no way
> to specify that on a per-device basis, so I think the BIOS must be
> relied upon here.

Yes, I believe you are correct.  It is my understanding that 
expansion ROM space is not "required" to be non-prefetchable
but "can be" non-prefetchable.  Since it "can be" non-prefetchable
it is also my understanding that the BIOS can assume that the
kernel will allocate expansion ROM space from the non-prefetch
window if sufficient space exists there.  The BIOS does this to
conserve PCI memory to make more space available to other PCI
devices (already installed or may be hotplugged) in the large
number of other PCI slots that exist in a multi-node system.

For example, I believe the minimum p2p bridge window size is
1MB so if the BIOS determines that all the PCI memory needs
(including expansion ROMs) for devices below the bridge can
be satisfied from a 1MB non-prefetch window, it can provide
(via _CRS) only 1MB of PCI memory for the non-prefetch window
and nothing for a prefetch window.  If the kernel strictly
requires expansion ROM space to be allocated from a prefetch
window the BIOS would have to provide an additional 1MB of PCI
memory for a prefetch window.  So, in this example the kernel
wants 2MB (1MB for non-prefetch window, 1 MB for prefetch window)
but the BIOS only provides 1MB for the non-prefetch window.

I hope this makes more sense now.

> 
> >I think it would still be useful to know what system/PCI adapter
> >combination you are seeing the problem with so that I can try
> >to put together a setup that will reproduce the problem here.
> >Alternatively, it would good if you wouldn't mind providing
> >more information, testing possible fixes, etc.  As a start,
> >could you send me the following taken with and without the
> >patch?
> >  - /proc/iomem
> >  - /proc/ioports
> >  - `dmesg` output
> >  - `lspci -vt` output
> >  - `lspci -vvv` output
> 
> Attached. *.0 is with the patch, *.1 is with it reverted. All output from
> the SLE10SP2 (2.6.16.54-based) kernel that has that patch backported.

Thanks!

> 
> I'd also like to note that I found that a second of the systems I'm
> regularly dealing with also has similar problems. I'm just not normally
> looking at the boot messages that closely.

Sounds like I better get to work. :)

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
