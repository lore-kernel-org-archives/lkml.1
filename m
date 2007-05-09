Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbXEIIAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbXEIIAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXEIH7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:59:47 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20885 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXEIH7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:59:44 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] Chaining sg lists for big IO commands v2
Date: Wed,  9 May 2007 09:59:14 +0200
Message-Id: <11786975641643-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ok, got this cleaned up and split a bit. Should be more reviewable
now. A rough overview of what this does:

Some people complain that Linux doesn't support really large IO
commands. The main reason why we do not support infinitely sized IO
is that we need to allocate a scatterlist to fill these elements
into for dma mapping. The Linux scatterlist is an array of scatterlist
elements, so we need to allocate a contig piece of memory to hold them
all. On i386, we can at most fit 256 scatterlist elements into a page,
and on x86-64 we are stuck with 128. So that puts us somewhere
between 512kb and 1024kb for a single IO.

To get around that limitation, this patchset introduces an sg
chaining concept. The way it works is that the last element of an
sg table can point to a new sgtable, thus extending the size of the
total IO scatterlist greatly.

The first parts of the patch are preparatory stuff, abstracting out
sg browsing/lookup and converting libata/SCSI/block to using those.
The latter part is enabling sg chaining on i386 and SCSI (and thus
libata as well).

The patch set defaults to being safe and doesn't enable large commands,
you must actively do so yourself. If you want to test eg sda with
large commands, you would do:

# cd /sys/block/sda/queue
# echo 1024 > max_segments
# cat max_hw_sectors_kb > max_sectors_kb

which would limit you to 1024 segments (effectively 8 scatterlists
chained), and should give you IO's of at least 4mb. You can go larger
than 1024, there's no real limit.

Changes since last time:

- Hopefully get the libata atapi/pio bits fixed.

- Clear __GFP_WAIT on second (and on) rounds of scatterlist allocation.

- Cleanups/fixes/etc.

It works for me, but you can't enable large commands on anything but
i386 right now. I still need to go over the x86-64 iommu bits to enable
it there as well.

 block/ll_rw_blk.c              |   41 +++++-
 crypto/digest.c                |    2 
 crypto/scatterwalk.c           |    2 
 crypto/scatterwalk.h           |    2 
 drivers/ata/libata-core.c      |   30 ++--
 drivers/scsi/scsi_lib.c        |  212 ++++++++++++++++++++++++---------
 drivers/scsi/scsi_tgt_lib.c    |    4 
 include/asm-i386/dma-mapping.h |   13 +-
 include/asm-i386/scatterlist.h |    4 
 include/linux/libata.h         |   16 +-
 include/linux/scatterlist.h    |   40 ++++++
 include/scsi/scsi.h            |    7 -
 include/scsi/scsi_cmnd.h       |    3 
 13 files changed, 275 insertions(+), 101 deletions(-)


