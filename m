Return-Path: <linux-kernel-owner+w=401wt.eu-S1765567AbZDANqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765567AbZDANqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764742AbZDANot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:42386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764378AbZDANor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:47 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [RFC PATCHSET block] block: blk-map updates and API cleanup
Date: Wed,  1 Apr 2009 22:44:15 +0900
Message-Id: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

These patches are available in the following git tree but it's on top
of the previous blk-map-related-fixes patchset which needs some
updating, so this posting is just for review and comments.  This
patchset needs to spend quite some time in RCs even if it gets acked
eventually, so definitely no .30 material.  Please also note that I
haven't updated the comment about bio chaining violating queue limit,
so please ignore that part.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-map
 http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=blk-map

The goals of this patchset are

* Clean up and refactor blk/bio PC map API interface and
  implementation.

* Add blk_rq_map_kern_sg() so that in-kernel user can issue
  multi-segment PC request.  scsi_lib.c currently does this directly
  by building rq itself.

* This is also in the general direction of making block layer
  interface more strictk.  For PC requests, users only get to deal
  with requests and buffers.

This patchset uses sg list to pass multi-segment memory area into
blk_rq_map_kern_sg() and also uses sgl to simplify internal
implementation.

Boaz Harrosh has some objections against both of them.  For the
former, I can't really think of using anything other than sgl for the
API.  For the second point, the use of sgl inside bio for map
implementation does add overhead for blk_rq_map_user*() calls because
it first maps to sgl and then gets interpreted to bvec.  The reason
that sgl is used for implementation is because it has richer API,
mainly sg_mapping_iter.

So, it basically comes down to whether reducing the overhead of
alloc/copying and freeing sgl one more time for each SG_IO call is
worth the added complexity.  I don't really think it will show up
anywhere but if this is a problem, switching over to bvec for internal
implementation wouldn't be too difficult although then copying back
and forth would require some hairy code.  Also, please note that the
new code is more generic in that it can handle highpage io and
bouncing buffers without adding any special provision for them.

I think the root problem is that we really don't have a proper data
structure and API for handling in-kernel segments.  iovec can't cover
high pages.  sgl is currently the closest thing but it's fat due for
the dma mapping addresses.  I think what we need to do is improve sgl
(sgt) such that it maintains separate lists for kernel segments and
DMA mappings and enable it to be linked, spliced, cloned or whatever,
so we don't have to re-map back and forth.  Well, that's for another
time.

This patchset contains the following 17 patches.

 0001-blk-map-move-blk_rq_map_user-below-blk_rq_map_use.patch
 0002-scatterlist-improve-atomic-mapping-handling-in-mapp.patch
 0003-blk-map-improve-alignment-checking-for-blk_rq_map_u.patch
 0004-bio-bio.h-cleanup.patch
 0005-bio-cleanup-rw-usage.patch
 0006-blk-map-bio-use-struct-iovec-instead-of-sg_iovec.patch
 0007-blk-map-bio-rename-stuff.patch
 0008-bio-reimplement-bio_copy_user_iov.patch
 0009-bio-collapse-__bio_map_user_iov-__bio_unmap_user.patch
 0010-bio-use-bio_create_from_sgl-in-bio_map_user_iov.patch
 0011-bio-add-sgl-source-support-to-bci-and-implement-bio.patch
 0012-bio-implement-bio_-map-copy-_kern_sgl.patch
 0013-blk-map-implement-blk_rq_map_kern_sgl.patch
 0014-scsi-replace-custom-rq-mapping-with-blk_rq_map_kern.patch
 0015-bio-blk-map-kill-unused-stuff-and-un-export-interna.patch
 0016-blk-map-bio-remove-superflous-len-parameter-from-b.patch
 0017-blk-map-bio-remove-superflous-q-from-blk_rq_map_-u.patch

0001 is misc prep.  0002 improves sg_miter so that it can be used for
copying between sgls.  0003 update alignment checking during direct
mapping (I think this is correct because there's no other way for low
level drivers to express segment length requirement).  0004-0007
cleans up the code for future updates.

0008-0013 refactors map code and adds blk_rq_map_kern_sgl().  0014
drops custom sg mapping in scsi_lib.c and make it use
blk_rq_map_kern_sgl().  0015 kills now unused stuff including
blk_rq_append_bio().

0016-0017 removes duplicate parameters from API.

This patchset is on top of the current linux-2.6-block#for-linus[1] +
blk-map-related-fixes patchset[2].

 block/blk-map.c                            |  216 ++----
 block/bsg.c                                |    5 
 block/scsi_ioctl.c                         |   21 
 drivers/block/pktcdvd.c                    |    2 
 drivers/cdrom/cdrom.c                      |    2 
 drivers/mmc/host/sdhci.c                   |    4 
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 
 drivers/scsi/device_handler/scsi_dh_emc.c  |    2 
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 
 drivers/scsi/scsi_lib.c                    |  113 ---
 drivers/scsi/scsi_tgt_lib.c                |    3 
 drivers/scsi/sg.c                          |    8 
 drivers/scsi/st.c                          |    3 
 fs/bio.c                                   |  980 +++++++++++++++--------------
 include/linux/bio.h                        |  170 ++---
 include/linux/blkdev.h                     |   23 
 include/linux/scatterlist.h                |   11 
 lib/scatterlist.c                          |   49 +
 18 files changed, 806 insertions(+), 810 deletions(-)

Thanks.

--
tejun

[1] 714ed0cf62319b14dc327273a7339a9a199fe046
[2] http://thread.gmane.org/gmane.linux.kernel/815647
