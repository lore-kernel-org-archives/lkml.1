Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0BLPqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:46:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320Ab0BLPqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:46:10 -0500
Date: Fri, 12 Feb 2010 07:45:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       jengelh@medozas.de, stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <20100212091609.GB1025@kernel.dk>
Message-ID: <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
References: <20100212091609.GB1025@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Feb 2010, Jens Axboe wrote:
> 
> This fixes it by using the passed in page writeback count, instead of
> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
> finish properly even when new pages are being dirted.

This seems broken.

The whole point of MAX_WRITEBACK_PAGES was to make sure that we don't 
generate a single IO bigger than a couple of MB. And then we have that 
loop around things to do multiple chunks. Your change to use nr_pages 
seems to make the whole looping totally pointless, and breaks that "don't 
do huge hunks" logic.

So I don't think that your patch is correct.

That said, I _do_ believe you when you say it makes a difference, which 
makes me think there is a bug there. I just don't think you fixed the 
right bug, and your change just happens to do what you wanted by pure 
random luck.

The _real_ bug seems to bethe one you mentioned, but then ignored:

> Instead of flushing everything older than the sync run, it will do 
> chunks of normal MAX_WRITEBACK_PAGES writeback and restart over and 
> over.

and it would seem that the _logical_ way to fix it would be something like 
the appended...

Hmm? Even when you do a 'fdatasync()', it's not going to guarantee that 
any _future_ data is written back, so the 'oldest_jif' thing would seem to 
be sane regardless of sync mode.

  NOTE NOTE NOTE! I do have to admit that this patch scares me, because 
  there could be some bug in the 'older_than_this' logic that means that 
  somebody sets it even if the inode is already dirty. So this patch makes 
  conceptual sense to me, and I think it's the right thing to do, but I 
  also suspect that we do not actually have a lot of test coverage of the 
  whole 'older_than_this' logic, because it historically has been just a
  small optimization for kupdated.

  So this patch scares me, as it could break 'fdatasync' entirely. So 
  somebody should really double-check the whole 'dirtied_when' logic, just 
  to be safe. If anybody ever sets 'dirtied_when' to the current time even 
  if the inode is already dirty (and has an earlier dirtied_when'), then 
  that would open up 'fdatasync()' and friends up to not writing things 
  back properly at all (because a newer write set 'dirtied_when' so that 
  old writes get ignored and thought to be 'totally new')

Comments? 

		Linus

---
 fs/fs-writeback.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1a7c42c..a0a8424 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -738,11 +738,16 @@ static long wb_writeback(struct bdi_writeback *wb,
 	long wrote = 0;
 	struct inode *inode;
 
-	if (wbc.for_kupdate) {
-		wbc.older_than_this = &oldest_jif;
-		oldest_jif = jiffies -
-				msecs_to_jiffies(dirty_expire_interval * 10);
-	}
+	/*
+	 * We never write back data that was dirtied _after_ we
+	 * started writeback. But kupdate doesn't even want to
+	 * write back recently dirtied stuff, only older data.
+	 */
+	oldest_jif = jiffies-1;
+	wbc.older_than_this = &oldest_jif;
+	if (wbc.for_kupdate)
+		oldest_jif -= msecs_to_jiffies(dirty_expire_interval * 10);
+
 	if (!wbc.range_cyclic) {
 		wbc.range_start = 0;
 		wbc.range_end = LLONG_MAX;
