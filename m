Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbXKZVJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbXKZVJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXKZVJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:09:03 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42605 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750716AbXKZVJB (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:09:01 -0500
Date: Tue, 27 Nov 2007 08:08:44 +1100
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl, xfs@oss.sgi.com
Subject: Re: XFS related Oops (suspend/resume related)
Message-ID: <20071126210844.GB119954183@sgi.com>
References: <20071112064706.GA23595@dose.home.local> <20071112222720.GG995458@sgi.com> <20071113105119.GA11527@dose.home.local> <20071113230445.GE995458@sgi.com> <20071126131210.GA4430@eazy.amigager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126131210.GA4430@eazy.amigager.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 02:12:10PM +0100, Tino Keitel wrote:
> On Wed, Nov 14, 2007 at 10:04:45 +1100, David Chinner wrote:
> > On Tue, Nov 13, 2007 at 11:51:19AM +0100, Tino Keitel wrote:
> > > On Tue, Nov 13, 2007 at 09:27:20 +1100, David Chinner wrote:
> > > 
> > > [...]
> > > 
> > > > No. I'd say something got screwed up during suspend/resume. Is it
> > > > reproducable?
> > > 
> > > No. I often use suspend to RAM, and usually it works without such
> > > failures. I restart squid during the resume prosecure, and the above
> > > Oops lead to a squid in D state.
> > 
> > Ok. Sounds like there's not much we can debug at this point. Thanks
> > for the report, though.
> 
> I got a similar Oops again:
> 
> xfs_iget_core: ambiguous vns: vp/0xc00700c0, invp/0xcb5a1680

Now there's a message that I haven't seen in about 3 years.

It indicates that the linux inode connected to the xfs_inode is not
the correct one. i.e. that the linux inode cache is out of step with
the XFS inode cache.

Basically, that is not supposed to happen. I suspect that the way
threads are frozen is resulting in an inode lookup racing with
a reclaim. The reclaim thread gets stopped after any use threads,
and so we could have the situation that a process blocked in lookup
has the XFS inode reclaimed and reused before it gets unblocked.

The question is why is it happening now when none of that code in
XFS has changed?

Rafael, when are threads frozen? Only when they schedule or call
try_to_freeze()? Did the freezer mechanism change in 2.6.23 (this is
on 2.6.23.1)?  Is there some way of getting a stack trace of all the
processes in the system once the machine is frozen and about to
suspend so we can see if we blocked in a lookup?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
