Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYHRT1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYHRT1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763608AbYHRT1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:27:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:40349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763528AbYHRT1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:27:31 -0400
Date: Mon, 18 Aug 2008 12:19:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 07/49] SCSI: ses: fix VPD inquiry overrun
Message-ID: <20080818191927.GH10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-ses-fix-vpd-inquiry-overrun.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 671a99c8eb2f1dde08ac5538d8cd912047c61ddf upstream

There are a few kerneloops.org reports like this one:

http://www.kerneloops.org/search.php?search=ses_match_to_enclosure

That seem to imply we're running off the end of the VPD inquiry data
(although at 512 bytes, it should be long enough for just about
anything).  we should be using correctly sized buffers anyway, so put
those in and hope this oops goes away.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ses.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -345,14 +345,14 @@ static int ses_enclosure_find_by_addr(st
 	return 0;
 }
 
-#define VPD_INQUIRY_SIZE 512
+#define VPD_INQUIRY_SIZE 36
 
 static void ses_match_to_enclosure(struct enclosure_device *edev,
 				   struct scsi_device *sdev)
 {
 	unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
 	unsigned char *desc;
-	int len;
+	u16 vpd_len;
 	struct efd efd = {
 		.addr = 0,
 	};
@@ -372,9 +372,19 @@ static void ses_match_to_enclosure(struc
 			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
 		goto free;
 
-	len = (buf[2] << 8) + buf[3];
+	vpd_len = (buf[2] << 8) + buf[3];
+	kfree(buf);
+	buf = kmalloc(vpd_len, GFP_KERNEL);
+	if (!buf)
+		return;
+	cmd[3] = vpd_len >> 8;
+	cmd[4] = vpd_len & 0xff;
+	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
+			     vpd_len, NULL, SES_TIMEOUT, SES_RETRIES))
+		goto free;
+
 	desc = buf + 4;
-	while (desc < buf + len) {
+	while (desc < buf + vpd_len) {
 		enum scsi_protocol proto = desc[0] >> 4;
 		u8 code_set = desc[0] & 0x0f;
 		u8 piv = desc[1] & 0x80;

-- 
