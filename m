Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbXFNSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbXFNSwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXFNSwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:52:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64641 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbXFNSwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:52:06 -0400
Date: Thu, 14 Jun 2007 14:48:51 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070614184851.GD2061@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com> <18031.26764.586958.632146@stoffel.org> <467186EA.6090409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467186EA.6090409@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 02:20:26PM -0400, Chuck Lever wrote:
> Hi Chris-
> 
> John Stoffel wrote:
> >As a user of Netapps, having quotas (if only for reporting purposes)
> >and some way to migrate non-used files to slower/cheaper storage would
> >be great.
> >
> >Ie. being able to setup two pools, one being RAID6, the other being
> >RAID1, where all currently accessed files are in the RAID1 setup, but
> >if un-used get migrated to the RAID6 area.  
> >
> >And of course some way for efficient backups and more importantly
> >RESTORES of data which is segregated like this.  
> 
> I like the way dump and restore was handled in AFS (and now ZFS and 
> NetApp).  There is a simple command to flatten a file system and send it 
> to another system, which can receive it and re-expand it.  The 
> dump/restore process uses snapshots and can easily send incremental 
> backups which are significantly smaller than 0-level.  This is somewhat 
> better than rsync, because you don't need checksums to discover what 
> data has changed -- you already have the new data segregated into 
> copied-on-write blocks.

The planned scheme in btrfs involves storing the transaction id in the
header of every btree block, the inodes and the file extents.  So, the
only info you need to generate the incremental is the transaction id of
the last time you sync'd.  The tree would get walked and everything with
a higher transaction id sent down the pipe.

Since there have back pointers from inode to directory, it also be able
to generate a list of filenames that have changed, along with a list of
extents that were modified.

Between the two schemes, you would be able to do metadata aware (ie
storing exact duplicates) syncs between two boxes, or just have a faster
rsync that doesn't need to walk the directory structure to find changes.

I will probably code the rsync version first, just because it allows
you to backup to anything, not just a btrfs specific target.  It is
somewhat safer for an experimental FS (metadata errors are not
duplicated) and will hopefully be easier to code.

> 
> NetApp happens to use the standard NDMP protocol for sending the 
> flattened file system.  NetApp uses it for synchronous replication, 
> volume migration, and back up to nearline storage and tape.  AFS used 
> "vol dump" and "vol restore" for migration, replication, and back-up. 
> ZFS has the "zfs send" and "zfs receive" commands that do basically the 
> same (Eric Kustarz recently published a blog entry that described how 
> these work).  And of course, all file system objects are able to be sent 
> this way:  streams, xattrs, ACLs, and so on are all supported.
> 
> Note also that NFSv4 supports the idea of migrated or replicated file 
> objects.  All that is needed to support it is a mechanism on the servers 
> to actually move the data.

Stringing the replication together with the underlying FS would be neat.
Is there a way to deal with a master/slave setup, where the slave may be
out of date?

-chris

