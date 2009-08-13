Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZHMTSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZHMTSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZHMTSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:18:20 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42101 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbZHMTST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:18:19 -0400
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
  slot is freed)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: david@lang.hm, Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
In-Reply-To: <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
References: <200908122007.43522.ngupta@vflare.org>
	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
	 <20090813151312.GA13559@linux.intel.com>
	 <20090813162621.GB1915@phenom2.trippelsdorf.de>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 19:18:15 +0000
Message-Id: <1250191095.3901.116.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 14:15 -0400, Greg Freemyer wrote:
> On Thu, Aug 13, 2009 at 12:33 PM, <david@lang.hm> wrote:
> > On Thu, 13 Aug 2009, Markus Trippelsdorf wrote:
> >
> >> On Thu, Aug 13, 2009 at 08:13:12AM -0700, Matthew Wilcox wrote:
> >>>
> >>> I am planning a complete overhaul of the discard work.  Users can send
> >>> down discard requests as frequently as they like.  The block layer will
> >>> cache them, and invalidate them if writes come through.  Periodically,
> >>> the block layer will send down a TRIM or an UNMAP (depending on the
> >>> underlying device) and get rid of the blocks that have remained unwanted
> >>> in the interim.
> >>
> >> That is a very good idea. I've tested your original TRIM implementation on
> >> my Vertex yesterday and it was awful ;-). The SSD needs hundreds of
> >> milliseconds to digest a single TRIM command. And since your
> >> implementation
> >> sends a TRIM for each extent of each deleted file, the whole system is
> >> unusable after a short while.
> >> An optimal solution would be to consolidate the discard requests, bundle
> >> them and send them to the drive as infrequent as possible.
> >
> > or queue them up and send them when the drive is idle (you would need to
> > keep track to make sure the space isn't re-used)
> >
> > as an example, if you would consider spinning down a drive you don't hurt
> > performance by sending accumulated trim commands.
> >
> > David Lang
> 
> An alternate approach is the block layer maintain its own bitmap of
> used unused sectors / blocks. Unmap commands from the filesystem just
> cause the bitmap to be updated.  No other effect.
> 
> (Big unknown: Where will the bitmap live between reboots?  Require DM
> volumes so we can have a dedicated bitmap volume in the mix to store
> the bitmap to? Maybe on mount, the filesystem has to be scanned to
> initially populate the bitmap?   Other options?)

I wouldn't really have it live anywhere.  Discard is best effort; it's
not required for fs integrity.  As long as we don't discard an in-use
block we're free to do anything else (including forget to discard,
rediscard a discarded block etc).

It is theoretically possible to run all of this from user space using
the fs mappings, a bit like a defrag command.

One other option would just be to scan on mount, discard everything
empty and redo on next mount ... this might be just the thing for
laptops.

> Assuming we have a persistent bitmap in place, have a background
> scanner that kicks in when the cpu / disk is idle.  It just
> continuously scans the bitmap looking for contiguous blocks of unused
> sectors.  Each time it finds one, it sends the largest possible unmap
> down the block stack and eventually to the device.
> 
> When normal cpu / disk activity kicks in, this process goes to sleep.
> 
> That way much of the smarts are concentrated in the block layer, not
> in the filesystem code.  And it is being done when the disk is
> otherwise idle, so you don't have the ncq interference.
> 
> Even laptop users should have enough idle cpu available to manage
> this.  Enterprise would get the large discards it wants, and
> unmentioned in the previous discussion, mdraid gets the large discards
> it also wants.
> 
> ie. If a mdraid raid5/raid6 volume is built of SSDs, it will only be
> able to discard a full stripe at a time. Otherwise the P=D1 ^ D2 logic
> is lost.
> 
> Another benefit of the above is the code should be extremely safe and testable.

Actually, I think, if we go in-kernel, the discard might be better tied
into the block plugging mechanism.  The real test might be no
outstanding commands and queue plugged, keep plugged and begin
discarding.

James


