Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZLOGdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZLOGdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZLOGdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:33:15 -0500
Received: from brmea-mail-1.Sun.COM ([192.18.98.31]:55640 "EHLO
	brmea-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZLOGdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:33:12 -0500
X-Greylist: delayed 788 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2009 01:33:12 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Date: Tue, 15 Dec 2009 01:19:57 -0500
From: Oleg Drokin <green@linuxhacker.ru>
Subject: Re: [PATCH] Possible data loss on ext[34],
 reiserfs with external journal
In-reply-to: <20091215053207.GA26541@thunk.org>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-id: <2EEF5D3D-AFA5-4D74-92A7-B42A0FB9A4F5@linuxhacker.ru>
X-Mailer: Apple Mail (2.1077)
References: <20091211081608.GA597088@fiona.linuxhacker.ru>
 <20091215053207.GA26541@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Dec 15, 2009, at 12:32 AM, tytso@mit.edu wrote:
> Can you separate this patch into separate ones for each file system?

Sure.

> I think we can actually do better for ext4; for example, in the case
> of data=journal or data=writeback, it's not necessary to flush the fs
> data device.  It's only the case of data=ordered that we need to send
> a barrier.  With that optimization, we do need to add a barrier in the
> case of fsync() and when we are doing a journal checkpoint, but the
> extra code complexity is worth not having to force a barrier for the
> fs data device for every single commit, especially in the data=journal
> mode with a heavy fsync workload.

Indeed, this is a good idea too.
I think we still can squeeze a bit more juice out of it if we can
submit the data device flush right after submitting all the data, but
only do the waiting for it before issuing journal device flush in normal
journaling mode (we need to do the waiting before writing commit block
in async journaling mode).

> Do you have a test case that will allow you to easily try out this
> patch, in all of ext4's various journalling modes?  Thanks!!

Not for vanilla kernel, but I'll see if I can construct something easily
for it.
> @@ -277,6 +278,16 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
> 	struct jbd2_inode *jinode, *next_i;
> 	int err, ret = 0;
> 
> +	/* 
> +	 * If the journal is not located on the file system device,
> +	 * then we must flush the file system device before we issue
> +	 * the commit record
> +	 */
> +	if (commit_transaction->t_flushed_data_blocks &&
> +	    (journal->j_fs_dev != journal->j_dev) &&
> +	    (journal->j_flags & JBD2_BARRIER))
> +		blkdev_issue_flush(journal->j_fs_dev, NULL);
> +

I am afraid this is not enough. This code is called after journal was flushed for
async commit case, so it leaves a race window where journal transaction is already
on disk and complete, but the data is still in cache somewhere.

Also the callsite has this comment which is misleading, I think:
        /*
         * This is the right place to wait for data buffers both for ASYNC
         * and !ASYNC commit. If commit is ASYNC, we need to wait only after
         * the commit block went to disk (which happens above). If commit is
         * SYNC, we need to wait for data buffers before we start writing
         * commit block, which happens below in such setting.
         */

In fact it is only safe to wait here in ASYNC mode (and internal journal only) because
the device was already flushed (and I hope all device drivers drain the queue too, if not,
even this might be problematic) by the blkdev_issue_flush.

Bye,
    Oleg
