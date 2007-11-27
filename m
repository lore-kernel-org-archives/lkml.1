Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbXK0ERy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbXK0ERy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbXK0ERr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:17:47 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34709 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbXK0ERr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:17:47 -0500
Date: Mon, 26 Nov 2007 23:17:36 -0500
Message-Id: <200711270417.lAR4HaTi012203@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: Re: unionfs: several more problems 
In-reply-to: Your message of "Mon, 26 Nov 2007 20:14:46 GMT."
             <Pine.LNX.4.64.0711261953220.2958@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0711261953220.2958@blonde.wat.veritas.com>, Hugh Dickins writes:
> On Mon, 26 Nov 2007, Erez Zadok wrote:
[...]
> > The small patch below fixed the problem.  Let me know what you think.
> 
> I've one issue with it: please move that wait_on_page_writeback before
> the clear_page_dirty_for_io instead of after it, then resubmit your 14/16.
[...]

Done, tested, and working.  Here's the revised patch (pushed to unionfs.git
on korg).

Thanks,
Erez.

------------------------------------------------------------------------------

Unionfs: prevent multiple writers to lower_page

Without this patch, the LTP fs test "rwtest04" triggers a
BUG_ON(PageWriteback(page)) in fs/buffer.c:1706.

CC: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 623a913..74f2e53 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -72,6 +72,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	}
 
 	BUG_ON(!lower_mapping->a_ops->writepage);
+	wait_on_page_writeback(lower_page); /* prevent multiple writers */
 	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
 	err = lower_mapping->a_ops->writepage(lower_page, wbc);
 	if (err < 0)
