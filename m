Return-Path: <linux-kernel-owner+w=401wt.eu-S1765341AbYBWATB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765341AbYBWATB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761468AbYBWASl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:18:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760907AbYBWASj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:18:39 -0500
Date: Fri, 22 Feb 2008 16:17:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tony Battersby <tonyb@cybernetics.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 1/8] SCSI: sd: handle bad lba in sense information
Message-ID: <20080223001721.GB27727@suse.de>
References: <20080223001123.939868182@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-sd-handle-bad-lba-in-sense-information.patch"
In-Reply-To: <20080223001702.GA27727@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.

------------------


From: James Bottomley <James.Bottomley@HansenPartnership.com>

patch 366c246de9cec909c5eba4f784c92d1e75b4dc38 in mainline.

Some devices report medium error locations incorrectly.  Add guards to
make sure the reported bad lba is actually in the request that caused
it.  Additionally remove the large case statment for sector sizes and
replace it with the proper u64 divisions.

Tested-by: Mike Snitzer <snitzer@gmail.com>
Cc: Stable Tree <stable@kernel.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sd.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -901,6 +901,7 @@ static void sd_rw_intr(struct scsi_cmnd 
  	unsigned int xfer_size = SCpnt->request_bufflen;
  	unsigned int good_bytes = result ? 0 : xfer_size;
  	u64 start_lba = SCpnt->request->sector;
+	u64 end_lba = SCpnt->request->sector + (xfer_size / 512);
  	u64 bad_lba;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
@@ -939,26 +940,23 @@ static void sd_rw_intr(struct scsi_cmnd 
 			goto out;
 		if (xfer_size <= SCpnt->device->sector_size)
 			goto out;
-		switch (SCpnt->device->sector_size) {
-		case 256:
+		if (SCpnt->device->sector_size < 512) {
+			/* only legitimate sector_size here is 256 */
 			start_lba <<= 1;
-			break;
-		case 512:
-			break;
-		case 1024:
-			start_lba >>= 1;
-			break;
-		case 2048:
-			start_lba >>= 2;
-			break;
-		case 4096:
-			start_lba >>= 3;
-			break;
-		default:
-			/* Print something here with limiting frequency. */
-			goto out;
-			break;
+			end_lba <<= 1;
+		} else {
+			/* be careful ... don't want any overflows */
+			u64 factor = SCpnt->device->sector_size / 512;
+			do_div(start_lba, factor);
+			do_div(end_lba, factor);
 		}
+
+		if (bad_lba < start_lba  || bad_lba >= end_lba)
+			/* the bad lba was reported incorrectly, we have
+			 * no idea where the error is
+			 */
+			goto out;
+
 		/* This computation should always be done in terms of
 		 * the resolution of the device's medium.
 		 */

-- 
