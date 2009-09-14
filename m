Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZINJFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZINJFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZINJFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:05:31 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41641 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZINJFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:05:30 -0400
Date: Mon, 14 Sep 2009 11:05:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: recent bdi changes result in WARN_ON on luksClose / dm
Message-ID: <20090914090533.GU14984@kernel.dk>
References: <20090912111928.GA8013@Chamillionaire.breakpoint.cc> <20090912195212.GF14984@kernel.dk> <20090912195839.GG14984@kernel.dk> <20090913091337.GA21969@Chamillionaire.breakpoint.cc> <20090913175717.GO14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913175717.GO14984@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13 2009, Jens Axboe wrote:
> On Sun, Sep 13 2009, Sebastian Andrzej Siewior wrote:
> > * Jens Axboe | 2009-09-12 21:58:40 [+0200]:
> > 
> > >Don't count this as a real fix, I'll investigate closer on monday. Does
> > >the warning go away with this hack? It'll ensure that pending dirty
> > >inodes are flushed.
> > 
> > That warning goes away but another pops up:
> 
> Oh right, just goes to show that it's doing this backwards. We need the
> umount rwsem for WB_SYNC_ALL. I'll look at this tomorrow.

I think the safest option is to ensure that we just move these entries
to our default bdi, which doesn't go away. This should fix the warning,
can you test whether it works as well?

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index fd93566..27f82dc 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -668,7 +668,17 @@ void bdi_destroy(struct backing_dev_info *bdi)
 {
 	int i;
 
-	WARN_ON(bdi_has_dirty_io(bdi));
+	/*
+	 * Splice our entries to the default_backing_dev_info, if this
+	 * bdi disappears
+	 */
+	if (bdi_has_dirty_io(bdi)) {
+		struct bdi_writeback *dst = &default_backing_dev_info.wb;
+
+		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
+		list_splice(&bdi->wb.b_io, &dst->b_io);
+		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+	}
 
 	bdi_unregister(bdi);
 

-- 
Jens Axboe

