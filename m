Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbZISVha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbZISVha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZISVh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:37:29 -0400
Received: from kroah.org ([198.145.64.141]:50877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZISVh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:37:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tilman Schmidt <tilman@imap.cc>, "David S. Miller" <davem@davemloft.net>,
       stable <stable@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/79] tty: gigaset: really fix chars_in_buffer
Date: Sat, 19 Sep 2009 14:36:06 -0700
Message-Id: <1253396244-7885-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>

The tty_operation chars_in_buffer() is not allowed to return a negative
value to signal an error.  Corrects the problem flagged by commit
23198fda7182969b619613a555f8645fdc3dc334, "tty: fix chars_in_buffers".

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/isdn/gigaset/interface.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 8ff7e35..f33ac27 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -408,33 +408,28 @@ static int if_write_room(struct tty_struct *tty)
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
 
-	if (mutex_lock_interruptible(&cs->mutex))
-		return -ERESTARTSYS; // FIXME -EINTR?
+	mutex_lock(&cs->mutex);
 
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
1.6.4.2

