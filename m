Return-Path: <linux-kernel-owner+w=401wt.eu-S1765979AbYCGFCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765979AbYCGFCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762508AbYCGFBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:01:00 -0500
Received: from ns.suse.de ([195.135.220.2]:41061 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761942AbYCGFA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:00:58 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 7 Mar 2008 16:00:53 +1100
Message-Id: <1080307050053.26127@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 2] md: Reduce CPU wastage on idle md array with a write-intent bitmap. fix
References: <20080307155754.25976.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recent patch titled
  Reduce CPU wastage on idle md array with a write-intent bitmap.

would sometimes leave the array with dirty bitmap bits that stay
dirty.  A subsequent write would sort things out so it isn't a big
problem, but should be fixed nonetheless.

We need to make sure that when the bitmap becomes not "allclean", the
daemon_sleep really does get set to a sensible value.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-03-07 15:51:23.000000000 +1100
+++ ./drivers/md/bitmap.c	2008-03-07 15:56:57.000000000 +1100
@@ -1045,7 +1045,8 @@ void bitmap_daemon_work(struct bitmap *b
 	if (bitmap == NULL)
 		return;
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
-		return;
+		goto done;
+
 	bitmap->daemon_lastrun = jiffies;
 	if (bitmap->allclean) {
 		bitmap->mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
@@ -1142,6 +1143,7 @@ void bitmap_daemon_work(struct bitmap *b
 		}
 	}
 
+ done:
 	if (bitmap->allclean == 0)
 		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
 }
