Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYBKKew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYBKKew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYBKKep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:34:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44835 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbYBKKeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:34:44 -0500
Date: Mon, 11 Feb 2008 13:34:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmap_region: cleanup, remove unneeded file != NULL check
Message-ID: <20080211103405.GB162@tv-sign.ru>
References: <20080203180122.GA5819@tv-sign.ru> <Pine.LNX.4.64.0802062013210.32204@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802062013210.32204@blonde.site>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay,

On 02/06, Hugh Dickins wrote:
>
> On Sun, 3 Feb 2008, Oleg Nesterov wrote:
> 
> > mmap_region() checks "file != NULL" when we know "file && vma_merge() == T".
> > Also, swap these if/else branches, imho make the code a bit more readable.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> Acked-with-a-but-by: Hugh Dickins <hugh@veritas.com>
> 
> But my but is this: you can go one step further, it's silly to be
> repeating the "if (correct_wcount) atomic_inc..." in both the if
> and the else clauses.

Ah. Shame on me. Of course, I noticed these 2 correct_wcount's, but
didn't realize we can safely use "inode" after fput(). Not only the
caller should have a reference, vma_merge() requires that vm_file == file,
so fput(file) can't destroy the last reference.

> For several minutes I thought that must indicate we already had a
> bug there.  Eventually I realized not: we need deny_write_access()
> above to test and deny atomically, then once we've merged or linked
> the vma it's securely denying in the vma itself: so before returning
> we need to undo our temporary denial.  A brief comment might be
> worthwhile, perhaps something like
> 
> 	/* Once vma denies write, undo our temporary denial count */
> 	if (correct_wcount)
> 		atomic_inc(&inode->i_writecount);

Thanks Hugh, I'll redo this cleanup.

Oleg.

