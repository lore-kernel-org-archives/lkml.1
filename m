Return-Path: <linux-kernel-owner+w=401wt.eu-S1750853AbYE2EAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853AbYE2EAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbYE2D7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:59:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575AbYE2D7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:59:49 -0400
Date: Wed, 28 May 2008 20:59:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] jbd2: Silence warnings about non-uptodate buffers
Message-Id: <20080528205913.10c31851.akpm@linux-foundation.org>
In-Reply-To: <12120117743119-git-send-email-jack@suse.cz>
References: <12120117733479-git-send-email-jack@suse.cz>
	<12120117743119-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 23:56:12 +0200 Jan Kara <jack@suse.cz> wrote:

> When underlying block device becomes unavailable (e.g. someone pulling an
> USB stick from under us), kernel produces warning about non-uptodate buffer
> (superblock) being marked dirty. Silence these warnings by making buffer
> uptodate before marking it dirty.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/jbd2/journal.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 2e24567..55de8f7 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1261,6 +1261,7 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
>  	spin_unlock(&journal->j_state_lock);
>  
>  	BUFFER_TRACE(bh, "marking dirty");
> +	set_buffer_uptodate(bh);
>  	mark_buffer_dirty(bh);
>  	if (wait)
>  		sync_dirty_buffer(bh);

I have issues....

- Are we really really sure that we aren't about to wreck people's
  filesystems when this happens?  I mean, a non-uptodate buffer might
  have random garbage in it, and it would be sad to write that to disk.

  Either way, I do think that potentially falsely setting BH_Uptodate
  just to squish a WARN_ON_ONCE() is not a good solution.  Better to
  set a new BH_Nowarn, or to call a new mark_buffer_dirty_nowarn() here.

- Did the reads of these buffers encounter an IO error?  If so,
  perhaps we could set a new BH_GotIOError or something.

Even if I'm completely wrong about everything as usual, I do think that
the code change should at least include a comment explaining why the
filesystem is doing set_buffer_uptodate() in such a weird place.

One nice way of adding that comment would be to implement a new

/*
 * comment goes here
 */
set_buffer_uptodate_for_mark_buffer_dirty(struct buffer_head *bh); /* needs better name */

and call that.

But I agree with me: this looks like abuse of buffer_uptodate(), and a
mark_buffer_dirty_nowarn() would be a cleaner solution.

