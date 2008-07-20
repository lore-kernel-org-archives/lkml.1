Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYGTP7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYGTP7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbYGTP70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:59:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:58782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYGTP70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:59:26 -0400
Date: Sun, 20 Jul 2008 08:59:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Rene Herman <rene.herman@keyaccess.nl>,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Daniel Walker <dwalker@mvista.com>
Subject: [patch 4/3] fastboot: hold the BKL over the async init call
 sequence
Message-ID: <20080720085924.122feb2b@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] fastboot: hold the BKL over the async init call sequence

Regular init calls are called with the BKL held; make sure
the async init calls are also called with the BKL held.
While this reduces parallelism a little, it does provide
lock-for-lock compatibility. The hit to prallelism isn't too
bad, most of the init calls are done immediately or actually
block for their delays.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 init/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index bf79b83..dcb2c32 100644
--- a/init/main.c
+++ b/init/main.c
@@ -746,8 +746,14 @@ static void __init do_async_initcalls(struct work_struct *dummy)
 {
 	initcall_t *call;
 
+	/*
+	 * For compatibility with normal init calls... take the BKL
+	 * not pretty, not desirable, but compatibility first
+	 */
+	lock_kernel();
 	for (call = __async_initcall_start; call < __async_initcall_end; call++)
 		do_one_initcall(*call);
+	unlock_kernel();
 }
 
 static struct workqueue_struct *async_init_wq;
-- 
1.5.5.1

