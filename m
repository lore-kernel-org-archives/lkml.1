Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYJUVZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYJUVZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYJUVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:25:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53009 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752109AbYJUVZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:25:35 -0400
Date: Tue, 21 Oct 2008 16:25:35 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] sgi-xp: support getting the address of a partition's reserved page
Message-ID: <20081021212535.GF14386@sgi.com>
References: <20081021212054.GB14386@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021212054.GB14386@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for getting the address of a partition's reserved page.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xpc_uv.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

Index: linux/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_uv.c	2008-10-21 12:50:18.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xpc_uv.c	2008-10-21 14:00:13.000000000 -0500
@@ -642,7 +642,7 @@ xpc_send_local_activate_IRQ_uv(struct xp
 	struct xpc_partition_uv *part_uv = &part->sn.uv;
 
 	/*
-	 * !!! Make our side think that the remote parition sent an activate
+	 * !!! Make our side think that the remote partition sent an activate
 	 * !!! message our way by doing what the activate IRQ handler would
 	 * !!! do had one really been sent.
 	 */
@@ -660,8 +660,33 @@ static enum xp_retval
 xpc_get_partition_rsvd_page_pa_uv(void *buf, u64 *cookie, unsigned long *rp_pa,
 				  size_t *len)
 {
-	/* !!! call the UV version of sn_partition_reserved_page_pa() */
-	return xpUnsupported;
+	s64 status;
+	enum xp_retval ret;
+
+#if defined CONFIG_X86_64
+	status = uv_bios_reserved_page_pa((u64)buf, cookie, (u64 *)rp_pa,
+					  (u64 *)len);
+	if (status == BIOS_STATUS_SUCCESS)
+		ret = xpSuccess;
+	else if (status == BIOS_STATUS_MORE_PASSES)
+		ret = xpNeedMoreInfo;
+	else
+		ret = xpBiosError;
+
+#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+	status = sn_partition_reserved_page_pa((u64)buf, cookie, rp_pa, len);
+	if (status == SALRET_OK)
+		ret = xpSuccess;
+	else if (status == SALRET_MORE_PASSES)
+		ret = xpNeedMoreInfo;
+	else
+		ret = xpSalError;
+
+#else
+	#error not a supported configuration
+#endif
+
+	return ret;
 }
 
 static int
