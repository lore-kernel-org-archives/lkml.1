Return-Path: <linux-kernel-owner+w=401wt.eu-S940598AbXGTQGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940598AbXGTQGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939709AbXGTQGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:06:25 -0400
Received: from thunk.org ([69.25.196.29]:33420 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbXGTQGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:06:23 -0400
Date: Fri, 20 Jul 2007 12:06:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
Message-ID: <20070720160614.GG26752@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de> <200707201522.17270.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707201522.17270.a1426z@gawab.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 03:22:17PM +0300, Al Boldi wrote:
> 
> Oh, gpart is great, but if we had a backup copy of the partition table on 
> every partition location on disk, then this backup copy could easily be 
> reused to reconstruct the original partition table without further 
> searching.  Just like the NetWare approach, and in some respect like the 
> ext2/3 superblock backups.

It wouldn't be that hard to put a backup partition table at the
beginning of an ext2/3 filesystem.  No one is currently using the
space between offset 512 and 1023 bytes, and it would be an easy place
to stash a backup copy of the partition table.  We wouldn't be able to
use the MBR format, since information about extended partitions are
stored scattered across the disk.

So for the sake of argument, I'll propose the following partition
backup, starting at offset 512 and going for 512 bytes to byte #1023:

offset 
from 512  Description
-------   -----------
0..7      Signature ASCII: "PARTBAK1"
8..9      Part-type: 1=MBR
10	  # of heads
11	  # sectors
12	  # of partitions in the backup
13..15    Reserved (must be zero)
16..31	  first part entry
...
496..511 31st partition entry

Partition entry (16 bytes)

offset    description
------    -----------
0	  Flags
1	  Type
2..3	  Reserved (must be zero)
4..11	  Start LBA (little endian)
12..15	  # of LBA in partition

Obviously this won't work for LVM or EFI volume partition tables, but
they have enough redundancy into their on-disk formats that it
shouldn't be an issue.

Someone want to write a stand-alone function which pulls the
information from the MBR (and extended MBR's) and put it into a 512
byte buffer?  If so, I'll integrate it into mke2fs and e2fsck (so that
when the user upgrades to a new enough e2fsprogs, it will
automatically back up the partition information just before the
superblock.

						- Ted
