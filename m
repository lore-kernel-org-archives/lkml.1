Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXLGBta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXLGBta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 20:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXLGBtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 20:49:23 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47581 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbXLGBtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 20:49:22 -0500
Date: Thu, 6 Dec 2007 18:49:20 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Bob Bell <b_lkml@thebellsplace.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       trond@netapp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TASK_KILLABLE version 2
Message-ID: <20071207014920.GB28595@parisc-linux.org>
References: <20070902024348.GJ14130@parisc-linux.org> <20070924201648.GA6850@newbie.thebellsplace.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924201648.GA6850@newbie.thebellsplace.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 04:16:48PM -0400, Bob Bell wrote:
> I've been testing this patch on my systems.  It's working for me when
> I read() a file.  Asynchronous write()s seem okay, too.  However,
> synchronous writes (caused by either calling fsync() or fcntl() to
> release a lock) prevent the process from being killed when the NFS
> server goes down.
> 
> When the process is sent SIGKILL, it's waiting with the following call
> tree:
>    do_fsync
>    nfs_fsync
>    nfs_wb_all
>    nfs_sync_mapping_wait
>    nfs_wait_on_requests_locks (I believe)
>    nfs_wait_on_request
>    out_of_line_wait_on_bit
>    __wait_on_bit
>    nfs_wait_bit_interruptible
>    schedule
> 
> When the process is later viewed after being deemed "stuck", it's
> waiting with the following call tree:
>    do_fsync
>    filemap_fdatawait
>    wait_on_page_writeback_range
>    wait_on_page_writeback
>    wait_on_page_bit
>    __wait_on_bit
>    sync_page
>    io_schedule
>    schedule
> 
> If I hazard a guess as to what might be wrong here, I believe that when
> the processes catches SIGKILL, nfs_wait_bit_interruptible is returning
> -ERESTARTSYS.  That error bubbles back up to nfs_fsync.  However,
> nfs_fsync returns ctx->error, not -ERESTARTSYS, and ctx->error is 0.
> do_fsync proceeds to call filemap_fdatawait.  I question whether 
> nfs_sync should return an error, and if do_fsync should skip 
> filemap_fdatawait if the fsync op returned an error.
> 
> I did try replacing the call to sync_page in __wait_on_bit with 
> sync_page_killable and replacing TASK_UNINTERRUPTIBLE with 
> TASK_KILLABLE.  That seemed to work once, but then really screwed things 
> up on subsequent attempts.

Hi Bob,

The patch I posted earlier today (a somewhat cleaned-up version of a
patch originally from Liam Howlett) converts NFS to use TASK_KILLABLE.
Could you have another shot at breaking it?  You can find it here:

http://marc.info/?l=linux-fsdevel&m=119698206729969&w=2

(It has some prerequisites that are in the git tree, so probably the
easiest thing is just to pull that git tree).

Liam notes that there's still problems with programs that call *stat*(),
but I haven't looked into that issue yet.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
