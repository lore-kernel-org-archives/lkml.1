Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbXLYJON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbXLYJON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 04:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbXLYJN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 04:13:58 -0500
Received: from relay2.sgi.com ([192.48.171.30]:57652 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751386AbXLYJN5 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 04:13:57 -0500
Date: Tue, 25 Dec 2007 20:13:47 +1100
From: David Chinner <dgc@sgi.com>
To: Janos Haar <djani22@netcenter.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: xfs|loop|raid: attempt to access beyond end of device
Message-ID: <20071225091347.GA155407@sgi.com>
References: <015601c84598$fa668f30$9900a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <015601c84598$fa668f30$9900a8c0@dcccs>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 08:21:08PM +0100, Janos Haar wrote:
> Hello, list,
> 
> I have a little problem on one of my productive system.
> 
> The system sometimes crashed, like this:
> 
> Dec 23 08:53:05 Albohacen-global kernel: attempt to access beyond end of
> device
> Dec 23 08:53:05 Albohacen-global kernel: loop0: rw=1, want=50552830649176,
> limit=3085523200
> Dec 23 08:53:05 Albohacen-global kernel: Buffer I/O error on device loop0,
> logical block 6319103831146
> Dec 23 08:53:05 Albohacen-global kernel: lost page write due to I/O error on
> loop0

So a long way beyond the end of the device.

[snip soft lockup warnings]

> Dec 23 09:08:19 Albohacen-global kernel: Filesystem "loop0": Access to block
> zero in inode 397821447 start_block: 0 start_off: 0 blkcnt: 0 extent-state:
> 0 lastx: e4

And that's to block zero of the filesystem. Sure signs of a corupted inode
extent btree. We've seen a few of these corruptions on loopback device
reported recently.

You'll need to unmount and repair the filesystem to make this go away,
but it's hard to know what is causing the btree corruption.

> Dec 23 09:08:22 Albohacen-global last message repeated 19 times
> 
> some more info:
> 
> [root@Albohacen-global ~]# uname -a
> Linux Albohacen-global 2.6.21.1 #3 SMP Thu May 3 04:33:36 CEST 2007 x86_64
> x86_64 x86_64 GNU/Linux
> [root@Albohacen-global ~]# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> [multipath] [faulty]
> md1 : active raid4 sdf2[1] sde2[0] sdd2[5] sdc2[4] sdb2[3] sda2[2]
>       19558720 blocks level 4, 64k chunk, algorithm 0 [6/6] [UUUUUU]
>       bitmap: 8/239 pages [32KB], 8KB chunk
> 
> md2 : active raid4 sdf3[1] sde3[0] sdd3[5] sdc3[4] sdb3[3] sda3[2]
>       1542761600 blocks level 4, 64k chunk, algorithm 0 [6/6] [UUUUUU]
>       bitmap: 0/148 pages [0KB], 1024KB chunk
> 
> md0 : active raid1 sdb1[1] sda1[0]
>       104320 blocks [2/2] [UU]
> 
> unused devices: <none>
> [root@Albohacen-global ~]# losetup /dev/loop0
> /dev/loop0: [0010]:6598 (/dev/md2), encryption blowfish (type 18)

You're using an encrypted block device? What mechanism are you using for
encryption (doesn't appear to be dmcrypt)? Does it handle readahead bio
cancellation correctly? We had similar XFS corruption problems on dmcrypt
between 2.6.14 and ~2.6.20 due to a bug in dmcrypt's failure to handle
aborted readahead I/O correctly....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
