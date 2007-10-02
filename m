Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXJBVzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXJBVzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbXJBVze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:55:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50710 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754229AbXJBVzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:55:33 -0400
Date: Wed, 3 Oct 2007 07:55:18 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 4/5] writeback: remove pages_skipped accounting in __block_write_full_page()
Message-ID: <20071002215518.GK995458@sgi.com>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.873023041@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002090254.873023041@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> do not quite agree with each other. The page writeback should be skipped for
> 'locked buffer', but here it is 'clean buffer'!

Ok, so that means we need an equivalent fix in xfs_start_page_writeback()
as it will skip pages with clean buffers just like this. Something like
this (untested)?

---
 fs/xfs/linux-2.6/xfs_aops.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-10-02 16:12:56.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-10-03 07:53:27.866602431 +1000
@@ -420,10 +420,9 @@ xfs_start_page_writeback(
 		clear_page_dirty_for_io(page);
 	set_page_writeback(page);
 	unlock_page(page);
-	if (!buffers) {
+	/* If no buffers on the page are to be written, finish it here */
+	if (!buffers)
 		end_page_writeback(page);
-		wbc->pages_skipped++;	/* We didn't write this page */
-	}
 }
 
 static inline int bio_add_buffer(struct bio *bio, struct buffer_head *bh)

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

