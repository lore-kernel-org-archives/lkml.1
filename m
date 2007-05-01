Return-Path: <linux-kernel-owner+w=401wt.eu-S1161137AbXEAKKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbXEAKKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161661AbXEAKKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:10:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137AbXEAKKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:10:48 -0400
Subject: [GFS2] flush the log if a transaction can't allocate space [10/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Benjamin Marzinski <bmarzins@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:06:15 +0100
Message-Id: <1178013975.5462.146.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 172e045a7fcc3ee647fa70dbd585a3c247b49cb2 Mon Sep 17 00:00:00 2001
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 23 Mar 2007 14:51:56 -0600
Subject: [PATCH] [GFS2] flush the log if a transaction can't allocate space

This is a fix for bz #208514. When GFS2 frees up space, the freed blocks
aren't available for reuse until the resource group is successfully written
to the ondisk journal. So in rare cases, GFS2 operations will fail, saying
that the filesystem is out of space, when in reality, you are just waiting for
a log flush. For instance, on a 1Gig filesystem, if I continually write 10 Mb
to a file, and then truncate it, after a hundred interations, the write will
fail with -ENOSPC, even though the filesystem is just 1% full.

The attached patch calls a log flush in these cases.  I tested this patch
fairly heavily to check if there were any locking issues that I missed, and
it seems to work just fine. Also, this patch only does the log flush if
get_local_rgrp makes a complete loop of resource groups without skipping
any do to locking issues. The code would be slightly simpler if it just always
did the log flush after the first failed pass, and you could only ever have
to go through the loop twice, instead of up to three times. However, I guessed
that failing to find a rg simply do to locking issues would be common enough
to skip the log flush in that case, but I'm not certain that this is the right
way to go. Either way, I don't suppose this code will be hit all that often.

Signed-off-by: Benjamin E. Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8d9c08b..2ce48d4 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -27,6 +27,7 @@
 #include "trans.h"
 #include "ops_file.h"
 #include "util.h"
+#include "log.h"
 
 #define BFITNOENT ((u32)~0)
 
@@ -941,9 +942,13 @@ static int get_local_rgrp(struct gfs2_inode *ip)
 			rgd = gfs2_rgrpd_get_first(sdp);
 
 		if (rgd == begin) {
-			if (++loops >= 2 || !skipped)
+			if (++loops >= 3)
 				return -ENOSPC;
+			if (!skipped)
+				loops++;
 			flags = 0;
+			if (loops == 2)
+				gfs2_log_flush(sdp, NULL);
 		}
 	}
 
-- 
1.5.1.2



