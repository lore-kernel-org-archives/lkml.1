Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbZDFQL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbZDFQL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZDFQKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:10:22 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58105 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752163AbZDFQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:10:16 -0400
Message-Id: <20090406161013.686747000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Apr 2009 11:08:16 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [patch 07/13] GRU - support contexts with zero dsrs or cbrs
References: <20090406160809.278924000@sgi.com>
Content-Disposition: inline; filename=uv_gru_zero_resources
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Support alocation of GRU contexts that contain zero DSR or CBR
resources. Some instructions do not require DSR resources.
Contexts without CBR resources are useful for diagnostics.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c |    6 ++----
 drivers/misc/sgi-gru/grumain.c |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-02-27 17:58:21.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-02-27 17:59:24.000000000 -0600
@@ -135,11 +135,9 @@ static int gru_create_new_context(unsign
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
 		return -EFAULT;
 
-	if (req.data_segment_bytes == 0 ||
-				req.data_segment_bytes > max_user_dsr_bytes)
+	if (req.data_segment_bytes > max_user_dsr_bytes)
 		return -EINVAL;
-	if (!req.control_blocks || !req.maximum_thread_count ||
-				req.control_blocks > max_user_cbrs)
+	if (req.control_blocks > max_user_cbrs || !req.maximum_thread_count)
 		return -EINVAL;
 
 	if (!(req.options & GRU_OPT_MISS_MASK))
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-02-27 17:58:17.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-02-27 17:59:24.000000000 -0600
@@ -150,7 +150,7 @@ static unsigned long reserve_resources(u
 	unsigned long bits = 0;
 	int i;
 
-	do {
+	while (n--) {
 		i = find_first_bit(p, mmax);
 		if (i == mmax)
 			BUG();
@@ -158,7 +158,7 @@ static unsigned long reserve_resources(u
 		__set_bit(i, &bits);
 		if (idx)
 			*idx++ = i;
-	} while (--n);
+	}
 	return bits;
 }
 

