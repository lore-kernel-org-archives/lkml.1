Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYHTDM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYHTDM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 23:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYHTDMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 23:12:19 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:48677 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYHTDMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 23:12:18 -0400
X-Greylist: delayed 1996 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 23:12:17 EDT
Message-Id: <200808200245.AA00210@capsicum.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Wed, 20 Aug 2008 11:45:05 +0900
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] nilfs2: continuous snapshotting file system
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a kernel patch of NILFS2 file system which was previously
announced in [1].  Since the original code did not comply with the
Linux Coding Style, I've rewritten it a lot.

NILFS2 is a log-structured file system (LFS) supporting ``continuous
snapshotting''.  In addition to versioning capability of the entire
file system, users can even restore files and namespaces mistakenly
overwritten or destroyed just a few seconds ago.

NILFS2 creates a number of checkpoints every few seconds or per
synchronous write basis (unless there is no change).  Users can select
significant versions among continuously created checkpoints, and can
change them into snapshots which will be preserved until they are
changed back to checkpoints.

There is no limit on the number of snapshots until the volume gets
full.  Each snapshot is mountable as a read-only file system
concurrently with its writable mount, and this feature is convenient
for online backup.  It will be also favorable for time-machine like
user environment or appliances.

Please see [2] for details on the project.

Other features are:

- Quick crash recovery on-mount (like conventional LFS)
- B-tree based file, inode, and other meta data management including
  snapshots.
- 64-bit data structures; support many files, large files and disks.
- Online disk space reclamation by userland daemon, which can maintain
  multiple snapshots.
- Less use of barrier with keeping reliability. The barrier is enabled
  by default.
- Easy and quickly performable snapshot administration

Some impressive benchmark results on SSD are shown in [3], however the
current NILFS2 performance is sensitive to machine environment due to
its immature implementation.

It has many TODO items:

- performance improvement (better block I/O submission)
- better integration of b-tree node cache with filemap and buffer code.
- cleanups, further simplification.
- atime support
- extendend attributes support
- POSIX ACL support
- Quota support

The patch against 2.6.27-rc3 (hopefully applicable to the next -mm
tree) is available at:

http://www.nilfs.org/pub/patch/nilfs2-continuous-snapshotting-file-system.patch

It is not yet divided into pieces (sorry).  Unlike original code
available at [4], many code lines to support past kernel versions and
peculiar debug code are removed in this patch.

The userland tools are included in nilfs-utils package, which is
available from [4].  Details on the tools are described in the man
pages included in the package.

Here is an example:

- To use nilfs2 as a local file system, simply:

 # mkfs -t nilfs2 /dev/block_device
 # mount -t nilfs2 /dev/block_device /dir

  This will also invoke the cleaner through the mount helper program
  (mount.nilfs2).

- Checkpoints and snapshots are managed by the following commands.
  Their manpages are included in the nilfs-utils package above.

   lscp     list checkpoints or snapshots.
   mkcp     make a checkpoint or a snapshot.
   chcp     change an existing checkpoint to a snapshot or vice versa.
   rmcp     invalidate specified checkpoint(s).

  For example,

 # chcp ss 2

  changes the checkpoint No. 2 into snapshot.

- To mount a snapshot,

 # mount -t nilfs2 -r -o cp=<cno> /dev/block_device /snap_dir

  where <cno> is the checkpoint number of the snapshot.

- More illustrative example is found in [5].

Thank you,
Ryusuke Konishi, NILFS Team, NTT.

1. NILFS version2 now available
http://marc.info/?l=linux-fsdevel&m=118187597808509&w=2

2. NILFS homepage
http://www.nilfs.org/en/index.html

3. Dongjun Shin, About SSD
http://www.usenix.org/event/lsf08/tech/shin_SSD.pdf

4. Source archive
http://www.nilfs.org/en/download.html

5. Using NILFS
http://www.nilfs.org/en/about_nilfs.html
