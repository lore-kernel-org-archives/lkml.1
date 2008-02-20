Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYBTBE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYBTBE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYBTBEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:04:21 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39633 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755131AbYBTBEU (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:04:20 -0500
Date: Wed, 20 Feb 2008 12:04:06 +1100
From: David Chinner <dgc@sgi.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: inode leak in 2.6.24?
Message-ID: <20080220010405.GF155407@sgi.com>
References: <87hcg9hkpp.fsf@szonett.ki.iif.hu> <20080218215344.GM155407@sgi.com> <87skzoanq3.fsf@szonett.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skzoanq3.fsf@szonett.ki.iif.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:57:08PM +0100, Ferenc Wagner wrote:
> David Chinner <dgc@sgi.com> writes:
> > On Sat, Feb 16, 2008 at 12:18:58AM +0100, Ferenc Wagner wrote:
> So, I loaded the same kernel on a different machine, but that seems to
> exhibit a very similar behaviour.  The machine is absolutely idle,
> nobody logged in during this period, though an updatedb ran during
> this period.  However, the increase seems steady, not correlated to
> cron.daily.
> 
> The contents of /proc/sys/fs/inode-nr after reboot was:
> 4421	95
> 
> and now, 13h35m later it's:
> 146182	0
> 
> Find the two slabinfo outputs attached.

Content-Description: slabinfo output immediately after reboot
> xfs_inode            791    800    384   10    1 : tunables   54   27    8 : slabdata     80     80      0
> xfs_vnode            790    790    384   10    1 : tunables   54   27    8 : slabdata     79     79      0
> dentry              5133   5133    132   29    1 : tunables  120   60    8 : slabdata    177    177      0

Content-Description: slabinfo output 13h35m after reboot
> xfs_inode         142548 142550    384   10    1 : tunables   54   27    8 : slabdata  14255  14255      0
> xfs_vnode         142548 142550    384   10    1 : tunables   54   27    8 : slabdata  14255  14255      0
> dentry            148003 148074    132   29    1 : tunables  120   60    8 : slabdata   5106   5106      0

> The xfs_inode, xfs_vnode and dentry lines show significant increase.
> The machine indeed uses XFS as its root filesystem.  Hope this gives
> enough clues to narrow down the problem.  I can try other kernels if
> needed.

The xfs inodes are clearly pinned by the dentry cache, so the issue
is dentries, not inodes. What's causing dentries not to be
reclaimed?  I can't see anything that cold pin them (e.g. no filp's
that would indicate open files being responsible), so my initial
thoughts are that memory reclaim may have changed behaviour.

I guess the first thing to find out is whether memory pressure
results in freeing the dentries. To simulate memory pressure causing
slab cache reclaim, can you run:

# echo 2 > /proc/sys/vm/drop_caches

and see if the number of dentries and inodes drops. If the number
goes down significantly, then we aren't leaking dentries and there's
been a change in memoy reclaim behaviour. If it stays the same, then
we probably are leaking dentries....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
