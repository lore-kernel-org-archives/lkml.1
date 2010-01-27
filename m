Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814Ab0A0UsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0A0UsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526Ab0A0Uqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1528 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab0A0Uqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 04/13] drivers/block/floppy.c: Remove #define FLOPPY_SANITY_CHECK
Date: Wed, 27 Jan 2010 12:46:20 -0800
Message-Id: <7c32ae31b24b88e2fddbeb98977772f9beb8b60c.1264624291.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code could not be compiled without the #define, so just
remove it and the #ifdef/#endif lines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   35 +----------------------------------
 1 files changed, 1 insertions(+), 34 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 25d4693..f37193c 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -144,7 +144,6 @@
  * Better audit of register_blkdev.
  */
 
-#define FLOPPY_SANITY_CHECK
 #undef  FLOPPY_SILENT_DCL_CLEAR
 
 #define REALLY_SLOW_IO
@@ -633,7 +632,6 @@ static DEFINE_TIMER(fd_timeout, floppy_shutdown, 0, 0);
 
 static const char *timeout_message;
 
-#ifdef FLOPPY_SANITY_CHECK
 static void is_alive(const char *message)
 {
 	/* this routine checks whether the floppy driver is "alive" */
@@ -642,12 +640,9 @@ static void is_alive(const char *message)
 		DPRINT("timeout handler died: %s\n", message);
 	}
 }
-#endif
 
 static void (*do_floppy)(void) = NULL;
 
-#ifdef FLOPPY_SANITY_CHECK
-
 #define OLOGSIZE 20
 
 static void (*lasthandler)(void);
@@ -663,7 +658,6 @@ static struct output_log {
 } output_log[OLOGSIZE];
 
 static int output_log_pos;
-#endif
 
 #define current_reqD -1
 #define MAXTIMEOUT -2
@@ -733,7 +727,6 @@ static int disk_change(int drive)
 {
 	int fdc = FDC(drive);
 
-#ifdef FLOPPY_SANITY_CHECK
 	if (time_before(jiffies, UDRS->select_date + UDP->select_delay))
 		DPRINT("WARNING disk change called early\n");
 	if (!(FDCS->dor & (0x10 << UNIT(drive))) ||
@@ -742,7 +735,6 @@ static int disk_change(int drive)
 		DPRINT("drive=%d fdc=%d dor=%x\n", drive, FDC(drive),
 		       (unsigned int)FDCS->dor);
 	}
-#endif
 
 	debug_dcl(UDP->flags,
 		  "checking disk change line for drive %d\n", drive);
@@ -1095,7 +1087,6 @@ static void setup_DMA(void)
 {
 	unsigned long f;
 
-#ifdef FLOPPY_SANITY_CHECK
 	if (raw_cmd->length == 0) {
 		int i;
 
@@ -1113,7 +1104,6 @@ static void setup_DMA(void)
 		FDCS->reset = 1;
 		return;
 	}
-#endif
 	f = claim_dma_lock();
 	fd_disable_dma();
 #ifdef fd_dma_setup
@@ -1173,12 +1163,10 @@ static int output_byte(char byte)
 
 	if (is_ready_state(status)) {
 		fd_outb(byte, FD_DATA);
-#ifdef FLOPPY_SANITY_CHECK
 		output_log[output_log_pos].data = byte;
 		output_log[output_log_pos].status = status;
 		output_log[output_log_pos].jiffies = jiffies;
 		output_log_pos = (output_log_pos + 1) % OLOGSIZE;
-#endif
 		return 0;
 	}
 	FDCS->reset = 1;
@@ -1202,10 +1190,8 @@ static int result(void)
 			break;
 		status &= STATUS_DIR | STATUS_READY | STATUS_BUSY | STATUS_DMA;
 		if ((status & ~STATUS_BUSY) == STATUS_READY) {
-#ifdef FLOPPY_SANITY_CHECK
 			resultjiffies = jiffies;
 			resultsize = i;
-#endif
 			return i;
 		}
 		if (status == (STATUS_DIR | STATUS_READY | STATUS_BUSY))
@@ -1853,7 +1839,6 @@ static void show_floppy(void)
 		jiffies, interruptjiffies, jiffies - interruptjiffies,
 		lasthandler);
 
-#ifdef FLOPPY_SANITY_CHECK
 	pr_info("timeout_message=%s\n", timeout_message);
 	pr_info("last output bytes:\n");
 	for (i = 0; i < OLOGSIZE; i++)
@@ -1865,7 +1850,6 @@ static void show_floppy(void)
 	pr_info("last redo_fd_request at %lu\n", lastredo);
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1,
 		       reply_buffer, resultsize, true);
-#endif
 
 	pr_info("status=%x\n", fd_inb(FD_STATUS));
 	pr_info("fdc_busy=%lu\n", fdc_busy);
@@ -2381,7 +2365,6 @@ static void rw_interrupt(void)
 		       R_HEAD - HEAD) * SECT_PER_TRACK +
 		      R_SECTOR - SECTOR + eoc) << SIZECODE >> 2;
 
-#ifdef FLOPPY_SANITY_CHECK
 	if (nr_sectors / ssize >
 	    DIV_ROUND_UP(in_sector_offset + current_count_sectors, ssize)) {
 		DPRINT("long rw: %x instead of %lx\n",
@@ -2394,7 +2377,6 @@ static void rw_interrupt(void)
 			SECT_PER_TRACK, fsector_t, ssize);
 		pr_info("in_sector_offset=%d\n", in_sector_offset);
 	}
-#endif
 
 	nr_sectors -= in_sector_offset;
 	INFBOUND(nr_sectors, 0);
@@ -2499,7 +2481,6 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 					      blk_rq_sectors(current_req));
 
 	remaining = current_count_sectors << 9;
-#ifdef FLOPPY_SANITY_CHECK
 	if (remaining > blk_rq_bytes(current_req) && CT(COMMAND) == FD_WRITE) {
 		DPRINT("in copy buffer\n");
 		pr_info("current_count_sectors=%ld\n", current_count_sectors);
@@ -2511,7 +2492,6 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 		pr_info("max_sector=%d\n", max_sector);
 		pr_info("ssize=%d\n", ssize);
 	}
-#endif
 
 	buffer_max = max(max_sector, buffer_max);
 
@@ -2527,7 +2507,6 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 		SUPBOUND(size, remaining);
 
 		buffer = page_address(bv->bv_page) + bv->bv_offset;
-#ifdef FLOPPY_SANITY_CHECK
 		if (dma_buffer + size >
 		    floppy_track_buffer + (max_buffer_sectors << 10) ||
 		    dma_buffer < floppy_track_buffer) {
@@ -2545,7 +2524,7 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 		}
 		if (((unsigned long)buffer) % 512)
 			DPRINT("%p buffer not aligned\n", buffer);
-#endif
+
 		if (CT(COMMAND) == FD_READ)
 			memcpy(buffer, dma_buffer, size);
 		else
@@ -2554,13 +2533,11 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 		remaining -= size;
 		dma_buffer += size;
 	}
-#ifdef FLOPPY_SANITY_CHECK
 	if (remaining) {
 		if (remaining > 0)
 			max_sector -= remaining >> 9;
 		DPRINT("weirdness: remaining %d\n", remaining >> 9);
 	}
-#endif
 }
 
 /* work around a bug in pseudo DMA
@@ -2580,13 +2557,11 @@ static void virtualdmabug_workaround(void)
 
 		hard_sectors = raw_cmd->length >> (7 + SIZECODE);
 		end_sector = SECTOR + hard_sectors - 1;
-#ifdef FLOPPY_SANITY_CHECK
 		if (end_sector > SECT_PER_TRACK) {
 			pr_info("too many sectors %d > %d\n",
 				end_sector, SECT_PER_TRACK);
 			return;
 		}
-#endif
 		SECT_PER_TRACK = end_sector;
 					/* make sure SECT_PER_TRACK
 					 * points to end of transfer */
@@ -2805,10 +2780,8 @@ static int make_raw_rw_request(void)
 		 * if we get here, we know that the write
 		 * is either aligned or the data already in the buffer
 		 * (buffer will be overwritten) */
-#ifdef FLOPPY_SANITY_CHECK
 		if (in_sector_offset && buffer_track == -1)
 			DPRINT("internal error offset !=0 on write\n");
-#endif
 		buffer_track = raw_cmd->track;
 		buffer_drive = current_drive;
 		copy_buffer(ssize, max_sector,
@@ -2822,7 +2795,6 @@ static int make_raw_rw_request(void)
 	raw_cmd->length = in_sector_offset + current_count_sectors;
 	raw_cmd->length = ((raw_cmd->length - 1) | (ssize - 1)) + 1;
 	raw_cmd->length <<= 9;
-#ifdef FLOPPY_SANITY_CHECK
 	if ((raw_cmd->length < current_count_sectors << 9) ||
 	    (raw_cmd->kernel_data != current_req->buffer &&
 	     CT(COMMAND) == FD_WRITE &&
@@ -2879,7 +2851,6 @@ static int make_raw_rw_request(void)
 		DPRINT("zero dma transfer attempted from make_raw_request\n");
 		return 0;
 	}
-#endif
 
 	virtualdmabug_workaround();
 	return 2;
@@ -4526,11 +4497,9 @@ cleanup:
 static void floppy_release_irq_and_dma(void)
 {
 	int old_fdc;
-#ifdef FLOPPY_SANITY_CHECK
 #ifndef __sparc__
 	int drive;
 #endif
-#endif
 	long tmpsize;
 	unsigned long tmpaddr;
 	unsigned long flags;
@@ -4561,7 +4530,6 @@ static void floppy_release_irq_and_dma(void)
 		buffer_min = buffer_max = -1;
 		fd_dma_mem_free(tmpaddr, tmpsize);
 	}
-#ifdef FLOPPY_SANITY_CHECK
 #ifndef __sparc__
 	for (drive = 0; drive < N_FDC * 4; drive++)
 		if (timer_pending(motor_off_timer + drive))
@@ -4574,7 +4542,6 @@ static void floppy_release_irq_and_dma(void)
 		pr_info("auxiliary floppy timer still active\n");
 	if (work_pending(&floppy_work))
 		pr_info("work still pending\n");
-#endif
 	old_fdc = fdc;
 	for (fdc = 0; fdc < N_FDC; fdc++)
 		if (FDCS->address != -1)
-- 
1.6.6.rc0.57.gad7a

