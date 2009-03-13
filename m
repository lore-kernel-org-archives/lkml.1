Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZCMFJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZCMFJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbZCMFG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:06:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:45022 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264AbZCMFGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:06:53 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
       =?utf-8?q?J=C3=B6rg=20Dorchain?= <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: [PATCH 12/14] block: kill end_request()
Date: Fri, 13 Mar 2009 14:02:56 +0900
Message-Id: <1236920578-2179-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236920578-2179-1-git-send-email-tj@kernel.org>
References: <1236920578-2179-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:03:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: kill obsolete interface function

end_request() has been kept around for backward compatibility;
however, it seems to be about time for it to go away.

* There aren't too many users left.

* Its use of @updtodate is pretty confusing.

* In some cases, newer code ends up using mixture of end_request() and
  [__]blk_end_request[_all](), which is way too confusing.

So, kill it.

Most conversions are straightforward.  Noteworthy ones are...

* paride/pcd: next_request() updated to take 0/-errno instead of 1/0.

* paride/pf: pf_end_request() and next_request() updated to take
  0/-errno instead of 1/0.

* xd: xd_readwrite() updated to return 0/-errno instead of 1/0.

* mtd/mtd_blkdevs: blktrans_discard_request() updated to return
  0/-errno instead of 1/0.  Unnecessary local variable res
  initialization removed from mtd_blktrans_thread().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jörg Dorchain <joerg@dorchain.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tim Waugh <tim@cyberelk.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
---
 drivers/block/amiflop.c         |   10 +++++-----
 drivers/block/ataflop.c         |   14 +++++++-------
 drivers/block/hd.c              |   14 +++++++-------
 drivers/block/paride/pcd.c      |   12 ++++++------
 drivers/block/paride/pd.c       |    5 +++--
 drivers/block/paride/pf.c       |   28 ++++++++++++++--------------
 drivers/block/ps3disk.c         |    6 +++---
 drivers/block/swim3.c           |   26 +++++++++++++-------------
 drivers/block/xd.c              |   15 ++++++++-------
 drivers/block/xen-blkfront.c    |    2 +-
 drivers/block/xsysace.c         |    4 ++--
 drivers/block/z2ram.c           |    4 ++--
 drivers/cdrom/gdrom.c           |    6 +++---
 drivers/message/i2o/i2o_block.c |    2 +-
 drivers/mtd/mtd_blkdevs.c       |   22 +++++++++++-----------
 drivers/sbus/char/jsflash.c     |    8 ++++----
 include/linux/blkdev.h          |   31 ++-----------------------------
 17 files changed, 92 insertions(+), 117 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 8df436f..163750e 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1359,7 +1359,7 @@ static void redo_fd_request(void)
 #endif
 		block = CURRENT->sector + cnt;
 		if ((int)block > floppy->blocks) {
-			end_request(CURRENT, 0);
+			__blk_end_request_all(CURRENT, -EIO);
 			goto repeat;
 		}
 
@@ -1373,11 +1373,11 @@ static void redo_fd_request(void)
 
 		if ((rq_data_dir(CURRENT) != READ) && (rq_data_dir(CURRENT) != WRITE)) {
 			printk(KERN_WARNING "do_fd_request: unknown command\n");
-			end_request(CURRENT, 0);
+			__blk_end_request_all(CURRENT, -EIO);
 			goto repeat;
 		}
 		if (get_track(drive, track) == -1) {
-			end_request(CURRENT, 0);
+			__blk_end_request_all(CURRENT, -EIO);
 			goto repeat;
 		}
 
@@ -1391,7 +1391,7 @@ static void redo_fd_request(void)
 
 			/* keep the drive spinning while writes are scheduled */
 			if (!fd_motor_on(drive)) {
-				end_request(CURRENT, 0);
+				__blk_end_request_all(CURRENT, -EIO);
 				goto repeat;
 			}
 			/*
@@ -1410,7 +1410,7 @@ static void redo_fd_request(void)
 	CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
 	CURRENT->sector += CURRENT->current_nr_sectors;
 
-	end_request(CURRENT, 1);
+	__blk_end_request_all(CURRENT, 0);
 	goto repeat;
 }
 
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 4234c11..c9844f0 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -612,7 +612,7 @@ static void fd_error( void )
 	CURRENT->errors++;
 	if (CURRENT->errors >= MAX_ERRORS) {
 		printk(KERN_ERR "fd%d: too many errors.\n", SelectedDrive );
-		end_request(CURRENT, 0);
+		__blk_end_request_all(CURRENT, -EIO);
 	}
 	else if (CURRENT->errors == RECALIBRATE_ERRORS) {
 		printk(KERN_WARNING "fd%d: recalibrating\n", SelectedDrive );
@@ -734,7 +734,7 @@ static void do_fd_action( int drive )
 			/* all sectors finished */
 			CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
 			CURRENT->sector += CURRENT->current_nr_sectors;
-			end_request(CURRENT, 1);
+			__blk_end_request_all(CURRENT, 0);
 			redo_fd_request();
 			return;
 		    }
@@ -1141,7 +1141,7 @@ static void fd_rwsec_done1(int status)
 		/* all sectors finished */
 		CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
 		CURRENT->sector += CURRENT->current_nr_sectors;
-		end_request(CURRENT, 1);
+		__blk_end_request_all(CURRENT, 0);
 		redo_fd_request();
 	}
 	return;
@@ -1414,7 +1414,7 @@ repeat:
 	if (!UD.connected) {
 		/* drive not connected */
 		printk(KERN_ERR "Unknown Device: fd%d\n", drive );
-		end_request(CURRENT, 0);
+		__blk_end_request_all(CURRENT, -EIO);
 		goto repeat;
 	}
 		
@@ -1430,12 +1430,12 @@ repeat:
 		/* user supplied disk type */
 		if (--type >= NUM_DISK_MINORS) {
 			printk(KERN_WARNING "fd%d: invalid disk format", drive );
-			end_request(CURRENT, 0);
+			__blk_end_request_all(CURRENT, -EIO);
 			goto repeat;
 		}
 		if (minor2disktype[type].drive_types > DriveType)  {
 			printk(KERN_WARNING "fd%d: unsupported disk format", drive );
-			end_request(CURRENT, 0);
+			__blk_end_request_all(CURRENT, -EIO);
 			goto repeat;
 		}
 		type = minor2disktype[type].index;
@@ -1445,7 +1445,7 @@ repeat:
 	}
 	
 	if (CURRENT->sector + 1 > UDT->blocks) {
-		end_request(CURRENT, 0);
+		__blk_end_request_all(CURRENT, -EIO);
 		goto repeat;
 	}
 
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 482c0c4..3fc066f 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -408,7 +408,7 @@ static void bad_rw_intr(void)
 	if (req != NULL) {
 		struct hd_i_struct *disk = req->rq_disk->private_data;
 		if (++req->errors >= MAX_ERRORS || (hd_error & BBD_ERR)) {
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			disk->special_op = disk->recalibrate = 1;
 		} else if (req->errors % RESET_FREQ == 0)
 			reset = 1;
@@ -464,7 +464,7 @@ ok_to_read:
 		req->buffer+512);
 #endif
 	if (req->current_nr_sectors <= 0)
-		end_request(req, 1);
+		__blk_end_request_all(req, 0);
 	if (i > 0) {
 		SET_HANDLER(&read_intr);
 		return;
@@ -503,7 +503,7 @@ ok_to_write:
 	--req->current_nr_sectors;
 	req->buffer += 512;
 	if (!i || (req->bio && req->current_nr_sectors <= 0))
-		end_request(req, 1);
+		__blk_end_request_all(req, 0);
 	if (i > 0) {
 		SET_HANDLER(&write_intr);
 		outsw(HD_DATA, req->buffer, 256);
@@ -548,7 +548,7 @@ static void hd_times_out(unsigned long dummy)
 #ifdef DEBUG
 		printk("%s: too many errors\n", name);
 #endif
-		end_request(CURRENT, 0);
+		__blk_end_request_all(CURRENT, -EIO);
 	}
 	local_irq_disable();
 	hd_request();
@@ -564,7 +564,7 @@ static int do_special_op(struct hd_i_struct *disk, struct request *req)
 	}
 	if (disk->head > 16) {
 		printk("%s: cannot handle device with more than 16 heads - giving up\n", req->rq_disk->disk_name);
-		end_request(req, 0);
+		__blk_end_request_all(req, -EIO);
 	}
 	disk->special_op = 0;
 	return 1;
@@ -610,7 +610,7 @@ repeat:
 	    ((block+nsect) > get_capacity(req->rq_disk))) {
 		printk("%s: bad access: block=%d, count=%d\n",
 			req->rq_disk->disk_name, block, nsect);
-		end_request(req, 0);
+		__blk_end_request_all(req, -EIO);
 		goto repeat;
 	}
 
@@ -650,7 +650,7 @@ repeat:
 			break;
 		default:
 			printk("unknown hd-command\n");
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			break;
 		}
 	}
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index e91d4b4..0ee886c 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -735,16 +735,16 @@ static void do_pcd_request(struct request_queue * q)
 			ps_set_intr(do_pcd_read, NULL, 0, nice);
 			return;
 		} else
-			end_request(pcd_req, 0);
+			__blk_end_request_all(pcd_req, -EIO);
 	}
 }
 
-static inline void next_request(int success)
+static inline void next_request(int err)
 {
 	unsigned long saved_flags;
 
 	spin_lock_irqsave(&pcd_lock, saved_flags);
-	end_request(pcd_req, success);
+	__blk_end_request_all(pcd_req, err);
 	pcd_busy = 0;
 	do_pcd_request(pcd_queue);
 	spin_unlock_irqrestore(&pcd_lock, saved_flags);
@@ -781,7 +781,7 @@ static void pcd_start(void)
 
 	if (pcd_command(pcd_current, rd_cmd, 2048, "read block")) {
 		pcd_bufblk = -1;
-		next_request(0);
+		next_request(-EIO);
 		return;
 	}
 
@@ -796,7 +796,7 @@ static void do_pcd_read(void)
 	pcd_retries = 0;
 	pcd_transfer();
 	if (!pcd_count) {
-		next_request(1);
+		next_request(0);
 		return;
 	}
 
@@ -815,7 +815,7 @@ static void do_pcd_read_drq(void)
 			return;
 		}
 		pcd_bufblk = -1;
-		next_request(0);
+		next_request(-EIO);
 		return;
 	}
 
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 9299455..1b8f001 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -410,7 +410,8 @@ static void run_fsm(void)
 				pd_claimed = 0;
 				phase = NULL;
 				spin_lock_irqsave(&pd_lock, saved_flags);
-				end_request(pd_req, res);
+				__blk_end_request_all(pd_req,
+						      res == Ok ? 0 : -EIO);
 				pd_req = elv_next_request(pd_queue);
 				if (!pd_req)
 					stop = 1;
@@ -477,7 +478,7 @@ static int pd_next_buf(void)
 	if (pd_count)
 		return 0;
 	spin_lock_irqsave(&pd_lock, saved_flags);
-	end_request(pd_req, 1);
+	__blk_end_request_all(pd_req, 0);
 	pd_count = pd_req->current_nr_sectors;
 	pd_buf = pd_req->buffer;
 	spin_unlock_irqrestore(&pd_lock, saved_flags);
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index bef3b99..bb51218 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -750,10 +750,10 @@ static int pf_ready(void)
 
 static struct request_queue *pf_queue;
 
-static void pf_end_request(int uptodate)
+static void pf_end_request(int err)
 {
 	if (pf_req) {
-		end_request(pf_req, uptodate);
+		__blk_end_request_all(pf_req, err);
 		pf_req = NULL;
 	}
 }
@@ -773,7 +773,7 @@ repeat:
 	pf_count = pf_req->current_nr_sectors;
 
 	if (pf_block + pf_count > get_capacity(pf_req->rq_disk)) {
-		pf_end_request(0);
+		pf_end_request(-EIO);
 		goto repeat;
 	}
 
@@ -788,7 +788,7 @@ repeat:
 		pi_do_claimed(pf_current->pi, do_pf_write);
 	else {
 		pf_busy = 0;
-		pf_end_request(0);
+		pf_end_request(-EIO);
 		goto repeat;
 	}
 }
@@ -805,7 +805,7 @@ static int pf_next_buf(void)
 		return 1;
 	if (!pf_count) {
 		spin_lock_irqsave(&pf_spin_lock, saved_flags);
-		pf_end_request(1);
+		pf_end_request(0);
 		pf_req = elv_next_request(pf_queue);
 		spin_unlock_irqrestore(&pf_spin_lock, saved_flags);
 		if (!pf_req)
@@ -816,12 +816,12 @@ static int pf_next_buf(void)
 	return 0;
 }
 
-static inline void next_request(int success)
+static inline void next_request(int err)
 {
 	unsigned long saved_flags;
 
 	spin_lock_irqsave(&pf_spin_lock, saved_flags);
-	pf_end_request(success);
+	pf_end_request(err);
 	pf_busy = 0;
 	do_pf_request(pf_queue);
 	spin_unlock_irqrestore(&pf_spin_lock, saved_flags);
@@ -844,7 +844,7 @@ static void do_pf_read_start(void)
 			pi_do_claimed(pf_current->pi, do_pf_read_start);
 			return;
 		}
-		next_request(0);
+		next_request(-EIO);
 		return;
 	}
 	pf_mask = STAT_DRQ;
@@ -863,7 +863,7 @@ static void do_pf_read_drq(void)
 				pi_do_claimed(pf_current->pi, do_pf_read_start);
 				return;
 			}
-			next_request(0);
+			next_request(-EIO);
 			return;
 		}
 		pi_read_block(pf_current->pi, pf_buf, 512);
@@ -871,7 +871,7 @@ static void do_pf_read_drq(void)
 			break;
 	}
 	pi_disconnect(pf_current->pi);
-	next_request(1);
+	next_request(0);
 }
 
 static void do_pf_write(void)
@@ -890,7 +890,7 @@ static void do_pf_write_start(void)
 			pi_do_claimed(pf_current->pi, do_pf_write_start);
 			return;
 		}
-		next_request(0);
+		next_request(-EIO);
 		return;
 	}
 
@@ -903,7 +903,7 @@ static void do_pf_write_start(void)
 				pi_do_claimed(pf_current->pi, do_pf_write_start);
 				return;
 			}
-			next_request(0);
+			next_request(-EIO);
 			return;
 		}
 		pi_write_block(pf_current->pi, pf_buf, 512);
@@ -923,11 +923,11 @@ static void do_pf_write_done(void)
 			pi_do_claimed(pf_current->pi, do_pf_write_start);
 			return;
 		}
-		next_request(0);
+		next_request(-EIO);
 		return;
 	}
 	pi_disconnect(pf_current->pi);
-	next_request(1);
+	next_request(0);
 }
 
 static int __init pf_init(void)
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index bccc42b..896d0d1 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -158,7 +158,7 @@ static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
 	if (res) {
 		dev_err(&dev->sbd.core, "%s:%u: %s failed %d\n", __func__,
 			__LINE__, op, res);
-		end_request(req, 0);
+		__blk_end_request_all(req, -EIO);
 		return 0;
 	}
 
@@ -180,7 +180,7 @@ static int ps3disk_submit_flush_request(struct ps3_storage_device *dev,
 	if (res) {
 		dev_err(&dev->sbd.core, "%s:%u: sync cache failed 0x%llx\n",
 			__func__, __LINE__, res);
-		end_request(req, 0);
+		__blk_end_request_all(req, -EIO);
 		return 0;
 	}
 
@@ -205,7 +205,7 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 				break;
 		} else {
 			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 	}
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 6129653..f661057 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -320,15 +320,15 @@ static void start_request(struct floppy_state *fs)
 #endif
 
 		if (req->sector < 0 || req->sector >= fs->total_secs) {
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 		if (req->current_nr_sectors == 0) {
-			end_request(req, 1);
+			__blk_end_request_all(req, 0);
 			continue;
 		}
 		if (fs->ejected) {
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 
@@ -336,7 +336,7 @@ static void start_request(struct floppy_state *fs)
 			if (fs->write_prot < 0)
 				fs->write_prot = swim3_readbit(fs, WRITE_PROT);
 			if (fs->write_prot) {
-				end_request(req, 0);
+				__blk_end_request_all(req, -EIO);
 				continue;
 			}
 		}
@@ -508,7 +508,7 @@ static void act(struct floppy_state *fs)
 		case do_transfer:
 			if (fs->cur_cyl != fs->req_cyl) {
 				if (fs->retries > 5) {
-					end_request(fd_req, 0);
+					__blk_end_request_all(fd_req, -EIO);
 					fs->state = idle;
 					return;
 				}
@@ -540,7 +540,7 @@ static void scan_timeout(unsigned long data)
 	out_8(&sw->intr_enable, 0);
 	fs->cur_cyl = -1;
 	if (fs->retries > 5) {
-		end_request(fd_req, 0);
+		__blk_end_request_all(fd_req, -EIO);
 		fs->state = idle;
 		start_request(fs);
 	} else {
@@ -559,7 +559,7 @@ static void seek_timeout(unsigned long data)
 	out_8(&sw->select, RELAX);
 	out_8(&sw->intr_enable, 0);
 	printk(KERN_ERR "swim3: seek timeout\n");
-	end_request(fd_req, 0);
+	__blk_end_request_all(fd_req, -EIO);
 	fs->state = idle;
 	start_request(fs);
 }
@@ -583,7 +583,7 @@ static void settle_timeout(unsigned long data)
 		return;
 	}
 	printk(KERN_ERR "swim3: seek settle timeout\n");
-	end_request(fd_req, 0);
+	__blk_end_request_all(fd_req, -EIO);
 	fs->state = idle;
 	start_request(fs);
 }
@@ -615,7 +615,7 @@ static void xfer_timeout(unsigned long data)
 	fd_req->current_nr_sectors -= s;
 	printk(KERN_ERR "swim3: timeout %sing sector %ld\n",
 	       (rq_data_dir(fd_req)==WRITE? "writ": "read"), (long)fd_req->sector);
-	end_request(fd_req, 0);
+	__blk_end_request_all(fd_req, -EIO);
 	fs->state = idle;
 	start_request(fs);
 }
@@ -646,7 +646,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				printk(KERN_ERR "swim3: seen sector but cyl=ff?\n");
 				fs->cur_cyl = -1;
 				if (fs->retries > 5) {
-					end_request(fd_req, 0);
+					__blk_end_request_all(fd_req, -EIO);
 					fs->state = idle;
 					start_request(fs);
 				} else {
@@ -731,7 +731,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				printk("swim3: error %sing block %ld (err=%x)\n",
 				       rq_data_dir(fd_req) == WRITE? "writ": "read",
 				       (long)fd_req->sector, err);
-				end_request(fd_req, 0);
+				__blk_end_request_all(fd_req, -EIO);
 				fs->state = idle;
 			}
 		} else {
@@ -740,7 +740,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				printk(KERN_ERR "swim3: fd dma: stat=%x resid=%d\n", stat, resid);
 				printk(KERN_ERR "  state=%d, dir=%x, intr=%x, err=%x\n",
 				       fs->state, rq_data_dir(fd_req), intr, err);
-				end_request(fd_req, 0);
+				__blk_end_request_all(fd_req, -EIO);
 				fs->state = idle;
 				start_request(fs);
 				break;
@@ -749,7 +749,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 			fd_req->current_nr_sectors -= fs->scount;
 			fd_req->buffer += fs->scount * 512;
 			if (fd_req->current_nr_sectors <= 0) {
-				end_request(fd_req, 1);
+				__blk_end_request_all(fd_req, 0);
 				fs->state = idle;
 			} else {
 				fs->req_sector += fs->scount;
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 64b496f..291ddc3 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -314,21 +314,22 @@ static void do_xd_request (struct request_queue * q)
 		int retry;
 
 		if (!blk_fs_request(req)) {
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 		if (block + count > get_capacity(req->rq_disk)) {
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 		if (rw != READ && rw != WRITE) {
 			printk("do_xd_request: unknown request\n");
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 		for (retry = 0; (retry < XD_RETRIES) && !res; retry++)
 			res = xd_readwrite(rw, disk, req->buffer, block, count);
-		end_request(req, res);	/* wrap up, 0 = fail, 1 = success */
+		/* wrap up, 0 = success, -errno = fail */
+		__blk_end_request_all(req, res);
 	}
 }
 
@@ -418,7 +419,7 @@ static int xd_readwrite (u_char operation,XD_INFO *p,char *buffer,u_int block,u_
 				printk("xd%c: %s timeout, recalibrating drive\n",'a'+drive,(operation == READ ? "read" : "write"));
 				xd_recalibrate(drive);
 				spin_lock_irq(&xd_lock);
-				return (0);
+				return -EIO;
 			case 2:
 				if (sense[0] & 0x30) {
 					printk("xd%c: %s - ",'a'+drive,(operation == READ ? "reading" : "writing"));
@@ -439,7 +440,7 @@ static int xd_readwrite (u_char operation,XD_INFO *p,char *buffer,u_int block,u_
 				else
 					printk(" - no valid disk address\n");
 				spin_lock_irq(&xd_lock);
-				return (0);
+				return -EIO;
 		}
 		if (xd_dma_buffer)
 			for (i=0; i < (temp * 0x200); i++)
@@ -448,7 +449,7 @@ static int xd_readwrite (u_char operation,XD_INFO *p,char *buffer,u_int block,u_
 		count -= temp, buffer += temp * 0x200, block += temp;
 	}
 	spin_lock_irq(&xd_lock);
-	return (1);
+	return 0;
 }
 
 /* xd_recalibrate: recalibrate a given drive and reset controller if necessary */
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index cd6cfe3..01efaaa 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -302,7 +302,7 @@ static void do_blkif_request(struct request_queue *rq)
 	while ((req = elv_next_request(rq)) != NULL) {
 		info = req->rq_disk->private_data;
 		if (!blk_fs_request(req)) {
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 119be34..d6a3da9 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -472,7 +472,7 @@ struct request *ace_get_next_request(struct request_queue * q)
 	while ((req = elv_next_request(q)) != NULL) {
 		if (blk_fs_request(req))
 			break;
-		end_request(req, 0);
+		__blk_end_request_all(req, -EIO);
 	}
 	return req;
 }
@@ -500,7 +500,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 
 		/* Drop all pending requests */
 		while ((req = elv_next_request(ace->queue)) != NULL)
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 
 		/* Drop back to IDLE state and notify waiters */
 		ace->fsm_state = ACE_FSM_STATE_IDLE;
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 80754cd..4172f2c 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -77,7 +77,7 @@ static void do_z2_request(struct request_queue *q)
 		if (start + len > z2ram_size) {
 			printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, count=%u\n",
 				req->sector, req->current_nr_sectors);
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 		while (len) {
@@ -93,7 +93,7 @@ static void do_z2_request(struct request_queue *q)
 			start += size;
 			len -= size;
 		}
-		end_request(req, 1);
+		__blk_end_request_all(req, 0);
 	}
 }
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index fee9a9e..c782778 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -654,17 +654,17 @@ static void gdrom_request(struct request_queue *rq)
 	while ((req = elv_next_request(rq)) != NULL) {
 		if (!blk_fs_request(req)) {
 			printk(KERN_DEBUG "GDROM: Non-fs request ignored\n");
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 		}
 		if (rq_data_dir(req) != READ) {
 			printk(KERN_NOTICE "GDROM: Read only device -");
 			printk(" write request ignored\n");
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 		}
 		if (req->nr_sectors)
 			gdrom_request_handler_dma(req);
 		else
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 	}
 }
 
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index a443e13..3b03eef 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -923,7 +923,7 @@ static void i2o_block_request_fn(struct request_queue *q)
 				break;
 			}
 		} else
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 	}
 };
 
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 1409f01..461b4a8 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -54,33 +54,33 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 
 	if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
 	    req->cmd[0] == REQ_LB_OP_DISCARD)
-		return !tr->discard(dev, block, nsect);
+		return tr->discard(dev, block, nsect);
 
 	if (!blk_fs_request(req))
-		return 0;
+		return -EIO;
 
 	if (req->sector + req->current_nr_sectors > get_capacity(req->rq_disk))
-		return 0;
+		return -EIO;
 
 	switch(rq_data_dir(req)) {
 	case READ:
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->readsect(dev, block, buf))
-				return 0;
-		return 1;
+				return -EIO;
+		return 0;
 
 	case WRITE:
 		if (!tr->writesect)
-			return 0;
+			return -EIO;
 
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->writesect(dev, block, buf))
-				return 0;
-		return 1;
+				return -EIO;
+		return 0;
 
 	default:
 		printk(KERN_NOTICE "Unknown request %u\n", rq_data_dir(req));
-		return 0;
+		return -EIO;
 	}
 }
 
@@ -96,7 +96,7 @@ static int mtd_blktrans_thread(void *arg)
 	while (!kthread_should_stop()) {
 		struct request *req;
 		struct mtd_blktrans_dev *dev;
-		int res = 0;
+		int res;
 
 		req = elv_next_request(rq);
 
@@ -119,7 +119,7 @@ static int mtd_blktrans_thread(void *arg)
 
 		spin_lock_irq(rq->queue_lock);
 
-		end_request(req, res);
+		__blk_end_request_all(req, res);
 	}
 	spin_unlock_irq(rq->queue_lock);
 
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index a9a9893..9ef95af 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -195,25 +195,25 @@ static void jsfd_do_request(struct request_queue *q)
 		size_t len = req->current_nr_sectors << 9;
 
 		if ((offset + len) > jdp->dsize) {
-               		end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 
 		if (rq_data_dir(req) != READ) {
 			printk(KERN_ERR "jsfd: write\n");
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 
 		if ((jdp->dbase & 0xff000000) != 0x20000000) {
 			printk(KERN_ERR "jsfd: bad base %x\n", (int)jdp->dbase);
-			end_request(req, 0);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 
 		jsfd_read(req->buffer, jdp->dbase + offset, len);
 
-		end_request(req, 1);
+		__blk_end_request_all(req, 0);
 	}
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6ba7dbf..ec3e855 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -823,9 +823,8 @@ extern unsigned int blk_rq_cur_bytes(struct request *rq);
  * blk_update_request() completes given number of bytes and updates
  * the request without completing it.
  *
- * blk_end_request() and friends.  __blk_end_request() and
- * end_request() must be called with the request queue spinlock
- * acquired.
+ * blk_end_request() and friends.  __blk_end_request() must be called
+ * with the request queue spinlock acquired.
  *
  * Several drivers define their own end_request and call
  * blk_end_request() for parts of the original function.
@@ -931,32 +930,6 @@ static inline bool blk_end_bidi_request(struct request *rq, int error,
 	return __blk_end_io(rq, error, nr_bytes, bidi_bytes, false);
 }
 
-/**
- * end_request - end I/O on the current segment of the request
- * @rq:		the request being processed
- * @uptodate:	error value or %0/%1 uptodate flag
- *
- * Description:
- *     Ends I/O on the current segment of a request. If that is the only
- *     remaining segment, the request is also completed and freed.
- *
- *     This is a remnant of how older block drivers handled I/O completions.
- *     Modern drivers typically end I/O on the full request in one go, unless
- *     they have a residual value to account for. For that case this function
- *     isn't really useful, unless the residual just happens to be the
- *     full current segment. In other words, don't use this function in new
- *     code. Use blk_end_request() or __blk_end_request() to end a request.
- **/
-static inline void end_request(struct request *rq, int uptodate)
-{
-	int error = 0;
-
-	if (uptodate <= 0)
-		error = uptodate ? uptodate : -EIO;
-
-	__blk_end_io(rq, error, rq->hard_cur_sectors << 9, 0, true);
-}
-
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
-- 
1.6.0.2

