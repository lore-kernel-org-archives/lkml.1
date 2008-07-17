Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYGQQv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYGQQv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbYGQQvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:51:20 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48786 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165AbYGQQvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:51:19 -0400
Subject: [PATCH] systemtap: fix up on_each_cpu() for kernels 2.6.26+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: systemtap@sourceware.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 11:51:16 -0500
Message-Id: <1216313476.5515.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel 2.6.26, this patch

commit 15c8b6c1aaaf1c4edd67e2f02e4d8e1bd1a51c0d
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri May 9 09:39:44 2008 +0200

    on_each_cpu(): kill unused 'retry' parameter

means that runtime/time.c is now using the wrong calling conventions.
Fix this up and surround it by kernel versioning #ifdefs.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 runtime/time.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/runtime/time.c b/runtime/time.c
index 8a0b6fa..fffdfe0 100644
--- a/runtime/time.c
+++ b/runtime/time.c
@@ -237,7 +237,12 @@ _stp_init_time(void)
 	    return -1;
     
     stp_timer_reregister = 1;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26)
     ret = on_each_cpu(__stp_init_time, NULL, 0, 1);
+#else
+    ret = on_each_cpu(__stp_init_time, NULL, 1);
+#endif
+
 
 #ifdef CONFIG_CPU_FREQ
     if (!ret && !__stp_constant_freq()) {
-- 
1.5.6



