Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608Ab0AVE5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0AVE5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606Ab0AVE4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:56:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1353 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab0AVEw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/24] drivers/block/floppy.c: Hoist assigns from if()s, neatening
Date: Thu, 21 Jan 2010 20:52:36 -0800
Message-Id: <798ebc180693752df5c3dd2acc909d47992d5ea9.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move assigns above if()s
Remove unnecessary parentheses from returns
Use a temporary for a duplicated test

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   53 ++++++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index f8c69fa..461c99a 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1175,9 +1175,9 @@ static int wait_til_ready(void)
 /* sends a command byte to the fdc */
 static int output_byte(char byte)
 {
-	int status;
+	int status = wait_til_ready();
 
-	if ((status = wait_til_ready()) < 0)
+	if (status < 0)
 		return -1;
 	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY) {
 		fd_outb(byte, FD_DATA);
@@ -1207,7 +1207,8 @@ static int result(void)
 	int status = 0;
 
 	for (i = 0; i < MAX_REPLIES; i++) {
-		if ((status = wait_til_ready()) < 0)
+		status = wait_til_ready();
+		if (status < 0)
 			break;
 		status &= STATUS_DIR | STATUS_READY | STATUS_BUSY | STATUS_DMA;
 		if ((status & ~STATUS_BUSY) == STATUS_READY) {
@@ -1236,9 +1237,9 @@ static int result(void)
 /* does the fdc need more output? */
 static int need_more_output(void)
 {
-	int status;
+	int status = wait_til_ready();
 
-	if ((status = wait_til_ready()) < 0)
+	if (status < 0)
 		return -1;
 	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY)
 		return MORE_OUTPUT;
@@ -1414,8 +1415,8 @@ static int fdc_dtr(void)
 	 * Pause 5 msec to avoid trouble. (Needs to be 2 jiffies)
 	 */
 	FDCS->dtr = raw_cmd->rate & 3;
-	return (fd_wait_for_completion(jiffies + 2UL * HZ / 100,
-				       (timeout_fn) floppy_ready));
+	return fd_wait_for_completion(jiffies + 2UL * HZ / 100,
+				      (timeout_fn)floppy_ready);
 }				/* fdc_dtr */
 
 static void tell_sector(void)
@@ -1951,8 +1952,8 @@ static int start_motor(void (*function)(void))
 	set_dor(fdc, mask, data);
 
 	/* wait_for_completion also schedules reset if needed. */
-	return (fd_wait_for_completion(DRS->select_date + DP->select_delay,
-				       (timeout_fn) function));
+	return fd_wait_for_completion(DRS->select_date + DP->select_delay,
+				      (timeout_fn)function);
 }
 
 static void floppy_ready(void)
@@ -2729,8 +2730,10 @@ static int make_raw_rw_request(void)
 		}
 	} else if (in_sector_offset || blk_rq_sectors(current_req) < ssize) {
 		if (CT(COMMAND) == FD_WRITE) {
-			if (fsector_t + blk_rq_sectors(current_req) > ssize &&
-			    fsector_t + blk_rq_sectors(current_req) < ssize + ssize)
+			unsigned int sectors;
+
+			sectors = fsector_t + blk_rq_sectors(current_req);
+			if (sectors > ssize && sectors < ssize + ssize)
 				max_size = ssize + ssize;
 			else
 				max_size = ssize;
@@ -2751,9 +2754,8 @@ static int make_raw_rw_request(void)
 		 * on a 64 bit machine!
 		 */
 		max_size = buffer_chain_size();
-		dma_limit =
-		    (MAX_DMA_ADDRESS -
-		     ((unsigned long)current_req->buffer)) >> 9;
+		dma_limit = (MAX_DMA_ADDRESS -
+			     ((unsigned long)current_req->buffer)) >> 9;
 		if ((unsigned long)max_size > dma_limit)
 			max_size = dma_limit;
 		/* 64 kb boundaries */
@@ -2771,16 +2773,16 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < DP->max_errors.read_track && ((!probing
-		       || (DP->read_track & (1 << DRS->probed_format)))))) {
+		     *errors < DP->max_errors.read_track &&
+		     ((!probing ||
+		       (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = blk_rq_sectors(current_req);
 		} else {
 			raw_cmd->kernel_data = current_req->buffer;
 			raw_cmd->length = current_count_sectors << 9;
 			if (raw_cmd->length == 0) {
-				DPRINT
-				    ("zero dma transfer attempted from make_raw_request\n");
-				DPRINT("indirect=%d direct=%d fsector_t=%d",
+				DPRINT("zero dma transfer attempted from make_raw_request\n");
+				DPRINT("indirect=%d direct=%d fsector_t=%d\n",
 				       indirect, direct, fsector_t);
 				return 0;
 			}
@@ -2977,7 +2979,7 @@ static void process_fd_request(void)
 	schedule_bh(redo_fd_request);
 }
 
-static void do_fd_request(struct request_queue * q)
+static void do_fd_request(struct request_queue *q)
 {
 	if (max_buffer_sectors == 0) {
 		pr_info("VFS: do_fd_request called on non-open device\n");
@@ -3937,7 +3939,8 @@ static char __init get_fdc_version(void)
 	output_byte(FD_DUMPREGS);	/* 82072 and better know DUMPREGS */
 	if (FDCS->reset)
 		return FDC_NONE;
-	if ((r = result()) <= 0x00)
+	r = result();
+	if (r <= 0x00)
 		return FDC_NONE;	/* No FDC present ??? */
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
 		pr_info("FDC %d is an 8272A\n", fdc);
@@ -3966,7 +3969,7 @@ static char __init get_fdc_version(void)
 	r = result();
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
 		pr_info("FDC %d is a pre-1991 82077\n", fdc);
-		return FDC_82077_ORIG;	/* Pre-1991 82077, doesn't know 
+		return FDC_82077_ORIG;	/* Pre-1991 82077, doesn't know
 					 * LOCK/UNLOCK */
 	}
 	if ((r != 1) || (reply_buffer[0] != 0x00)) {
@@ -4357,7 +4360,8 @@ static int __init floppy_init(void)
 		if (err)
 			goto out_flush_work;
 
-		err = device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		err = device_create_file(&floppy_device[drive].dev,
+					 &dev_attr_cmos);
 		if (err)
 			goto out_unreg_platform_dev;
 
@@ -4578,7 +4582,8 @@ static void __init parse_floppy_cfg_string(char *cfg)
 	char *ptr;
 
 	while (*cfg) {
-		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++) ;
+		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++)
+			;
 		if (*cfg) {
 			*cfg = '\0';
 			cfg++;
-- 
1.6.6.rc0.57.gad7a

