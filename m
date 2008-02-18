Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbYBRMJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbYBRMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758042AbYBRMJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:09:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009AbYBRMJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:09:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Mahoney <jeffm@suse.com>
Subject: Re: kernel BUG at kernel/power/snapshot.c:464!
Date: Mon, 18 Feb 2008 13:07:44 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <47ACA77E.2030001@suse.com> <47ACD9BA.5040608@suse.com> <200802090040.01479.rjw@sisk.pl>
In-Reply-To: <200802090040.01479.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181307.45429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 9 of February 2008, Rafael J. Wysocki wrote:
> On Friday, 8 of February 2008, Jeff Mahoney wrote:
> > Rafael J. Wysocki wrote:
> > > On Friday, 8 of February 2008, Pavel Machek wrote:
> > >> Hi!
> > >>
> > >>> Our old friend kernel BUG at kernel/power/snapshot.c:464! is back, this
> > >>> time from mainline. I can't reproduce with 2.6.24-final, but I can with
> > >>> a git snapshot from a few days ago. I'm doing a git bisect run now, but
> > >>> it's rather time consuming, so I thought I'd pass this on in the interim.
> > >>>
> > >>> I can reproduce this just by doing "cat /dev/snapshot".
> > >>>
> > >>> Working output looks like:
> > >>> swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> > >>> swsusp: Marking nosave pages: 00000000f7ff0000 - 0000000100000000
> > >>> swsusp: Basic memory bitmaps created
> > >>> swsusp: Basic memory bitmaps freed
> > >> root@amd:~# cat /dev/snapshot
> > >> cat: /dev/snapshot: No data available
> > >> root@amd:~#
> > >>
> > >> ...on less than two days old 2.6.25-rc0-git. Rafael, do you have any
> > >> ideas what may break?
> > >
> > > No idea and I can't reproduce it.
> > >
> > > Plus the trace looks bogus, as there are no "swsusp: ..." messages in the
> > > mainline any more.
> > 
> > The git version from two days ago did. :)
> > 
> > I just git pulled and built and got the same BUG.
> > 
> > Here are the nosave registration messages:
> > PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> > PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> > PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> > PM: Registered nosave memory: 00000000f7ff0000 - 00000000f7fff000
> > PM: Registered nosave memory: 00000000f7fff000 - 00000000f8000000
> > PM: Registered nosave memory: 00000000f8000000 - 00000000ff780000
> > PM: Registered nosave memory: 00000000ff780000 - 0000000100000000
> > 
> > And the old swsusp messages match those ranges, just coalesced into two
> > ranges.
> > 
> > Reassembling the zones from /proc/zoneinfo yields:
> > Node 0, zone DMA	start_pfn: 0, spanned 4096
> > 			(0x0-0x1000)
> > Node 0, zone DMA32	start_pfn: 4096, spanned 1011696
> > 			(0x1000-0xf7ff0)
> > Node 1, zone Normal	start_pfn: 1048576, spanned 1048576
> > 			(0x100000-200000)
> 
> Ah, NUMA.
> 
> > The pfn it's searching for is 0xf7ff0, which will end up hitting this in
> > memory_bm_find_bit:
> > while (pfn < zone_bm->start_pfn || pfn >= zone_bm->end_pfn) {
> > 	zone_bm = zone_bm->next;
> > 	BUG_ON(!zone_bm)
> > }
> > 
> > Should that be pfn > zone_bm->end_pfn, or is end_pfn non-inclusive?
> 
> It used to be non-inclusive and I think it is, as 0xf7ff0 seems to be the start
> of a reserved region.
> 
> Well, the assumption is that if the PFN doesn't belong to any zone, then
> pfn_valid() in mark_nosave_pages() should filter it out.  Apparently, it has
> stopped doing this at one point.

Andi, Thomas, Ingo,
the source of the bug is that on a K8 NUMA system there is a PFN for which
pfn_valid() returns 'true' and yet it doesn't belong to any zone.  Is there a
valid scenarion in which something like this is possible?  It didn't happen
with 2.6.24.

[Please see http://bugzilla.kernel.org/show_bug.cgi?id=9966 for the reference
to the entire thread.]

Thanks,
Rafael
