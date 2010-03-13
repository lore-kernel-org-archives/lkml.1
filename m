Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab0CMNQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 08:16:16 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:54635 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759179Ab0CMNQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 08:16:14 -0500
Date: Sun, 14 Mar 2010 00:16:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: howto combat highly pathologic latencies on a server?
Message-ID: <20100313131609.GH4732@dastard>
References: <201003101817.42812.hpj@urpla.net>
 <20100310232940.GB16344@discord.disaster>
 <201003111758.50224.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201003111758.50224.hpj@urpla.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 05:58:49PM +0100, Hans-Peter Jansen wrote:
> On Thursday 11 March 2010, 00:29:40 Dave Chinner wrote:
> > On Wed, Mar 10, 2010 at 06:17:42PM +0100, Hans-Peter Jansen wrote:
> > >
> > > The xfs filesystems are mounted with rw,noatime,attr2,nobarrier,noquota
> > > (yes, I do have a BBU on the areca, and disk write cache is effectively
> > > turned off).
> >
> > Make sure the filesystem has the "lazy-count=1" attribute set (use
> > xfs_info to check, xfs_admin to change). That will remove the
> > superblock from most transactions and significant reduce latency of
> > transactions as they serialise while locking it...
> 
> Done that now on my local test system, but on one of its filesystems, 
> xfs_admin -c1 didn't succeed, it simply stopped (waiting for a futex):
> 
> Famous last syscall:
> 6750  futex(0x868330c8, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
> 
> Consequently, xfs_repair behaved similar, hanging in phase 6, traversing 
> filesystem... I have a huge strace from this run, if someone is interested.
> 
> It's an 3 TB Raid 5 array (4 * 1 TB hd) with one FS also driven by areca:
> 
> meta-data=/dev/sdb1              isize=256    agcount=4, agsize=183105406 
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=732421623, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Luckily, xfs_repair -P finally did succeed. Phuah.. 
> 
> This is with: xfs_repair version 2.10.1.
> 
> After calling xfs_admin -c1, all filesystems showed differences in 
> superblock features (from a xfs_repair -n run). Is xfs_repair mandatory, or 
> does the initial mount fix this automatically? 

Mandatory - there are extra fields in the AGF headers that track
free space btree block usage (the tree itself) that need to be
calculated correctly. This allows the block usage in the filesystem
to be tracked from the AGFs rather than the superblock, hence
removing the single poにnt of contention in the allocation path...

xfs_repair does this calculation for us - putting that code into the
kernel to avoid running repair is a lot of work for a relatively
rare operation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
