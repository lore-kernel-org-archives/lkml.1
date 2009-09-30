Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZI3LQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZI3LQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZI3LQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:16:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:37499 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZI3LQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:16:41 -0400
Date: Wed, 30 Sep 2009 13:17:09 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] floppy: Add an extra bound check on ioctl arguments
Message-ID: <20090930131709.7300dff3@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 90d75780b319153d050bb1c0f3f38ce054775615 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 30 Sep 2009 13:13:59 +0200
Subject: [PATCH] floppy: Add an extra bound check on ioctl arguments

gcc is not convinced that the floppy.c ioctl has sufficient bound checks,
and frankly, as a human I have a hard time proving the same more or less
(the size comes from the ioctl argument. humpf. maybe. the code isn't
very nice)

This patch adds an explicit check to make 100% sure it's safe, better
than finding out later that there indeed was a gap.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/block/floppy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5c01f74..0f11a77 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3497,6 +3497,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
 		return -EPERM;
 
+	if (size < 0 || size > sizeof(inparam))
+		return -EINVAL;
+
 	/* copyin */
 	CLEARSTRUCT(&inparam);
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
-- 
1.6.2.5


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
