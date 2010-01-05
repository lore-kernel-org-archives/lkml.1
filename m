Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593Ab0AEA5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0AEA5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114Ab0AEAei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:38 -0500
Received: from kroah.org ([198.145.64.141]:34070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0AEAeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/97] SCSI: st: fix mdata->page_order handling
Date: Mon,  4 Jan 2010 16:32:16 -0800
Message-Id: <1262651630-7354-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit c982c368bb90adbd312faa05d0cfd842e9ab45a7 upstream.

dio transfer always resets mdata->page_order to zero. It breaks
high-order pages previously allocated for non-dio transfer.

This patches adds reserved_page_order to st_buffer structure to save
page order for non-dio transfer.

http://bugzilla.kernel.org/show_bug.cgi?id=14563

When enlarge_buffer() allocates 524288 from 0, st uses six-order page
allocation. So mdata->page_order is 6 and frp_seg is 2.

After that, if st uses dio, sgl_map_user_pages() sets
mdata->page_order to 0 for st_do_scsi(). After that, when we call
normalize_buffer(), it frees only free frp_seg * PAGE_SIZE (2 * 4096)
though we should free frp_seg * PAGE_SIZE << 6 (2 * 4096 << 6). So we
see buffer_size is set to 516096 (524288 - 8192).

Reported-by: Joachim Breuer <linux-kernel@jmbreuer.net>
Tested-by: Joachim Breuer <linux-kernel@jmbreuer.net>
Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/st.c |   23 ++++++++++++-----------
 drivers/scsi/st.h |    1 +
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 12d58a7..5081f97 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -552,13 +552,15 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	SRpnt->waiting = waiting;
 
 	if (STp->buffer->do_dio) {
+		mdata->page_order = 0;
 		mdata->nr_entries = STp->buffer->sg_segs;
 		mdata->pages = STp->buffer->mapped_pages;
 	} else {
+		mdata->page_order = STp->buffer->reserved_page_order;
 		mdata->nr_entries =
 			DIV_ROUND_UP(bytes, PAGE_SIZE << mdata->page_order);
-		STp->buffer->map_data.pages = STp->buffer->reserved_pages;
-		STp->buffer->map_data.offset = 0;
+		mdata->pages = STp->buffer->reserved_pages;
+		mdata->offset = 0;
 	}
 
 	memcpy(SRpnt->cmd, cmd, sizeof(SRpnt->cmd));
@@ -3718,7 +3720,7 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		priority |= __GFP_ZERO;
 
 	if (STbuffer->frp_segs) {
-		order = STbuffer->map_data.page_order;
+		order = STbuffer->reserved_page_order;
 		b_size = PAGE_SIZE << order;
 	} else {
 		for (b_size = PAGE_SIZE, order = 0;
@@ -3751,7 +3753,7 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		segs++;
 	}
 	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
-	STbuffer->map_data.page_order = order;
+	STbuffer->reserved_page_order = order;
 
 	return 1;
 }
@@ -3764,7 +3766,7 @@ static void clear_buffer(struct st_buffer * st_bp)
 
 	for (i=0; i < st_bp->frp_segs; i++)
 		memset(page_address(st_bp->reserved_pages[i]), 0,
-		       PAGE_SIZE << st_bp->map_data.page_order);
+		       PAGE_SIZE << st_bp->reserved_page_order);
 	st_bp->cleared = 1;
 }
 
@@ -3772,7 +3774,7 @@ static void clear_buffer(struct st_buffer * st_bp)
 /* Release the extra buffer */
 static void normalize_buffer(struct st_buffer * STbuffer)
 {
-	int i, order = STbuffer->map_data.page_order;
+	int i, order = STbuffer->reserved_page_order;
 
 	for (i = 0; i < STbuffer->frp_segs; i++) {
 		__free_pages(STbuffer->reserved_pages[i], order);
@@ -3780,7 +3782,7 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 	}
 	STbuffer->frp_segs = 0;
 	STbuffer->sg_segs = 0;
-	STbuffer->map_data.page_order = 0;
+	STbuffer->reserved_page_order = 0;
 	STbuffer->map_data.offset = 0;
 }
 
@@ -3790,7 +3792,7 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, int do_count)
 {
 	int i, cnt, res, offset;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	for (i = 0, offset = st_bp->buffer_bytes;
 	     i < st_bp->frp_segs && offset >= length; i++)
@@ -3822,7 +3824,7 @@ static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, in
 static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count)
 {
 	int i, cnt, res, offset;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	for (i = 0, offset = st_bp->read_pointer;
 	     i < st_bp->frp_segs && offset >= length; i++)
@@ -3855,7 +3857,7 @@ static void move_buffer_data(struct st_buffer * st_bp, int offset)
 {
 	int src_seg, dst_seg, src_offset = 0, dst_offset;
 	int count, total;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	if (offset == 0)
 		return;
@@ -4577,7 +4579,6 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
         }
 
 	mdata->offset = uaddr & ~PAGE_MASK;
-	mdata->page_order = 0;
 	STbp->mapped_pages = pages;
 
 	return nr_pages;
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 544dc6b..f91a67c 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -46,6 +46,7 @@ struct st_buffer {
 	struct st_request *last_SRpnt;
 	struct st_cmdstatus cmdstat;
 	struct page **reserved_pages;
+	int reserved_page_order;
 	struct page **mapped_pages;
 	struct rq_map_data map_data;
 	unsigned char *b_data;
-- 
1.6.6

