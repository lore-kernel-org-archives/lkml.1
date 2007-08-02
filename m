Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbXHBWUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbXHBWUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbXHBWUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:20:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40693 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756617AbXHBWUN (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:20:13 -0400
Date: Fri, 3 Aug 2007 08:20:02 +1000
From: David Chinner <dgc@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Tesarik <ptesarik@suse.cz>, Dave Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mmap behavior on out-of-space conditions
Message-ID: <20070802222002.GT12413810@sgi.com>
References: <1186058486.2289.17.camel@elijah.suse.cz> <1186059975.12034.111.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186059975.12034.111.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 03:06:15PM +0200, Peter Zijlstra wrote:
> On Thu, 2007-08-02 at 14:41 +0200, Petr Tesarik wrote:
> > Hello,
> > 
> > while solving a different issue, my colleague Libor Pechacek found a
> > problem with handling mmapped sparse files. If you mmap the hole insidea
> > sparse file and write to it, the data gets silently lost if there is not
> > enough space left on the underlying device.
> 
> I think Dave's block_page_mkwrite() stuff addresses this as well, no?
> 
> http://lkml.org/lkml/2007/3/18/198

Yes it does. But only XFS hooks that right now. It works, too. ;)

Create and mount 128MB filesystem:

budgie:~ # mkfs.xfs -f -d size=128m /dev/sdb9
....

Fill it up:

budgie:~ # dd if=/dev/zero of=/mnt/scratch/fred bs=1024k count=127
dd: writing `/mnt/scratch/fred': No space left on device
119+0 records in
118+0 records out
124764160 bytes (125 MB) copied, 4.69505 seconds, 26.6 MB/s
budgie:~ # sync
budgie:~ # df -h /mnt/scratch
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb9             124M  120M   48K 100% /mnt/scratch

Free up one block:

budgie:~ # xfs_io -f -c "truncate 124760000" /mnt/scratch/fred
budgie:~ # df -h /mnt/scratch
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb9             124M  120M   52K 100% /mnt/scratch

Create sparse file:

budgie:~ # dd if=/dev/zero of=/mnt/scratch/sparse_mmap_file bs=4k count=1 seek=1000000000
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 0.00022675 seconds, 18.1 MB/s
budgie:~ # ls -l /mnt/scratch/sparse_mmap_file
-rw-r--r-- 1 root root 4096000004096 Aug  3 08:13 /mnt/scratch/sparse_mmap_file

Mmap sparse file and try to write to it:

budgie:~ # xfs_io -f -c "mmap 0 1000000000" -c " mwrite 4000000 50000" /mnt/scratch/sparse_mmap_file
Bus error

There's your bus error. The blocks that were allocated before ENOSPC:

budgie:~ # xfs_bmap -vp /mnt/scratch/sparse_mmap_file
/mnt/scratch/sparse_mmap_file:
 EXT: FILE-OFFSET               BLOCK-RANGE      AG AG-OFFSET             TOTAL
   0: [0..7807]:                hole                                       7808
   1: [7808..7839]:             155520..155551    4 (24448..24479)           32
   2: [7840..7999999999]:       hole                                 7999992160
   3: [8000000000..8000000007]: 155512..155519    4 (24440..24447)            8
budgie:~ #

We got 4x4k data blocks allocated and:

budgie:~ # df -h /mnt/scratch
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb9             124M  120M   32K 100% /mnt/scratch

That shows that 5 blocks were allocated to hold the 4 data blocks
that lead to ENOSPC. i.e. a metadata block of some kind was also
allocated.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
