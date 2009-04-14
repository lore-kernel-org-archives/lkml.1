Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZDNQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZDNQBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbZDNQBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:01:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52971 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbZDNQA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:00:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix lpfc_parse_bg_err()'s use of do_div()
To: james.smart@emulex.com, linux-scsi@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2009 16:59:49 +0100
Message-ID: <20090414155948.27755.2131.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix lpfc_parse_bg_err()'s use of do_div().  It should be passing a 64-bit
variable as the first parameter.  However, since it's only using a 32-bit
variable, it doesn't need to use do_div() at all, but can instead use the
division operator.

This deals with the following warnings:

  CC      drivers/scsi/lpfc/lpfc_scsi.o
drivers/scsi/lpfc/lpfc_scsi.c: In function 'lpfc_parse_bg_err':
drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: comparison of distinct pointer types lacks a cast
drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: right shift count >= width of type
drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: passing argument 1 of '__div64_32' from incompatible pointer type

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/scsi/lpfc/lpfc_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b1bd3fc..36fd2e7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1394,7 +1394,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
 		 */
 		cmd->sense_buffer[8] = 0;     /* Information */
 		cmd->sense_buffer[9] = 0xa;   /* Add. length */
-		do_div(bghm, cmd->device->sector_size);
+		bghm /= cmd->device->sector_size;
 
 		failing_sector = scsi_get_lba(cmd);
 		failing_sector += bghm;

