Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0CLElf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:41:35 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:56999 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755338Ab0CLEld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:41:33 -0500
Date: Fri, 12 Mar 2010 15:41:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: Nick's vfs-scalability patches ported to 2.6.33-rt
Message-ID: <20100312044112.GC4732@dastard>
References: <1267163608.2002.9.camel@work-vm>
 <20100226060109.GH9738@laptop>
 <1267659090.4317.67.camel@localhost.localdomain>
 <20100304033312.GO8653@laptop>
 <1267675511.4317.78.camel@localhost.localdomain>
 <1268189462.3339.12.camel@localhost.localdomain>
 <20100310090142.GA9529@infradead.org>
 <1268363312.3475.85.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268363312.3475.85.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 07:08:32PM -0800, john stultz wrote:
> On Wed, 2010-03-10 at 04:01 -0500, Christoph Hellwig wrote:
> > On Tue, Mar 09, 2010 at 06:51:02PM -0800, john stultz wrote:
> > > So this all means that with Nick's patch set, we're no longer getting
> > > bogged down in the vfs (at least at 8-way) at all. All the contention is
> > > in the actual filesystem (ext2 in group_adjust_blocks, and ext3 in the
> > > journal and block allocation code).
> > 
> > Can you check if you're running into any fs scaling limit with xfs?
> 
> 
> Here's the charts from some limited testing:
> http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/xfs-dbench.png

What's the X-axis? Number of clients?

If so, I have previously tested XFS to make sure throughput is flat
out to about 1000 clients, not 8. i.e I'm not interested in peak
throughput from dbench (generally a meaningless number), I'm much
more interested in sustaining that throughput under the sorts of
loads a real fileserver would see...

> They're not great.  And compared to ext3, the results are basically
> flat.
> http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/ext3-dbench.png
> 
> Now, I've not done any real xfs work before, so if there is any tuning
> needed for dbench, please let me know.

Dbench does lots of transactions which runs XFS into being log IO
bound. Make sure you have at least a 128MB log and are using
lazy-count=1 andperhaps even the logbsize=262144 mount option.  but
in general it only takes 2-4 clients to reach maximum throughput on
XFS....

> The odd bit is that perf doesn't show huge overheads in the xfs runs.
> The spinlock contention is supposedly under 5%. So I'm not sure whats
> causing the numbers to be so bad.

It's bound by sleeping locks or IO. call-graph based profiles
triggered on context switches are the easiest way to find the
contending lock.

Last time I did this (around 2.6.16, IIRC) it involved patching the
kernel to put the sample point in the context switch code - can we
do that now without patching the kernel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
