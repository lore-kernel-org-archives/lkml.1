Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZESGLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZESGLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZESGKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:10:47 -0400
Received: from mga05.intel.com ([192.55.52.89]:7439 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753583AbZESGKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:10:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,213,1241420400"; 
   d="scan'208";a="691615215"
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
In-Reply-To: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Tue, 19 May 2009 14:11:03 +0800
Message-Id: <1242713463.2560.5.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 14:19 +0200, Jens Axboe wrote:
> Hi,
> 
> This is the fourth version of this patchset. Chances since v3:
> 
> - Dropped a prep patch, it has been included in mainline since.
> 
> - Add a work-to-do list to the bdi. This is struct bdi_work. Each
>   wb thread will notice and execute work on bdi->work_list. The arguments
>   are which sb (or NULL for all) to flush and how many pages to flush.
> 
> - Fix a bug where not all bdi's would end up on the bdi_list, so potentially
>   some data would not be flushed.
> 
> - Make wb_kupdated() pass on wbc->older_than_this so we maintain the same
>   behaviour for kupdated flushes.
> 
> - Have the wb thread flush first before sleeping, to avoid losing the
>   first flush on lazy register.
> 
> - Rebase to newer kernels.
Jens,

Applied V4 to 2.6.30-rc6 and got some confliction reports.
----------patch-2----------
patching file fs/buffer.c
patching file fs/fs-writeback.c
patching file fs/ntfs/super.c
patching file fs/sync.c
patching file include/linux/backing-dev.h
patching file include/linux/fs.h
patching file include/linux/writeback.h
patching file mm/backing-dev.c
patching file mm/page-writeback.c
Hunk #5 FAILED at 666.
1 out of 6 hunks FAILED -- saving rejects to file mm/page-writeback.c.rej
patching file mm/vmscan.c
----------patch-3----------
patching file fs/fs-writeback.c
patching file include/linux/writeback.h
patching file mm/Makefile
patching file mm/pdflush.c
----------patch-4----------
patching file fs/fs-writeback.c
patching file include/linux/backing-dev.h
patching file mm/backing-dev.c
----------patch-5----------
patching file fs/fs-writeback.c
patching file include/linux/backing-dev.h
patching file include/linux/fs.h
patching file mm/backing-dev.c
patching file mm/page-writeback.c
Hunk #1 succeeded at 708 with fuzz 2 (offset 41 lines).
Hunk #2 FAILED at 716.
1 out of 2 hunks FAILED -- saving rejects to file mm/page-writeback.c.rej


Then, I manually fixed the conflictions, but compilation reports errors.
Your patches seem not clean.

  CC      fs/exec.o
mm/page-writeback.c: In function 'background_writeout':
mm/page-writeback.c:695: error: 'MAX_WRITEBACK_PAGES' undeclared (first use in this function)
mm/page-writeback.c:695: error: (Each undeclared identifier is reported only once
mm/page-writeback.c:695: error: for each function it appears in.)
mm/page-writeback.c: In function 'wb_kupdate':
mm/page-writeback.c:769: error: 'MAX_WRITEBACK_PAGES' undeclared (first use in this function)
mm/page-writeback.c: In function 'wb_timer_fn':
mm/page-writeback.c:802: error: implicit declaration of function 'pdflush_operation'
make[1]: *** [mm/page-writeback.o] Error 1
make[1]: *** Waiting for unfinished jobs....
  CC      fs/pipe.o


Yanmin

> 
> - Little fixes here and there.
> 
> So generally not a lot of changes, the major one is using the ->work_list
> and getting rid of writeback_acquire()/writeback_release(). This fixes
> the concern Jan Kara had about missing sync/WB_SYNC_ALL, if writeback
> was already in progress.
> 
> I've run a few benchmarks today:
> 
> 1) Large file writes from a single process
> 2) Random file writes from multiple (16) processes.


