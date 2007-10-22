Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbXJVJGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbXJVJGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXJVJGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:06:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbXJVJGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:06:03 -0400
Date: Mon, 22 Oct 2007 02:05:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: forcing write-back from FS - again
Message-Id: <20071022020559.aa3fc59c.akpm@linux-foundation.org>
In-Reply-To: <471C64D1.3020904@yandex.ru>
References: <471BB45D.8070509@nokia.com>
	<20071021135526.57db7519.akpm@linux-foundation.org>
	<471C64D1.3020904@yandex.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 11:52:33 +0300 Artem Bityutskiy <dedekind@yandex.ru> wrote:

> > It _should_ be the case that the number of locked-and-dirty pages which
> > writeback encounters is very small, so skipping locked pages during
> > writeback-for-memory-flushing won't have any significant effect.  The first
> > step should be to add a new /proc/vmstat field to count these pages and
> > then do broad testing (especially on blocksize<pagesize filesystems) to
> > confirm the theory.
> > 
> > We'll still need to synchronously lock the page in
> > writeback-for-data-integrity mode though.
> 
> Thanks for suggestion. It sounds as a separate big job to enhance existing 
> WB_SYNC_NONE. I've just introduced new WB mode, and it seems to work fine:
> 
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> @@ -28,6 +28,7 @@ static inline int task_is_pdflush(struct task_struct *task)
>    */
>   enum writeback_sync_modes {
>          WB_SYNC_NONE,   /* Don't wait on anything */
> +       WB_SYNC_NONE_PG,/* Don't wait on anything, don't touch locked pages */
>          WB_SYNC_ALL,    /* Wait on every mapping */
>          WB_SYNC_HOLD,   /* Hold the inode on sb_dirty for sys_sync() */
>   };

It would be simpler/safer/saner to add a new bitflag to writeback_control
and use that directly.  The WB_SYNC_foo flags are a holdover from an
earlier time and really should be made to go away, in favour of directly
setting up an appropriate writeback_control.


> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> @@ -641,6 +641,10 @@ retry:
>                  for (i = 0; i < nr_pages; i++) {
>                          struct page *page = pvec.pages[i];
> 
> +                       if (wbc->sync_mode == WB_SYNC_NONE_PG &&
> +                           PageLocked(page))
> +                               continue;
> +
> 
> My only concern is - what if the page we skipped because of WB_SYNC_NONE_PG 
> will somehow loose its dirty TAG and will never be written-back? But it is 
> because of my poor knowledge of Linux MM internals. Could you please comment on 
> this?

Well it might lose its dirty tag, if the thread which has a lock on the
page is about to write it out or truncate it.  But that shouldn't concern
you here.

The code you have there looks racy: if someone else locks the page in that
little window after the PageLocked() test we'll still block in lock_page().
 That's unlikely to happen in your application (apart from a remaining
ab/ba scenario) but we should make it robust:

	if (wbc->skip_locked_pages) {
		if (TestSetPageLocked(page))
			continue;
	} else {
		lock_page(page);
	}


