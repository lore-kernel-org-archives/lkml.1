Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536Ab0AZX6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0AZX6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494Ab0AZX6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:58:51 -0500
Received: from kroah.org ([198.145.64.141]:35293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab0AZXnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:35 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:26 2010
Message-Id: <20100126233926.411111435@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [42/98] [SCSI] libfc: fix ddp in fc_fcp for 0 xid
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yi Zou <yi.zou@intel.com>

commit 5e472d077f45de4f37365171bd742f18b3ef20de upstream.

xid 0 was used as an indication of invalid xid before but now xid 0
can be used as a valid exchange i. This patch fixes the ddp completion
in fcp layer, i.e., in fc_fcp.c:fc_fcp_ddp_done() function, to make sure it
does not use xid 0 for indication of an invalid xid, instead, it now
uses use FC_XID_UNKNOWN for such indication.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libfc/fc_fcp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -302,10 +302,13 @@ static void fc_fcp_ddp_done(struct fc_fc
 	if (!fsp)
 		return;
 
+	if (fsp->xfer_ddp == FC_XID_UNKNOWN)
+		return;
+
 	lp = fsp->lp;
-	if (fsp->xfer_ddp && lp->tt.ddp_done) {
+	if (lp->tt.ddp_done) {
 		fsp->xfer_len = lp->tt.ddp_done(lp, fsp->xfer_ddp);
-		fsp->xfer_ddp = 0;
+		fsp->xfer_ddp = FC_XID_UNKNOWN;
 	}
 }
 
@@ -1708,6 +1711,7 @@ int fc_queuecommand(struct scsi_cmnd *sc
 	fsp->cmd = sc_cmd;	/* save the cmd */
 	fsp->lp = lp;		/* save the softc ptr */
 	fsp->rport = rport;	/* set the remote port ptr */
+	fsp->xfer_ddp = FC_XID_UNKNOWN;
 	sc_cmd->scsi_done = done;
 
 	/*


