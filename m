Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYCLWfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYCLWfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYCLWex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:34:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34061 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYCLWew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:34:52 -0400
Date: Wed, 12 Mar 2008 15:34:31 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
	Reported regressions from 2.6.24)
Message-ID: <20080312223431.GA24150@kroah.com>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com> <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 03:20:51PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 12 Mar 2008, Greg KH wrote:
> > 
> > Ok, I think I got it.  And it looks like an ACPI bug, but one that we
> > might have been ignoring for a long time...
> 
> I still think that the fact that it regressed in that PCI patch means that 
> there is simply something wrong with the patch. At the very least that 
> patch changed behaviour, which was *not* what it was claiming it was 
> doing.
> 
> I do think it's triggered by the "acpi=noirq" setting: that means that 
> ACPI *won't* disable the legacy scan. Now, admittedly that's a really odd 
> thing to do, and I think it's really strange how pci_acpi_init() does that
> 
> 	pcibios_scanned++;
> 
> in a place where it is not actually scanning the bus, so I do agree that 
> ACPI is doing something really odd here, but the fact is, this code all 
> used to work.
> 
> Can we please just fix the regression caused by that offending patch?  In 
> other words: why did that patch change behaviour AT ALL?
> 
> Quite frankly, we're too late in the game to say "this exposed some other 
> long-time bug". That *particular* patch needs to be fixed, or reverted. We 
> can look at changing ACPI in 2.6.26, not in -rc6.

What happend in .25-rc was that we now catch these kinds of problems
(watching for duplicate kobjects to be registered and such.)  So this
might have always been happening, but no warning was ever produced.

I can revert the "catch this kind of thing" patch, but I don't think
that's the real solution here :)

The reason we aren't shutting down is also due to the way kobjects now
work.  If you don't clean up properly, they linger around and something
on the shutdown path (I haven't figured that out yet) doesn't want to
stop the machine.

We have seen this in a number of places, all catching real problems in
subsystems where they were grabbing 2 references to an object, and then
only releasing one when finished (cpufreq is an example of this.)  When
those are fixed, the shutdown problem goes away.

So in this case, we are registering a kobject twice, which increases the
reference count, and then we never clean it up on shutdown properly as
we only drop it once.  Hence the shutdown problem.

So, we need to not register the device twice, my patch should fix that
problem.  Or we can add the pcibios_scanned++ call somewhere in PNP or
ACPI to prevent us from ever attempting to try to register the device
twice.  Either way should fix Guennadi's issue.

thanks,

greg k-h
