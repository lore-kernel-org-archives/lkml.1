Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbYGUH6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbYGUH6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbYGUH6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:58:34 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39804 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbYGUH6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:58:32 -0400
Date: Mon, 21 Jul 2008 09:58:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/7] drivers/scsi/scsi_scan.c: Release mutex in error handling
 code
Message-ID: <Pine.LNX.4.64.0807210958120.24625@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1760,6 +1760,7 @@ static void scsi_finish_async_scan(struc
 		printk("%s called twice for host %d", __FUNCTION__,
 				shost->host_no);
 		dump_stack();
+		mutex_unlock(&shost->scan_mutex);
 		return;
 	}
 
