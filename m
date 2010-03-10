Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab0CJX3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:29:45 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:57222 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755397Ab0CJX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:29:44 -0500
Date: Thu, 11 Mar 2010 10:29:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: howto combat highly pathologic latencies on a server?
Message-ID: <20100310232940.GB16344@discord.disaster>
References: <201003101817.42812.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003101817.42812.hpj@urpla.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 06:17:42PM +0100, Hans-Peter Jansen wrote:
> in a commercial setting, with all those evil elements at work like VMware, 
> NFS, XFS, openSUSE, diskless fat clients, you name it...
> 
> System description:
> 
> Dual socket board: Tyan S2892, 2 * AMD Opteron 285 @ 2.6 GHz, 8 GB RAM, 
> PRO/1000 MT Dual Port Server NIC, Areca ARC-1261 16 channel RAID 
> controller, with 3 sets of RAID 5 arrays attached:
> System is running from: 4 * WD Raptor 150GB (WDC WD1500ADFD-00NLR5)
> VMware (XP-) images used via NFS: 6 * WD Raptor 74 GB (WDC WD740GD-00FLA0)
> Homes, diskless clients, appl. data: 4 * Hitachi 1 GB (HDE721010SLA330).
> 
> All filesystems are xfs. The server serves about 20 diskless PC's, most use 
> an Intel Pro/1000 GT NIC, all attached on a 3com 3870 48-port 10/100/1000 
> switch.
> 
> OS is openSUSE 11.1/i586 with kernel 2.6.27.45 (the same kernel as SLE 11).
> 
> It serves mostly NFS, SMB, and does mild database (MySQL) and email 
> processing (Cyrus IMAP, Postfix...). It also drives an ancient (but very 
> important) terminal based transport order mgmt system, that often syncs 
> it's data. Unfortunately, it's also used for running a VMware-Server 
> (1.0.10) XP-client, that itself does simple database stuff (employers time 
> registration).
> 
> Users generally describe this system as slow, although the load on the 
> server is less than 1.5 most of the time. Interestingly, the former system, 
> using ancient kernels (2.6.11, SuSE 9.3) was perceived significantly 
> quicker (but not fast..).
> 
> The diskless clients are started once in the morning (taking 60-90 sec), use 
> an aufs2 layered NFS mount for their openSUSE 11.1 system, and simple NFS 
> mounted homes and shared folders. 2/3th also need running a VMware XP 
> client (also NFS mounted). Their CPUs range from Athlon 64 3000+ up to 
> Phenom X4 955, with 2 or 4 GB RAM.
> 
> While this system usually operates fine, it suffers from delays, that are 
> displayed in latencytop as: "Writing page to disk:     8425,5 ms": 
> ftp://urpla.net/lat-8.4sec.png, but we see them also in the 1.7-4.8 sec 
> range: ftp://urpla.net/lat-1.7sec.png, ftp://urpla.net/lat-2.9sec.png, 
> ftp://urpla.net/lat-4.6sec.png and ftp://urpla.net/lat-4.8sec.png.
> 
> From other observations, this issue "feels" like it is induced by single 
> syncronisation points in the block layer, eg. if I create heavy IO load on 
> one RAID array, say resizing a VMware disk image, it can take up to a 
> minute to log in by ssh, although the ssh login does not touch this area at 
> all (different RAID arrays). Note, that the latencytop snapshots above are 
> made during normal operation, not this kind of load..
> 
> The network side looks fine, as its main interface rarely passes 40MiB/s, 
> and usually keeps in the 1 Kib/s - 5 MiB/s range. 
> 
> The xfs filesystems are mounted with rw,noatime,attr2,nobarrier,noquota 
> (yes, I do have a BBU on the areca, and disk write cache is effectively 
> turned off). 

Make sure the filesystem has the "lazy-count=1" attribute set (use
xfs_info to check, xfs_admin to change). That will remove the
superblock from most transactions and significant reduce latency of
transactions as they serialise while locking it...

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com
