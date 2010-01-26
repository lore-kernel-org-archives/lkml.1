Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235Ab0AZGUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0AZGUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021Ab0AZGUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:20:05 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:56058 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437Ab0AZGUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:20:01 -0500
Date: Tue, 26 Jan 2010 17:19:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: tytso@mit.edu, Ric Wheeler <rwheeler@redhat.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, Jan Kara <jack@suse.cz>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: IO error semantics
Message-ID: <20100126061954.GD15853@discord.disaster>
References: <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz> <20100118051847.GA8678@laptop> <20100118060518.GA9151@laptop> <20100118122437.GF7264@discord.disaster> <20100118140039.GA13909@laptop> <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk> <4B5DB78D.2090408@redhat.com> <20100125174723.GB28459@thunk.org> <20100125175529.GB2018@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125175529.GB2018@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:55:30AM +1100, Nick Piggin wrote:
> On Mon, Jan 25, 2010 at 12:47:23PM -0500, tytso@mit.edu wrote:
> > On Mon, Jan 25, 2010 at 10:23:57AM -0500, Ric Wheeler wrote:
> > > 
> > > For permanent write errors, I would expect any modern drive to do a
> > > sector remapping internally. We should never need to track this kind
> > > of information for any modern device that I know of (S-ATA, SAS,
> > > SSD's and raid arrays should all handle this).
> > 
> > ... and if the device is run out of all of its blocks in its spare
> > blocks pool, it's probably well past the time to replace said disk.
> > 
> > BTW, I really liked Dave Chinner's summary of the issues involved; I
> > ran into Kawai-san last week at Linux.conf.au, and we discussed pretty
> > much the same thing over lunch.  (i.e., that it's a hard problem, and
> > in some cases we need to retry the writes, such as a transient FC path
> > problem --- but some kind of write throttling is critical or we could
> > end up choking the VM due to too many pages getting dirtied and no way
> > of cleaning them.)
> 
> Well I just don't think we can ever discard them by default.

We have done this for a long time in XFS. e.g. If we can't issue IO
on the page (e.g. allocation fails or we are in a shutdown
situation already) we invalidate the page immediately, clear the
page uptodate flag and return an error to mark the address space
with an error. See xfs_page_state_convert() for more detail.

And besides, if there is an error of some kind sufficient to shut
down the filesystem, the last thing you want to do is write more
data to it and potentially make the problem worse, especially if
async transactions that the data write might rely on were cancelled
by the shutdown rather than pushed to disk....

> Therefore
> we must default to not discarding them, therefore we need to solve or
> work around the dirty page congestion problem some how.

Agreed. The way XFS treats data IO errors is because that's the only
thing we can do right now if we want the system to continue to function
in the face of IO errors....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
