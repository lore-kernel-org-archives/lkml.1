Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbXEIRWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbXEIRWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbXEIRWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:22:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756775AbXEIRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:22:15 -0400
Date: Wed, 9 May 2007 10:21:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
       bunk@stusta.de, linux-kernel@vger.kernel.org
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070509094418.GA13245@kroah.com>
Message-ID: <alpine.LFD.0.98.0705091010320.4062@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508140753.GB12641@kroah.com> <20070508.135810.48808124.davem@davemloft.net>
 <20070509094418.GA13245@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 May 2007, Greg KH wrote:

> On Tue, May 08, 2007 at 01:58:10PM -0700, David Miller wrote:
> > 
> > 1) A proper dependency system is necessary
> > 
> > 2) Proper mutual exclusion for shared system resources/registers/etc.
> >    that are poked at in an ad-hoc unlocked manner currently
> > 
> > Is that basically what it boils down to?
> 
> Yes, that's about it.
> 
> Number 1 seemed to cause the most crashes, I don't think number 2 ever
> caused any problems, but it might have, there were too many weird oopses
> to be able to rule that out.

One issue is that a lot of shared resources and their locking really 
aren't known until *after* you've done a first-level probing.

The classic example of this really is a cardbus controller, and almost any 
multi-function PCI device. Yes, they are "independent" PCI devices in 
their own right, but they almost invariably have some shared state.

A bus driver that probes them concurrently is simply broken. 

And no, the solution is not to special-case multi-function devices and 
always probe the subfunctions serially. That would suck for many things 
(disk controllers are *also* often subfunctions). The solution really *is* 
to probe the devices serially, and let the layer that actually knows what 
it is doing (the low-level driver) decide how it goes from there.

I can almost guarantee that the same is true of most other buses. For 
example, I wouldn't be surprised at all to hear that you shouldn't probe 
the individual LUN's of many "SCSI" devices concurrently. The number of 
bugs in things like multifunction card readers (total lockup if you read 
the wrong config pages or even try to read past the end of the flash etc) 
is just scary.

(Server people seem to think that "SCSI" == "high-end expensive hardware 
that we paid too much for", and yes, that's sometimes true, but "SCSI" 
also equals "el-cheapo stuff that sells for $5 and talks something that 
looks enough like SCSI commands that we want to consider it SCSI").

So I'm really convinced that the bus layer should be serial and then have 
some capability to allow lower levels to do the things *they* know is fine 
to do independently in a parallel way. But anything that makes that be a 
bus-level choice is almost guaranteed to be broken on just about all 
buses!

			Linus
