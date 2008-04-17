Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbYDQB0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbYDQB0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759896AbYDQBJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:20 -0400
Received: from sous-sol.org ([216.99.217.87]:58989 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761072AbYDQBJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:19 -0400
Message-Id: <20080417010338.739366626@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Korolev <akorolev@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: mtd: fix broken state in CFI driver caused by FL_SHUTDOWN
Content-Disposition: inline; filename=mtd-fix-broken-state-in-cfi-driver-caused-by-fl_shutdown.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alexey Korolev <akorolev@infradead.org>

upstream commit: fb6d080c6f75dfd7e23d5a3575334785aa8738eb

THe CFI driver in 2.6.24 kernel is broken.  Not so intensive read/write
operations cause incomplete writes which lead to kernel panics in JFFS2.

We investigated the issue - it is caused by bug in FL_SHUTDOWN parsing code.
Sometimes chip returns -EIO as if it is in FL_SHUTDOWN state when it should
wait in FL_PONT (error in order of conditions).

The following patch fixes the bug in state parsing code of CFI.  Also I've
added comments to notify developers if they want to add new case in future.

Signed-off-by: Alexey Korolev <akorolev@infradead.org>
Reviewed-by: Joern Engel <joern@logfs.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -669,7 +669,7 @@ static int chip_ready (struct map_info *
 			/* Someone else might have been playing with it. */
 			return -EAGAIN;
 		}
-
+		/* Fall through */
 	case FL_READY:
 	case FL_CFI_QUERY:
 	case FL_JEDEC_QUERY:
@@ -729,14 +729,14 @@ static int chip_ready (struct map_info *
 		chip->state = FL_READY;
 		return 0;
 
+	case FL_SHUTDOWN:
+		/* The machine is rebooting now,so no one can get chip anymore */
+		return -EIO;
 	case FL_POINT:
 		/* Only if there's no operation suspended... */
 		if (mode == FL_READY && chip->oldstate == FL_READY)
 			return 0;
-
-	case FL_SHUTDOWN:
-		/* The machine is rebooting now,so no one can get chip anymore */
-		return -EIO;
+		/* Fall through */
 	default:
 	sleep:
 		set_current_state(TASK_UNINTERRUPTIBLE);

-- 
