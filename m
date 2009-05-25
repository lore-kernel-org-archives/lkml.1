Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZEYIyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZEYIyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZEYIyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:54:31 -0400
Received: from mga05.intel.com ([192.55.52.89]:30181 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969AbZEYIya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:54:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,243,1241420400"; 
   d="scan'208";a="693319780"
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org
In-Reply-To: <20090522081539.GM11363@kernel.dk>
References: <20090519062049.GP4140@kernel.dk>
	 <1242805911.2560.28.camel@ymzhang> <20090520080938.GM11363@kernel.dk>
	 <20090520085446.GN11363@kernel.dk> <1242811142.2560.33.camel@ymzhang>
	 <20090520092528.GP11363@kernel.dk> <20090520111910.GS11363@kernel.dk>
	 <1242887627.2560.45.camel@ymzhang> <20090521091033.GA6987@duck.suse.cz>
	 <1242955708.2560.52.camel@ymzhang>  <20090522081539.GM11363@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 May 2009 16:54:44 +0800
Message-Id: <1243241684.2560.121.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 10:15 +0200, Jens Axboe wrote:
> > > > > > > > > > > > > This is the fourth version of this patchset. Chances since v3:

> Thanks, I'll get this reproduced and fixed. Can you post the results
> you got comparing writeback and vanilla meanwhile?
I didn't post the result because some test cases benefit from the patches
while others are hurt from the patches. Sometime one case benefit from the patches
on this machine, but is hurt on another machine.

As a matter of fact, I tested the patches on 4 machines. One machine which
triggered the bug has only 1 disk. The other 3 machines have 1 JBOD per machine.
1) machine lkp-st02﻿ (stoakley): has a fiberchannel JBOD with 13 SCSI disks. Every
disk has 1 partition (ext3 filesystem). Memory is 8GB.
2) ﻿machine lkp-st01: has a SAS JBOD with 7 SAS disks. Every disk has 2
partitions. 8GB memory.
3) Machine lkp-ne02 (nehalem): has a SATA JBOD with 11 disks. Every disk has
2 partitions. 6GB memory.

The HBA cards connecting to JBOD have no raid capability,
or they have, but I don't turn raid on.
﻿
Mount ext3 with option '-o writeback'.

Below results focus on the 3 machines who have JBOD. 

I use iozone/tiobench/fio/ffsb for this testing. With iozone/tiobench, I always
use one disk on all machines. But with fio/ffsb which has lots of subtest cases,
I use all disks of the JBOD connecting to the corresponding machine.

The comparation is between 2.6.30-rc6 and 2.6.30-rc6+V4_patches, or plus
3 new patches (starting with 0001~0003).

1) iozone: 500MB iozone testing has no result difference. But 1.2GB testing has
about 40% regression on rewrite with the 3 new patches (001~003). If no the 3 new
patches, the regression is more than 90%. write has the simular regression, but its
regression disappears with the new 3 patches.

2) tiobench: result variation is considered as fluctuation.

3) fio: consists of more than 30 sub test cases, including sync/aio/mmap,
plus the combination with block size (less4k/4k/64k, soetimes 128k) and random.
As for write testing, mostly, one thread per partition.
   Mostly, fio_mmap_randwrite(randrw)_4k_preread has 5%~30% improvement. But with
the new 3 patches, the improvement becomes smaller, for example becomes 14% from 30%.
   fio_mmap_randwrite has 5%~10% regression on lkp-st01 and lkp-ne02 (both machines'
JBOD has 2 partitions per disk), but has 2%~15% improvement on lkp-st02 (one partition
per disk).fio_mmap_randrw has the similar behavior.
   fio_mmap_randwrite_4k_halfbusy (Use 4 disks and less workload than other fio cases)
has about 20%~30% improvement.
   fio sync read has about 15%~30% regression on lkp-st01, but the regression disappears
with the 3 new patches. Other machines haven't the issue.
  aio has no regression.

4) ffsb:
   ffsb_create (blocksize 4k, 64k) has 10%~20% improvement on lkp-st01 and
lkp-ne02, but hasn't on lkp-st02.
   The data of other ffsb test cases looks suspicious, so I need double-check it, or
tune parameters to rerun.

Yanmin


