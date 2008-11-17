Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYKQHck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYKQHck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbYKQHVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:36 -0500
Received: from kroah.org ([198.145.64.141]:38608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754611AbYKQHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:27 -0500
Date: Sun, 16 Nov 2008 23:16:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Miquel van Smoorenburg <mikevs@xs4all.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 32/46] SCSI: dpt_i2o: fix transferred data length for
	scsi_set_resid()
Message-ID: <20081117071616.GG29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-dpt_i2o-fix-transferred-data-length-for-scsi_set_resid.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miquel van Smoorenburg <mikevs@xs4all.net>

commit df81d2371aeca0f7474f197a3090830899016e39 upstream.

dpt_i2o.c::adpt_i2o_to_scsi() reads the value at (reply+5) which
should contain the length in bytes of the transferred data. This
would be correct if reply was a u32 *. However it is a void * here,
so we need to read the value at (reply+20) instead.

The value at (reply+5) is usually 0xff0000, which is apparently
'large enough' and didn't cause any trouble until 2.6.27 where

commit 427e59f09fdba387547106de7bab980b7fff77be
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Mar 8 18:24:17 2008 -0600

    [SCSI] make use of the residue value

caused this to become visible through e.g. iostat -x .

Signed-off-by: Miquel van Smoorenburg <mikevs@xs4all.net>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/dpt_i2o.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2445,7 +2445,7 @@ static s32 adpt_i2o_to_scsi(void __iomem
 	hba_status = detailed_status >> 8;
 
 	// calculate resid for sg 
-	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+5));
+	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+20));
 
 	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
 
@@ -2456,7 +2456,7 @@ static s32 adpt_i2o_to_scsi(void __iomem
 		case I2O_SCSI_DSC_SUCCESS:
 			cmd->result = (DID_OK << 16);
 			// handle underflow
-			if(readl(reply+5) < cmd->underflow ) {
+			if (readl(reply+20) < cmd->underflow) {
 				cmd->result = (DID_ERROR <<16);
 				printk(KERN_WARNING"%s: SCSI CMD underflow\n",pHba->name);
 			}

-- 
