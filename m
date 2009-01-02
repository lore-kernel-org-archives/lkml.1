Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZABDfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZABDfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 22:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZABDfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 22:35:11 -0500
Received: from thunk.org ([69.25.196.29]:36500 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZABDfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 22:35:10 -0500
X-Greylist: delayed 1436 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2009 22:35:10 EST
Date: Thu, 1 Jan 2009 22:11:10 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andreas Sundstrom <sunkan@zappa.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
Message-ID: <20090102031110.GF17821@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andreas Sundstrom <sunkan@zappa.cx>, linux-kernel@vger.kernel.org
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx> <20081226182145.GP9871@mit.edu> <495526F6.9040704@zappa.cx> <20081226193307.GA2138@mit.edu> <495553EB.6030604@zappa.cx> <20081227030632.GA3539@mit.edu> <4955F338.4020509@zappa.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4955F338.4020509@zappa.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 10:19:52AM +0100, Andreas Sundstrom wrote:
> Theodore Tso wrote:
> > On Fri, Dec 26, 2008 at 11:00:11PM +0100, Andreas Sundstrom wrote:
> >> But I enabled debugfs and did
> >> "echo 3 > /sys/kernel/debug/jbd2/jbd2-debug" and reproduced the problem
> >> by taking a snapshot while the system was live.
> >> I hope this had the same effect as your proposed change.
> > 
> > Thanks, that was helpful.  Can you try applying this patch, and let me
> > know whether the printk triggers?
> 
> No problem
> 

Hi Andreas,

Can you try this patch?  This should (hopefully!) allow you to mount
ext4 in a Xen guest without needing to explicitly disable barriers.
If it works, it's what I plan to push to Linus.

         	     	       	      	      	 - Ted

jbd2: Add barrier not supported test to journal_wait_on_commit_record

Xen doesn't report that barriers are not supported until buffer I/O is
reported as completed, instead of when the buffer I/O is submitted.
Add a check and a fallback codepath to journal_wait_on_commit_record()
to detect this case, so that attempts to mount ext4 filesystems on
LVM/devicemapper devices on Xen guests don't blow up with an "Aborting
journal on device XXX"; "Remounting filesystem read-only" error.

Thanks to Andreas Sundstrom for reporting this issue.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index bd1fad0..4b87547 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -25,6 +25,7 @@
 #include <linux/crc32.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
+#include <linux/bio.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -168,12 +169,34 @@ static int journal_submit_commit_record(journal_t *journal,
  * This function along with journal_submit_commit_record
  * allows to write the commit record asynchronously.
  */
-static int journal_wait_on_commit_record(struct buffer_head *bh)
+static int journal_wait_on_commit_record(journal_t *journal, 
+					 struct buffer_head *bh)
 {
 	int ret = 0;
 
+retry:
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
+	if (buffer_eopnotsupp(bh) && (journal->j_flags & JBD2_BARRIER)) {
+		printk(KERN_WARNING
+		       "JBD2: wait_on_commit_record: sync failed on %s - "
+		       "disabling barriers\n", journal->j_devname);
+		spin_lock(&journal->j_state_lock);
+		journal->j_flags &= ~JBD2_BARRIER;
+		spin_unlock(&journal->j_state_lock);
+
+		lock_buffer(bh);
+		clear_buffer_dirty(bh);
+		set_buffer_uptodate(bh);
+		bh->b_end_io = journal_end_buffer_io_sync;
+
+		ret = submit_bh(WRITE_SYNC, bh);
+		if (ret) {
+			unlock_buffer(bh);
+			return ret;
+		}
+		goto retry;
+	}
 
 	if (unlikely(!buffer_uptodate(bh)))
 		ret = -EIO;
@@ -802,7 +825,7 @@ wait_for_iobuf:
 			__jbd2_journal_abort_hard(journal);
 	}
 	if (!err && !is_journal_aborted(journal))
-		err = journal_wait_on_commit_record(cbh);
+		err = journal_wait_on_commit_record(journal, cbh);
 
 	if (err)
 		jbd2_journal_abort(journal, err);
