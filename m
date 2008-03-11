Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYCKEYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYCKEYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYCKEX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:23:59 -0400
Received: from phunq.net ([64.81.85.152]:53422 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750735AbYCKEX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:23:58 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 10 Mar 2008 20:23:51 -0800
User-Agent: KMail/1.9.5
Cc: Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803100123.51395.phillips@phunq.net> <20080310093737.3c1e938a@core>
In-Reply-To: <20080310093737.3c1e938a@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102123.52067.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008 02:37, Alan Cox wrote:
> > Usual block device semantics are preserved so long as UPS power does
> > not run out before emergency writeback completes.  It is not possible
> > to order writes to the backing store and still deliver ramdisk level
> > write latency to the application.
> 
> Why - your chunks simply become a linked list in write barrier order.

Good idea, it would be nice to offer that operating mode.  But linear
sweeping is going to put the most data onto rotating media the fastest,
thus making the loss-of-line-power flush window as small as possible,
which is what the current incarnation of this driver optimizes for.

Note that half a TB worth of dirty ramdisk chunks will need 1 GB of
linked list storage, so this imposes a limit on total dirty data for
practical purposes.

> Solve your bitmap sweep cost as well.

What happens with the linked list gets too long?  Fall back to linear
sweep?  Or accept suboptimal write caching?

A linked list would work for linking together dirty bitmap pages, one
level up, thus 2**15 rarer.  Even there I prefer the linear sweep.  I
intend to implement a dirty map of the dirty map, at least because I
have not seen one of those before, but also because I think it will
perform well.

> As you are already making a copy 
> before going to backing store you don't have the internal consistency
> problems of further writes during the I/O.

Indeed.  That is the entire reason I did it that way.  In fact ramback
used to write the ramdisk and backing store from the same application
source, so the writethrough code was significantly shorter.  But not
correct...

> Yes you may need to throttle in the specific case of having too many
> copies of pages sitting in the queue - but surely that would be the set of
> pages that are written but not yet committed from a previous store
> barrier ?

The only time ramback cares about barriers is when it switches to
writethrough mode.  It would be nice to have a mode where barriers are
respected at the backing store level, but there is no way you will get
the same write performance.  The central idea here is that ramback
relies on a UPS to achieve the ultimate in disk performance.  I agree
that other modes would be very nice, but not necessary for this thing
to be actually useful.  I suspect than early users will be looking for
all the performance that can get.

> BTW: I'm also curious why you made it a block device. What does that
> offer over say ramfs + dnotify and a userspace daemon or perhaps for big
> files to work smoothly a ramfs variant that keeps dirty bitmaps on file
> pages.

As a block device it is very flexible, and as a block device it is
fairly simple.  As a block device, the only interesting userspace setup
is the hookup to power management scripts.  Dnotify... probably you
meant inotify, and even then it sounds daunting, but maybe somebody
can prove me wrong.

> That way write back would be file level and while you might lose 
> changesets that have not been fsync()'d your underlying disk fs would
> always be coherent.

That would a nice hack, why not take a run at it?

Regards,

Daniel
