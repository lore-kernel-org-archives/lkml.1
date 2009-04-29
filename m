Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbZD2WW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbZD2WW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbZD2WVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:08 -0400
Received: from kroah.org ([198.145.64.141]:40187 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbZD2WVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:23 2009
Message-Id: <20090429220923.226388330@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:02 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 03/58] USB: usb-storage: increase max_sectors for tape drives
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0010-USB-usb-storage-increase-max_sectors-for-tape-driv.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

upstream commit: 5c16034d73da2c1b663aa25dedadbc533b3d811c

This patch (as1203) increases the max_sector limit for USB tape
drives.  By default usb-storage sets max_sectors to 240 (i.e., 120 KB)
for all devices.  But tape drives need a higher limit, since tapes can
and do have very large block sizes.  Without the ability to transfer
an entire large block in a single command, such tapes can't be used.

This fixes Bugzilla #12207.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Phil Mitchell <philipm@sybase.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/storage/scsiglue.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -135,6 +135,12 @@ static int slave_configure(struct scsi_d
 		if (sdev->request_queue->max_sectors > max_sectors)
 			blk_queue_max_sectors(sdev->request_queue,
 					      max_sectors);
+	} else if (sdev->type == TYPE_TAPE) {
+		/* Tapes need much higher max_sector limits, so just
+		 * raise it to the maximum possible (4 GB / 512) and
+		 * let the queue segment size sort out the real limit.
+		 */
+		blk_queue_max_sectors(sdev->request_queue, 0x7FFFFF);
 	}
 
 	/* We can't put these settings in slave_alloc() because that gets


