Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZGQUlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZGQUlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZGQUlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:41:00 -0400
Received: from kroah.org ([198.145.64.141]:50653 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884AbZGQUk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:40:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:38:24 2009
Message-Id: <20090717203824.651982629@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:37:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 5/8] floppy: fix lock imbalance
References: <20090717203718.637372453@mini.kroah.org>
Content-Disposition: inline; filename=floppy-fix-lock-imbalance.patch
In-Reply-To: <20090717203935.GA5641@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 8516a500029890a72622d245f8ed32c4e30969b7 upstream.

A crappy macro prevents us unlocking on a fail path.

Expand the macro and unlock appropriatelly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/floppy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3320,7 +3320,10 @@ static inline int set_geometry(unsigned 
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		mutex_lock(&open_lock);
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1)) {
+			mutex_unlock(&open_lock);
+			return -EINTR;
+		}
 		floppy_type[type] = *g;
 		floppy_type[type].name = "user format";
 		for (cnt = type << 2; cnt < (type << 2) + 4; cnt++)


