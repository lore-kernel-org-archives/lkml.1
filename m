Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbXIXU0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbXIXU0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbXIXU0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:26:02 -0400
Received: from srv01.macroped.com ([207.44.188.8]:54496 "EHLO
	srv01.macroped.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbXIXUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:25:59 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2007 16:25:48 EDT
X-ClientAddr: 75.67.251.249
X-Envelope-From: b_lkml@thebellsplace.com
Date: Mon, 24 Sep 2007 16:16:48 -0400
From: Bob Bell <b_lkml@thebellsplace.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       trond@netapp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TASK_KILLABLE version 2
Message-ID: <20070924201648.GA6850@newbie.thebellsplace.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20070902024348.GJ14130@parisc-linux.org>
X-Editor: Vim http://www.vim.org/
X-Editor: Vim http://www.vim.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-yoursite-MailScanner-Information: Please contact the ISP for more information
X-yoursite-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: b_lkml@thebellsplace.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 08:43:49PM -0600, Matthew Wilcox wrote:
> Here's the second version of TASK_KILLABLE.  A few changes since version 1:
<snip>
> I obviously haven't covered every place that can result in a process
> sleeping uninterruptibly while attempting an operation.  But sync_page
> (patch 4/5) covers about 90% of the times I've attempted to kill cat,
> and I hope that by providing the two examples, I can help other people
> to fix the cases that they find interesting.

I've been testing this patch on my systems.  It's working for me when
I read() a file.  Asynchronous write()s seem okay, too.  However,
synchronous writes (caused by either calling fsync() or fcntl() to
release a lock) prevent the process from being killed when the NFS
server goes down.

When the process is sent SIGKILL, it's waiting with the following call
tree:
    do_fsync
    nfs_fsync
    nfs_wb_all
    nfs_sync_mapping_wait
    nfs_wait_on_requests_locks (I believe)
    nfs_wait_on_request
    out_of_line_wait_on_bit
    __wait_on_bit
    nfs_wait_bit_interruptible
    schedule

When the process is later viewed after being deemed "stuck", it's
waiting with the following call tree:
    do_fsync
    filemap_fdatawait
    wait_on_page_writeback_range
    wait_on_page_writeback
    wait_on_page_bit
    __wait_on_bit
    sync_page
    io_schedule
    schedule

If I hazard a guess as to what might be wrong here, I believe that when
the processes catches SIGKILL, nfs_wait_bit_interruptible is returning
-ERESTARTSYS.  That error bubbles back up to nfs_fsync.  However,
nfs_fsync returns ctx->error, not -ERESTARTSYS, and ctx->error is 0.
do_fsync proceeds to call filemap_fdatawait.  I question whether 
nfs_sync should return an error, and if do_fsync should skip 
filemap_fdatawait if the fsync op returned an error.

I did try replacing the call to sync_page in __wait_on_bit with 
sync_page_killable and replacing TASK_UNINTERRUPTIBLE with 
TASK_KILLABLE.  That seemed to work once, but then really screwed things 
up on subsequent attempts.

-- 
Bob Bell
