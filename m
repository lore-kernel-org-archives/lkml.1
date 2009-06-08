Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZFHRWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZFHRWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZFHRUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:24 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57157 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753662AbZFHRUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:20:23 -0400
Message-Id: <20090608172021.096659000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:58 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 10/12] GRU - fixes to grudump utility
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_grudump_fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Minor fixes to the SGI GRU grudump facility:
	- fix address where user data is written
	- add gru number to data passed to user
	- indicate if context is locked


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukdump.c |    8 ++++++--
 drivers/misc/sgi-gru/grulib.h   |    4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux/drivers/misc/sgi-gru/grukdump.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukdump.c	2009-06-05 15:16:57.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukdump.c	2009-06-05 15:20:36.000000000 -0500
@@ -26,7 +26,7 @@
 
 static int gru_user_copy_handle(void __user **dp, void *s)
 {
-	if (copy_to_user(dp, s, GRU_HANDLE_BYTES))
+	if (copy_to_user(*dp, s, GRU_HANDLE_BYTES))
 		return -1;
 	*dp += GRU_HANDLE_BYTES;
 	return 0;
@@ -109,7 +109,7 @@ static int gru_dump_context(struct gru_s
 {
 	struct gru_dump_context_header hdr;
 	struct gru_dump_context_header __user *uhdr = ubuf;
-	struct gru_context_configuration_handle *cch;
+	struct gru_context_configuration_handle *cch, *ubufcch;
 	struct gru_thread_state *gts;
 	int try, cch_locked, cbrcnt = 0, dsrcnt = 0, bytes = 0, ret = 0;
 	void *grubase;
@@ -125,8 +125,11 @@ static int gru_dump_context(struct gru_s
 	}
 
 	ubuf += sizeof(hdr);
+	ubufcch = ubuf;
 	if (gru_user_copy_handle(&ubuf, cch))
 		goto fail;
+	if (cch_locked)
+		ubufcch->delresp = 0;
 	bytes = sizeof(hdr) + GRU_CACHE_LINE_BYTES;
 
 	if (cch_locked || !lock_cch) {
@@ -155,6 +158,7 @@ static int gru_dump_context(struct gru_s
 		return ret;
 
 	hdr.magic = GRU_DUMP_MAGIC;
+	hdr.gid = gru->gs_gid;
 	hdr.ctxnum = ctxnum;
 	hdr.cbrcnt = cbrcnt;
 	hdr.dsrcnt = dsrcnt;
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2009-06-05 15:16:57.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2009-06-05 15:20:46.000000000 -0500
@@ -120,7 +120,7 @@ struct gru_flush_tlb_req {
 enum {dcs_pid, dcs_gid};
 struct gru_dump_chiplet_state_req {
 	unsigned int	op;
-	int		gid;
+	unsigned int	gid;
 	int		ctxnum;
 	char		data_opt;
 	char		lock_cch;
@@ -134,7 +134,7 @@ struct gru_dump_chiplet_state_req {
 #define GRU_DUMP_MAGIC	0x3474ab6c
 struct gru_dump_context_header {
 	unsigned int	magic;
-	unsigned char	gid;
+	unsigned int	gid;
 	unsigned char	ctxnum;
 	unsigned char	cbrcnt;
 	unsigned char	dsrcnt;

