Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbYKNJgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbYKNJgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKNJgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:36:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58112 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYKNJge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:36:34 -0500
Message-ID: <491D45EB.5050307@cn.fujitsu.com>
Date: Fri, 14 Nov 2008 17:33:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: jens.axboe@oracle.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] relay: fix cpu offline problem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

relay_open() will close allocated buffers when failed.
but if cpu offlined, some buffer will not be closed.
this patch fixed it.

and did cleanup for relay_reset() too.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/relay.c b/kernel/relay.c
index 8d13a78..32b0bef 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -400,7 +400,7 @@ void relay_reset(struct rchan *chan)
 	}
 
 	mutex_lock(&relay_channels_mutex);
-	for_each_online_cpu(i)
+	for_each_possible_cpu(i)
 		if (chan->buf[i])
 			__relay_reset(chan->buf[i], 0);
 	mutex_unlock(&relay_channels_mutex);
@@ -611,10 +611,9 @@ struct rchan *relay_open(const char *base_filename,
 	return chan;
 
 free_bufs:
-	for_each_online_cpu(i) {
-		if (!chan->buf[i])
-			break;
-		relay_close_buf(chan->buf[i]);
+	for_each_possible_cpu(i) {
+		if (chan->buf[i])
+			relay_close_buf(chan->buf[i]);
 	}
 
 	kref_put(&chan->kref, relay_destroy_channel);

