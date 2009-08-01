Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZHAMTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZHAMTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 08:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZHAMTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 08:19:08 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:56599 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZHAMTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 08:19:07 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 2.6.31-rc4] gigaset: really fix chars_in_buffer
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: Alan Cox <alan@linux.intel.com>, Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090801-patch-01.tilman@imap.cc>
Date: Sat,  1 Aug 2009 14:18:51 +0200 (CEST)
X-Spam-Score: 0.1 () RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the problem noted but left unfixed by commit
23198fda7182969b619613a555f8645fdc3dc334 "tty: fix chars_in_buffers".
The tty_operation chars_in_buffer() should return zero, not a
negative value, in the error case.

Impact: error handling bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---

I only just noticed the "tty: fix chars_in_buffers" patch going in.
Please merge this follow-up fix for 2.6.31, too. Thanks.

 drivers/isdn/gigaset/interface.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 8b62df8..dfeec68 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -408,33 +408,29 @@ static int if_write_room(struct tty_struct *tty)
 	return retval;
 }
 
-/* FIXME: This function does not have error returns */
-
 static int if_chars_in_buffer(struct tty_struct *tty)
 {
 	struct cardstate *cs;
-	int retval = -ENODEV;
+	int retval = 0;
 
 	cs = (struct cardstate *) tty->driver_data;
 	if (!cs) {
 		pr_err("%s: no cardstate\n", __func__);
-		return -ENODEV;
+		return 0;
 	}
 
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
 	if (mutex_lock_interruptible(&cs->mutex))
-		return -ERESTARTSYS; // FIXME -EINTR?
+		return 0;
 
-	if (!cs->connected) {
+	if (!cs->connected)
 		gig_dbg(DEBUG_IF, "not connected");
-		retval = -ENODEV;
-	} else if (!cs->open_count)
+	else if (!cs->open_count)
 		dev_warn(cs->dev, "%s: device not opened\n", __func__);
-	else if (cs->mstate != MS_LOCKED) {
+	else if (cs->mstate != MS_LOCKED)
 		dev_warn(cs->dev, "can't write to unlocked device\n");
-		retval = -EBUSY;
-	} else
+	else
 		retval = cs->ops->chars_in_buffer(cs);
 
 	mutex_unlock(&cs->mutex);
-- 
1.6.2.1.214.ge986c

