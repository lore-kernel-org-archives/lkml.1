Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbXKHWFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbXKHWFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbXKHWFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:05:37 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:40325 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbXKHWFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:05:36 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-parport@lists.infradead.org
Subject: Re: [PATCH] pf broken
Date: Thu, 8 Nov 2007 23:05:29 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200711082258.55946.linux@rainbow-software.org>
In-Reply-To: <200711082258.55946.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711082305.30228.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the broken patch. Hope it's OK now.


The pf driver for parallel port floppy drives seems to be broken. At least
with Imation SuperDisk with EPAT chip, the driver calls pi_connect() and
pi_disconnect after each transferred sector. At least with EPAT, this
operation is very expensive - causes drive recalibration. Thus,
transferring even a single byte (dd if=/dev/pf0 of=/dev/null bs=1 count=1)
takes 20 seconds, making the driver useless.

The pf_next_buf() function seems to be broken as it returns 1 always
(except when pf_run is non-zero), causing the loop in do_pf_read_drq (and
do_pf_write_drq) to be executed only once.

The following patch fixes this problem. It also fixes swapped descriptions
in pf_lock() function and removes DBMSG macro, which seems useless.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

-- 
Ondrej Zary

--- linux-2.6.23-orig/drivers/block/paride/pf.c	2007-10-09 22:31:38.000000000 +0200
+++ linux/drivers/block/paride/pf.c	2007-11-08 22:29:31.000000000 +0100
@@ -488,13 +488,11 @@
 	return r;
 }
 
-#define DBMSG(msg)      ((verbose>1)?(msg):NULL)
-
 static void pf_lock(struct pf_unit *pf, int func)
 {
 	char lo_cmd[12] = { ATAPI_LOCK, pf->lun << 5, 0, 0, func, 0, 0, 0, 0, 0, 0, 0 };
 
-	pf_atapi(pf, lo_cmd, 0, pf_scratch, func ? "unlock" : "lock");
+	pf_atapi(pf, lo_cmd, 0, pf_scratch, func ? "lock" : "unlock");
 }
 
 static void pf_eject(struct pf_unit *pf)
@@ -555,7 +553,7 @@
 	    { ATAPI_MODE_SENSE, pf->lun << 5, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0 };
 	char buf[8];
 
-	pf_atapi(pf, ms_cmd, 8, buf, DBMSG("mode sense"));
+	pf_atapi(pf, ms_cmd, 8, buf, "mode sense");
 	pf->media_status = PF_RW;
 	if (buf[3] & 0x80)
 		pf->media_status = PF_RO;
@@ -591,7 +589,7 @@
 	char buf[8];
 	int bs;
 
-	if (pf_atapi(pf, rc_cmd, 8, buf, DBMSG("get capacity"))) {
+	if (pf_atapi(pf, rc_cmd, 8, buf, "get capacity")) {
 		pf->media_status = PF_NM;
 		return;
 	}
@@ -804,13 +802,18 @@
 	pf_buf += 512;
 	pf_block++;
 	if (!pf_run)
-		return 0;
-	if (!pf_count)
 		return 1;
-	spin_lock_irqsave(&pf_spin_lock, saved_flags);
-	pf_end_request(1);
-	spin_unlock_irqrestore(&pf_spin_lock, saved_flags);
-	return 1;
+	if (!pf_count) {
+		spin_lock_irqsave(&pf_spin_lock, saved_flags);
+		pf_end_request(1);
+		pf_req = elv_next_request(pf_queue);
+		spin_unlock_irqrestore(&pf_spin_lock, saved_flags);
+		if (!pf_req)
+			return 1;
+		pf_count = pf_req->current_nr_sectors;
+		pf_buf = pf_req->buffer;
+	}
+	return 0;
 }
 
 static inline void next_request(int success)
