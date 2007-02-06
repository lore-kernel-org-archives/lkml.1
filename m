Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbXBFJAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbXBFJAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbXBFJAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:00:14 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:35900 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXBFJAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:00:11 -0500
Message-ID: <45C84399.70407@s5r6.in-berlin.de>
Date: Tue, 06 Feb 2007 10:00:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, David Moore <dcm@mit.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>, discuss@x86-64.org,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] Missing critical phys_to_virt in lib/swiotlb.c
References: <1170614380.26464.52.camel@PISCES.MIT.EDU> <20070205133556.9b290d0a.akpm@linux-foundation.org> <200702060856.45473.ak@suse.de>
In-Reply-To: <200702060856.45473.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/2007 8:56 AM, Andi Kleen wrote:
>> > From: David Moore <dcm@acm.org>
...
>> > It fixes real crashes:
>> > http://lists.opensuse.org/opensuse-bugs/2006-12/msg02943.html
>> > http://qa.mandriva.com/show_bug.cgi?id=28224
>> > http://www.pchdtv.com/forum/viewtopic.php?t=2063&sid=a959a14a4c2db0eebaab7b0df56103ce
>> > 
>> > --- linux-2.6.19.x86_64/lib/swiotlb.c.orig	2007-02-04 13:18:41.000000000 -0500
>> > +++ linux-2.6.19.x86_64/lib/swiotlb.c	2007-02-04 13:19:43.000000000 -0500
>> > @@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
>> >  
>> >  	for (i = 0; i < nelems; i++, sg++)
>> >  		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
>> > -			sync_single(hwdev, (void *) sg->dma_address,
>> > +			sync_single(hwdev, phys_to_virt(sg->dma_address),
>> >  				    sg->dma_length, dir, target);
>> >  }
...
> Sounds weird. If this really didn't work much more should be broken
> (e.g. no cdroms/sound on Intel x86-64 boxes with >4GB)

Yes, it's weird; e.g. it seems that reports of that on linux1394-user
and -devel came in only recently. But I may have missed something.
(OTOH, this bug was partially hidden for FireWire users because one of
the relevant FireWire drivers was lacking respective _sync_sg calls.)

> I'm a little sceptical. Perhaps the TV driver is doing something bogus
> here? 

sync_single() definitely wants a virtual address there. sg->dma_address
is a physical address. The bug and the fix are obvious.

Unfortunately an author of lib/swiotlb.c chose to call many variables
holding *virtual* addresses "dma_addr". Note how that file at the same
time contains variables like "dma_addr_t dma_handle". A recipe for disaster.

> Also I haven't heard of this problem before at all and I'm sure I would
> have if sounds/cdroms were broken.
> 
> Shouldn't be applied without further analysis.

Maybe some recent changes elsewhere cause more frequent use of
swiotlb-driven bounce buffers? That should be verified.

Or maybe people are deploying affected hardware more often now?
-- 
Stefan Richter
-=====-=-=== --=- --==-
http://arcgraph.de/sr/
