Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618Ab0A0Uqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0A0Uqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556Ab0A0Uqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:40 -0500
Received: from mail.perches.com ([173.55.12.10]:1539 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab0A0Uqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:34 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 06/13] drivers/block/floppy.c: Use __func__ where appropriate
Date: Wed, 27 Jan 2010 12:46:22 -0800
Message-Id: <009a51987c6f9e8f5d3824c89f5fa653921d7701.1264624292.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use __func__ to is_alive
Use __func__ in some DPRINTs

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 8700c6a..c1004b8 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -631,12 +631,12 @@ static DEFINE_TIMER(fd_timeout, floppy_shutdown, 0, 0);
 
 static const char *timeout_message;
 
-static void is_alive(const char *message)
+static void is_alive(const char *func, const char *message)
 {
 	/* this routine checks whether the floppy driver is "alive" */
 	if (test_bit(0, &fdc_busy) && command_status < 2 &&
 	    !timer_pending(&fd_timeout)) {
-		DPRINT("timeout handler died: %s\n", message);
+		DPRINT("%s: timeout handler died.  %s\n", func, message);
 	}
 }
 
@@ -1734,7 +1734,7 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 		pr_info("DOR0=%x\n", fdc_state[0].dor);
 		pr_info("floppy interrupt on bizarre fdc %d\n", fdc);
 		pr_info("handler=%p\n", handler);
-		is_alive("bizarre fdc");
+		is_alive(__func__, "bizarre fdc");
 		return IRQ_NONE;
 	}
 
@@ -1769,7 +1769,7 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 	schedule_bh(handler);
-	is_alive("normal interrupt end");
+	is_alive(__func__, "normal interrupt end");
 
 	/* FIXME! Was it really for us? */
 	return IRQ_HANDLED;
@@ -1894,7 +1894,7 @@ static void floppy_shutdown(unsigned long data)
 		pr_info("no cont in shutdown!\n");
 		process_fd_request();
 	}
-	is_alive("floppy shutdown");
+	is_alive(__func__, "");
 }
 
 /* start motor, check media-changed condition and write protection */
@@ -2027,7 +2027,7 @@ static int wait_til_done(void (*handler)(void), bool interruptible)
 			if (command_status >= 2 || !NO_SIGNAL)
 				break;
 
-			is_alive("wait_til_done");
+			is_alive(__func__, "");
 			schedule();
 		}
 
@@ -2602,7 +2602,7 @@ static int make_raw_rw_request(void)
 		raw_cmd->flags |= FD_RAW_WRITE;
 		COMMAND = FM_MODE(_floppy, FD_WRITE);
 	} else {
-		DPRINT("make_raw_rw_request: unknown command\n");
+		DPRINT("%s: unknown command\n", __func__);
 		return 0;
 	}
 
@@ -2743,7 +2743,7 @@ static int make_raw_rw_request(void)
 			raw_cmd->kernel_data = current_req->buffer;
 			raw_cmd->length = current_count_sectors << 9;
 			if (raw_cmd->length == 0) {
-				DPRINT("zero dma transfer attempted from make_raw_request\n");
+				DPRINT("%s: zero dma transfer attempted\n", __func__);
 				DPRINT("indirect=%d direct=%d fsector_t=%d\n",
 				       indirect, direct, fsector_t);
 				return 0;
@@ -2938,7 +2938,7 @@ static void process_fd_request(void)
 static void do_fd_request(struct request_queue *q)
 {
 	if (max_buffer_sectors == 0) {
-		pr_info("VFS: do_fd_request called on non-open device\n");
+		pr_info("VFS: %s called on non-open device\n", __func__);
 		return;
 	}
 
@@ -2953,12 +2953,12 @@ static void do_fd_request(struct request_queue *q)
 	if (test_bit(0, &fdc_busy)) {
 		/* fdc busy, this new request will be treated when the
 		   current one is done */
-		is_alive("do fd request, old request running");
+		is_alive(__func__, "old request running");
 		return;
 	}
 	lock_fdc(MAXTIMEOUT, false);
 	process_fd_request();
-	is_alive("do fd request");
+	is_alive(__func__, "");
 }
 
 static struct cont_t poll_cont = {
-- 
1.6.6.rc0.57.gad7a

