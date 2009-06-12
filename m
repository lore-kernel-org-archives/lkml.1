Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbZFLKco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbZFLKco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933857AbZFLKcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:32:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34916 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933899AbZFLKcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:32:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] tty: bfin_jtag_comm: clean up printk usage
Date: Fri, 12 Jun 2009 06:32:22 -0400
Message-Id: <1244802742-14107-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original patch garned some feedback and a v2 was posted, but that
version seems to have been missed when merging the driver.

At any rate, this cleans up the printk usage as suggested by Jiri Slaby.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/char/bfin_jtag_comm.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/char/bfin_jtag_comm.c b/drivers/char/bfin_jtag_comm.c
index 44c113d..1d7c34c 100644
--- a/drivers/char/bfin_jtag_comm.c
+++ b/drivers/char/bfin_jtag_comm.c
@@ -8,6 +8,10 @@
  * Licensed under the GPL-2 or later.
  */
 
+#define DRV_NAME "bfin-jtag-comm"
+#define DEV_NAME "ttyBFJC"
+#define pr_fmt(fmt) DRV_NAME ": " fmt
+
 #include <linux/circ_buf.h>
 #include <linux/console.h>
 #include <linux/delay.h>
@@ -22,18 +26,14 @@
 #include <linux/tty_flip.h>
 #include <asm/atomic.h>
 
+#define pr_init(fmt, args...) ({ static const __initconst char __fmt[] = fmt; printk(__fmt, ## args); })
+
 /* See the Debug/Emulation chapter in the HRM */
 #define EMUDOF   0x00000001	/* EMUDAT_OUT full & valid */
 #define EMUDIF   0x00000002	/* EMUDAT_IN full & valid */
 #define EMUDOOVF 0x00000004	/* EMUDAT_OUT overflow */
 #define EMUDIOVF 0x00000008	/* EMUDAT_IN overflow */
 
-#define DRV_NAME "bfin-jtag-comm"
-#define DEV_NAME "ttyBFJC"
-
-#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
-#define debug(fmt, args...) pr_debug(DRV_NAME ": " fmt, ## args)
-
 static inline uint32_t bfin_write_emudat(uint32_t emudat)
 {
 	__asm__ __volatile__("emudat = %0;" : : "d"(emudat));
@@ -74,7 +74,7 @@ bfin_jc_emudat_manager(void *arg)
 	while (!kthread_should_stop()) {
 		/* no one left to give data to, so sleep */
 		if (bfin_jc_tty == NULL && circ_empty(&bfin_jc_write_buf)) {
-			debug("waiting for readers\n");
+			pr_debug("waiting for readers\n");
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule();
 			__set_current_state(TASK_RUNNING);
@@ -82,7 +82,7 @@ bfin_jc_emudat_manager(void *arg)
 
 		/* no data available, so just chill */
 		if (!(bfin_read_DBGSTAT() & EMUDIF) && circ_empty(&bfin_jc_write_buf)) {
-			debug("waiting for data (in_len = %i) (circ: %i %i)\n",
+			pr_debug("waiting for data (in_len = %i) (circ: %i %i)\n",
 				inbound_len, bfin_jc_write_buf.tail, bfin_jc_write_buf.head);
 			if (inbound_len)
 				schedule();
@@ -99,11 +99,11 @@ bfin_jc_emudat_manager(void *arg)
 			if (tty != NULL) {
 				uint32_t emudat = bfin_read_emudat();
 				if (inbound_len == 0) {
-					debug("incoming length: 0x%08x\n", emudat);
+					pr_debug("incoming length: 0x%08x\n", emudat);
 					inbound_len = emudat;
 				} else {
 					size_t num_chars = (4 <= inbound_len ? 4 : inbound_len);
-					debug("  incoming data: 0x%08x (pushing %zu)\n", emudat, num_chars);
+					pr_debug("  incoming data: 0x%08x (pushing %zu)\n", emudat, num_chars);
 					inbound_len -= num_chars;
 					tty_insert_flip_string(tty, (unsigned char *)&emudat, num_chars);
 					tty_flip_buffer_push(tty);
@@ -117,7 +117,7 @@ bfin_jc_emudat_manager(void *arg)
 			if (outbound_len == 0) {
 				outbound_len = circ_cnt(&bfin_jc_write_buf);
 				bfin_write_emudat(outbound_len);
-				debug("outgoing length: 0x%08x\n", outbound_len);
+				pr_debug("outgoing length: 0x%08x\n", outbound_len);
 			} else {
 				struct tty_struct *tty;
 				int tail = bfin_jc_write_buf.tail;
@@ -136,7 +136,7 @@ bfin_jc_emudat_manager(void *arg)
 				if (tty)
 					tty_wakeup(tty);
 				mutex_unlock(&bfin_jc_tty_mutex);
-				debug("  outgoing data: 0x%08x (pushing %zu)\n", emudat, ate);
+				pr_debug("  outgoing data: 0x%08x (pushing %zu)\n", emudat, ate);
 			}
 		}
 	}
@@ -149,7 +149,7 @@ static int
 bfin_jc_open(struct tty_struct *tty, struct file *filp)
 {
 	mutex_lock(&bfin_jc_tty_mutex);
-	debug("open %lu\n", bfin_jc_count);
+	pr_debug("open %lu\n", bfin_jc_count);
 	++bfin_jc_count;
 	bfin_jc_tty = tty;
 	wake_up_process(bfin_jc_kthread);
@@ -161,7 +161,7 @@ static void
 bfin_jc_close(struct tty_struct *tty, struct file *filp)
 {
 	mutex_lock(&bfin_jc_tty_mutex);
-	debug("close %lu\n", bfin_jc_count);
+	pr_debug("close %lu\n", bfin_jc_count);
 	if (--bfin_jc_count == 0)
 		bfin_jc_tty = NULL;
 	wake_up_process(bfin_jc_kthread);
@@ -174,7 +174,7 @@ bfin_jc_circ_write(const unsigned char *buf, int count)
 {
 	int i;
 	count = min(count, circ_free(&bfin_jc_write_buf));
-	debug("going to write chunk of %i bytes\n", count);
+	pr_debug("going to write chunk of %i bytes\n", count);
 	for (i = 0; i < count; ++i)
 		circ_byte(&bfin_jc_write_buf, bfin_jc_write_buf.head + i) = buf[i];
 	bfin_jc_write_buf.head += i;
-- 
1.6.3.1

