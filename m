Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbXFTSbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbXFTSbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbXFTSaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46724 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754411AbXFTSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:09 -0400
Message-Id: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:07 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [00/37] Large Blocksize Support V4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

V3->V4
- It is possible to transparently make filesystems support larger
  blocksizes by simply allowing larger blocksizes in set_blocksize.
  Remove all special modifications for mmap etc from the filesystems.
  This now makes 3 disk based filesystems that can use larger blocks
  (reiser, ext2, xfs). Are there any other useful ones to make work?
- Patch against 2.6.22-rc4-mm2 which allows the use of Mel's antifrag
  logic to avoid fragmentation.
- More page cache cleanup by applying the functions to filesystems.
- Disable bouncing when the gfp mask is setup.
- Disable mmap directly in mm/filemap.c to avoid filesystem changes
  while we have no mmap support for higher order pages.

RFC V2->V3
- More restructuring
- It actually works!
- Add XFS support
- Fix up UP support
- Work out the direct I/O issues
- Add CONFIG_LARGE_BLOCKSIZE. Off by default which makes the inlines revert
  back to constants. Disabled for 32bit and HIGHMEM configurations.
  This also allows a gradual migration to the new page cache
  inline functions. LARGE_BLOCKSIZE capabilities can be
  added gradually and if there is a problem then we can disable
  a subsystem.

RFC V1->V2
- Some ext2 support
- Some block layer, fs layer support etc.
- Better page cache macros
- Use macros to clean up code.

This patchset modifies the Linux kernel so that larger block sizes than
page size can be supported. Larger block sizes are handled by using
compound pages of an arbitrary order for the page cache instead of
single pages with order 0.

Rationales:

1. We have problems supporting devices with a higher blocksize than
   page size. This is for example important to support CD and DVDs that
   can only read and write 32k or 64k blocks. We currently have a shim
   layer in there to deal with this situation which limits the speed
   of I/O. The developers are currently looking for ways to completely
   bypass the page cache because of this deficiency.

2. 32/64k blocksize is also used in flash devices. Same issues.

3. Future harddisks will support bigger block sizes that Linux cannot
   support since we are limited to PAGE_SIZE. Ok the on board cache
   may buffer this for us but what is the point of handling smaller
   page sizes than what the drive supports?

4. Reduce fsck times. Larger block sizes mean faster file system checking.
   Using 64k block size will reduce the number of blocks to be managed
   by a factor of 16 and produce much denser and contiguous metadata.

5. Performance. If we look at IA64 vs. x86_64 then it seems that the
   faster interrupt handling on x86_64 compensate for the speed loss due to
   a smaller page size (4k vs 16k on IA64). Supporting larger block sizes
   sizes on all allows a significant reduction in I/O overhead and increases
   the size of I/O that can be performed by hardware in a single request
   since the number of scatter gather entries are typically limited for
   one request. This is going to become increasingly important to support
   the ever growing memory sizes since we may have to handle excessively
   large amounts of 4k requests for data sizes that may become common
   soon. For example to write a 1 terabyte file the kernel would have to
   handle 256 million 4k chunks.

6. Cross arch compatibility: It is currently not possible to mount
   an 16k blocksize ext2 filesystem created on IA64 on an x86_64 system.
   With this patch this becomes possible. Note that this also means that
   some filesystems are already capable of working with blocksizes of
   up to 64k (ext2, XFS) which is currently only available on a select
   few arches. This patchset enables that functionality on all arches.
   There are no special modifications needed to the filesystems. The
   set_blocksize() function call will simply support a larger blocksize.

7. VM scalability
   Large block sizes mean less state keeping for the information being
   transferred. For a 1TB file one needs to handle 256 million page
   structs in the VM if one uses 4k page size. A 64k page size reduces
   that amount to 16 million. If the limitation in existing filesystems
   are removed then even higher reductions become possible. For very
   large files like that a page size of 2 MB may be beneficial which
   will reduce the number of page struct to handle to 512k. The variable
   nature of the block size means that the size can be tuned at file
   system creation time for the anticipated needs on a volume.

8. IO scalability
   The IO layer will receive large blocks of contiguious memory with
   this patchset. This means that less scatter gather elements are needed
   and the memory used is guaranteed to be contiguous. Instead of having
   to handle 4k chunks we can f.e. handle 64k chunks in one go.

   Dave Chinner measures a performance increase of 50% when going to 64k
   blocksize with XFS.

How to make this work:

1. Apply this patchset on top of 2.6.22-rc4-mm2
2. Enable LARGE_BLOCKSIZE Support
3. compile kernel

In order to use a filesystem with a higher order it needs to be formatted
with larger blocksize. This is done using the mkfs.xxx tool for each
filesystem. The existing tools work without modification. They may just
warn you that the blocksize you specify is not supported on your particular
architecture. Ignore that warning since this is no longer true after you have
applied this patchset.


Tested file systems:

Filesystem	Max Blocksize	Changes

Reiserfs	8k		Page size functions
Ext2		64k		Page size functions
XFS		64k		Page size functions / Remove PAGE_SIZE check
Ramfs		MAX_ORDER	Parameter to specify order

Todo/Issues:

- There are certainly numerous issues with this patch. I have only tested
  copying files back and forth, volume creation etc. Others have run
  fsxlinux on the volumes. The missing mmap support limits what can be
  done for now.

- Antifragmentation in mm does address some fragmentation issues (typically
  works up to 32k blocksize). However, large orders lead to fragmentation of
  the movable sections. Seems that we need Mel's memory compaction to support
  even larger orders. How memory compaction impacts performance still has to
  be determined.

- Support for bouncing pages.

- Remove PAGE_CACHE_xxx constants after using page_cache_xxx functions
  everywhere. But that will have to wait until merging becomes possible.
  For now certain subsystems (shmem f.e.) are not using these functions.
  They will only use order 0 pages.

- Support for non harddisk based filesystems. Remove the pktdvd etc
  layers needed because the VM current does not support sufficiently
  large blocksizes for these devices. Look for other places  in the kernel
  where we have similar issues.

- Mmap read support

  Its likely easier to do restricted read only mmap support first. That
  would enable running executables off the filesystems with large block
  size.

- Full mmmap support

--
