Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab0BDRVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:21:48 -0500
Received: from kroah.org ([198.145.64.141]:34604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932930Ab0BDRVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:33 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:52 2010
Message-Id: <20100204171451.492266211@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [09/74] libata: retry FS IOs even if it has failed with AC_ERR_INVALID
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 534ead709235b967b659947c55d9130873a432c4 upstream.

libata currently doesn't retry if a command fails with AC_ERR_INVALID
assuming that retrying won't get it any further even if retried.
However, a failure may be classified as invalid through hardware
glitch (incorrect reading of the error register or firmware bug) and
there isn't whole lot to gain by not retrying as actually invalid
commands will be failed immediately.  Also, commands serving FS IOs
are extremely unlikely to be invalid.  Retry FS IOs even if it's
marked invalid.

Transient and incorrect invalid failure was seen while debugging
firmware related issue on Samsung n130 on bko#14314.

  http://bugzilla.kernel.org/show_bug.cgi?id=14314

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2019,8 +2019,9 @@ static void ata_eh_link_autopsy(struct a
 			qc->err_mask &= ~(AC_ERR_DEV | AC_ERR_OTHER);
 
 		/* determine whether the command is worth retrying */
-		if (!(qc->err_mask & AC_ERR_INVALID) &&
-		    ((qc->flags & ATA_QCFLAG_IO) || qc->err_mask != AC_ERR_DEV))
+		if (qc->flags & ATA_QCFLAG_IO ||
+		    (!(qc->err_mask & AC_ERR_INVALID) &&
+		     qc->err_mask != AC_ERR_DEV))
 			qc->flags |= ATA_QCFLAG_RETRY;
 
 		/* accumulate error info */


