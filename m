Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbZDQQRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbZDQQRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZDQQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:17:06 -0400
Received: from relay3.sgi.com ([192.48.156.57]:34641 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758123AbZDQQRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:17:05 -0400
Date: Fri, 17 Apr 2009 11:17:04 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: [Patch] sgi-xp sgi-gru Allow modules to load on non-uv systems.
Message-ID: <20090417161704.GJ10764@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For an upcoming distro release, we need to have the xp kernel module
loadable even when not on UV equipment.  The xpc module will not load.
This will allow one set of modules dependent upon xp to work on either
UV or non-UV equipment.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>

---

 drivers/misc/sgi-gru/grufile.c |    2 +-
 drivers/misc/sgi-xp/xp_main.c  |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)
Index: 20090417/drivers/misc/sgi-gru/grufile.c
===================================================================
--- 20090417.orig/drivers/misc/sgi-gru/grufile.c	2009-04-17 07:39:38.000000000 -0500
+++ 20090417/drivers/misc/sgi-gru/grufile.c	2009-04-17 08:46:01.756544851 -0500
@@ -375,7 +375,7 @@ static int __init gru_init(void)
 	void *gru_start_vaddr;
 
 	if (!is_uv_system())
-		return -ENODEV;
+		return 0;
 
 #if defined CONFIG_IA64
 	gru_start_paddr = 0xd000000000UL; /* ZZZZZZZZZZZZZZZZZZZ fixme */
Index: 20090417/drivers/misc/sgi-xp/xp_main.c
===================================================================
--- 20090417.orig/drivers/misc/sgi-xp/xp_main.c	2009-04-17 07:39:38.000000000 -0500
+++ 20090417/drivers/misc/sgi-xp/xp_main.c	2009-04-17 10:21:02.912293772 -0500
@@ -248,19 +248,19 @@ xp_init(void)
 	enum xp_retval ret;
 	int ch_number;
 
+	/* initialize the connection registration mutex */
+	for (ch_number = 0; ch_number < XPC_MAX_NCHANNELS; ch_number++)
+		mutex_init(&xpc_registrations[ch_number].mutex);
+
 	if (is_shub())
 		ret = xp_init_sn2();
 	else if (is_uv())
 		ret = xp_init_uv();
 	else
-		ret = xpUnsupported;
+		ret = 0;
 
 	if (ret != xpSuccess)
-		return -ENODEV;
-
-	/* initialize the connection registration mutex */
-	for (ch_number = 0; ch_number < XPC_MAX_NCHANNELS; ch_number++)
-		mutex_init(&xpc_registrations[ch_number].mutex);
+		return ret;
 
 	return 0;
 }
