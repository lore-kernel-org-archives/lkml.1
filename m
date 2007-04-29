Return-Path: <linux-kernel-owner+w=401wt.eu-S1030760AbXD2UWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030760AbXD2UWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031377AbXD2UWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:22:20 -0400
Received: from pat.uio.no ([129.240.10.15]:45487 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030760AbXD2UWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:22:19 -0400
Subject: Re: NR_UNSTABLE_FS vs. NR_FILE_DIRTY: double counting pages?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ethan Solomita <solo@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <4632A1A6.90702@google.com>
References: <4632A1A6.90702@google.com>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 16:22:15 -0400
Message-Id: <1177878135.6400.37.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.182)
X-UiO-Scanned: 50FC59319932307473DD4106F726C70C1843BE2B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 283 total 1403828 max/h 8345 blacklist 0 greylist 1 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 18:21 -0700, Ethan Solomita wrote:
> There are several places where we add together NR_UNSTABLE_FS and
> NF_FILE_DIRTY:
> 
> sync_inodes_sb()
> balance_dirty_pages()
> wakeup_pdflush()
> wb_kupdate()
> prefetch_suitable()
> 
>     I can trace a standard codepath where it seems both of these are set
> on the same page:
> 
> nfs_file_aops.commit_write ->
>     nfs_commit_write
>     nfs_updatepages
>     nfs_writepage_setup
>     nfs_wb_page
>     nfs_wb_page_priority
>     nfs_writepage_locked
>     nfs_flush_mapping
>     nfs_flush_list
>     nfs_flush_multi
>     nfs_write_partial_ops.rpc_call_done
>     nfs_writeback_done_partial
>     nfs_writepage_release
>     nfs_reschedule_unstable_write
>     nfs_mark_request_commit
>     incr NR_UNSTABLE_NFS
> 
> nfs_file_aops.commit_write ->
>     nfs_commit_write
>     nfs_updatepage
>     __set_page_dirty_nobuffers
>     incr NF_FILE_DIRTY
> 
> 
>     This is the standard code path that derives from sys_write(). Can
> someone either show how this code sequence can't happen, or confirm for
> me that there's a bug?
>     -- Ethan

It should not happen. If the page is on the unstable list, then it will
be committed before nfs_updatepage is allowed to redirty it. See the
recent fixes in 2.6.21-rc7.

Trond

