Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYL0DGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYL0DGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 22:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYL0DGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 22:06:38 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62716 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbYL0DGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 22:06:37 -0500
Date: Fri, 26 Dec 2008 22:06:32 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Andreas Sundstrom <sunkan@zappa.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
Message-ID: <20081227030632.GA3539@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andreas Sundstrom <sunkan@zappa.cx>, linux-kernel@vger.kernel.org
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx> <20081226182145.GP9871@mit.edu> <495526F6.9040704@zappa.cx> <20081226193307.GA2138@mit.edu> <495553EB.6030604@zappa.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495553EB.6030604@zappa.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 11:00:11PM +0100, Andreas Sundstrom wrote:
> But I enabled debugfs and did
> "echo 3 > /sys/kernel/debug/jbd2/jbd2-debug" and reproduced the problem
> by taking a snapshot while the system was live.
> I hope this had the same effect as your proposed change.

Thanks, that was helpful.  Can you try applying this patch, and let me
know whether the printk triggers?

What I'm guessing is going on is that on a native kernel, we get the
ENOTSUPP error immediately when we call submit_bh().  However, with
the Xen kernel, we aren't getting the error right away; we're either
getting ENOTSUPP later on, when we call wait_on_buffer().  For ext3,
this doesn't matter, since we call sync_dirty_buffer() which calls
submit_bh() and wait_on_buffer() synchronously.  But ext4 doesn't use
sync_dirty_buffer(), instead calling submit_bh() and wait_on_buffer()
separately.

This patch should be able to confirm whether or not this supposition
is correct.

						- Ted

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index bd1fad0..630196d 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -174,9 +174,16 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
 
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
+	if (buffer_eopnotsupp(bh)) {
+		printk("jbd2: journal_wait_on_commit_record: eopnotsupp\n");
+		ret = sync_dirty_buffer(bh);
+		printk("jbd2: sync_dirty_buffer returned %d\n", ret);
+	}
 
-	if (unlikely(!buffer_uptodate(bh)))
+	if (unlikely(!buffer_uptodate(bh))) {
+		printk("jbd2: journal_wait_on_commit_record: not uptodate\n");
 		ret = -EIO;
+	}
 	put_bh(bh);            /* One for getblk() */
 	jbd2_journal_put_journal_head(bh2jh(bh));
 
