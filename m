Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbXEPROV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbXEPROV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbXEPROO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:14:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18341 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbXEPRON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:14:13 -0400
Date: Wed, 16 May 2007 13:11:56 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-ID: <20070516171156.GY26766@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com> <464B2AC2.10206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B2AC2.10206@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 12:01:06PM -0400, Chuck Ebbert wrote:
> Chris Mason wrote:
> > For example, I'll pick on xfs for a minute.  compilebench shows the
> > default FS you get from mkfs.xfs is pretty slow for untarring a
> > bunch of kernel trees.  Dave Chinner gave me some mount options that
> > make it dramatically better, but it still writes at 10MB/s on a sata
> > drive that can do 80MB/s.  Ext3 is better, but still only 20MB/s. 
> > 
> 
> Now try JFS. My lawn grows faster than it can write a new kernel tree.
> 
> What we need is a tool that shows *why* this stuff happens...
> 
Unfortunately, this varies with every FS.  ext3 is pretty fast for the
first 10 or so untars, and then the log wraps.  I tossed a systemtap
probe into __log_wait_for_space and basically every time it gets called
vmstat shows write throughput go from 30MB/s to 4MB/s.

Presumably, xfs suffers from something similar since tuning the log to
be larger and the log buffers to be larger improves performance.  I
don't remember if the jfs log is tunable here or not.

On ext3, blktrace shows that we're getting pretty good overall
sequential writeback except for the log flushing.  reiserfsv3 gives
similar numbers to xfs, which is important only because I spent a
bunch of time tuning the v3 log flushing code to work in big batches a
few years ago.

At least on ext3, it may help to sort the blocks under io for
flushing...it may not.  A bigger log would definitely help, but I would
say the mkfs defaults should be reasonable for a workload this simple.

(data=writeback was used for my ext3 numbers).

-chris

