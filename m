Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbZKXPHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbZKXPHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933132AbZKXPHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:44 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57685 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933225AbZKXPHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:42 -0500
Message-Id: <20091124150747.739523000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:05:59 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 02/29] GRU - Add comments raised in previous code reviews
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_formating
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add comments from previous code reviews. The comments
help explain some of the more esoteric aspects of the driver.

Move a free() to the other side of an unlock.


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grufault.c     |    5 +++++
 drivers/misc/sgi-gru/grukservices.c |    4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:15.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:27.000000000 -0600
@@ -733,6 +733,11 @@ long gru_get_gseg_statistics(unsigned lo
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
 		return -EFAULT;
 
+	/*
+	 * The library creates arrays of contexts for threaded programs.
+	 * If no gts exists in the array, the context has never been used & all
+	 * statistics are implicitly 0.
+	 */
 	gts = gru_find_lock_gts(req.gseg);
 	if (gts) {
 		memcpy(&req.stats, &gts->ustats, sizeof(gts->ustats));
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:25.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:27.000000000 -0600
@@ -200,13 +200,15 @@ static int gru_free_kernel_contexts(void
 		bs = gru_base[bid];
 		if (!bs)
 			continue;
+
+		/* Ignore busy contexts. Don't want to block here.  */
 		if (down_write_trylock(&bs->bs_kgts_sema)) {
 			kgts = bs->bs_kgts;
 			if (kgts && kgts->ts_gru)
 				gru_unload_context(kgts, 0);
-			kfree(kgts);
 			bs->bs_kgts = NULL;
 			up_write(&bs->bs_kgts_sema);
+			kfree(kgts);
 		} else {
 			ret++;
 		}

