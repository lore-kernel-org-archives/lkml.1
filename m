Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbZKXPJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbZKXPJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933280AbZKXPHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:53 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45503 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933250AbZKXPHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:47 -0500
Message-Id: <20091124150753.531315000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:09 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 12/29] GRU - Add debug option for cache flushing
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_grudump_flush
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add a debug option to the SGI GRU driver for flushing GRU cache lines from memory.
In theory this is not needed but it is useful for debugging. This
has no use by end users.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukdump.c |   13 ++++++++-----
 drivers/misc/sgi-gru/grulib.h   |    2 ++
 2 files changed, 10 insertions(+), 5 deletions(-)

Index: linux/drivers/misc/sgi-gru/grukdump.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukdump.c	2009-11-20 09:32:14.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukdump.c	2009-11-20 09:32:32.000000000 -0600
@@ -44,7 +44,8 @@ static int gru_user_copy_handle(void __u
 
 static int gru_dump_context_data(void *grubase,
 			struct gru_context_configuration_handle *cch,
-			void __user *ubuf, int ctxnum, int dsrcnt)
+			void __user *ubuf, int ctxnum, int dsrcnt,
+			int flush_cbrs)
 {
 	void *cb, *cbe, *tfh, *gseg;
 	int i, scr;
@@ -55,6 +56,8 @@ static int gru_dump_context_data(void *g
 	tfh = grubase + GRU_TFH_BASE;
 
 	for_each_cbr_in_allocation_map(i, &cch->cbr_allocation_map, scr) {
+		if (flush_cbrs)
+			gru_flush_cache(cb);
 		if (gru_user_copy_handle(&ubuf, cb))
 			goto fail;
 		if (gru_user_copy_handle(&ubuf, tfh + i * GRU_HANDLE_STRIDE))
@@ -115,7 +118,7 @@ fail:
 
 static int gru_dump_context(struct gru_state *gru, int ctxnum,
 		void __user *ubuf, void __user *ubufend, char data_opt,
-		char lock_cch)
+		char lock_cch, char flush_cbrs)
 {
 	struct gru_dump_context_header hdr;
 	struct gru_dump_context_header __user *uhdr = ubuf;
@@ -159,8 +162,7 @@ static int gru_dump_context(struct gru_s
 			ret = -EFBIG;
 		else
 			ret = gru_dump_context_data(grubase, cch, ubuf, ctxnum,
-							dsrcnt);
-
+							dsrcnt, flush_cbrs);
 	}
 	if (cch_locked)
 		unlock_cch_handle(cch);
@@ -215,7 +217,8 @@ int gru_dump_chiplet_request(unsigned lo
 	for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
 		if (req.ctxnum == ctxnum || req.ctxnum < 0) {
 			ret = gru_dump_context(gru, ctxnum, ubuf, ubufend,
-						req.data_opt, req.lock_cch);
+						req.data_opt, req.lock_cch,
+						req.flush_cbrs);
 			if (ret < 0)
 				goto fail;
 			ubuf += ret;
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2009-11-20 09:32:28.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grulib.h	2009-11-20 09:32:32.000000000 -0600
@@ -125,6 +125,8 @@ struct gru_dump_chiplet_state_req {
 	int		ctxnum;
 	char		data_opt;
 	char		lock_cch;
+	char		flush_cbrs;
+	char		fill[10];
 	pid_t		pid;
 	void		*buf;
 	size_t		buflen;

