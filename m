Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZESGnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZESGnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZESGm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:42:57 -0400
Received: from mga06.intel.com ([134.134.136.21]:59753 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750721AbZESGm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:42:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,213,1241420400"; 
   d="scan'208";a="413662533"
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
In-Reply-To: <20090519062049.GP4140@kernel.dk>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
	 <1242713463.2560.5.camel@ymzhang>  <20090519062049.GP4140@kernel.dk>
Content-Type: text/plain
Date: Tue, 19 May 2009 14:43:14 +0800
Message-Id: <1242715394.2560.8.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 08:20 +0200, Jens Axboe wrote:
> On Tue, May 19 2009, Zhang, Yanmin wrote:
> > On Mon, 2009-05-18 at 14:19 +0200, Jens Axboe wrote:
> > > Hi,
> > > 
> > > This is the fourth version of this patchset. Chances since v3:
> > > 
> > > - Dropped a prep patch, it has been included in mainline since.
> > > 
> > > - Add a work-to-do list to the bdi. This is struct bdi_work. Each
> > >   wb thread will notice and execute work on bdi->work_list. The arguments
> > >   are which sb (or NULL for all) to flush and how many pages to flush.
> > > 
> > > - Fix a bug where not all bdi's would end up on the bdi_list, so potentially
> > >   some data would not be flushed.
> > > 
> > > - Make wb_kupdated() pass on wbc->older_than_this so we maintain the same
> > >   behaviour for kupdated flushes.
> > > 
> > > - Have the wb thread flush first before sleeping, to avoid losing the
> > >   first flush on lazy register.
> > > 
> > > - Rebase to newer kernels.
> > Jens,
> > 
> > Applied V4 to 2.6.30-rc6 and got some confliction reports.
> > ----------patch-2----------
> > patching file fs/buffer.c
> > patching file fs/fs-writeback.c
> > patching file fs/ntfs/super.c
> > patching file fs/sync.c
> > patching file include/linux/backing-dev.h
> > patching file include/linux/fs.h
> > patching file include/linux/writeback.h
> > patching file mm/backing-dev.c
> > patching file mm/page-writeback.c
> > Hunk #5 FAILED at 666.
> > 1 out of 6 hunks FAILED -- saving rejects to file mm/page-writeback.c.rej
> > patching file mm/vmscan.c
> > ----------patch-3----------
> > patching file fs/fs-writeback.c
> > patching file include/linux/writeback.h
> > patching file mm/Makefile
> > patching file mm/pdflush.c
> > ----------patch-4----------
> > patching file fs/fs-writeback.c
> > patching file include/linux/backing-dev.h
> > patching file mm/backing-dev.c
> > ----------patch-5----------
> > patching file fs/fs-writeback.c
> > patching file include/linux/backing-dev.h
> > patching file include/linux/fs.h
> > patching file mm/backing-dev.c
> > patching file mm/page-writeback.c
> > Hunk #1 succeeded at 708 with fuzz 2 (offset 41 lines).
> > Hunk #2 FAILED at 716.
> > 1 out of 2 hunks FAILED -- saving rejects to file mm/page-writeback.c.rej
> 
> It's not against -rc6, it's against current -git. And current -git had a
> one-liner fixup to the centisec calculation, so it'll fail. If you apply
> the below patch to -rc6, then the series should apply cleanly on top of
> that.
> 
> > Then, I manually fixed the conflictions, but compilation reports errors.
> > Your patches seem not clean.
> > 
> >   CC      fs/exec.o
> > mm/page-writeback.c: In function 'background_writeout':
> > mm/page-writeback.c:695: error: 'MAX_WRITEBACK_PAGES' undeclared (first use in this function)
> > mm/page-writeback.c:695: error: (Each undeclared identifier is reported only once
> > mm/page-writeback.c:695: error: for each function it appears in.)
> > mm/page-writeback.c: In function 'wb_kupdate':
> > mm/page-writeback.c:769: error: 'MAX_WRITEBACK_PAGES' undeclared (first use in this function)
> > mm/page-writeback.c: In function 'wb_timer_fn':
> > mm/page-writeback.c:802: error: implicit declaration of function 'pdflush_operation'
> > make[1]: *** [mm/page-writeback.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> >   CC      fs/pipe.o
> 
> You still have remnants of pdflush, so there's definite something wrong
> with your manual patching :-)
> 
> I'm attaching two patches - apply #1 to -rc6, and then #2 is a roll-up
> of the patch series that you can apply next.
The new patches do work.

Thanks,
Yanmin


