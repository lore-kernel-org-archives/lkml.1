Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbYEPS71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbYEPS71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbYEPS7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:59:16 -0400
Received: from sandeen.net ([209.173.210.139]:12481 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYEPS7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:59:15 -0400
Message-ID: <482DD981.5070004@sandeen.net>
Date: Fri, 16 May 2008 13:59:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>,
       xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com>
In-Reply-To: <482DC043.5000307@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> I just attempted a kernel upgrade from 2.6.20.7 to 2.6.25.3 and it no longer
> mounts my xfs filesystem.
> 
> I bisected it to around
> a67d7c5f5d25d0b13a4dfb182697135b014fa478
> [XFS] Move platform specific mount option parse out of core XFS code

around that... not exactly?  That commit should have been largely a code
move, which is not to say that it can't contain a bug... :)

> I have a RAID5 array with partitions:
> 
> Partition Table for /dev/md_d0
> 
>                First       Last
>  # Type       Sector      Sector   Offset    Length   Filesystem Type (ID) Flag
> -- ------- ----------- ----------- ------ ----------- -------------------- ----
>  1 Primary           0  2500288279      4  2500288280 Linux (83)           None
>  2 Primary  2500288280  2500483583      0      195304 Non-FS data (DA)     None
> 
> 
> when I attempt to mount /media:
> /dev/md_d0p1 /media xfs rw,nobarrier,noatime,logdev=/dev/md_d0p2,allocsize=512m 0 0

mythbox?  :)

Hm, so it's the external log size that it doesn't much like...

> I get:
>  md_d0: p1 p2
> XFS mounting filesystem md_d0p1
> attempt to access beyond end of device
> md_d0p2: rw=0, want=195311, limit=195304

what does /proc/partitions say about md_d0p1 and p2?  Is it different
between the older & newer kernel?

What does xfs_info /mount/point say about the filesystem when you mount
it under the older kernel?  Or... if you can't mount it,

xfs_db -r -c "sb 0" -c p /dev/md_d0p1

-Eric
