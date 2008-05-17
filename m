Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYEQLBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYEQLBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 07:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYEQLBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 07:01:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:52978 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbYEQLB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 07:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references:sender;
        b=k6ooVZ4MYP+la+MvVqwWFSMczz8ZGuIDQ0EfWAy9j8dcepAVt9j7JPm4RVJ5gCPrusHgh7cmQZLTR4pW2P0PhXoIvnHJlSb599TXnS3ZQ4fjCl4ZKoftCrL3bDKiEYbYka9uvb9zGhSs3RplmaEXvfnlLYNIKxicM0KAQj0a/Dc=
From: Bryan Wu <cooloney@kernel.org>
To: me@felipebalbi.com, david-b@pacbell.net, tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] MUSB: fix bug - since 2.6.24 urb API changed, giveback function return wrong status
Date: Sat, 17 May 2008 19:01:20 +0800
Message-Id: <1211022081-27298-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When MUSB got STALL, but reported "short read trasfer"
usb-storage: Command MODE_SENSE (6 bytes)
usb-storage:  1a 00 3f 00 c0 00
usb-storage: Bulk Command S 0x43425355 T 0x18 L 192 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
usb-storage: Status code -121; transferred 0/192
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 0/13
usb-storage: -- short transfer
usb-storage: Received 0-length CSW; retrying...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 0/13
usb-storage: -- short transfer
usb-storage: Bulk status result = 1
usb-storage: -- transport indicates error, resetting
usb-storage: storage_pre_reset


The right message is:

usb-storage: Command MODE_SENSE (6 bytes)
usb-storage:  1a 00 3f 00 c0 00
usb-storage: Bulk Command S 0x43425355 T 0x6 L 192 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
usb-storage: Status code -121; transferred 4/192
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code -32; transferred 0/13
usb-storage: clearing endpoint halt for pipe 0xc0010280
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: Attempting to get CSW (2nd try)...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/musb_host.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 3d4fc3e..535922d 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -422,7 +422,11 @@ musb_advance_schedule(struct musb *musb, struct urb *urb,
 		qh = hw_ep->in_qh;
 	else
 		qh = hw_ep->out_qh;
-	qh = musb_giveback(qh, urb, 0);
+
+	if (urb->status == -EINPROGRESS)
+		qh = musb_giveback(qh, urb, 0);
+	else
+		qh = musb_giveback(qh, urb, urb->status);
 
 	if (qh && qh->is_ready && !list_empty(&qh->hep->urb_list)) {
 		DBG(4, "... next ep%d %cX urb %p\n",
-- 
1.5.5

