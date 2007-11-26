Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbXKZQx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbXKZQx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbXKZQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:53:17 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53460 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbXKZQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:53:16 -0500
Date: Mon, 26 Nov 2007 11:53:02 -0500
Message-Id: <200711261653.lAQGr2Et011553@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: Re: unionfs: several more problems 
In-reply-to: Your message of "Tue, 20 Nov 2007 19:14:59 GMT."
             <Pine.LNX.4.64.0711201802480.9934@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0711201802480.9934@blonde.wat.veritas.com>, Hugh Dickins writes:

[...]
> Please try running LTP (e.g. ltp-full-20071031.tgz) after something like
[...]

Hugh,

I just posted a series of patches to unionfs (already in unionfs.git on
korg), which fix every problem LTP found, as well as other problems
mentioned in your email.  With this series of patches, the same set of tests
which pass on ext3 also pass with unionfs mounted over ext3.

I'd like to call your attention to one small unionfs_writepage fix.  One of
the ltp fs tests (rwtest04) triggered a BUG_ON(PageWriteback(page)) in
fs/buffer.c:1706, when we call the lower ->writepage.  This was due to
multiple writers to the same page.  Looking at other kernel code, it seems
that the right fix is to use wait_on_page_writeback(lower_page) to serialize
concurrent writebacks to the same page, no?  The small patch below fixed the
problem.  Let me know what you think.

Thanks,
Erez.


diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index eef43aa..d0fd4d0 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -73,6 +73,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 
 	BUG_ON(!lower_mapping->a_ops->writepage);
 	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
+	wait_on_page_writeback(lower_page); /* prevent multiple writers */
 	err = lower_mapping->a_ops->writepage(lower_page, wbc);
 	if (err < 0)
 		goto out_release;
