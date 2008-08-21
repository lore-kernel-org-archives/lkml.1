Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYHUP4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYHUP4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYHUP4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:56:35 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:49969 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbYHUP4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:56:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACAqrUh5LD0w/2dsb2JhbAC2JYFm
X-IronPort-AV: E=Sophos;i="4.32,246,1217773800"; 
   d="scan'208";a="176601402"
Date: Fri, 22 Aug 2008 01:56:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821155629.GH5706@disturbed>
Mail-Followup-To: Matthew Wilcox <matthew@wil.cx>,
	Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <20080820004326.519405a2.akpm@linux-foundation.org> <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed> <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net> <20080821051508.GB5706@disturbed> <20080821060418.GC5706@disturbed> <20080821115310.GP8318@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821115310.GP8318@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 05:53:10AM -0600, Matthew Wilcox wrote:
> On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > One thing I just found out - my old *laptop* is 4-5x faster than the
> > 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> > if the long delays in dispatch is caused by an interaction with CTQ
> > but I can't change it on the cciss raid controllers. Are you using
> > ctq/ncq on your machine?  If so, can you reduce the depth to
> > something less than 4 and see what difference that makes?
> 
> I don't think that's going to make a difference when using CFQ.  I did
> some tests that showed that CFQ would never issue more than one IO at a
> time to a drive.  This was using sixteen userspace threads, each doing a
> 4k direct I/O to the same location.  When using noop, I would get 70k
> IOPS and when using CFQ I'd get around 40k IOPS.

Not obviously the same sort of issue. The traces clearly show
multiple nested dispatches and completions so CTQ is definitely
active...

Anyway, after a teeth-pulling equivalent exercise of finding the
latest firmware for the machine in a format I could apply, I
upgraded the firmware throughout the machine (disks, raid
controller, system, etc) and XFS is a *lot* faster. In fact -
mostly back to +/- a small amount compared to ext3.

run complete:
==========================================================================
				  avg MB/s       user       sys
			runs	 xfs   ext3    xfs ext3    xfs ext3
intial create total      30	6.36   6.29   4.48 3.79   7.03 5.22
create total              7	5.20   5.68   4.47 3.69   7.34 5.23
patch total               6	4.53   5.87   2.26 1.96   6.27 4.86
compile total             9    16.46   9.61   1.74 1.72   9.02 9.74
clean total               4   478.50 553.22   0.09 0.06   0.92 0.70
read tree total           2    13.07  15.62   2.39 2.19   3.68 3.44
read compiled tree        1    53.94  60.91   2.57 2.71   7.35 7.27
delete tree total         3    15.94s  6.82s  1.38 1.06   4.10 1.49
delete compiled tree      1    24.07s  8.70s  1.58 1.18   5.56 2.30
stat tree total           5	3.30s  3.22s  1.09 1.07   0.61 0.53
stat compiled tree total  3	2.93s  3.85s  1.17 1.22   0.59 0.55


The blocktrace looks very regular, too. All the big bursts of
dispatch and completion are gone as are the latencies on
log I/Os. It would appear that ext3 is not sensitive to
concurrent I/O latency like XFS is...

At this point, I'm still interested to know if the original
results were had ctq/ncq enabled and if it is whether it is
introducing latencies are not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
