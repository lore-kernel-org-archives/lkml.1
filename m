Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526Ab0AZX5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0AZX5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533Ab0AZX5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:57:46 -0500
Received: from kroah.org ([198.145.64.141]:35303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0AZXnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:26 2010
Message-Id: <20100126233926.670249339@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [44/98] [SCSI] libfc: Fix wrong scsi return status under FC_DATA_UNDRUN
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yi Zou <yi.zou@intel.com>

commit 4347fa66878e079766258bc0d077c350cb31a799 upstream.

This bug is exposed when there is a link flap in LLD. Particularly, when it
happens right after a SCSI write command is sent out, no FCP_DATA is sent,
causing fsp->status_code to be set as FC_DATA_UNDRUN in fc_fcp_complete_locked
even no SCSI status is received. Consequently, fc_io_compl treats this as DID_OK.
This results in SCSI returning successful to the initial I/O request even
there is no DATA actually sent. Particularly, if you run an I/O tool w/ data
verification on, the read back for verification is gonna fail.

This is fixed here by checking when FC_DATA_UNDRUN happens, SCSI status is
received w/ FC_SRB_RCV_STATUS set in fsp->state.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libfc/fc_fcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1850,7 +1850,8 @@ static void fc_io_compl(struct fc_fcp_pk
 			 * scsi status is good but transport level
 			 * underrun.
 			 */
-			sc_cmd->result = DID_OK << 16;
+			sc_cmd->result = (fsp->state & FC_SRB_RCV_STATUS ?
+					  DID_OK : DID_ERROR) << 16;
 		} else {
 			/*
 			 * scsi got underrun, this is an error


