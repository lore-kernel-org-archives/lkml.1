Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbYBGBcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbYBGBcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYBGBcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:32:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:43050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYBGBcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:32:06 -0500
From: Neil Brown <neilb@suse.de>
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Date: Thu, 7 Feb 2008 12:32:02 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18346.24466.83745.944149@notabene.brown>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext3 can fail badly when device stops accepting BIO_RW_BARRIER requests. 
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some devices - notably dm and md - can change their behaviour in
response to BIO_RW_BARRIER requests.  They might start out accepting
such requests but on reconfiguration, they find out that they cannot
any more.

ext3 (and other filesystems) deal with this by always testing if
BIO_RW_BARRIER requests fail with EOPNOTSUPP, and retrying the write
requests without the barrier (probably after waiting for any pending
writes to complete).

However there is a bug in the handling for this for ext3.

When ext3 (jbd actually) decides to submit a BIO_RW_BARRIER request,
it sets the buffer_ordered flag on the buffer head.
If the request completes successfully, the flag STAYS SET.

Other code might then write the same buffer_head after the device has
been reconfigured to not accept barriers.  This write will then fail,
but the "other code" is not ready to handle EOPNOTSUPP errors and the
error will be treated as fatal.

This can be seen without having to reconfigure a device at exactly the
wrong time by putting:

		if (buffer_ordered(bh))
			printk("OH DEAR, and ordered buffer\n");


in the while loop in "commit phase 5" of journal_commit_transaction.

If it ever prints the "OH DEAR ..." message (as it does sometimes for
me), then that request could (in different circumstances) have failed
with EOPNOTSUPP, but that isn't tested for.

My proposed fix is to clear the buffer_ordered flag after it has been
used, as in the following patch.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

diff .prev/fs/jbd/commit.c ./fs/jbd/commit.c
--- .prev/fs/jbd/commit.c	2008-02-07 10:01:57.000000000 +1100
+++ ./fs/jbd/commit.c	2008-02-07 10:04:58.000000000 +1100
@@ -131,6 +131,8 @@ static int journal_write_commit_record(j
 		barrier_done = 1;
 	}
 	ret = sync_dirty_buffer(bh);
+	if (barrier_done)
+		clear_buffer_ordered(bh);
 	/* is it possible for another commit to fail at roughly
 	 * the same time as this one?  If so, we don't want to
 	 * trust the barrier flag in the super, but instead want
@@ -148,7 +150,6 @@ static int journal_write_commit_record(j
 		spin_unlock(&journal->j_state_lock);
 
 		/* And try again, without the barrier */
-		clear_buffer_ordered(bh);
 		set_buffer_uptodate(bh);
 		set_buffer_dirty(bh);
 		ret = sync_dirty_buffer(bh);
