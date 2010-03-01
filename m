Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0CAPSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:18:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab0CAPR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:17:59 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Dave Chinner <dchinner@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/5] GFS2: ordered writes are backwards
Date: Mon,  1 Mar 2010 15:08:25 +0000
Message-Id: <1267456106-3084-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1267456106-3084-4-git-send-email-swhiteho@redhat.com>
References: <1267456106-3084-1-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-2-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-3-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we queue data buffers for ordered write, the buffers are added
to the head of the ordered write list. When the log needs to push
these buffers to disk, it also walks the list from the head. The
result is that the the ordered buffers are submitted to disk in
reverse order.

For large writes, this means that whenever the log flushes large
streams of reverse sequential order buffers are pushed down into the
block layers. The elevators don't handle this particularly well, so
IO rates tend to be significantly lower than if the IO was issued in
ascending block order.

Queue new ordered buffers to the tail of the ordered buffer list to
ensure that IO is dispatched in the order it was submitted. This
should significantly improve large sequential write speeds. On a
disk capable of 85MB/s, speeds increase from 50MB/s to 65MB/s for
noop and from 38MB/s to 50MB/s for cfq.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/lops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index de97632..adc260f 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -528,9 +528,9 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
 		sdp->sd_log_num_databuf++;
-		list_add(&le->le_list, &sdp->sd_log_le_databuf);
+		list_add_tail(&le->le_list, &sdp->sd_log_le_databuf);
 	} else {
-		list_add(&le->le_list, &sdp->sd_log_le_ordered);
+		list_add_tail(&le->le_list, &sdp->sd_log_le_ordered);
 	}
 out:
 	gfs2_log_unlock(sdp);
-- 
1.6.2.5

