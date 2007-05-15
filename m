Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbXEOAPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbXEOAPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbXEOAPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:15:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34882 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756669AbXEOAPM (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:15:12 -0400
Date: Tue, 15 May 2007 10:14:50 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070515001450.GS86004887@sgi.com>
References: <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <Pine.LNX.4.61.0705121323030.9570@yvahk01.tjqt.qr> <20070512135143.GG85884050@sgi.com> <4645D594.4070801@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4645D594.4070801@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 07:56:20AM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > What I don't understand is that on unmount dirty xfs inodes get
> > written out. Clearly this is not happening - either there's a hole
> > in the writeback logic (unlikely - it was unchanged) or we've missed
> > some case where we need to update the filesize and mark the inode
> > dirty.
> >
> > Hmmmm - if the write was just a short append to the file, then the
> > block that was written to should already be mapped. Then we'll just
> > look up the extent by doing a BMAPI_READ lookup, set the type to
> > IOMAP_READ and add the block to ioend we are building.
> >   
> 
> Well, that result I mailed you showed that the difference was just over
> 16k, and that there was a 32 block difference in the final extent
> length.  Does that fit with this theory?

Yes - because when we do specualtive allocation of 64k beyond EOF
by default on appends....

> > The type IOMAP_READ determines the I/O completion behaviour - in this case
> > it is xfs_end_bio_read(), which fails to update the file size....
> >
> > Bingo.
> >
> > A patch for you to try, Jeremy. I've just started a test run on it...
> >   
> 
> Thanks, I'll give it a spin.  Have you reproduced the bug yourself?

No, not yet. I haven't had chance because I'm travelling at the moment....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
