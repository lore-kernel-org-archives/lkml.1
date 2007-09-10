Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbXIJVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbXIJVGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760551AbXIJVGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 17:06:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbXIJVGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 17:06:06 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, rostedt@goodmiss.org,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       glommer@gmail.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] Add macros for acessing lguest fields
Date: Mon, 10 Sep 2007 15:20:40 -0300
Message-Id: <11894484404160-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The assumption that we have an overall irqs_pending flags,
and a one-to-one lguest <-> task mapping fails to hold on x86_64,
where we can have multiple puppies, aka vcpus.

Although ifdefs could be used, it makes the code much more
unreadable, and other ports are on the way, anyway. So some sort
of acessor is preferred anyway.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/io.c |   10 +++++-----
 drivers/lguest/lg.h |    3 +++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/lguest/io.c b/drivers/lguest/io.c
index ea68613..70bab38 100644
--- a/drivers/lguest/io.c
+++ b/drivers/lguest/io.c
@@ -247,7 +247,7 @@ static int lgread_other(struct lguest *lg,
 			void *buf, u32 addr, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
-	    || access_process_vm(lg->tsk, addr, buf, bytes, 0) != bytes) {
+	    || access_process_vm(lguest_task(lg), addr, buf, bytes, 0) != bytes) {
 		memset(buf, 0, bytes);
 		kill_guest(lg, "bad address in registered DMA struct");
 		return 0;
@@ -261,7 +261,7 @@ static int lgwrite_other(struct lguest *lg, u32 addr,
 			 const void *buf, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
-	    || (access_process_vm(lg->tsk, addr, (void *)buf, bytes, 1)
+	    || (access_process_vm(lguest_task(lg), addr, (void *)buf, bytes, 1)
 		!= bytes)) {
 		kill_guest(lg, "bad address writing to registered DMA");
 		return 0;
@@ -376,7 +376,7 @@ static u32 do_dma(struct lguest *srclg, const struct lguest_dma *src,
 		 * we only want a single page.  But it works, and returns the
 		 * number of pages.  Note that we're holding the destination's
 		 * mmap_sem, as get_user_pages() requires. */
-		if (get_user_pages(dstlg->tsk, dstlg->mm,
+		if (get_user_pages(lguest_task(dstlg), dstlg->mm,
 				   dst->addr[i], 1, 1, 1, pages+i, NULL)
 		    != 1) {
 			/* This means the destination gave us a bogus buffer */
@@ -469,9 +469,9 @@ static int dma_transfer(struct lguest *srclg,
 	/* We trigger the destination interrupt, even if the destination was
 	 * empty and we didn't transfer anything: this gives them a chance to
 	 * wake up and refill. */
-	set_bit(dst->interrupt, dstlg->irqs_pending);
+	set_bit(dst->interrupt, lguest_irqs_pending(dstlg));
 	/* Wake up the destination process. */
-	wake_up_process(dstlg->tsk);
+	wake_up_process(lguest_task(dstlg));
 	/* If we passed the last "struct lguest_dma", the receive had no
 	 * buffers left. */
 	return i == dst->num_dmas;
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 64f0abe..b1ed671 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -258,6 +258,9 @@ unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
 void do_hypercalls(struct lguest *lg);
 void write_timestamp(struct lguest *lg);
 
+#define lguest_task(__lg) __lg->tsk
+#define lguest_irqs_pending(__lg) __lg->irqs_pending
+
 /*L:035
  * Let's step aside for the moment, to study one important routine that's used
  * widely in the Host code.
-- 
1.4.4.2

