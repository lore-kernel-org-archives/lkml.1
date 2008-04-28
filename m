Return-Path: <linux-kernel-owner+w=401wt.eu-S1764789AbYD1CJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764789AbYD1CJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 22:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYD1CJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 22:09:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:10352 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYD1CJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 22:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=GyJjQr4jicViNUB+UJOL/CULFhDVexgkPI1tpTCAIG3YauqzfzgzV8A65iV5JyrJiEQV8iv1h1HEeeYjlpGBXgyrNO/c4JAe+241jKGB0vbPgTAI88xhg5VLVwkz76/3KmbNOZL9iYlbrZ6YQitXdl8pDcr3fsBiZROHbXmk/0w=
Date: Mon, 28 Apr 2008 10:10:22 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com
Subject: [PATCH 2/2] loop : Don't hold the lo_ctl_mutex while fput in
	loop_clr_fd
Message-ID: <20080428021022.GB2698@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixing bug 10504]

If the bakingfile is a block device file, losetuo -d will trigger lockdep
warning of "circular locking dependency".

open/release lock order : bdev->bd_mutex ---> lo->lo_ctl_mutex
loop_clr_fd lock order  : lo->lo_ctl_mutex ---> bdev->bd_mutex (fput)

Don't hold the lo_ctl_mutex while fput in loop_clr_fd to fix it. It's safe
because all loop device state will be consistent here.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
drivers/block/loop.c |    5 +++++
1 file changed, 5 insertions(+)

diff -upr linux/drivers/block/loop.c linux.new/drivers/block/loop.c
--- linux/drivers/block/loop.c	2008-04-25 10:10:25.000000000 +0800
+++ linux.new/drivers/block/loop.c	2008-04-25 10:10:35.000000000 +0800
@@ -923,7 +923,12 @@ static int loop_clr_fd(struct loop_devic
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
+
+	/* unlock the lo_ctl_mutex to silence lockdep in case
+	 the backingfile is a block device */
+	mutex_unlock(&lo->lo_ctl_mutex);
 	fput(filp);
+	mutex_lock(&lo->lo_ctl_mutex);
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
 	if (max_part > 0)
