Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbXCJGVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbXCJGVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXCJGUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:20:41 -0500
Received: from ns1.suse.de ([195.135.220.2]:41058 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXCJGTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:19:48 -0500
Date: Fri, 9 Mar 2007 22:18:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, James.Bottomley@SteelEye.com,
       Douglas Gilbert <dougg@torque.net>
Subject: [patch 13/20] Fix bug 7994 sleeping function called from invalid context
Message-ID: <20070310061810.GN31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-bug-7994-sleeping-function-called-from-invalid-context.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Douglas Gilbert <dougg@torque.net>

  - addresses the reported bug (with GFP_KERNEL -> GFP_ATOMIC)
  - improves error checking, and
  - is a subset of the changes to scsi_debug in lk 2.6.21-rc*

Compiled and lightly tested (in lk 2.6.21-rc2 environment).

Signed-off-by: Douglas Gilbert <dougg@torque.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_debug.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -954,7 +954,9 @@ static int resp_inquiry(struct scsi_cmnd
 	int alloc_len, n, ret;
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
-	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_KERNEL);
+	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
+	if (! arr)
+		return DID_REQUEUE << 16;
 	if (devip->wlun)
 		pq_pdt = 0x1e;	/* present, wlun */
 	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
@@ -1217,7 +1219,9 @@ static int resp_report_tgtpgs(struct scs
 	alen = ((cmd[6] << 24) + (cmd[7] << 16) + (cmd[8] << 8)
 		+ cmd[9]);
 
-	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_KERNEL);
+	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
+	if (! arr)
+		return DID_REQUEUE << 16;
 	/*
 	 * EVPD page 0x88 states we have two ports, one
 	 * real and a fake port with no device connected.
@@ -1996,6 +2000,8 @@ static int scsi_debug_slave_configure(st
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
 	devip = devInfoReg(sdp);
+	if (NULL == devip)
+		return 1;       /* no resources, will be marked offline */
 	sdp->hostdata = devip;
 	if (sdp->host->cmd_per_lun)
 		scsi_adjust_queue_depth(sdp, SDEBUG_TAGGED_QUEUING,
@@ -2044,7 +2050,7 @@ static struct sdebug_dev_info * devInfoR
 		}
 	}
 	if (NULL == open_devip) { /* try and make a new one */
-		open_devip = kzalloc(sizeof(*open_devip),GFP_KERNEL);
+		open_devip = kzalloc(sizeof(*open_devip),GFP_ATOMIC);
 		if (NULL == open_devip) {
 			printk(KERN_ERR "%s: out of memory at line %d\n",
 				__FUNCTION__, __LINE__);

-- 
