Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYFVOVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYFVOVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYFVOUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:20:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbYFVOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:20:20 -0400
To: mchehab@infradead.org
Subject: [PATCH] dvbdmx_write: memcpy from user-supplied pointer
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQQV-00022V-Iv@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:20:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... copy to kernel memory first

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/dvb-core/demux.h     |    2 +-
 drivers/media/dvb/dvb-core/dvb_demux.c |   17 ++++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/demux.h b/drivers/media/dvb/dvb-core/demux.h
index b0d347d..eb91fd8 100644
--- a/drivers/media/dvb/dvb-core/demux.h
+++ b/drivers/media/dvb/dvb-core/demux.h
@@ -247,7 +247,7 @@ struct dmx_demux {
 	void* priv;                  /* Pointer to private data of the API client */
 	int (*open) (struct dmx_demux* demux);
 	int (*close) (struct dmx_demux* demux);
-	int (*write) (struct dmx_demux* demux, const char* buf, size_t count);
+	int (*write) (struct dmx_demux* demux, const char __user *buf, size_t count);
 	int (*allocate_ts_feed) (struct dmx_demux* demux,
 				 struct dmx_ts_feed** feed,
 				 dmx_ts_cb callback);
diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index 934e15f..e2eca0b 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -1056,16 +1056,27 @@ static int dvbdmx_close(struct dmx_demux *demux)
 	return 0;
 }
 
-static int dvbdmx_write(struct dmx_demux *demux, const char *buf, size_t count)
+static int dvbdmx_write(struct dmx_demux *demux, const char __user *buf, size_t count)
 {
 	struct dvb_demux *dvbdemux = (struct dvb_demux *)demux;
+	void *p;
 
 	if ((!demux->frontend) || (demux->frontend->source != DMX_MEMORY_FE))
 		return -EINVAL;
 
-	if (mutex_lock_interruptible(&dvbdemux->mutex))
+	p = kmalloc(count, GFP_USER);
+	if (!p)
+		return -ENOMEM;
+	if (copy_from_user(p, buf, count)) {
+		kfree(p);
+		return -EFAULT;
+	}
+	if (mutex_lock_interruptible(&dvbdemux->mutex)) {
+		kfree(p);
 		return -ERESTARTSYS;
-	dvb_dmx_swfilter(dvbdemux, (u8 *)buf, count);
+	}
+	dvb_dmx_swfilter(dvbdemux, p, count);
+	kfree(p);
 	mutex_unlock(&dvbdemux->mutex);
 
 	if (signal_pending(current))
-- 
1.5.3.GIT


