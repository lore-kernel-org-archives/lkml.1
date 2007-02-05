Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXBEX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXBEX1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbXBEX1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:27:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:43004 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965092AbXBEX13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:27:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=ExmB2U4Hsl2E6Bj6rKJoCak+AbEnS3CbKI/pMLHvAi/NVOBDfg1DamnFLb4CbbTfso49kKJul09VK0nCz79S+kjeImAXKK63u6QE43h2wQkQi8HsSDddK7921NbZLxmu37iTNKH3h4cFu3/zukU6FDev3R5UD2RM+Vx8/QvHq8U=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][4/5] floppy.c: Add explicit/better printk() levels
Date: Tue, 6 Feb 2007 00:29:59 +0100
User-Agent: KMail/1.9.4
Cc: Andi Kleen <ak@suse.de>, Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702060029.59798.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There are lots of printk() statements in floppy.c - more or less all of 
them without explicit message levels.
Since a lot of these levels (IMHO) are not warnings, but of a more 
informational nature, this patch adds explicit levels to most of the 
printk()'s and modifies some of them to not be KERN_WARNING.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.c |  119 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 64 insertions(+), 55 deletions(-)

--- linux-2.6.20/drivers/block/floppy.c.patch3	2007-02-05 23:19:49.000000000 +0100
+++ linux-2.6.20/drivers/block/floppy.c	2007-02-05 23:21:20.000000000 +0100
@@ -276,7 +276,7 @@
 		return;	/* we have the memory */
 	if (can_use_virtual_dma != 2)
 		return;	/* no fallback allowed */
-	printk("DMA memory shortage. "
+	printk(KERN_WARNING "DMA memory shortage. "
 		"Temporarily falling back on virtual DMA\n");
 	*addr = (char *)nodma_mem_alloc(l);
 #else
@@ -621,7 +621,7 @@
 static inline void debugt(const char *message)
 {
 	if (DP->flags & DEBUGT)
-		printk("%s dtime=%lu\n", message, jiffies - debugtimer);
+		printk(KERN_DEBUG "%s dtime=%lu\n", message, jiffies - debugtimer);
 }
 #else
 static inline void set_debugt(void) { }
@@ -851,7 +851,7 @@
 		current_drive = drive;
 	}
 	if (fdc != 1 && fdc != 0) {
-		printk("bad fdc value\n");
+		printk(KERN_WARNING "bad fdc value\n");
 		return;
 	}
 	set_dor(fdc, ~0, 8);
@@ -1102,7 +1102,7 @@
 	if (raw_cmd->length == 0) {
 		int i;
 
-		printk("zero dma transfer size:");
+		printk(KERN_WARNING "zero dma transfer size:");
 		for (i = 0; i < raw_cmd->cmd_count; i++)
 			printk("%x,", raw_cmd->cmd[i]);
 		printk("\n");
@@ -1111,7 +1111,7 @@
 		return;
 	}
 	if (((unsigned long)raw_cmd->kernel_data) % 512) {
-		printk("non aligned address: %p\n", raw_cmd->kernel_data);
+		printk(KERN_WARNING "non aligned address: %p\n", raw_cmd->kernel_data);
 		cont->done(0);
 		FDCS->reset = 1;
 		return;
@@ -1409,7 +1409,7 @@
 
 static void tell_sector(void)
 {
-	printk(": track %d, head %d, sector %d, size %d",
+	printk(KERN_NOTICE ": track %d, head %d, sector %d, size %d",
 	       R_TRACK, R_HEAD, R_SECTOR, R_SIZECODE);
 }				/* tell_sector */
 
@@ -1474,7 +1474,6 @@
 				tell_sector();
 			}
 			printk("\n");
-
 		}
 		if (ST2 & ST2_WC || ST2 & ST2_BC)
 			/* wrong cylinder => recal */
@@ -1745,9 +1744,9 @@
 	do_floppy = NULL;
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
-		printk("DOR0=%x\n", fdc_state[0].dor);
-		printk("floppy interrupt on bizarre fdc %d\n", fdc);
-		printk("handler=%p\n", handler);
+		printk(KERN_WARNING "DOR0=%x\n", fdc_state[0].dor);
+		printk(KERN_WARNING "floppy interrupt on bizarre fdc %d\n", fdc);
+		printk(KERN_WARNING "handler=%p\n", handler);
 		is_alive("bizarre fdc");
 		return IRQ_NONE;
 	}
@@ -1844,45 +1843,47 @@
 	int i;
 
 	printk("\n");
-	printk("floppy driver state\n");
-	printk("-------------------\n");
-	printk("now=%lu last interrupt=%lu diff=%lu last called handler=%p\n",
-	       jiffies, interruptjiffies, jiffies - interruptjiffies,
-	       lasthandler);
+	printk(KERN_INFO "floppy driver state\n");
+	printk(KERN_INFO "-------------------\n");
+	printk(KERN_INFO "now=%lu last interrupt=%lu diff=%lu "
+		"last called handler=%p\n",
+		jiffies, interruptjiffies, jiffies - interruptjiffies,
+		lasthandler);
 
 #ifdef FLOPPY_SANITY_CHECK
-	printk("timeout_message=%s\n", timeout_message);
-	printk("last output bytes:\n");
+	printk(KERN_INFO "timeout_message=%s\n", timeout_message);
+	printk(KERN_INFO "last output bytes:\n");
 	for (i = 0; i < OLOGSIZE; i++)
 		printk("%2x %2x %lu\n",
 		       output_log[(i + output_log_pos) % OLOGSIZE].data,
 		       output_log[(i + output_log_pos) % OLOGSIZE].status,
 		       output_log[(i + output_log_pos) % OLOGSIZE].jiffies);
-	printk("last result at %lu\n", resultjiffies);
-	printk("last redo_fd_request at %lu\n", lastredo);
+	printk(KERN_INFO "last result at %lu\n", resultjiffies);
+	printk(KERN_INFO "last redo_fd_request at %lu\n", lastredo);
+	printk(KERN_INFO " ");
 	for (i = 0; i < resultsize; i++) {
 		printk("%2x ", reply_buffer[i]);
 	}
-	printk("\n");
+	printk(KERN_INFO "\n");
 #endif
 
-	printk("status=%x\n", fd_inb(FD_STATUS));
-	printk("fdc_busy=%lu\n", fdc_busy);
+	printk(KERN_INFO "status=%x\n", fd_inb(FD_STATUS));
+	printk(KERN_INFO "fdc_busy=%lu\n", fdc_busy);
 	if (do_floppy)
-		printk("do_floppy=%p\n", do_floppy);
+		printk(KERN_INFO "do_floppy=%p\n", do_floppy);
 	if (work_pending(&floppy_work))
-		printk("floppy_work.func=%p\n", floppy_work.func);
+		printk(KERN_INFO "floppy_work.func=%p\n", floppy_work.func);
 	if (timer_pending(&fd_timer))
-		printk("fd_timer.function=%p\n", fd_timer.function);
+		printk(KERN_INFO "fd_timer.function=%p\n", fd_timer.function);
 	if (timer_pending(&fd_timeout)) {
-		printk("timer_function=%p\n", fd_timeout.function);
-		printk("expires=%lu\n", fd_timeout.expires - jiffies);
-		printk("now=%lu\n", jiffies);
-	}
-	printk("cont=%p\n", cont);
-	printk("current_req=%p\n", current_req);
-	printk("command_status=%d\n", command_status);
-	printk("\n");
+		printk(KERN_INFO "timer_function=%p\n", fd_timeout.function);
+		printk(KERN_INFO "expires=%lu\n", fd_timeout.expires - jiffies);
+		printk(KERN_INFO "now=%lu\n", jiffies);
+	}
+	printk(KERN_INFO "cont=%p\n", cont);
+	printk(KERN_INFO "current_req=%p\n", current_req);
+	printk(KERN_INFO "command_status=%d\n", command_status);
+	printk(KERN_INFO "\n");
 }
 
 static void floppy_shutdown(unsigned long data)
@@ -2309,7 +2310,7 @@
 	reschedule_timeout(MAXTIMEOUT, "request done %d", uptodate);
 
 	if (!req) {
-		printk("floppy.c: no request in request_done\n");
+		printk(KERN_INFO "floppy.c: no request in request_done\n");
 		return;
 	}
 
@@ -2577,7 +2578,7 @@
 		end_sector = SECTOR + hard_sectors - 1;
 #ifdef FLOPPY_SANITY_CHECK
 		if (end_sector > SECT_PER_TRACK) {
-			printk("too many sectors %d > %d\n",
+			printk(KERN_WARNING "too many sectors %d > %d\n",
 				end_sector, SECT_PER_TRACK);
 			return;
 		}
@@ -2602,7 +2603,8 @@
 	int max_sector, max_size, tracksize, ssize;
 
 	if (max_buffer_sectors == 0) {
-		printk("VFS: Block I/O scheduled on unopened device\n");
+		printk(KERN_WARNING 
+			"VFS: Block I/O scheduled on unopened device\n");
 		return 0;
 	}
 
@@ -2958,15 +2960,18 @@
 static void do_fd_request(request_queue_t *q)
 {
 	if (max_buffer_sectors == 0) {
-		printk("VFS: do_fd_request called on non-open device\n");
+		printk(KERN_WARNING 
+			"VFS: do_fd_request called on non-open device\n");
 		return;
 	}
 
 	if (usage_count == 0) {
-		printk("warning: usage count=0, current_req=%p exiting\n",
-		       current_req);
-		printk("sect=%ld type=%x flags=%x\n", (long)current_req->sector,
-		       current_req->cmd_type, current_req->cmd_flags);
+		printk(KERN_WARNING 
+			"warning: usage count=0, current_req=%p exiting\n",
+			current_req);
+		printk(KERN_WARNING "sect=%ld type=%x flags=%x\n",
+			(long)current_req->sector,
+			current_req->cmd_type, current_req->cmd_flags);
 		return;
 	}
 	if (test_bit(0, &fdc_busy)) {
@@ -3013,7 +3018,7 @@
  */
 static void reset_intr(void)
 {
-	printk("weird, reset interrupt called\n");
+	printk(KERN_WARNING "floppy.c : weird, reset interrupt called\n");
 }
 
 static struct cont_t reset_cont = {
@@ -3385,7 +3390,7 @@
 			*size = _IOC_SIZE(*cmd);
 			*cmd = ioctl_table[i];
 			if (*size > _IOC_SIZE(*cmd)) {
-				printk("ioctl not yet supported\n");
+				printk(KERN_NOTICE "ioctl not yet supported\n");
 				return -EFAULT;
 			}
 			return 0;
@@ -3844,7 +3849,8 @@
 	if (UTESTF(FD_DISK_CHANGED) ||
 	    UTESTF(FD_VERIFY) || test_bit(drive, &fake_change) || NO_GEOM) {
 		if (usage_count == 0) {
-			printk("VFS: revalidate called on non-open device.\n");
+			printk(KERN_WARNING "VFS: revalidate called on "
+				"non-open device.\n");
 			return -EFAULT;
 		}
 		lock_fdc(drive, 0);
@@ -3905,9 +3911,9 @@
 		return FDC_8272A;	/* 8272a/765 don't know DUMPREGS */
 	}
 	if (r != 10) {
-		printk
-		    ("FDC %d init: DUMPREGS: unexpected return of %d bytes.\n",
-		     fdc, r);
+		printk(KERN_WARNING 
+			"FDC %d init: DUMPREGS: unexpected return of %d bytes."
+			"\n", fdc, r);
 		return FDC_UNKNOWN;
 	}
 
@@ -3932,15 +3938,16 @@
 					 * LOCK/UNLOCK */
 	}
 	if ((r != 1) || (reply_buffer[0] != 0x00)) {
-		printk("FDC %d init: UNLOCK: unexpected return of %d bytes.\n",
-		       fdc, r);
+		printk(KERN_WARNING 
+			"FDC %d init: UNLOCK: unexpected return of %d bytes."
+			"\n", fdc, r);
 		return FDC_UNKNOWN;
 	}
 	output_byte(FD_PARTID);
 	r = result();
 	if (r != 1) {
-		printk("FDC %d init: PARTID: unexpected return of %d bytes.\n",
-		       fdc, r);
+		printk(KERN_WARNING "FDC %d init: PARTID: unexpected return "
+			"of %d bytes.\n", fdc, r);
 		return FDC_UNKNOWN;
 	}
 	if (reply_buffer[0] == 0x80) {
@@ -4452,15 +4459,17 @@
 #ifndef __sparc__
 	for (drive = 0; drive < N_FDC * 4; drive++)
 		if (timer_pending(motor_off_timer + drive))
-			printk("motor off timer %d still active\n", drive);
+			printk(KERN_WARNING  "motor off timer %d still "
+				"active\n", drive);
 #endif
 
 	if (timer_pending(&fd_timeout))
-		printk("floppy timer still active:%s\n", timeout_message);
+		printk(KERN_WARNING  "floppy timer still active:%s\n",
+			timeout_message);
 	if (timer_pending(&fd_timer))
-		printk("auxiliary floppy timer still active\n");
+		printk(KERN_WARNING "auxiliary floppy timer still active\n");
 	if (work_pending(&floppy_work))
-		printk("work still pending\n");
+		printk(KERN_WARNING "work still pending\n");
 #endif
 	old_fdc = fdc;
 	for (fdc = 0; fdc < N_FDC; fdc++)



