Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbXFLQNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbXFLQNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXFLQNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:13:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24452 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbXFLQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:13:44 -0400
Date: Tue, 12 Jun 2007 12:10:29 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070612161029.GB28279@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

After the last FS summit, I started working on a new filesystem that
maintains checksums of all file data and metadata.  Many thanks to Zach
Brown for his ideas, and to Dave Chinner for his help on 
benchmarking analysis.

The basic list of features looks like this:

	* Extent based file storage (2^64 max file size)
	* Space efficient packing of small files
	* Space efficient indexed directories
	* Dynamic inode allocation
	* Writable snapshots
	* Subvolumes (separate internal filesystem roots)
	- Object level mirroring and striping
	* Checksums on data and metadata (multiple algorithms available)
	- Strong integration with device mapper for multiple device support
	- Online filesystem check
	* Very fast offline filesystem check
	- Efficient incremental backup and FS mirroring

The ones with marked with * are mostly working, and the others are on
my todo list.  There are more details on the FS design, some benchmarks
and download links here:

http://oss.oracle.com/~mason/btrfs/

The current status is a very early alpha state, and the kernel code
weighs in at a sparsely commented 10,547 lines.  I'm releasing now in
hopes of finding people interested in testing, benchmarking,
documenting, and contributing to the code.

I've gotten this far pretty quickly, and plan on continuing to knock off
the features as fast as I can.  Hopefully I'll manage a release every
few weeks or so.  The disk format will probably change in some major way
every couple of releases.

The TODO list has some critical stuff:

	* Ability to return -ENOSPC instead of oopsing
	* mmap()ed writes
	* Fault tolerance, (EIO, bad metadata etc)
	* Concurrency.  I use one mutex for all operations today
	* ACLs and extended attributes
	* Reclaim dead roots after a crash
	* Various other bits from the feature list above

And finally, here's a quick and dirty summary of the FS design points:

	* One large Btree per subvolume
	* Copy on write logging for all data and metadata
	* Reference count snapshots are the basis of the transaction
	  system.  A transaction is just a snapshot where the old root
	  is immediately deleted on commit
	* Subvolumes can be snapshotted any number of times
	* Snapshots are read/write and can be snapshotted again
	* Directories are doubly indexed to improve readdir speeds

So, please give it a try or a look and let me know what you think.

-chris

