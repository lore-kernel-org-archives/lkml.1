Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbXIXQgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbXIXQgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760683AbXIXQ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:08 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57945 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680AbXIXQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:06 -0400
Date: Mon, 24 Sep 2007 09:21:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [32/50] Fix race with shared tag queue maps
Message-ID: <20070924162149.GG13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-race-with-shared-tag-queue-maps.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

The commit in Linus upstream git tree is
f3da54ba140c6427fa4a32913e1bf406f41b5dda.

Fix race with shared tag queue maps

There's a race condition in blk_queue_end_tag() for shared tag maps,
users include stex (promise supertrak thingy) and qla2xxx.  The former
at least has reported bugs in this area, not sure why we haven't seen
any for the latter.  It could be because the window is narrow and that
other conditions in the qla2xxx code hide this.  It's a real bug,
though, as the stex smp users can attest.

We need to ensure two things - the tag bit clearing needs to happen
AFTER we cleared the tag pointer, as the tag bit clearing/setting is
what protects this map.  Secondly, we need to ensure that the visibility
of the tag pointer and tag bit clear are ordered properly.

[ I removed the SMP barriers - "test_and_clear_bit()" already implies
  all the required barriers.  -- Linus ]

Also see http://bugzilla.kernel.org/show_bug.cgi?id=7842

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/ll_rw_blk.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1081,12 +1081,6 @@ void blk_queue_end_tag(request_queue_t *
 		 */
 		return;
 
-	if (unlikely(!__test_and_clear_bit(tag, bqt->tag_map))) {
-		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
-		       __FUNCTION__, tag);
-		return;
-	}
-
 	list_del_init(&rq->queuelist);
 	rq->cmd_flags &= ~REQ_QUEUED;
 	rq->tag = -1;
@@ -1096,6 +1090,13 @@ void blk_queue_end_tag(request_queue_t *
 		       __FUNCTION__, tag);
 
 	bqt->tag_index[tag] = NULL;
+
+	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {
+		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
+		       __FUNCTION__, tag);
+		return;
+	}
+
 	bqt->busy--;
 }
 

-- 
