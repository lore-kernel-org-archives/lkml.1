Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbXDSXml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbXDSXml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbXDSXml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:42:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbXDSXmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:42:40 -0400
Date: Thu, 19 Apr 2007 16:40:14 -0700
From: Greg KH <gregkh@suse.de>
To: Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, torvalds@osdl.org
Cc: Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI bridge range sizing bug
Message-ID: <20070419234014.GB3215@suse.de>
References: <1175812632.17147.12.camel@localhost.localdomain> <200704191611.52125.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704191611.52125.jesse.barnes@intel.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 04:11:50PM -0700, Jesse Barnes wrote:
> On Thursday, April 5, 2007 3:37 pm Adam Jackson wrote:
> > So I'm attempting to do something fairly heinous (X server across
> > five video cards), and I hit a fun bug in bridge range setup.  See
> > attached lspci and dmesg, but the short of it is I've got two VGA
> > chips on one card behind a bridge, which is itself behind a second
> > PCI bridge, and the bridge ranges get set up so that I can't map the
> > ROMs, which means I can't post them, and therefore can't use them
> > period.
> >
> > The alignment restriction on the ROMs seems a bit extreme:
> >
> > % sudo setpci -s 7:2 ROM_ADDRESS=ffffffff
> > % sudo setpci -s 7:2 ROM_ADDRESS
> > f0000001
> >
> > (same for 7:1) so that might be part of the problem.
> 
> ...
> Allocating PCI resources starting at 88000000 (gap: 80000000:7ff00000)
> ...
> 
> That's ~2G of space, which should be plenty for your PCI resources I 
> hope?  If you have a bunch of cards with large BARS though you might be 
> running out.
> 
> ...
> PCI: Bridge: 0000:00:01.0
>   IO window: 4000-4fff
>   MEM window: a3500000-a35fffff (1M)
>   PREFETCH window: 90000000-97ffffff
> PCI: Bridge: 0000:00:03.0
>   IO window: disabled.
>   MEM window: a3400000-a34fffff (1M)
>   PREFETCH window: 98000000-9fffffff
> PCI: Bridge: 0000:00:1c.0
>   IO window: disabled.
>   MEM window: a3300000-a33fffff (1M)
>   PREFETCH window: 80000000-8fffffff
> PCI: Bridge: 0000:00:1c.4
>   IO window: 3000-3fff
>   MEM window: a3200000-a32fffff (1M)
>   PREFETCH window: a3700000-a37fffff
> PCI: Bridge: 0000:00:1c.5
>   IO window: 2000-2fff
>   MEM window: a3100000-a31fffff (1M)
>   PREFETCH window: disabled.
> PCI: Failed to allocate mem resource #6:10000000@b0000000 for 
> 0000:07:01.0
> PCI: Failed to allocate mem resource #6:10000000@b0000000 for 
> 0000:07:02.0
> ...
> 
> Yep, looks like those two devices had a problem.  Supposedly they want 
> to sit at 256M?  Given that we're only giving each bridge 1M of memory 
> space that would definitely be a problem.
> 
> The total so far is only 5M of PCI space... so we're not making good use 
> of the 2G we were given.
> 
> ...
> PCI: Bridge: 0000:06:00.0
>   IO window: disabled.
>   MEM window: a1000000-a2ffffff (32M)
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1e.0
>   IO window: 1000-1fff
>   MEM window: a1000000-a30fffff (~32M)
>   PREFETCH window: a0000000-a0ffffff
> ...
> 
> And these bridges got more space somehow...  Greg who's in charge of our 
> bridge resource allocation code?

Ivan and Linus seem to be doing the most of the work in this area, I
gladly pass these issues on to them :)

thanks,

greg k-h
