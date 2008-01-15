Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYAOPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYAOPxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYAOPxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:53:08 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:25858 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYAOPxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:53:06 -0500
Date: Tue, 15 Jan 2008 10:52:38 -0500
From: Chris Mason <chris.mason@oracle.com>
To: btrfs-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [ANNOUNCE] Btrfs v0.10 (online growing/shrinking, ext3 conversion,
 and more)
Message-ID: <20080115105238.4fc3e992@think.oraclecorp.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello everyone,

Btrfs v0.10 is now available for download from:

http://oss.oracle.com/projects/btrfs/

Btrfs is still in an early alpha state, and the disk format is not finalized.
v0.10 introduces a new disk format, and is not compatible with v0.9.

The core of this release is explicit back references for all metadata blocks,
data extents, and directory items.  These are a crucial building block for
future features such as online fsck and migration between devices.  The back
references are verified during deletes, and the extent back references are
checked by the existing offline fsck tool.

For all of the details of how the back references are maintained, please
see the design document:

http://oss.oracle.com/projects/btrfs/dist/documentation/btrfs-design.html

Other new features (described in detail below):

* Online resizing (including shrinking)
* In place conversion from Ext3 to Btrfs
* data=ordered support
* Mount options to disable data COW and checksumming 
* Barrier support for sata and IDE drives

[ Resizing ]

In order to demonstrate and test the back references, I've added an online
resizer, which can both grow and shrink the filesystem:

mount -t btrfs /dev/xxx /mnt

# add 2GB to the FS
btrfsctl -r +2g /mnt

# shrink the FS by 4GB
btrfsctl -r -4g /mnt

# Explicitly set the FS size
btrfsctl -r 20g /mnt

# Use 'max' to grow the FS to the limit of the device
btrfsctl -r max /mnt

[ Conversion from Ext3 ]

This is an offline, in place, conversion program written by Yan Zheng.  It
has been through basic testing, but should not be trusted with critical data.

To build the conversion program, run 'make convert' in the btrfs-progs
tree. It depends on libe2fs and acl development libraries.

The conversion program uses the copy on write nature of Btrfs to preserve the
original Ext3 FS, sharing the data blocks between Btrfs and Ext3 metadata.
Btrfs metadata is created inside the free space of the Ext3 filesystem, and it
is possible to either make the conversion permanent (reclaiming the space used
by Ext3) or roll back the conversion to the original Ext3 filesystem.

More details and example usage of the conversion program can be found here:

http://oss.oracle.com/projects/btrfs/dist/documentation/btrfs-converter.html

Thanks to Yan Zheng for all of his work on the converter.

[ New mount options ]

mount -o nodatacsum disables checksumming on data extents

mount -o nodatacow disables copy on write of data extents, unless a given
extent is referenced by more than one snapshot.  This is targeted at database
workloads, where copy on write is not optimal for performance.

The explicit back references allow the nodatacow code to make sure copy
on write is done when multiple snapshots reference the same file, maintaining
snapshot consistency.

mount -o alloc_start=num forces allocation hints to start at least num bytes
into the disk.  This was introduced to test the resizer.  Example usage:

mount -o alloc_start=16g /dev/xxxx /mnt
(do something to the FS)
btrfsctl -r 12g /mnt

The btrfsctl command will resize the FS down to 12GB in size.  Because
the FS was mounted with -o alloc_start=16g, any allocations done after
mounting will need to be relocated by the resizer.

It is safe to specify a number past the end of the FS, if the alloc_start is too
large, it is ignored.

mount -o nobarrier disables cache flushes during commit.

-chris
