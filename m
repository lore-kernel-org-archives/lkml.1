Return-Path: <linux-kernel-owner+w=401wt.eu-S1161377AbXDKW4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161377AbXDKW4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161369AbXDKW4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:56:14 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55794 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161377AbXDKWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:40 -0400
Date: Wed, 11 Apr 2007 15:52:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Albert Lee <albertcc@tw.ibm.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 27/31] libata: Clear tf before doing request sense (take 3)
Message-ID: <20070411225250.GB24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-clear-tf-before-doing-request-sense.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Albert Lee <albertcc@tw.ibm.com>

libata: Clear tf before doing request sense (take 3)

patch 2/4:
  Clear tf before doing request sense.

This fixes the AOpen 56X/AKH timeout problem.
(http://bugzilla.kernel.org/show_bug.cgi?id=8244)

Signed-off-by: Albert Lee <albertcc@tw.ibm.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -954,26 +954,27 @@ static int ata_eh_read_log_10h(struct at
  *	RETURNS:
  *	0 on success, AC_ERR_* mask on failure
  */
-static unsigned int atapi_eh_request_sense(struct ata_device *dev,
-					   unsigned char *sense_buf)
+static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 {
+	struct ata_device *dev = qc->dev;
+	unsigned char *sense_buf = qc->scsicmd->sense_buffer;
 	struct ata_port *ap = dev->ap;
 	struct ata_taskfile tf;
 	u8 cdb[ATAPI_CDB_LEN];
 
 	DPRINTK("ATAPI request sense\n");
 
-	ata_tf_init(dev, &tf);
-
 	/* FIXME: is this needed? */
 	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
 
-	/* XXX: why tf_read here? */
-	ap->ops->tf_read(ap, &tf);
-
-	/* fill these in, for the case where they are -not- overwritten */
+	/* initialize sense_buf with the error register,
+	 * for the case where they are -not- overwritten
+	 */
 	sense_buf[0] = 0x70;
-	sense_buf[2] = tf.feature >> 4;
+	sense_buf[2] = qc->result_tf.feature >> 4;
+
+	/* some devices time out if garbage left in tf */
+	ata_tf_init(dev, &tf);
 
 	memset(cdb, 0, ATAPI_CDB_LEN);
 	cdb[0] = REQUEST_SENSE;
@@ -1137,8 +1138,7 @@ static unsigned int ata_eh_analyze_tf(st
 
 	case ATA_DEV_ATAPI:
 		if (!(qc->ap->pflags & ATA_PFLAG_FROZEN)) {
-			tmp = atapi_eh_request_sense(qc->dev,
-						     qc->scsicmd->sense_buffer);
+			tmp = atapi_eh_request_sense(qc);
 			if (!tmp) {
 				/* ATA_QCFLAG_SENSE_VALID is used to
 				 * tell atapi_qc_complete() that sense

-- 
