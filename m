Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZHFUGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZHFUGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbZHFUGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:06:09 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39064 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbZHFUGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:06:07 -0400
Date: Thu, 6 Aug 2009 22:06:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] drivers/scsi: Add kmalloc NULL tests
Message-ID: <Pine.LNX.4.64.0908062205190.19100@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc is not NULL before passing it to other
functions.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/sr.c                   |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index cce0fe4..3fbf42e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -211,6 +211,8 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 	}
 
 	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
+	if (!sshdr)
+		return -ENOMEM;
 	retval = sr_test_unit_ready(cd->device, sshdr);
 	if (retval || (scsi_sense_valid(sshdr) &&
 		       /* 0x3a is medium not present */
