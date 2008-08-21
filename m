Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYHUO4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYHUO4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbYHUOzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:55:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60525 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002AbYHUOzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:55:42 -0400
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, gus3 <musicman529@yahoo.com>,
       Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
In-Reply-To: <20080821085332.GG5706@disturbed>
References: <20080821051508.GB5706@disturbed>
	 <684252.68814.qm@web34508.mail.mud.yahoo.com>
	 <20080821061443.GD5706@disturbed>
	 <200808211700.39584.nickpiggin@yahoo.com.au>
	 <20080821085332.GG5706@disturbed>
Content-Type: text/plain; charset=utf-8
Date: Thu, 21 Aug 2008 10:52:44 -0400
Message-Id: <1219330364.7854.68.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 18:53 +1000, Dave Chinner wrote:
> On Thu, Aug 21, 2008 at 05:00:39PM +1000, Nick Piggin wrote:
> > On Thursday 21 August 2008 16:14, Dave Chinner wrote:
> > 
> > > I think that we need to issue explicit unplugs to get the log I/O
> > > dispatched the way we want on all elevators and stop trying to
> > > give elevators implicit hints by abusing the bio types and hoping
> > > they do the right thing....
> > 
> > FWIW, my explicit plugging idea is still hanging around in one of
> > Jens' block trees (actually he refreshed it a couple of months ago).
> > 
> > It provides an API for VM or filesystems to plug and unplug
> > requests coming out of the current process, and it can reduce the
> > need to idle the queue. Needs more performance analysis and tuning
> > though.
> 
> We've already got plenty of explicit unplugs in XFS to get stuff
> moving quickly - I'll just have to add another....
> 

I did some compilebench runs with xfs this morning, creating 30 kernel
trees on the same machine I posted btrfs and xfs numbers with last week.
Btrfs gets between 60 and 75MB/s average depending on the mount options
used, ext4 gets around 60MB/s

This is a single sata drive that can run at 100MB/s streaming writes.
The numbers show XFS is largely log bound, and that turning off barriers
makes a huge difference.  I'd be happy to try another run with explicit
unplugging somewhere in the transaction commit path.

I think the most relevant number is the count of MB written at the end
of blkparse. I'm not sure why the 4ag XFS writes less, but the numbers
do include calling sync at the end.  None of the filesystems were doing
barriers in these numbers:

Ext4                                9036MiB
Btrfs metadata dup                  9190MiB
Btrfs metadata dup no inline files 10280MiB
XFS 4ag, nobarrier                 14299MiB
XFS 1ag, nobarrier                 17836MiB

This is a long way of saying the xfs log isn't optimal for these kinds
of operations, which isn't really news.  I'm not ripping on xfs here,
this is just one tiny benchmark.

I uploaded some graphs of the IO here:

http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs


XFS:

*** 4ag, 128m log, logbsize=256k
intial create total runs 30 avg 7.48 MB/s (user 0.52s sys 1.04s)

*** 4ag, 128m log, logbsize=256k, nobarrier
intial create total runs 30 avg 21.58 MB/s (user 0.51s sys 1.04s)
﻿http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs/xfs-4ag-nobarrier.png

*** 1ag, 128m log, logbsize=256k, nobarrier
intial create total runs 30 avg 26.28 MB/s (user 0.50s sys 1.15s)
http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs/xfs-nobarrier-1ag.png

It is hard to see in the graph, but it looks like the log is in the
first 128MB of the drive.  If we give XFS an external log device:

*** 1ag 128m external log, logbsize=256k, nobarrier
intial create total runs 30 avg 38.44 MB/s (user 0.51s sys 1.09s)

This graph shows that log is running more or less seek free between
30-60MB/s for the whole run.  I'd expect the explicit unplugging to help
the most in this config?

http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs/xfs-external-log-disk.png

Here is the main disk during the run:
http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs/xfs-external-log-main-disk.png


*** 1ag 128m external log, logbsize=256k, nobarrier, deadline
intial create total runs 30 avg 34.00 MB/s (user 0.51s sys 1.07s)

Deadline didn't help on this box.

-chris


