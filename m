Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbZAHV4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbZAHV4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZAHV4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:56:19 -0500
Received: from ns2.suse.de ([195.135.220.15]:43294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbZAHV4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:56:18 -0500
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Jan 2009 08:55:59 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18790.30319.768568.100620@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ftp.linux.org.uk>, Tejun Heo <tj@kernel.org>
Subject: [PULL request] md update for 2.6.29 (includes change to fs/block.c)
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 here is my drivers/md pull request for the 2.6.29 merge window.

 The most interesting change is
      md: make devices disappear when they are no longer needed.
 which is functionality I have tried to add in the past and always got
 wrong.  I think it is right this time :-)

 It involves a change to fs/block_dev.c.
 The reason for this change is the there is a period between ->probe
 being called on a device, and ->open being call, where the gendisk is
 not reference counted but must not go away.
 This interacts badly which md's (questionable but historic) approach
 of devices being created by ->probe.
 The fs/block_dev.c change allows the open to fail in a new way
 (ERESTARTSYS) so that we loop back and call ->probe, so if the
 gendisk does get removed in that window, we handle the situation
 gracefully.   The changelog (and code) give more details.

 This was discussed on linux-kernel with Al Viro and Tejun Heo without
 a clear resolution.  There was a feeling that some sort of cleanup in
 the block layer could make this unnecessary and would fix other
 issues, but no clear direction on the cleanup was found, nor were
 any clear problems with my approach identified.


 Also of some note is 
         md: Allow md devices to be created by name.
 which provides a new way of creating md devices and allows us to
 provide the name for kernel-internal use, so it isn't always 
 md0 or md27, but can be md_bitbucket or md_scratch.

 Finally
       md: fix bitmap-on-external-file bug.
 fixes a bug that I let in to 2.6.28 fairly late due to insufficient
 testing.  It is flagged for -stable.

Thanks,
NeilBrown



The following changes since commit 9e42d0cf5020aaf217433cad1a224745241d212a:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/sparc-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Andre Noll (9):
      md: raid0_make_request(): Replace chunksize_bits by chunksect_bits.
      md: raid0_make_request(): Remove local variable chunk_size.
      md: raid0_make_request(): Replace local variable block by sector.
      md: raid0: Represent device offset in sectors.
      md: raid0: Represent zone->zone_offset in sectors.
      md: raid0 create_strip_zones(): Make two local variables sector-based.
      md: raid0 create_strip_zones(): Add KERN_INFO/KERN_ERR to printk's.
      md: raid0: Represent the size of strip zones in sectors.
      md: raid0: make hash_spacing and preshift sector-based.

Cheng Renquan (2):
      md: use list_for_each_entry macro directly
      md: need another print_sb for mdp_superblock_1

NeilBrown (7):
      md: fix bitmap-on-external-file bug.
      md: use sysfs_notify_dirent to notify changes to md/sync_action.
      md: move allocation of ->queue from mddev_find to md_probe
      md: centralise all freeing of an 'mddev' in 'md_free'
      md: make devices disappear when they are no longer needed.
      md: Allow md devices to be created by name.
      md: don't retry recovery of raid1 that fails due to error on source drive.

 drivers/md/bitmap.c        |   11 +-
 drivers/md/faulty.c        |    3 +-
 drivers/md/linear.c        |    3 +-
 drivers/md/md.c            |  416 +++++++++++++++++++++++++++++++-------------
 drivers/md/multipath.c     |    3 +-
 drivers/md/raid0.c         |  178 ++++++++++----------
 drivers/md/raid1.c         |   11 +-
 drivers/md/raid10.c        |    3 +-
 drivers/md/raid5.c         |    8 +-
 fs/block_dev.c             |   14 ++
 include/linux/raid/md_k.h  |   20 ++-
 include/linux/raid/md_p.h  |    2 +
 include/linux/raid/raid0.h |   10 +-
 13 files changed, 435 insertions(+), 247 deletions(-)
