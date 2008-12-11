Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbYLKTYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbYLKTYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbYLKTSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:23 -0500
Received: from kroah.org ([198.145.64.141]:55926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756966AbYLKTSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:11 -0500
Date: Thu, 11 Dec 2008 11:14:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Jan Kara <jack@suse.cz>,
       Eric Sandeen <sandeen@redhat.com>
Subject: [patch 17/83] jbd: test BH_Write_EIO to detect errors on metadata
	buffers
Message-ID: <20081211191406.GQ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

commit 9f818b4ac04f53458d0354950b4f229f54be4dbf upstream.

__try_to_free_cp_buf(), __process_buffer(), and __wait_cp_io() test
BH_Uptodate flag to detect write I/O errors on metadata buffers.  But by
commit 95450f5a7e53d5752ce1a0d0b8282e10fe745ae0 "ext3: don't read inode
block if the buffer has a write error"(*), BH_Uptodate flag can be set to
inode buffers with BH_Write_EIO in order to avoid reading old inode data.
So now, we have to test BH_Write_EIO flag of checkpointing inode buffers
instead of BH_Uptodate.  This patch does it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/checkpoint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -94,7 +94,7 @@ static int __try_to_free_cp_buf(struct j
 	struct buffer_head *bh = jh2bh(jh);
 
 	if (jh->b_jlist == BJ_None && !buffer_locked(bh) &&
-	    !buffer_dirty(bh) && buffer_uptodate(bh)) {
+	    !buffer_dirty(bh) && !buffer_write_io_error(bh)) {
 		JBUFFER_TRACE(jh, "remove from checkpoint list");
 		ret = __journal_remove_checkpoint(jh) + 1;
 		jbd_unlock_bh_state(bh);
@@ -199,7 +199,7 @@ restart:
 			spin_lock(&journal->j_list_lock);
 			goto restart;
 		}
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			ret = -EIO;
 
 		/*
@@ -268,7 +268,7 @@ static int __process_buffer(journal_t *j
 		ret = 1;
 	} else if (!buffer_dirty(bh)) {
 		ret = 1;
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			ret = -EIO;
 		J_ASSERT_JH(jh, !buffer_jbddirty(bh));
 		BUFFER_TRACE(bh, "remove from checkpoint");

