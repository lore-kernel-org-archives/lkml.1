Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbXH1TJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbXH1TJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbXH1THn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:07:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58311 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752968AbXH1THb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:31 -0400
Message-Id: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:05:51 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [00/36] Large Blocksize Support V6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[An update before the Kernel Summit because of the numerous requests that I
have had for this patchset. Please speak up if you feel that we need something
like this.]

This patchset modifies the Linux kernel so that larger block sizes than
page size can be supported. Larger block sizes are handled by using
compound pages of an arbitrary order for the page cache instead of
single pages with order 0.

Support is added in a way that limits the changes to existing code.
As a result filesystems can support I/O using large buffers with minimal
changes.

The page cache functions are mostly unchanged. Instead of a page struct
representing a single page they take a head page struct (which looks
the same as a regular page struct apart from the compound flags) and
operate on those. Most page cache functions can stay as they are.

No locking protocols are added or modified.

The support is also fully transparent at the level of the OS. No
specialized heuristics are added to switch to larger pages. Large
page support is enabled by filesystems or device drivers when a device
or volume is mounted. Larger block sizes are usually set during volume
creation although the patchset supports setting these sizes per file.
The formattted partition will then always be accessed with the
configured blocksize.

Some of the changes are:

- Replace the use of PAGE_CACHE_XXX constants to calculate offsets into
  pages with functions that do the the same and allow the constants to
  be parameterized.

- Extend the capabilities of compound pages so that they can be
  put onto the LRU and reclaimed.

- Allow setting a larger blocksize via set_blocksize()

Rationales:
-----------

1. The ability to handle memory of an arbitrarily large size using
   a singe page struct "handle" is essential for scaling memory handling
   and reducing overhead in multiple kernel subsystems. This patchset
   is a strategic move that allows performance gains throughout the
   kernel.

2. Reduce fsck times. Larger block sizes mean faster file system checking.
   Using 64k block size will reduce the number of blocks to be managed
   by a factor of 16 and produce much denser and contiguous metadata.

3. Performance. If we look at IA64 vs. x86_64 then it seems that the
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

4. Cross arch compatibility: It is currently not possible to mount
   an 16k blocksize ext2 filesystem created on IA64 on an x86_64 system.
   With this patch this becomes possible. Note that this also means that
   some filesystems are already capable of working with blocksizes of
   up to 64k (ext2, XFS) which is currently only available on a select
   few arches. This patchset enables that functionality on all arches.
   There are no special modifications needed to the filesystems. The
   set_blocksize() function call will simply support a larger blocksize.

5. VM scalability
   Large block sizes mean less state keeping for the information being
   transferred. For a 1TB file one needs to handle 256 million page
   structs in the VM if one uses 4k page size. A 64k page size reduces
   that amount to 16 million. If the limitation in existing filesystems
   are removed then even higher reductions become possible. For very
   large files like that a page size of 2 MB may be beneficial which
   will reduce the number of page struct to handle to 512k. The variable
   nature of the block size means that the size can be tuned at file
   system creation time for the anticipated needs on a volume.

6. IO scalability
   The IO layer will receive large blocks of contiguious memory with
   this patchset. This means that less scatter gather elements are needed
   and the memory used is guaranteed to be contiguous. Instead of having
   to handle 4k chunks we can f.e. handle 64k chunks in one go.

7. Limited scatter gather support restricts I/O sizes.

   A lot of I/O controllers are limited in the number of scatter gather
   elements that they support. For example a controller that support 128
   entries in the scatter gather lists can only perform I/O of 128*4k =
   512k in one go. If the blocksize is larger (f.e. 64k) then we can perform
   larger I/O transfers. If we support 128 entries then 128*64k = 8M
   can be transferred in one transaction.

   Dave Chinner measured a performance increase of 50% when going to 64k
   blocksize with XFS with an earlier version of this patchset.

8. We have problems supporting devices with a higher blocksize than
   page size. This is for example important to support CD and DVDs that
   can only read and write 32k or 64k blocks. We currently have a shim
   layer in there to deal with this situation which limits the speed
   of I/O. The developers are currently looking for ways to completely
   bypass the page cache because of this deficiency.

9. 32/64k blocksize is also used in flash devices. Same issues.

10. Future harddisks will support bigger block sizes that Linux cannot
   support since we are limited to PAGE_SIZE. Ok the on board cache
   may buffer this for us but what is the point of handling smaller
   page sizes than what the drive supports?


Acceptance issues:
------------------

The patchset is a pretty significant change to the way that the Linux kernel
operates. I have tried to keep the changes as minimal as possible and I
believe that this is a reasonable start to introduce large block I/O
capabilities.

The Linux VM is gradually acquiring abilities to defragment memory. These
capabilities are partially present for 2.6.23. Later versions may merge
more of the defragmentation work. The use of large pages may cause
significant fragmentation to memory. Without proper defragmentation support
these patches cannot work reliably and may cause OOMs (although I have
rarely seen those and I have seen none with 2.6.23 when testing with 16k
blocksize. Possibly the effect of the limited defragmentation capabilities
in 2.6.23 is already sufficient. Beware: Larger blocksize can cause
more defragmentation).

A number of key developers are hesitant about this functionality given the
problems that we have had in the past with memory defragmentation and the
invasiveness of the patchset. It is to be expected that it will take awhile
until confidence in the defragmentation logic builds up. So the patchset
may still have to exist for a long time unmerged. However, it is necessary
that work on this patchset continue even outside of the kernel tree in order
to mature this patchset until it can be merged at some point in the future.

The most serious shortcoming of this patchset is the lack of mmap support.
This means f.e. that it is not possible to execute binaries. Adding
mmap support would mean more changes to the VM. In order to do that some
support by multiple developers is likely needed. The current idea is to
allow the mapping of 4K segments of larger pages to preserve mmap semantics.
This means that application programs could still map pages in 4k chunks and
the VM would provide a mapping into a subsection of a larger page.

How to make this patchset work:
-------------------------------

1. Apply this patchset or do a

git pull
  git://git.kernel.org/pub/scm/linux/kernel/git/christoph/largeblocksize.git
  largeblock

(The git archive is used to keep the patchset up to date. Please send patches
against the git tree)

2. Enable LARGE_BLOCKSIZE Support
3. Compile kernel

In order to use a filesystem with a larger blocksize it needs to be formatted
for that larger blocksize. This is done using the mkfs.xxx tool for each
filesystem. Surprisingly the existing tools work without modification. These
formatting tools may warn you that the blocksize you specify is not supported
on your particular architecture. Ignore that warning since this is no longer
true after you have applied this patchset.

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

- ZONE_MOVABLE is available in 2.6.23. Using the kernelcore=xxx as a kernel
  parameter enables an area where defragmentation can work. This may be
  necessary to avoid OOMs although I have seen no problems with up to 32k
  blocksize even without that measure.

- The antifragmentation patches in Andrew's tree address more fragmentation
  issues. However, large orders may still lead to fragmentation
  of the movable sections. Memory compaction is still not merged and will
  likely be needed to reliably support even larger orders of 256k or more.
  How memory compaction impacts performance still has to be determined.

- Support for bouncing pages.

- Remove PAGE_CACHE_xxx constants after using page_cache_xxx functions
  everywhere. But that will have to wait until merging becomes possible.
  For now certain subsystems (shmem f.e.) are not using these functions.
  They will only use order 0 pages.

- Support for non harddisk based filesystems. Remove the pktdvd etc
  layers needed because the VM current does not support sufficiently
  large blocksizes for these devices. Look for other places  in the kernel
  where we have similar issues.

- Mmap support

V5->V6:
- Rediff against 2.6.23-rc4
- Fix breakage introduced by updates to reiserfs
- Readahead fixes by Fengguang Wu <fengguang.wu@gmail.com>
- Provide a git tree that is kept up to date

V4->V5:
- Diff against 2.6.22-rc6-mm1
- provide test tree on ftp.kernel.org:/pub/linux

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

-- 
